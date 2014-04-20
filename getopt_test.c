#include<stdio.h>
#include<string.h>
#include<unistd.h>
/*
int main(int argc,char **argv)
{
	int ch;
	opterr = 0;
	char command[512] = {0};
	strcpy(command, "lvs -o,lv_uuid ");
	while((ch = getopt(argc,argv,"l:de::"))!= -1) 
	{
		switch(ch)
		{
			case 'l':
				strcat(command, optarg);
				strcat(command, "|grep -v 'LV UUID'>/tmp/.osnlv_uuid");
				system(command);
				//system("cat /tmp/.osnlv_uuid");
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
	int i;
	for(i = 0; i < argc; i++)
		printf("%s\n", argv[i]);
}
*/

int main(int argc,char *argv[]) 
{ 
  int ch; 
  opterr=0; 

  while((ch=getopt(argc,argv,"a:b:cd"))!=-1) 
  { 
    printf("ch: %c\n",ch); 
    printf("optind: %d\n",optind); 
    printf("argv[%d]: %s\n",optind, argv[optind]); 
    printf("optarg: %s\n",optarg); 
    printf("optopt: %c\n",optopt); 
    printf("=============\n"); 
/*
    switch(ch) 
    {   
      case 'a': 
        printf("option a: '%s'\n",optarg); 
        break; 
      case 'b': 
        printf("option b: '%s'\n",optarg); 
        break; 
      case 'c': 
        printf("option c\n"); 
        break; 
      case 'd': 
        printf("option d\n"); 
        break; 
      default:
        printf("other option: %c\n",ch); 
    } 
*/
  } 
  printf("optind: %d\n",optind); 
}
