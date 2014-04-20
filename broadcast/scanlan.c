#include <stdio.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netdb.h>
#include <unistd.h>
#include <stdlib.h>

static dm_list *get_broadcast()
{
	struct ifaddrs *ifaddr, *ifa;
	struct sockaddr *bcast;
	struct sockaddr_in *bcast_in;
	int s;
	char host[NI_MAXHOST];

	if (getifaddrs(&ifaddr) == -1) {
		exit(-1);
	}

	for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr == NULL)
			continue;


		if (ifa->ifa_addr->sa_family == AF_INET) {
			s = getnameinfo(ifa->ifa_addr, sizeof (struct sockaddr_in),
				host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
			if (s != 0) {
				exit(-1);
			}
			if (ifa->ifa_flags & IFF_BROADCAST) {
				bcast = ifa->ifa_ifu.ifu_broadaddr;
				bcast_in = (struct sockaddr_in*)bcast;
				printf("broadcast: %s\n",
					inet_ntoa(bcast_in->sin_addr));
			}
		}
	}

	freeifaddrs(ifaddr);
	exit(0);
}
