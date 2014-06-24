#include <stdio.h>
#include <string.h>
#include <fcntl.h>

#define BUF_SIZE 4096

int copy_file(const char *from, const char *to)
{
	int fd_r, fd_w;
	ssize_t read_bytes;
	char buf[BUF_SIZE];

	fd_r = open(from, O_RDONLY);
	if (fd_r < 0) {
		return -1;
	}

	fd_w = open(to, O_WRONLY|O_CREAT);
	if (fd_w < 0) {
		close(fd_r);
		return -1;
	}

	while (1) {
		memset(buf, 0, sizeof (buf));
		read_bytes = read(fd_r, buf, sizeof (buf));
		if (!read_bytes)
			break;

		write(fd_w, buf, read_bytes);
	}

	close(fd_r);
	close(fd_w);

	return 0;
}

int main()
{
	copy_file("test.orig", "test.orin.tmp");
	return 0;
}
