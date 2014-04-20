#include <stdio.h>   
#include <sys/socket.h>   
#include <unistd.h>   
#include <sys/types.h>   
#include <netinet/in.h>   
#include <stdlib.h>   
    
#define SERVER_PORT 445 // define the defualt connect port id   
#define CLIENT_PORT ((20001+rand())%65536) // define the defualt client port as a random port   
    
#define BUFFER_SIZE  1024  
#define REUQEST_MESSAGE "welcome to connect the server.\n"   
    
void usage(char *name)   
{   
       printf("usage: %s IpAddr\n",name);   
}   
    
int main(int argc, char **argv)   
{       
       int servfd = 0, clifd = 0, length = 0;   
       struct sockaddr_in servaddr,cliaddr;   
       socklen_t socklen = sizeof(servaddr);   
       char buf[BUFFER_SIZE];   
         
       if (argc < 2)   
       {   
              usage(argv[0]);   
              exit(1);   
       }   
         
       if ((clifd = socket(AF_INET,SOCK_STREAM,0)) < 0)   
       {   
              printf("create socket error!\n");   
              exit(1);   
       }   
       srand(time(NULL));//initialize random generator   
       bzero(&cliaddr,sizeof(cliaddr));   
       cliaddr.sin_family = AF_INET;   
       cliaddr.sin_port = htons(CLIENT_PORT);   
       cliaddr.sin_addr.s_addr = htons(INADDR_ANY);   
    
       bzero(&servaddr,sizeof(servaddr));   
       servaddr.sin_family = AF_INET;   
       inet_aton(argv[1],&servaddr.sin_addr);   
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

       FILE *fin = fopen("mark", "rb");
       if(!fin)
       {
           printf("can not open file\n");
           return -1;
       }       
       fread(buf, sizeof(char), BUFFER_SIZE, fin);
       fclose(fin);
       int wsize = send(clifd, buf, BUFFER_SIZE, 0);
       if(wsize <= 0)
       {
           printf("send error\n");
           exit(1);
       }
       close(clifd);   
       return 0;   
}  
