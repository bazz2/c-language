#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdlib.h>
//#include <signal.h>


#define MAXLINE 80
int port = 13336;

int main(void)
{
  struct sockaddr_in sin;
  struct sockaddr_in rin;
  int sock_fd;
  int address_size;
  char buf[MAXLINE];
  char str[INET_ADDRSTRLEN];
  int i;
  int len;
  int n;

  bzero(&sin, sizeof(sin));
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(port);


  sock_fd = socket(AF_INET, SOCK_DGRAM, 0);
  if (-1 == sock_fd)
  {
    perror("call to socket");
    exit(1);
  }
  n = bind(sock_fd, (struct sockaddr *)&sin, sizeof(sin));
  if (-1 == n)
  {
    perror("call to bind");
    exit(1);
  }

  while(1)
  {
    address_size = sizeof(rin);
	memset(&rin, 0, sizeof (rin));
    n = recvfrom(sock_fd, buf, MAXLINE, 0, (struct sockaddr *)&rin, &address_size);
    if (-1 == n)
    {
      perror("call to recvfrom.\n");
      exit(1);
    }

	/* 打印收到的十六进制字符串 */
    printf("[receive from %s:%d] ",
            inet_ntop(AF_INET, &rin.sin_addr,str,sizeof(str)),
            ntohs(rin.sin_port));
	for (i=0; i<n; i++)
		printf("%X", buf[i]);
	printf("\n");

    len = strlen(buf);
	printf("[sendto] ");
	for (i=0; i<n; i++)
		printf("%X", buf[i]);
	printf("\n");
    n = sendto(sock_fd, buf, len, 0, (struct sockaddr *)&rin, address_size);
    if (-1 == n)
    {
      perror("call to sendto\n");
      exit(1);
    }
  }
}

