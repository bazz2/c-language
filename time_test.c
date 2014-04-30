/*
#include<time.h>
#include<stdio.h>

void main()
{
	long timestamp = time(NULL);
	printf("%s\n",ctime(&timestamp));
	while(1){
	time_t nowtime;
	struct tm *timeinfo;
	nowtime = time(NULL);
	timeinfo = localtime(&nowtime);
	if(timeinfo->tm_sec)
		printf("second: %d\n", timeinfo->tm_sec);
	printf("year: %d\n", timeinfo->tm_year);
	printf("month: %d\n", timeinfo->tm_mon);
	printf("day: %d\n", timeinfo->tm_mday);
	printf("hour: %d\n", timeinfo->tm_mday);
	printf("minute: %d\n", timeinfo->tm_mday);
	sleep(1);
}
	int asc = toascii(timeinfo->tm_year);
	printf("*****ascii year: 0x%x\n", asc);
	printf("*****year: 0x%x\n", timeinfo->tm_year);
	
	printf("year: %d\n", timeinfo->tm_year);
	printf("month: %d\n", timeinfo->tm_mon);
	printf("mday: %d\n", timeinfo->tm_mday);
	printf("hour: %d\n", timeinfo->tm_hour);
	printf("minute: %d\n", timeinfo->tm_min);
	printf("sec: %d\n", timeinfo->tm_sec);
	printf("wday: %d\n", timeinfo->tm_wday);
	printf("yday: %d\n", timeinfo->tm_yday);
	printf("isdst: %d\n", timeinfo->tm_isdst);
	printf("current time is: %s", asctime(timeinfo));
	free(timeinfo);
}
*/
#include <stdio.h>
#include <time.h>
#include <memory.h>
int main(void)
{
	time_t timep;
	struct tm *p;
	struct tm timeinfo;
	char tmp[512];

#if 0
	time(&timep);
	printf("time() : %d \n",timep);
	p=localtime(&timep);
	timep = mktime(p);
	printf("%d\n", p->tm_year);
	printf("time()->localtime()->mktime():%d\n",timep);
	printf("year: %d\n", p->tm_year+1900);
	printf("month: %d\n", p->tm_mon);
	printf("mday: %d\n", p->tm_mday);
	printf("hour: %d\n", p->tm_hour);
	printf("minute: %d\n", p->tm_min);
	printf("second: %d\n", p->tm_sec);
	printf("wday: %d\n", p->tm_wday);
printf("++++++++++++++++++++++++++++\n\n");
#endif

	memset(&timeinfo, 0, sizeof (struct tm));
	timeinfo.tm_year = 2014-1900;
	timeinfo.tm_mon = 4;
	timeinfo.tm_mday = 6;
	timeinfo.tm_hour = 9;
	timeinfo.tm_min = 37;

	strftime(tmp, 512, "%Y/%m/%d %I:%M:%S", &timeinfo);
//	printf("is dst: %d\n", timeinfo.tm_isdst);
	printf("%s\n", tmp);

	timep = mktime(&timeinfo);
	printf("timep: %d\n", timep);
	p=localtime(&timep);
	strftime(tmp, 512, "%Y/%m/%d %I:%M:%S", p);
//	printf("is dst: %d\n", p->tm_isdst);
	printf("%s\n", tmp);
#if 0
	printf("year: %d\n", p->tm_year);
	printf("month: %d\n", p->tm_mon);
	printf("mday: %d\n", p->tm_mday);
	printf("hour: %d\n", p->tm_hour);
	printf("minute: %d\n", p->tm_min);
	printf("second: %d\n", p->tm_sec);
	printf("wday: %d\n", p->tm_wday);
#endif
}
/*
#include <stdio.h>
#include <memory.h>
#include <time.h>

static time_t parse_exectime(char *time)
{
        struct tm timeinfo;
        int hour, minute;

        if (!time)
                return 0;

        memset(&timeinfo, 0, sizeof (struct tm));

        if (2 == sscanf(time, "%d:%d", &hour, &minute)) {
                timeinfo.tm_hour = hour;
                timeinfo.tm_min = minute;
        } else
                return 0;

        return mktime(&timeinfo);
}

void main()
{
	printf("%d\n", parse_exectime("00:00"));
}
*/
