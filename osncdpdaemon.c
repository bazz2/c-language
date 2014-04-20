#include <stdio.h>
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
	FILE *fp;
	while (1) {
		memset(pc.buffer, 0, sizeof (struct cdp_schedule));
		fp = fopen("/var/run/osncdpsch.fifo", "r");
		fread(pc.buffer, 200, 1, fp);
		printf("%d -> %s -> %d\n", pc.cs.operate, pc.cs.vol_path, pc.cs.interval);
		fclose(fp);
	}
}
