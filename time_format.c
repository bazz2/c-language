#include <stdio.h>
#include <time.h>
int main ()
{
	time_t rawtime;
	struct tm * timeinfo;
	char timE [80];
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );
	//strftime ( timE,80,"%Y-%m-%d %H:%M:%S\n", timeinfo);
	strftime ( timE,80,"%a %h %d %Y %H:%M:%S\n", timeinfo);
	printf ("%s", timE);
	return 0;
}
