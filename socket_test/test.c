#include <stdio.h>
#include <arpa/inet.h>

void main()
{
	struct sockaddr_in dest;
	dest.sin_addr.s_addr = 1812113600;
	printf("%s\n", inet_ntoa(dest.sin_addr));
}
