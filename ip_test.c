#include <arpa/inet.h>
#include <stdio.h>

void main()
{
	struct in_addr inp;
	const char *ip_str = "10.152.69.202";
	const char *ip_str_II = "10.152.69.203";

	int res = inet_aton(ip_str, &inp);
	//inp.s_addr >>= 8;
	printf("%s => 0x%x\n", ip_str, inp.s_addr);
	inet_aton(ip_str_II, &inp);
	//inp.s_addr >>= 8;
	printf("%s => 0x%x\n", ip_str_II, inp.s_addr);
}
