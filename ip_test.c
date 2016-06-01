#include <arpa/inet.h>
#include <stdio.h>

void main()
{
	struct in_addr inp;
	const char *ip_str = "10.152.69.206";
	const char *ip_str_II = "10.152.69.205";

	int res = inet_aton(ip_str, &inp);
	//inp.s_addr >>= 8;
	printf("%s => 0x%u\n", ip_str, inp.s_addr);
	inet_aton(ip_str_II, &inp);
	//inp.s_addr >>= 8;
	printf("%s => 0x%u\n", ip_str_II, inp.s_addr);
}
