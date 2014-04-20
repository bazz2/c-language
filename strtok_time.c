#include <stdio.h>  
#include <string.h>  

static int parse_time(char *time)
{
	char hour[4] = {0};
	char minute[4] = {0};
	char second[4] = {0};
	char *p;
        p = strtok(time, ":"); /* get hour */                                                       
        if((!p) || (strlen(p)>2))
                return 0;                                                                            
        strcpy(hour, p);
        p = strtok(NULL, ":"); /* get minute */
        if((!p) || (strlen(p)>2))
                return 0;
        strcpy(minute, p);
        p = strtok(NULL, ":"); /* get second */
        if(p) {
		 if(strlen(p)>2)
                	return 0;
        	strcpy(second, p);
	}

        if(hour[0]<'0' || hour[0]>'9')                                                       
                return 0;
        if(hour[1] && (hour[1]<'0' || hour[1]>'9'))                                                   
                return 0;
        if(atoi(hour)<0 || atoi(hour)>23)                                                    
                return 0;
        if(minute[0]<'0' || minute[0]>'9')                                                   
                return 0;
        if(minute[1] && (minute[1]<'0' || minute[1]>'9'))
                return 0;
        if(atoi(minute)<0 || atoi(minute)>59)
                return 0;                                                                            
	if(second[0]) {
        	if(second[0]<'0' || second[0]>'9')                                      
        	        return 0;
        	if(second[1] && (second[1]<'0' || second[1]>'9'))
        	        return 0;
        	if(atoi(second)<0 || atoi(second)>59)
        	        return 0;
	}
	return 1;
        
}
int main(int argc, char **argv)
{  
	char time[32] = {0};
	strcpy(time, argv[1]);
	if(parse_time(time))
		printf("valid time\n");
	else
		printf("invalid time\n");
}
