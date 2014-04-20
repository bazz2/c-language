#include <stdio.h>  
#include <string.h>  

static int parse_month(char *time)
{
	char months[32] = {0};
	char month[4] = {0};
	char day[4] = {0};
	char *p;
        p = strtok(time, "/"); /* get months */                                                       
        if((!p) || (strlen(p)>26))
                return 0;                                                                            
        strcpy(months, p);
        p = strtok(NULL, "/"); /* get day */
        if((!p) || (strlen(p)>2))
                return 0;
        strcpy(day, p);

	if(day[0]<'0' || day[0]>'9')
		return 0;
	if(day[1] && (day[1]<'0' || day[1]>'9'))
		return 0;
	if(atoi(day)<1 || atoi(day)>31)
		return 0;
	p = strtok(months, ",");
	if(!p) return 0;
	while(p){
        	if(strlen(p)>2)
			return 0;
		strcpy(month, p);
		if(month[0]<'0' || month[0]>'9')
			return 0;
		if(month[1] && (month[1]<'0' ||month[1]>'2'))
			return 0;
		if(atoi(month)<1 || atoi(month)>12)
			return 0;
		p = strtok(NULL, ",");
	}
	return 1;
}
int main(int argc, char **argv)
{  
	char time[32] = {0};
	strcpy(time, argv[1]);
	if(parse_month(time))
		printf("valid time\n");
	else
		printf("invalid time\n");
}
