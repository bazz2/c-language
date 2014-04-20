#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <poll.h>
#include <pthread.h>
#include <osn/osndisk.h>

#include "ops.h"
#include "stream_priv.h"

#include "../include/st_proto.h"
#include "../include/net.h"
#include "../include/logger.h"
#include "../include/list.h"

#define MAX_NAME_LEN 512
#define MAX_REQUEST 512
#define MAX_IP_NUM 64
#define OSNSTM_SERVER_PORT 9997
#define OSNSTM_CLIENT_PORT 9998
#define HEARTBEAT_INTERVAL 5
#define OSM_LIST_INIT(name) struct list_head name = { &(name), &(name)}
#define OSM_LOCAL_SOCK "/var/run/osnstm.sock"

struct session_stat {
	struct list_head list;
	
	pthread_t thid; /* process who connect with remote */
	int sockfd; /* this session's socket fd */
	int idle_timeout; /* check if session timeout */
	char user_name[USER_NAME_LEN];
	time_t next_time;
};

struct osnstm_session {
	struct list_head sessions; /* list of struct session_stat */
	pthread_mutex_t lock;
	pthread_cond_t cond;
	int activefd; /* record active sockfd */
	int timeout_running; /* record if timeout_thread is running */
};

enum {
	SERVER_LOCAL_CHANGE_PASSWD = ST_OP_MAX + 1,
	SERVER_LOCAL_LIST_USER,
	SERVER_LOCAL_MAX,
};

int idle_ssn_timeout = 15*60; /* session timeout: 15 minutes */
struct osnstm_session g_ssn;

static void free_stat(struct session_stat* stat)
{
	free(stat);
}

static void free_request(struct request* req)
{
	free(req->recv_xml);
	free(req->send_xml);
	free(req);
}

static void start_daemon(const char *daemon_name)
{
	char buf[64];
	char pid_file[MAX_NAME_LEN];
	pid_t pid;
	int i, fd, nullfd;

	if (!daemon_name)
		exit(1);

	st_debug("Starting %s...", daemon_name);
	snprintf(pid_file, MAX_NAME_LEN, "/var/run/%s.pid", daemon_name);
	fd = open(pid_file, O_WRONLY|O_CREAT, 0644);
	if (fd < 0) {
		st_err("Unable to create pid file");
		exit(1);
	}
	pid = fork();
	if (pid < 0) {
		st_err("Starting daemon failed");
		exit(1);
	} else if (pid)
		exit(0);

	if (chdir("/") < 0) {
		st_err("Failed to set working dir to /: %m");
		exit(1);
	}
	if (lockf(fd, F_TLOCK, 0) < 0) {
		st_err("Unable to lock pid file");
		exit(1);
	}
	if (ftruncate(fd, 0) < 0) {
		st_err("Failed to ftruncate the PID file: %m");
		exit(1);
	}

	sprintf(buf, "%d\n", (int)getpid());
	if (write(fd, buf, strlen(buf)) < strlen(buf)) {
		st_err("Failed to write PID to PID file: %m");
		exit(1);
	}

	nullfd = open("/dev/null", O_RDWR);
	if (nullfd != -1) {
		dup2(nullfd, STDIN_FILENO);
		dup2(nullfd, STDOUT_FILENO);
		dup2(nullfd, STDERR_FILENO);
		if (nullfd > 2)
			close(nullfd);
	} else {
		st_err("Failed to open /dev/null");
		exit(1);
	}

	for (i = 3; i < 1024; i++)
		close(i);

	setsid();
}

static void show_help(const char *name)
{
	const char *usage = "osnstm daemon\n"
	"  -d    set debug mode, print transport information into logfile\n"
	"  -h    show this information and exit\n";
	fprintf(stdout, "%s: %s", name, usage);
}

static int reused_sock(void)
{
	int sockfd, opt;
	int retry = 3;

resocket:
	if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		if (retry--)
			goto resocket;
		else {
			st_err("Failed to create socket (%s)", strerror(errno));
			return -1;
		}
	}

	opt = 1;
	if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof (opt))) {
		st_warn("Failed to set SO_REUSEADDR (%s)", strerror(errno));
		goto error;
	}

	return sockfd;

error:
	close(sockfd);
	return -1;
}

/**
 * send message to remote
 * return: -1 if failed, 0 if success
 */
