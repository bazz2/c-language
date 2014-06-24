#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#define OSNLOG_BUFFSZ (20)

#define TEST_FILE "osn.debug"

#define MIN(x,y) (x)<(y)?(x):(y)

int main()
{
	int fd;
	off_t start_pos, end_pos, pos;
	int read_bytes, filesz, idx;
	int read_end = 0;
	char buf[OSNLOG_BUFFSZ+1], *char_tmp;
	int i = 3;

	fd = open("test", O_RDONLY);
	if (fd == -1)
		return -1;

	end_pos = lseek(fd, 0, SEEK_END);
	if (end_pos <= 0) /* blank file or pipe/FIFP/socket */
		goto out;

	start_pos = lseek(fd, 0, SEEK_SET);
	if (start_pos == -1) /* open pipe, FIFO or socket, do nothing */
		goto out;

	pos = start_pos;
	while (1) {
		read_bytes = MIN(end_pos - pos, OSNLOG_BUFFSZ);
		if (read_bytes <= 0)
			break;

		memset(buf, 0, OSNLOG_BUFFSZ+1);
		read(fd, buf, read_bytes); /* note: SEEK_CUR's position changed */
		/* we need get unbroken lines  */
		char_tmp = strrchr(buf, '\n');
		if (char_tmp)
			*char_tmp = 0;
		else
			continue;
printf("%s\n", buf);

		pos = lseek(fd, 0, SEEK_CUR);
		idx = read_bytes - (char_tmp - buf) - 1;

		pos = lseek(fd, pos-idx, SEEK_SET);

	}

out:
	close(fd);
}

