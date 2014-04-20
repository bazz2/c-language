#include<stdio.h>
#include<stdlib.h>
#include<getopt.h>
typedef enum { 
	TYPE_HELP, 
	TYPE_LIST_HANDLER,
	TYPE_LIST_DEVICE, 
	TYPE_LIST_DRIVER, 

	TYPE_NUM 
}opt;

const char *short_options = "h";
const struct option long_options[] = { 
	{"help", 0, NULL, 0},
	{"list_handler", 0, NULL, TYPE_LIST_HANDLER}, 
	{"list_device", 1, NULL, TYPE_LIST_DEVICE}, 
	{"list_driver", 2, NULL, TYPE_LIST_DRIVER}, 
	{0, 0, 0, 0}, 
};
int main(int argc, char **argv)
{
	int ch;
	if(argc == 0)
		return 0;
	while((ch = getopt_long(argc, argv, short_options, long_options, NULL)) != -1) {
		printf("ch = %d\n", ch);
		switch(ch) {
		case '?':
			printf("unknown param\n");
			break;
		}
	}
}
