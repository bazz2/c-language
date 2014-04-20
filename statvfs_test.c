#include <stdio.h>
#include <sys/statvfs.h>
#include <sys/types.h>

int main(int argc, char **argv)
{
	struct statvfs buf;
	if (statvfs(argv[1], &buf) != 0) {
		perror("statvfs");
		return -1;
	}

	printf("buf.f_bsize: %ld\n", buf.f_bsize);
	printf("buf.f_frsize: %ld\n", buf.f_frsize);
	printf("buf.f_blocks: %ld\n", buf.f_blocks);
	printf("buf.f_bfree: %ld\n", buf.f_bfree);
	printf("buf.f_fsid: %ld\n", buf.f_fsid);
	return 0;
}
