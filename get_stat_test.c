#include <stdio.h>
#include <sys/stat.h>
#include <linux/major.h>

int is_resides_on_scsi_disk(const char *file_path)
{
        int ret, major;
        struct stat stat_buf;

        if (!file_path)
                return 0;

        ret = stat(file_path, &stat_buf);
        if (-1 == ret) {
                return 0;
        }

        major = stat_buf.st_dev >> 8;
        if (major == SCSI_DISK0_MAJOR)
                return 1;
        if (major >= SCSI_DISK1_MAJOR && major <= SCSI_DISK7_MAJOR)
                return 1;
        if (major >= SCSI_DISK8_MAJOR && major <= SCSI_DISK15_MAJOR)
                return 1;

        return 0;
}
 
int main(int argc, char **argv)
{
	struct stat s;
	int ret;

	if (argc != 2) {
		printf("%s <file>\n", argv[0]);
		return -1;
	}

	ret = is_resides_on_scsi_disk(argv[1]);
	printf("%s %s residing on scsi disk\n", argv[1], ret?"is":"isn't") ;

	return ret;
}
