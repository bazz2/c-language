#include <stdio.h>
#include <fcntl.h>
#include <memory.h>
#include <linux/limits.h>
#include <netinet/in.h>

typedef uint16_t month_t;
typedef uint8_t week_t;

struct cdp_schedule {
        char vol_path[PATH_MAX];
        struct in_addr ipaddr;     /* client host which runs cdpagent */
        int mode;             /* one of min/day/week/mon         */
        time_t starttime;          /* min/day mode                    */
        time_t exectime;           /* week/mon mode                   */
        unsigned int interval;     /* time span for min/day mode      */
        unsigned int mday;         /* day in month                    */
        week_t wdays;              /* days in a week                  */
        month_t months;            /* months                          */

        /* followed is internal parameter */
        int operate;
};

union pipecmd {
	struct cdp_schedule cs;
	char buffer[200];
};

void main()
{
	union pipecmd pc;
	int ret;
	memset(&pc, 200, 1);
	strcpy(pc.cs.vol_path, "fuckyou");
	pc.cs.operate = 2;
	pc.cs.interval = 100;
	int fd = open("/var/run/osncdpsch.fifo", O_WRONLY|O_NONBLOCK|O_CREAT);
	write(fd, pc.buffer, 200);
	close(fd);
}
