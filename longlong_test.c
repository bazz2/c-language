#include<stdio.h>

void main()
{
	unsigned int year = 112;
	unsigned int mon = 12;
	unsigned int day = 30;
	unsigned int hour = 24;
	unsigned int minute = 59;
	unsigned int time = year*10000 + mon*100 + day;
	printf("%u\n", time);
}
