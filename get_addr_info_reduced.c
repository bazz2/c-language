#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void main()
{
        struct ifaddrs *ifaddr, *ifa;
        int family, s;
        char host[NI_MAXHOST];

        if (getifaddrs(&ifaddr) == -1) {
                printf("getifaddrs error!\n");
                exit(1);
        }

        for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next) {
                if (ifa->ifa_addr == NULL)
                        continue;
                if(!strcmp(ifa->ifa_name, "lo"))
                        continue;

                family = ifa->ifa_addr->sa_family;
                if (family == AF_INET) {
                	printf("%s: ", ifa->ifa_name);
                        s = getnameinfo(ifa->ifa_addr, sizeof(struct sockaddr_in),
                                        host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
                        if (s != 0) {
                                printf("getnameinfo() failed: %s\n", gai_strerror(s));
                                exit(1);
                        }
                 printf("%s\n", host);
                }
        }

        freeifaddrs(ifaddr);
        exit(0);
}