int send_to_remote(int fd, struct st_header *hd, const char *xml)
{
	int size;

	if (!hd) {
		st_err("Invalid message head");
		return -1;
	}

	if (xml && (hd->data_length != strlen(xml))) {
		st_err("You must send %d Byte of xml string", hd->data_length);
		return -1;
	}

	size = do_write(fd, hd, ST_HEADER_LEN);
	if (size < 0) {
		st_err("Failed to send msg (%s)", strerror(errno));
		return -1;
	}
	st_debug("Send head: ret=%d, flag=%d, cmd=%d, data_len=%d",
		hd->ret_status, hd->flags, hd->cmd, hd->data_length);

	if (hd->data_length == 0)
		goto out;

	size = do_write(fd, xml, hd->data_length);
	if (size < 0) {
		st_err("Failed to send msg (%s)", strerror(errno));
		return -1;
	}
	st_debug("Send xml: %s", xml);

out:
	return 0;
}

int recv_from_remote(int fd, struct st_header *hd, char **xml)
{
	int read_sz;
	char *xml_tmp = NULL;

	if (!hd)
		return -1;

	read_sz = do_read(fd, hd, ST_HEADER_LEN);
	if (read_sz != ST_HEADER_LEN) {
		st_err("Failed to recv msg (%s)", strerror(errno));
		return -1;
	}
	st_debug("Recv head: ret=%d, flag=%d, pad=%d, cmd=%d, data_len=%d",
		(hd)->ret_status,
		(hd)->flags,
		(hd)->pad,
		(hd)->cmd,
		(hd)->data_length);

	if ((hd)->data_length) {
		/* allocate 1 Byte more than data length, in case of 'strlen(xml)' */
		xml_tmp = calloc(1, hd->data_length + 1);
		if (!xml_tmp) {
			st_err("Failed to allocate memory");
			return -1;
		}

		read_sz = do_read(fd, xml_tmp, (hd)->data_length);
		if (read_sz != (hd)->data_length) {
			free(xml_tmp);
			st_err("Failed to recv msg (%s)", strerror(errno));
			return -1;
		}
		st_debug("Recv xml: %s", xml_tmp);
	}

	if (!xml && xml_tmp) {
		free(xml_tmp);
	} else {
		*xml = xml_tmp;
	}

	return 0;
}

static void timeout_thread_exit(void *junk __attribute__((unused)))
{
	g_ssn.timeout_running = 0;
	pthread_mutex_unlock(&g_ssn.lock);
}

/**
 * _LOCK_ g_ssn.lock in this function
 */
static void *timeout_thread(void *junk __attribute__((unused)))
{
	struct timespec timeout;
	time_t curr_time;
	struct session_stat *stat, *stat_safe;
	int need_cond;

	timeout.tv_nsec = 0;

	pthread_cleanup_push(timeout_thread_exit, NULL);
	pthread_mutex_lock(&g_ssn.lock);

	while (!list_empty(&g_ssn.sessions)) {
		need_cond = 0;
		list_for_each_entry_safe(stat, stat_safe, &g_ssn.sessions, list) {
			if (stat->idle_timeout) {
				pthread_cancel(stat->thid);
				list_del(&stat->list);
				free_stat(stat);
			}
		}

		timeout.tv_sec = 0;
		curr_time = time(NULL);
		list_for_each_entry(stat, &g_ssn.sessions, list) {
			if (stat->next_time < curr_time) {
				stat->idle_timeout = 1;
				/* idle_timeout changed, refresh immediately */
				need_cond = 1;
			} else if (stat->sockfd == g_ssn.activefd) {
				/* update active socket's next_time */
				stat->next_time = curr_time + idle_ssn_timeout;
				g_ssn.activefd = 0;
			}

			if (timeout.tv_sec || timeout.tv_sec>stat->next_time)
				timeout.tv_sec = stat->next_time;
		}

		if (need_cond)
			pthread_cond_signal(&g_ssn.cond);

		/* unlock g_ssn.lock while wait for cond (or timeout) */
		pthread_cond_timedwait(&g_ssn.cond, &g_ssn.lock, &timeout);
	}

	pthread_cleanup_pop(1);

	return NULL;
}

