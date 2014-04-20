#include<stdio.h>
#include<string.h>
#include<unistd.h>
int main(int argc,char **argv)
{
	int ch;
	opterr = 0;
	char command[512] = {0};
	strcpy(command, "lvs -o,lv_uuid ");
	while((ch = getopt(argc,argv,"l:e::nd"))!= -1) 
	{
		switch(ch)
		{
		case 'l':
			strcat(command, optarg);
			strcat(command, "|grep -v 'LV UUID'>/tmp/.osnlv_uuid");
			system(command);
		//	system("cat /tmp/.osnlv_uuid");
			printf("%s\n", optarg);
			break;
		case 'e': 
			printf("e:%s\n", optarg);break;
		case 'n':
			printf("n:\n");break;
		case 'd':
			printf("d:\n");break;
		default:
			printf("%c: unknow para\n",ch);break;
		}
	}
	printf("+++++++++++++++++++++++\n");
	int i;
	printf("argc = %d\n", argc);
	for(i = 0; i < argc; i++)
	{
		printf("argv[%d] = %s\n", i, argv[i]);
	}
	printf("\n");
}
