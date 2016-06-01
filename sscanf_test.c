#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <libgen.h>
#include <linux/major.h>
#include <fcntl.h>

#if 0
void main()
{
	const char *str = "/dev/VG01/base min S2013/7/1-11:5 i1 p192.168.3.138";
	char lvpath[50], mode[4], ip[20], starttime[20];
	int i;
	int res = sscanf(str, "%*s %*s S%s", lvpath);
	printf("res: %d\n%s\n", res, lvpath);
	printf("left: %s\n", str);
}
#endif

#if 0
void main()
{
	const char *str = "1 2 3abc5";
	uint64_t tmp;
	int res = sscanf(str, "%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d", &tmp, &tmp, &tmp, &tmp, &tmp, &tmp);
	//int res = sscanf(str, "%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d%*[^0-9]%d", &tmp, &tmp, &tmp, &tmp, &tmp, &tmp);
	printf("res: %d\n", res);
	printf("tmp: %u\n", tmp);
}
#endif

#if 0
void main()
{
	const char *str = "client_guid=\"1131bb35-7fea-0000-22c6-e1d0ea7f0000\"";
	char tmp[1024] = {0};
	int ret;

	ret = sscanf(str, "\"%s\"", tmp);
	if (ret != 1) {
		printf("ret: %d\n", ret);
		return;
	}
	
	printf("tmp: %s\n", tmp);
}

#endif
#if 0
void main()
{
	const char *ip = "a=\"168.3.1\"";
	int tmp[100];

	sscanf(ip, "%*[^\"]\"%[^\"]", tmp);
	printf("%s\n", tmp);
}
#endif
#if 0
void main()
{
	const char *host = "hostf10f";
	int tmp = -1;
	int ret = -1;

	ret = sscanf(host, "host%d", &tmp);
	printf("ret:%d; tmp:%d\n", ret, tmp);
}
#endif
#if 0
void main()
{
	const char *ip_port = "192.168.3.98:9997";
	char ip[32] = {0};
	int port = 0, ret;

	ret = sscanf(ip_port, "%30[^:]:%d", ip, &port);
	printf("[%d] %s : %d\n", ret, ip, port);
}
#endif
#if 1
void main()
{
	const char *mode = "1d2:w59";
	int ret = -1;
    int num = -1;
    char time[128] = {0};
    char time2[128] = {0};
    int hour, min;

	ret = sscanf(mode, "%d:%d", &hour, &min);
	printf("ret:%d; %d %d\n", ret, hour, min);
}
#endif
