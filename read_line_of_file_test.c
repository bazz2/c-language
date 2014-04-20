#include<stdio.h>
#include<stdlib.h>

void main(int argc, char **argv)
{
	FILE *fp;
	char buffer[256];
	if((fp = fopen(argv[1], "r")) != NULL) {
		//while(fgets(buffer, sizeof(buffer), fp)) {
			fgets(buffer, sizeof(buffer), fp);
			printf("%s\n", buffer);
		//}
	}
	fclose(fp);
}
