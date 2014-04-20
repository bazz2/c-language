#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <blkid/blkid.h>
#include <sys/statvfs.h>

enum vfssize {
	NONE,
	TOTAL_SIZE,
	FREE_SIZE,
	USED_SIZE,
	AVAIL_SIZE
};

char *byte_size_to_str(fsblkcnt_t size)
{
	char *size_str;
	const double k = 1024;
	const double m = k * k;
	const double g = m * k;
	const double t = g * k;

	size_str = (char*)malloc(128);
	if (size >= t)
		sprintf(size_str, "%0.2lfTB", size/t);
	else if (size >= g)
		sprintf(size_str, "%0.2lfGB", size/g);
	else if (size >= m)
		sprintf(size_str, "%0.2lfMB", size/m);
	else if (size >= k)
		sprintf(size_str, "%0.2lfKB", size/k);
	else
		sprintf(size_str, "%0.0lfByte", size>=0 ? size : 0.0);

	return size_str;
}

fsblkcnt_t get_vfs_size(struct statvfs *buf, enum vfssize flag)
{
	fsblkcnt_t block;
	fsblkcnt_t bsize;

	bsize = buf->f_bsize;

	switch (flag) {
	case TOTAL_SIZE:
		block = buf->f_blocks;
		break;
	case FREE_SIZE:
		block = buf->f_bfree;
		break;
	case USED_SIZE:
		block = buf->f_blocks - buf->f_bavail;
		break;
	case AVAIL_SIZE:
		block = buf->f_bavail;
		break;
	default:
		block = 0;
		break;
	}
	return bsize * block;
}

int main(int argc, char **argv)
{
	blkid_probe pr;
	struct statvfs buf;
	const char *uuid;
	const char *type;
	fsblkcnt_t size;
	int ret;

/*
	if (argc != 2) {
		printf("usage: %s devname\n", argv[0]);
		return -1;
	}
*/

	pr = blkid_new_probe_from_filename(argv[1]);
	if (!pr) {
		printf("Failed to open %s\n", argv[1]);
		return -1;
	}

	blkid_do_probe(pr);
	if (blkid_probe_lookup_value(pr, "UUID", &uuid, NULL) == -1) {
		printf("Failed to get uuid of %s\n", argv[1]);
		return -1;
	}
	if (blkid_probe_lookup_value(pr, "TYPE", &type, NULL) == -1) {
		printf("Failed to get fs type of %s\n", argv[1]);
		return -1;
	}

	printf("UUID = %s\n", uuid);
	printf("TYPE = %s\n", type);
	blkid_free_probe(pr);

	memset(&buf, 0, sizeof (buf));
	if (statvfs(argv[2], &buf) < 0) {
		printf("statvfs(): %m\n");
		return -1;
	}
printf("[%s]mount flag: %d\n", argv[2], buf.f_flag);

	size = get_vfs_size(&buf, TOTAL_SIZE);
	printf("  total: %s\n", byte_size_to_str(size));
	size = get_vfs_size(&buf, USED_SIZE);
	printf("  used: %s\n", byte_size_to_str(size));
	size = get_vfs_size(&buf, AVAIL_SIZE);
	printf("  avail: %s\n", byte_size_to_str(size));

	return 0;
}
