#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void main()
{

	FILE *fp = fopen("mark", "r");
        if(fp ==NULL)
        {
                printf("can't open file\n");
                exit(0);
        }

        fseek(fp, 0, SEEK_END);
        unsigned long filesize = ftell(fp);
	printf("filesize = %d\n", filesize);
        rewind(fp);
        char* buf = (char*)malloc(filesize + 1);
        memset(buf, 0, filesize + 1);
	printf("sizeof fp is: %d\n", sizeof(buf));
	printf("ftell fp is: %d\n", filesize);
	printf("size of char* is: %d\n", sizeof(char*));
        fclose(fp);
	free(buf);
}