static void register_for_session(struct session_stat *stat)
{
	int ret = 0;
	pthread_t thid;

	if (!stat)
		return;

	pthread_mutex_lock(&g_ssn.lock);

	list_add_tail(&stat->list, &g_ssn.sessions);
	if (g_ssn.timeout_running)
		pthread_cond_signal(&g_ssn.cond);
	else {
		ret = pthread_create(&thid, NULL, timeout_thread, NULL);
		if (ret != 0) {
			st_err("Failed to create timeout thread");
			return;
		}
		g_ssn.timeout_running = 1;
	}

	pthread_mutex_unlock(&g_ssn.lock);
}

/**
 * close other session(s), make sure only one user login,
 * lock g_ssn.lock in this function.
 */
static void unregister_for_sessions(const char *user_name)
{
	struct session_stat *stat;
	int need_cond = 0;

	if (!user_name)
		return;

	pthread_mutex_lock(&g_ssn.lock);

	if (!strcmp(user_name, ST_SUPER_USER)) {
		/* if super manager login, close all sessions first */
		list_for_each_entry(stat, &g_ssn.sessions, list) {
			stat->idle_timeout = 1;
			/* idle_timeout changed, refresh immediately */
			need_cond = 1;
		}
	} else {
		/* else, close this user's session first */
		list_for_each_entry(stat, &g_ssn.sessions, list) {
			if (!strcmp(stat->user_name, user_name)) {
				stat->idle_timeout = 1;
				/* idle_timeout changed, refresh immediately */
				need_cond = 1;
			}
		}
	}

	/* refresh g_ssn immediately if necessary */
	if (need_cond && g_ssn.timeout_running)
		pthread_cond_signal(&g_ssn.cond);

	pthread_mutex_unlock(&g_ssn.lock);

}

/**
 * _LOCK_ streamer.lock & g_ssn.lock in this function
 */
