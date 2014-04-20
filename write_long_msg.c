#include<stdio.h>
#include<string.h>
#include<errno.h>

static int writen(int fd, const void *buf, size_t len)
{
        int total = 0, ret;

        while (len) {
                ret = write(fd, (char*)buf + total, len);
		printf("ret=%d, total=%d\n", ret, total);
                if (ret == 0) {
                        printf("Connectiong is closed (%d bytes left)\n", len);
                        return -1;
                }
                if (ret < 0) {
                        if (errno == EAGAIN || errno == EINTR)
                                continue;
                        printf("Failed to write (%s)\n", strerror(errno));
                        return -1;
                }

                len -= ret;
                total += ret;
        }

        return 0;
}

int main()
{
	const char *cmd_ok = "chenjt";
	int fd = open("123", "w");
	int count = write(fd, cmd_ok, strlen(cmd_ok));
	close(fd);
	printf("ok: %d, strlen: %d\n", count, strlen(cmd_ok));
	return 0;
}
