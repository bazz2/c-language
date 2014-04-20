#include <stdio.h>   
#include <sys/socket.h>   
#include <unistd.h>   
#include <sys/types.h>   
#include <netinet/in.h>   
#include <stdlib.h>   
#include <memory.h>   
 
#define SERVER_PORT 59191
#define CLIENT_PORT 59292
#define BUFFER_SIZE  1024  
 
int main(int argc, char **argv)   
{       
       int servfd = 0, clifd = 0, length = 0;   
       struct sockaddr_in servaddr,cliaddr;   
       socklen_t socklen = sizeof(servaddr);   
       char buf[BUFFER_SIZE];
        
       if (argc < 2)   
       {   
              printf("Usage: %s IP Adress\n", argv[0]);   
              exit(1);   
       }   
         
       if ((clifd = socket(AF_INET,SOCK_STREAM,0)) < 0)   
       {   
              printf("create socket error!\n");   
              exit(1);   
       }   

       memset(&cliaddr, 0, sizeof(cliaddr));
       cliaddr.sin_family = AF_INET;   
       cliaddr.sin_port = htons(CLIENT_PORT);   
       cliaddr.sin_addr.s_addr = htons(INADDR_ANY);   
    
       memset(&servaddr, 0, sizeof(servaddr));
       servaddr.sin_family = AF_INET;   
       inet_aton(argv[1],&servaddr.sin_addr);  //set server's ip address
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

       FILE *fin = fopen("mark_lineup", "rb");
       if(!fin)
       {
           printf("can not open file\n");
           return -1;
       }       
#if 1
       int read_size = fread(buf, sizeof(char), BUFFER_SIZE, fin);
#endif
       fclose(fin);

	printf("%s",buf);
       int wsize = send(clifd, buf, read_size, 0);
	printf("\n\nSend size(Byte): %d\n", wsize);
       if(wsize <= 0)
       {
           printf("send error\n");
           exit(1);
       }
       close(clifd);   
       return 0;   
}  
