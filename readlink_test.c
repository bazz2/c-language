#include<stdio.h>
#include<string.h>
#include<unistd.h>

#define MAX_PATH_LEN 256
void main()
{
	int result = 0;
	int index = 0;
        char true_dev[MAX_PATH_LEN] = "/tmp/5";
        char tmp_dev[MAX_PATH_LEN] = {0};
        while((result=readlink(true_dev, tmp_dev, sizeof(tmp_dev)))!=-1 \
                && index<5) {
		printf("%s\n", true_dev);
		printf("index: %d\n", index);
                index++;
                tmp_dev[result] = 0;
                strcpy(true_dev, tmp_dev);
        }
}
