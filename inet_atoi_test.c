#include <stdio.h>
#include <arpa/inet.h>

void main()
{
	const char *ip = "192.168.2.47";
	struct in_addr ia;
	printf("%s\n", ip);
	int ret = inet_aton(ip, &ia);
	printf("ret: %d\n", ret);
	printf("in_addr.s_addr: %u\n", ia.s_addr);
	printf("inet_ntoa(in_addr): %s\n", inet_ntoa(ia));
}
