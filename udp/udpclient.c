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

	memset(&remote_addr,0,sizeof(remote_addr)); //���ݳ�ʼ��--����  
    remote_addr.sin_family=AF_INET; //����ΪIPͨ��  
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");//������IP��ַ  
    remote_addr.sin_port=htons(7777); //�������˿ں� 

	udpfd = socket(AF_INET, SOCK_DGRAM, 0);
	z = sendto(udpfd, "hello", 128, 0, (struct sockaddr *)&remote_addr, sizeof(remote_addr));
	printf("send %d bytes\n", z);

	close(udpfd);
}
