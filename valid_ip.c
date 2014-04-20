#include <arpa/inet.h>
#include <stdio.h>

void main()
{
	struct in_addr inp;
	const char *ip_str = "0.0.0.0";
	char *ip_str_2;

	int res = inet_aton(ip_str, &inp);
	ip_str_2 = inet_ntoa(inp);
	printf("orig ip: %s\n", ip_str);
	printf("res: %d\n", res);
	printf("ip: %u\n", inp.s_addr);
	printf("ip2: %s\n", ip_str_2);
}
