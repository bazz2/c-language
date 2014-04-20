#include<stdio.h>
#include<string.h>
#include<time.h>

void FormatSysTime(char *des_str, int num)
{
        char tmp[3] = {0};
        des_str[0] = ',';
        if(num / 10)
        {
                tmp[0] = num / 10 + 48;
                tmp[1] = num % 10 + 48;
        }
        else
                tmp[0] = num + 48;
	printf("tmp[0] = %d, tmp[1] = %d\n", tmp[0], tmp[1]);
        strcat(des_str, tmp);
        strcat(des_str, ",");
}

void main()
{
	char str[8] = {0};
	char str1[8] = {0};
	time_t nowtime = time(NULL);
	struct tm *timeinfo = localtime(&nowtime);
	printf("%d\n", timeinfo->tm_mday);
	FormatSysTime(str, timeinfo->tm_mday);
	FormatSysTime(str1, 12);
	printf("%s\n", str);
	printf("%s\n", str1);
}
