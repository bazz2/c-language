#include <stdio.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>


int main(int argc, char *argv[])  
{  
int server_sockfd;  
int len;  
struct sockaddr_in my_addr;   //服务器网络地址结构体  
	 struct sockaddr_in remote_addr; //客户端网络地址结构体  
int sin_size;  
char buf[BUFSIZ];  //数据传送的缓冲区  
memset(&my_addr,0,sizeof(my_addr)); //数据初始化--清零  
my_addr.sin_family=AF_INET; //设置为IP通信  
my_addr.sin_addr.s_addr=INADDR_ANY;//服务器IP地址--允许连接到所有本地地址上  
my_addr.sin_port=htons(7777); //服务器端口号  
  
  
if((server_sockfd=socket(PF_INET,SOCK_DGRAM,0))<0)  
{    
	perror("socket");  
	return 1;  
}  

	  
if (bind(server_sockfd,(struct sockaddr *)&my_addr,sizeof(struct sockaddr))<0)  
{  
	perror("bind");  
	return 1;  
}  
sin_size=sizeof(struct sockaddr_in);  
printf("waiting for a packet...\n");  
  
  
if((len=recvfrom(server_sockfd,buf,BUFSIZ,0,(struct sockaddr *)&remote_addr,&sin_size))<0)  
{  
	perror("recvfrom");   
	return 1;  
}  
printf("received packet from %s:\n",inet_ntoa(remote_addr.sin_addr));  
buf[len]='/0';  
printf("contents: %s\n",buf);  
close(server_sockfd);  
	return 0;  
}  
