#include<stdio.h>
#include<netdb.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <arpa/inet.h>
void print_sock_errors(); 
void main()
{
	print_sock_errors();
}
void print_sock_errors() {
	int i;
#define _ITEM(i)  {i, #i}
	struct sock_error {
		int error;
		char str[32];
	} errors[] = {
			_ITEM(EAGAIN),
			_ITEM(EWOULDBLOCK),
			_ITEM(EBADF),
			_ITEM(ECONNREFUSED),
			_ITEM(EFAULT),
			_ITEM(EINTR),
			_ITEM(EINVAL),
			_ITEM(ENOMEM),
			_ITEM(ENOTCONN),
			_ITEM(ENOTSOCK),
			_ITEM(EACCES),
			_ITEM(ECONNRESET),
			_ITEM(EDESTADDRREQ),
			_ITEM(EMSGSIZE),
			_ITEM(ENOBUFS),
			_ITEM(EOPNOTSUPP),
			_ITEM(EPIPE),
			_ITEM(EPERM),
			_ITEM(EADDRINUSE),
			_ITEM(EAFNOSUPPORT),
			_ITEM(EALREADY),
			_ITEM(EINPROGRESS),
			_ITEM(EISCONN),
			_ITEM(ENETUNREACH),
			_ITEM(ETIMEDOUT),
			_ITEM(EMFILE),		//accept
			_ITEM(ENFILE),		//accept
			_ITEM(EPROTO),
			_ITEM(EADDRINUSE),
			_ITEM(EADDRNOTAVAIL),	//bind
			_ITEM(ELOOP),			//bind
			_ITEM(ENAMETOOLONG),	//bind
			_ITEM(ENOENT),			//bind
			_ITEM(ENOTDIR),			//bind
			_ITEM(EROFS),			//bind
			_ITEM(EPROTONOSUPPORT),	//socket
		};

	for(i = 0; i < sizeof(errors) / sizeof(errors[0]); i ++) {
		errno = errors[i].error;
		perror(errors[i].str);
	}

	printf("\n\n");
}
