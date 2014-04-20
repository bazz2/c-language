#include<stdio.h>
#include<stdint.h>
#include<memory.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>
#include<arpa/inet.h>

#define FIFO_NAME "/var/run/osncdpsch.fifo"
#define MAX_PIPEBUFF_LEN 200
#define MAX_PATH_LEN 4096

struct cdp_schedule {
        char vol_path[MAX_PATH_LEN];
        struct in_addr ipaddr;  /* client host which runs cdpagent */
        int mode;               /* one of min/day/week/mon         */
        int starttime;          /* min/day mode                    */
        time_t exectime;           /* week/mon mode                   */
        time_t interval;           /* time span for min/day mode      */
        int mday;               /* day in month                    */
        uint8_t wdays;           /* days in a week                  */
        uint16_t months;         /* months                          */

        /* followed is internal parameter */
//        struct list_head sch_list;
};

union pipe_cmd {
	struct cdp_schedule cdpsch;
	char buffer[MAX_PIPEBUFF_LEN];
};

void main()
{

	union pipe_cmd pc;
        if(access(FIFO_NAME, F_OK) == -1)
        {
                if(mkfifo(FIFO_NAME, S_IFIFO|6060) == -1)
                {
                        printf("mkfifo error!");
                        return;
                }
        }
	mode_t old = umask(0);
        int fd = open(FIFO_NAME, O_RDONLY);
	umask(old);
        if(fd == -1)
        {
                printf("fopen error!");
                return;
        }

        while(1)
        {
                memset(pc.buffer, 0, sizeof(pc.buffer));
                if(read(fd, pc.buffer, sizeof(pc.buffer)) > 0) {
                        printf("Name: %s\n", pc.cdpsch.vol_path);
                        printf("Mode: %d\n", pc.cdpsch.mode);
		}
        }
        close(fd);
}
