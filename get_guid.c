#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void get_GUID(char *guid_str, const char *lv_name_str)
{
        char command[1024] = "lvs -o,lv_uuid ";
        char buffer[64] =  {0};
	char *p = buffer;
        strcat(command, lv_name_str);
        strcat(command, " 2>/dev/null|grep -v 'LV UUID'");
        FILE *fp = popen(command, "r");
        fgets(buffer, sizeof(buffer), fp);
        pclose(fp);
	p = buffer;
	while(p++) {
		if(*p == '\n') {
			*p = '\0';
			break;
		} else if (*p == '\0') {
			break;	
		}
	}
        strcpy(guid_str, "osn_{");
	p = buffer + 2;
        strcat(guid_str, p);
        strcat(guid_str, "}");
}

void main()
{
	char buf[256];
	get_GUID(buf, "/dev/VG-8G/base");
	printf("%s\n", buf);
}
