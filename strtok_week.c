#include <stdio.h>  
#include <string.h>  

static int parse_week(char *time)
{
	char wday[4] = {0};
	char *p;

	if(strlen(time) > 13)
		return 0;
	p = strtok(time, ",");
	if(!p) return 0;
	while(p){
        	if(strlen(p)>1)
			return 0;
		strcpy(wday, p);
		if(wday[0]<'0' || wday[0]>'9')
			return 0;
		if(wday[1] && (wday[1]<'0' ||wday[1]>'2'))
			return 0;
		if(atoi(wday)<0 || atoi(wday)>6)
			return 0;
		p = strtok(NULL, ",");
	}
	return 1;
}
int main(int argc, char **argv)
{  
	char time[32] = {0};
	strcpy(time, argv[1]);
	if(parse_week(time))
		printf("valid time\n");
	else
		printf("invalid time\n");
}
