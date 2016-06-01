#include <stdio.h>   
#include <sys/socket.h>   
#include <unistd.h>   
#include <sys/types.h>   
#include <netinet/in.h>   
#include <stdlib.h>   
#include <memory.h>   
    
#define SERVER_PORT 8801 // define the defualt connect port id   
#define CLIENT_PORT ((20001+rand())%65536) // define the defualt client port as a random port   
    
#define BUFFER_SIZE  1024  
    
void usage(char *name)   
{   
       printf("usage: %s IpAddr\n",name);   
}   
char *string="\x03\x00\x00\x61<omc>\n\t<packcd>6002</packcd>\n\t<taskid>277</taskid>\n\t<style>1</style>\n\t<areaid>13</areaid>\n</omc>\n";
    
int main(int argc, char **argv)   
{       
       int servfd = 0, clifd = 0, length = 0;   
       struct sockaddr_in servaddr, cliaddr;   
       socklen_t socklen = sizeof(servaddr);   
       char buf[BUFFER_SIZE] = {0};   
         
         
       memcpy(buf, string, 0x61+4);

       if ((clifd = socket(AF_INET,SOCK_STREAM,0)) < 0)   
       {   
              printf("create socket error!\n");   
              exit(1);   
       }   
       srand(time(NULL));//initialize random generator   
       memset(&cliaddr, 0, sizeof(cliaddr));   
       cliaddr.sin_family = AF_INET;   
       cliaddr.sin_port = htons(CLIENT_PORT);   
       cliaddr.sin_addr.s_addr = htons(INADDR_ANY);   
    
       memset(&servaddr,0,sizeof(servaddr));   
       servaddr.sin_family = AF_INET;   
       inet_aton("192.168.60.141",&servaddr.sin_addr);   
       servaddr.sin_port = htons(SERVER_PORT);   
      
    
       if (bind(clifd,(struct sockaddr*)&cliaddr,sizeof(cliaddr))<0)   
       {   
              printf("bind to port %d failure!\n",CLIENT_PORT);   
              exit(1);   
       }   
       if (connect(clifd,(struct sockaddr*)&servaddr, socklen) < 0)   
       {   
              printf("can't connect to %s!\n",argv[1]);   
              exit(1);   
       }   

       
       int wsize = send(clifd, buf, 0x61+4, 0);
       if(wsize <= 0)
       {
           printf("send error\n");
           exit(1);
       }
	   wsize = recv(clifd, buf, BUFFER_SIZE, 0);
       close(clifd);   
       return 0;   
}  
