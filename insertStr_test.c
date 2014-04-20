#include<stdio.h>
#include<string.h>

void insertStr(char *desStr, const char *PosStr, const char *str)
{
        char temp[256] = {0};
        strcpy(temp, desStr);
        char *ptr = strstr(temp, PosStr);
        ptr += strlen(PosStr);
        *ptr = '\0'; //split temp string
        ptr = strstr(desStr, PosStr);
        ptr = ptr + strlen(PosStr) + 3; // ptr point to ';' which after "ALL"
        strcat(temp, str);
        strcat(temp, ptr);
        strcpy(desStr, temp);
}

void main()
{
	char sch[256] = "Year:ALL;Month:ALL;Day:ALL;WeekNum:ALL;DayOfWeek:ALL;Hour:ALL;Minute:ALL;Second:0;IntervalDays:ALL;IntervalMinutes:ALL";
	insertStr(sch, "IntervalMinutes:", "13");
	printf("%s\n", sch);
	
}
