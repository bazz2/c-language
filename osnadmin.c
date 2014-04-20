#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#define OPT_NUMBER 9

typedef enum {
	TYPE_HELP,
	TYPE_LIST_HANDLER,
	TYPE_LIST_DEVICE,
	TYPE_LIST_DRIVER,
	TYPE_LIST_TARGET,
	TYPE_LIST_GROUP,
	TYPE_LIST_DGRP,
	TYPE_LIST_TGRP,

	TYPE_NUM
}op_t;

const char *short_options = "h";
const struct option long_options[] = {
	{"help", 0, NULL, 'h'},
	{"list_handler", 2, NULL, TYPE_LIST_HANDLER},
	{"list_device", 2, NULL, TYPE_LIST_DEVICE},
	{"list_driver", 2, NULL, TYPE_LIST_DRIVER},
	{"list_target", 2, NULL, TYPE_LIST_TARGET},
	{"list_group", 2, NULL, TYPE_LIST_GROUP},
	{"list_dgrp", 2, NULL, TYPE_LIST_DGRP},
	{"list_tgrp", 2, NULL, TYPE_LIST_TGRP},
	{NULL, 0, NULL, 0},
};

static void show_help()
{
	fprintf(stdout, "hehe\n");
}
static int parse_params(int argc, char **argv)
{
	int ch;
	if(argc == 0)
		return 0;
	while((ch = getopt_long(argc, argv, short_options,
			long_options, NULL)) != -1) {
		printf("ch = %d\n", ch);
		switch(ch) {
		case '?':
			printf("Unknown option\n");
			break;
		case 'h':
			show_help();
			break;
		case TYPE_LIST_HANDLER:
			printf("handler\n");
			
			break;
		}
	}
}

int main(int argc, char **argv)
{
	printf("hello world\n");
	if(!parse_params(argc, argv)) {
		return 0;
	}
	return 1;
}
