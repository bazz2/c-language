#include<netdb.h>
#include<stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#if 1
void main()
{
	char name[200];
	char str[32];
	gethostname(name, sizeof(name));
	struct hostent *hostinfo = gethostbyname(name);
	const char *ip = inet_ntop(hostinfo->h_addrtype, hostinfo->h_addr, str, sizeof(str));
	printf("hostname = %s\n", name);
	printf("ip = %s\n", ip);
}

#else
void main()
{
	int inet_sock;
	struct ifreq ifr;
	inet_sock = socket(AF_INET, SOCK_DGRAM, 0);
	strcpy(ifr.ifr_name, "eth0");
	if(ioctl(inet_sock, SIOCGIFADDR, &ifr) != 0)
		perror("ioctl\n");
	printf("%s\n", inet_ntoa(((struct sockaddr_in*)&(ifr.ifr_addr))->sin_addr));
	close(inet_sock);
}
#endif
