#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void main(int argc, char **argv)
{
/*
	char command[1024] = "lvs -o,lv_path ";
	char buffer[1024] =  {0};
	char tmp[2] = {0};
	strcat(command, " 2>/dev/null|grep -v 'Path'");
	FILE *fp = popen(command, "r");
	char ch;
	while((ch = getc(fp)) != EOF)
	{
		if(ch == ' ') 
			continue;
		else if(ch == '\n')
			tmp[0] = ':';
		else
			tmp[0] = ch;
		strcat(buffer, tmp);
	}
	printf("%s\n", buffer);
	pclose(fp);
*/
/*
	char command[1024] = "lvs -o,lv_uuid ";
	char buffer[64] =  {0};
	strcat(command, argv[1]);
	strcat(command, " 2>/dev/null|grep -v 'LV UUID'");
	FILE *fp = popen(command, "r");
	fgets(buffer, sizeof(buffer), fp);
	printf("%s", buffer);
	pclose(fp);
*/

	// check if logical volume exist
	char command[1024] = "lvs ";
	char buffer[64] =  {0};
	strcat(command, argv[1]);
	strcat(command, " >/dev/null 2>&1");
	int i = system(command); //if exist, return 0, else return an error code
	printf("%d\n", i);
/*
	char cmd[512] = "cat /etc/lvm/backup/VG01";
	system(cmd);
*/
}
