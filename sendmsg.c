#include <sys/types.h>  
#include <sys/socket.h>  
#include <sys/types.h>  
#include <stdio.h>  
#include <string.h>  
#include <netinet/in.h>  
#include <arpa/inet.h>  
int main(){  
    int sockfd;  
    int len;  
    struct sockaddr_in address;  
    int result;  
    char *strings="hello world\n";  
    char ch;  
    sockfd = socket(AF_INET, SOCK_STREAM, 0);  
    address.sin_family = AF_INET;  
    address.sin_addr.s_addr = inet_addr("192.168.2.54");  
    address.sin_port = htons(445);  
    len = sizeof(address);  
    result = connect(sockfd,  (struct sockaddr *)&address, len);  
    if(result == -1){  
        perror("oops: client1");  
        return 1;  
    }  
      
    write(sockfd,strings,strlen(strings));  
    while(read(sockfd,&ch,1))  
        printf("%c", ch);  
    close(sockfd);  
      
    return 1;  
}  