static void *launch_session(void *arg)
{
	int ret;
	struct session_stat *stat;
	int sockfd = *(int*)arg;
	struct request *req = NULL;

	free(arg);
	req = calloc(1, sizeof (struct request));
	if (!req) {
		st_err("Failed to malloc for 'struct request'");
		return NULL;
	}

	ret = recv_from_remote(sockfd, &req->recv_head, &req->recv_xml);
	if (ret < 0)
		return NULL;

	switch (req->recv_head.cmd) {
	case ST_OP_CLIENT_HEARTBEAT:
		/* TODO: process heart beat */
		free_request(req);
		return NULL;
	case ST_OP_LOGIN:
		/* TODO: process login */
	case ST_OP_LOGIN_FORCE:
		char user_name[USER_NAME_LEN] = {0};

		/* _LOCK_ streamer.lock in this function */
		req->send_head.ret_status = login(req, user_name);
		send_to_remote(sockfd, &req->send_head, req->send_xml);
		free_request(req);

		if (user_name[0]) {
			/* _LOCK_ g_ssn.lock in this function */
			unregister_for_sessions(user_name);
		}
		break;
	default:
		free_request(req);
		return NULL;
	}

	/* post login */
	stat = calloc(1, sizeof (*stat));
	if (!stat) {
		st_err("Failed to allocate memory for session stat");
		return NULL;
	}

	stat->thid = pthread_self();
	stat->sockfd = sockfd;
	stat->idle_timeout = 0;
	stat->next_time = time(NULL) + idle_ssn_timeout;

	/* _LOCK_ g_ssn.lock in this function */
	register_for_session(stat);

	while (1) {
		memset(req, 0, sizeof (struct request));
		/* blocked */
		ret = recv_from_remote(sockfd, &req->recv_head, &req->recv_xml);
		if (ret < 0)
			continue;

		pthread_mutex_lock(&g_ssn.lock);
		g_ssn.activefd = sockfd;
		pthread_mutex_unlock(&g_ssn.lock);
		/* refresh activefd's next_time immediately */
		pthread_cond_signal(&g_ssn.cond);

		/* init msg head to send */
		req->send_head.ret_status = ST_RES_FAILED;
		req->send_head.cmd = req->recv_head.cmd;

#if 0
		switch  (req->recv_head.cmd) {
		case ST_OP_SCAN_CLIENTS:
			req->send_head.ret_status = scan_client();
			break;
		case ST_OP_ADD_CLIENTS:
			break;
		case ST_OP_DEL_CLIENTS:
			break;
		case ST_OP_ADD_BACKUP:
			req->send_head.ret_status = add_backup(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_ESTABLISH_CHANNELS:
			req->send_head.ret_status = establish_channels(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_GET_CLIENTS_INFO:
			break;
		case ST_OP_DEL_CLIENTS_FORCE:
			break;
		case ST_OP_RENAME_CLIENT:
			req->send_head.ret_status = rename_client(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_GET_SERVER_INFO:
			break;
		case ST_OP_ADD_DISKS_TO_POOL:
			break;
		case ST_OP_DEL_DISKS_FROM_POOL:
			break;
		case ST_OP_SERVER_DISK_RESCAN:
			break;
		case ST_OP_ADD_DISKS_TO_POOL_FORCE:
			break;
		case ST_OP_DEL_BACKUP:
			req->send_head.ret_status = del_backup(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_SET_CDP_SCHEDULE:
			req->send_head.ret_status = set_cdp_schedule(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_INIT_MIRROR:
			req->send_head.ret_status = init_mirror(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_CANCEL_INIT_MIRROR:
			req->send_head.ret_status = cancel_init_mirror(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_REMOVE_MISSING_FROM_POOL:
			break;
		case ST_OP_GET_SNAPS_INFO_BY_SNAPID:
		case ST_OP_GET_SNAPS_INFO_BY_BIRTH_DATE:
			ret = get_snaps_info(req);
			req->send_head.ret_status = ret;
			if (ret) {
				send_to_remote(sockfd, &req->send_head, NULL);
				break;
			}

			req->send_head.data_length = strlen(req->send_xml) + 1;
			send_to_remote(sockfd, &req->send_head, req->send_xml);
			break;
		case ST_OP_CREATE_SNAPSHOT:
			req->send_head.ret_status = create_snapshot(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_DEL_SNAPSHOT:
			req->send_head.ret_status = del_snapshot(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_SNAP_RESTORE:
			req->send_head.ret_status = snap_restore(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_GET_CHANNELS_FOR_RESTORE:
			ret = get_channels_for_restore(req);
			req->send_head.ret_status = ret;
			if (ret) {
				send_to_remote(sockfd, &req->send_head, NULL);
				break;
			}

			req->send_head.data_length = strlen(req->send_xml) + 1;
			send_to_remote(sockfd, &req->send_head, req->send_xml);
			break;
		case ST_OP_RESTORE_SNAP_TO_CHANNEL:
			req->send_head.ret_status = restore_snap_to_channel(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_CANCEL_RESTORE:
			req->send_head.ret_status = cancel_restore(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_CLIENT_HEARTBEAT:
			ret = client_heartbeat(req);
			req->send_head.ret_status = ret;
			if (ret) {
				send_to_remote(sockfd, &req->send_head, NULL);
				break;
			}

			req->send_head.data_length = strlen(req->send_xml) + 1;
			send_to_remote(sockfd, &req->send_head, req->send_xml);
			break;
		case ST_OP_LOGOUT:
			req->send_head.ret_status = logout(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_ADDUSER:
			req->send_head.ret_status = adduser(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_CHANGE_PASSWD:
			req->send_head.ret_status = change_passwd(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case ST_OP_DELUSER:
			req->send_head.ret_status = deluser(req);
			send_to_remote(sockfd, &req->send_head, NULL);
			break;
		case SERVER_LOCAL_LIST_USER:
			ret = list_user(req);
			req->send_head.ret_status = ret;
			if (ret) {
				send_to_remote(sockfd, &req->send_head, NULL);
				break;
			}

			req->send_head.data_length = strlen(req->send_xml) + 1;
			send_to_remote(sockfd, &req->send_head, req->send_xml);
			break;
		case SERVER_LOCAL_CHANGE_PASSWD:
			ret = change_local_passwd(req);
			req->send_head.ret_status = ret;
			if (ret) {
				send_to_remote(sockfd, &req->send_head, NULL);
				break;
			}

			req->send_head.data_length = strlen(req->send_xml) + 1;
			send_to_remote(sockfd, &req->send_head, req->send_xml);
			break;
		default:
			st_debug("Unkown command: %d", req->recv_head.cmd);
			req->send_head.ret_status = ST_RES_CMD_NOT_SUPPORT;
			send_to_remote(sockfd, &req->send_head, NULL);
			/* I have no clue whats goin' on here... */
			break;
		}
#endif

		free_request(req);

		/* please make sure all resource created by this thread is freed */
		pthread_testcancel();
	}

	close(sockfd);

	return NULL;
}

void init_streamer(void)
{
	return;
}

static void init_session(void)
{
	memset(&g_ssn, 0, sizeof (g_ssn));
	INIT_LIST_HEAD(&g_ssn.sessions);
	pthread_mutex_init(&g_ssn.lock, NULL);
	pthread_cond_init(&g_ssn.cond, NULL);
	g_ssn.activefd = 0;
}

int main(int argc, char **argv)
{
	int sockfd = 0, unixfd = 0, maxfd = 0, *acceptfd = NULL;
	int argch, ret;
	pthread_t thid;
	socklen_t addrlen;
	struct sockaddr_in this_addr;
	struct sockaddr_un this_addr_un;
	struct sockaddr *peeraddr = NULL;

	if (argv[1] == NULL)
		argv[1] = "-";

	argch = getopt(argc, argv, "hd");
	debug_off();
	switch (argch) {
	case 'h':
		show_help(argv[0]);
		return 0;
	case 'd':
		debug_on();
		break;
	default:
		break;
	}

	start_daemon("streamer");

	signal(SIGPIPE, SIG_IGN);

	init_streamer();
	init_session();

	ret = pthread_create(&thid, NULL, timeout_thread, NULL);
	if (ret != 0) {
		st_err("Failed to create timeout_thrad");
		return -1;
	}

	/* tcp socket */
	memset(&this_addr, 0, sizeof(this_addr));
	this_addr.sin_family = AF_INET;
	this_addr.sin_port = htons(OSNSTM_CLIENT_PORT);
	this_addr.sin_addr.s_addr = htons(INADDR_ANY);

	sockfd = reused_sock();
	if (sockfd < 0) {
		st_err("Failed to socket()");
		goto error;
	}
	maxfd = maxfd > sockfd ? maxfd : sockfd;

	if (bind(sockfd, (struct sockaddr*)&this_addr, sizeof (struct sockaddr))) {
		st_err("Failed to bind (%s)", strerror(errno));
		goto error;
	}

	if (listen(sockfd, MAX_REQUEST)) {
		st_err("Failed to listen (%s)", strerror(errno));
		goto error;
	}

	/* unix socket */
	unlink(OSM_LOCAL_SOCK);
	unixfd = socket(AF_UNIX, SOCK_STREAM, 0);
	if (unixfd < 0) {
		st_err("Failed to socket()");
		goto error;
	}
	maxfd = maxfd > unixfd ? maxfd : unixfd;

	memset(&this_addr_un, 0, sizeof (this_addr_un));
	this_addr_un.sun_family = AF_UNIX;
	strncpy(this_addr_un.sun_path, OSM_LOCAL_SOCK, sizeof (this_addr_un.sun_path));
	ret = bind(unixfd, (struct sockaddr*)&this_addr_un, sizeof (this_addr_un));
	if (ret) {
		st_err("Failed to bind (%s)", strerror(errno));
		goto error;
	}

	ret = listen(unixfd, MAX_REQUEST);
	if (ret) {
		st_err("Failed to listen (%s)", strerror(errno));
		goto error;
	}

	addrlen = sizeof (struct sockaddr);
	while (1) {
		fd_set rdset;
		FD_ZERO(&rdset);
		FD_SET(sockfd, &rdset);
		FD_SET(unixfd, &rdset);

		select(maxfd+1, &rdset, NULL, NULL, NULL);

		acceptfd = calloc(1, sizeof (int));
		if (!acceptfd) {
			st_err("Failed to allocate memory for acceptfd");
			goto error;
		}

		if (FD_ISSET(sockfd, &rdset)) {
			*acceptfd = accept(sockfd, peeraddr, &addrlen);
		} else if (FD_ISSET(unixfd, &rdset)) {
			*acceptfd = accept(unixfd, peeraddr, &addrlen);
		}
		if (*acceptfd < 0) {
			if (errno == EINTR)
				st_debug("Accept is interrupted");
			else
				st_err("Failed to accept socket (%s)", strerror(errno));

			free(acceptfd);
			acceptfd = NULL;
			continue;
		}

		pthread_create(&thid, NULL, launch_session, acceptfd);
	}

	return 0;

error:
	if (sockfd > 0)
		close(sockfd);
	if (unixfd > 0)
		close(unixfd);
	return -1;
}
