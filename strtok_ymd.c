#include <stdio.h>  
#include <string.h>  

static int parse_ymd(char *time)
{
	char year[8] = {0};
	char month[4] = {0};
	char day[4] = {0};
	char *p;

	if(strlen(time) > 10)
		return 0;
	if(!(p = strtok(time, "/")))
		return 0;
	strcpy(year, p);
	if(!(p = strtok(NULL, "/")))
		return 0;
	strcpy(month, p);
	if(!(p = strtok(NULL, "/")))
		return 0;
	strcpy(day, p);

	if(strlen(year) != 4)
		return 0;
	if(atoi(year)<1970 || atoi(year)>3000)
		return 0;

	if(month[0]<'0' || month[0]>'9')
		return 0;
	if(month[1] && (month[1]<'0' || month[1]>'9'))
		return 0;
        if(atoi(month)<1 || atoi(month)>12)
                return 0;

	if(day[0]<'0' || day[0]>'9')
		return 0;
	if(day[1] && (day[1]<'0' || day[1]>'9'))
		return 0;
        if(atoi(day)<1 || atoi(day)>31)
                return 0;

	return 1;
}
int main(int argc, char **argv)
{  
	char time[32] = {0};
	strcpy(time, argv[1]);
	if(parse_ymd(time))
		printf("valid time\n");
	else
		printf("invalid time\n");
}
