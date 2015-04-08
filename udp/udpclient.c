#include <stdio.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>

void main()
{
	int udpfd, z;
	struct sockaddr_in remote_addr;

	memset(&remote_addr,0,sizeof(remote_addr)); //数据初始化--清零  
    remote_addr.sin_family=AF_INET; //设置为IP通信  
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");//服务器IP地址  
    remote_addr.sin_port=htons(7777); //服务器端口号 

	udpfd = socket(AF_INET, SOCK_DGRAM, 0);
	z = sendto(udpfd, "hello", 128, 0, (struct sockaddr *)&remote_addr, sizeof(remote_addr));
	printf("send %d bytes\n", z);

	close(udpfd);
}
