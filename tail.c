#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#define OSNLOG_LINESZ 1024
#define OSNLOG_BUFFSZ (2000)

#define TEST_FILE "osn.debug"

#define MIN(x,y) (x)<(y)?(x):(y)
#define MAX(x,y) (x)>(y)?(x):(y)

static int find_line_head_in_buf(const char *buf)
{
	int i = 0;

	while(*(buf+i) != '\n') {
		i++;
	}

	return i + 1;
}

int main()
{
	int fd;
	off_t start_pos, end_pos, curpos, pos;
	int read_bytes, filesz, idx;
	int read_end = 0;
	char buf[OSNLOG_BUFFSZ], *char_tmp;
	int i = 3;

	fd = open("test", O_RDONLY);
	if (fd == -1)
		return -1;

printf("%d\n", fd);
	start_pos = lseek(fd, 0, SEEK_CUR);
	if (start_pos == -1) /* open pipe, FIFO or socket, do nothing */
		goto out;

	end_pos = lseek(fd, 0, SEEK_END);
	if (start_pos >= end_pos) /* blank file or pipe/FIFP/socket */
		goto out;

	read_bytes = end_pos;
	pos = end_pos;
	while (i--) {
		read_bytes = MIN(pos, OSNLOG_BUFFSZ);
		pos = lseek(fd, -read_bytes, SEEK_CUR);
		/* it seems that we must use the whence of 'SEEK_SET' if we
		 * want to get some bytes by the use of 'read()' */
		lseek(fd, pos, SEEK_SET);

		memset(buf, 0, OSNLOG_BUFFSZ);
		read(fd, buf, read_bytes); /* note: SEEK_CUR's position changed */
		/* the end byte's value of a file is 'EOF', we need ignore it */
		char_tmp = strrchr(buf, '\n');
		*char_tmp = 0;

		idx = 0;
		if (pos != 0) {
			/* haven't reach start of file */
//			idx = find_line_head_in_buf(buf);
			char_tmp = strchr(buf, '\n');
			idx = char_tmp - buf;
			pos = lseek(fd, pos+idx, SEEK_SET);
		} else /* read over, time to goto out */
			read_end = 1;

printf("%s\n\n", buf+idx);
		if (read_end)
			goto out;

	}

out:
	close(fd);
}

