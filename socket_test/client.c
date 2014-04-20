#include <stdio.h>  
#include <error.h>
#include <string.h>  
#include <sys/socket.h>  
#include <netinet/in.h>  
  
static char *SERVER_HOST = "192.168.2.108";  
static int SERVER_PORT = 10001;  
static int MAX_DATA_SIZE = 100;  
/** 
 * start tcp client 
 */  
int tcpclient() {  
    int sockfd;  
    struct sockaddr_in server_addr;  
    char buf[MAX_DATA_SIZE + 1];  
  
    // create socket  
    sockfd = socket(AF_INET, SOCK_STREAM, 0);  
  
    server_addr.sin_family = AF_INET;  
    server_addr.sin_port = htons(SERVER_PORT);  
    server_addr.sin_addr.s_addr = inet_addr(SERVER_HOST);  
  
    // connect  
   printf("connecting...\n");
    if ((connect(sockfd, (struct sockaddr *) &server_addr, sizeof(struct sockaddr))) == -1) {  
        perror("connect error\n");  
        return 1;  
    }  


struct sockaddr_in dest;
dest.sin_addr.s_addr = 1812113600;
printf("%s\n", inet_ntoa(dest.sin_addr));
socklen_t addr_len;
addr_len  = sizeof (struct sockaddr_in);
memset(&dest, 0, sizeof (dest));
connect(sockfd, (struct sockaddr*)&server_addr, sizeof (struct sockaddr));
int ret = getpeername(sockfd, (struct sockaddr*)&dest, &addr_len);
printf("ret%d, sockfd%d\n", ret, sockfd);
printf("%d\n", dest.sin_addr.s_addr);
printf("%s\n", inet_ntoa(dest.sin_addr));

  
    char *s_send = "hi server!";  
    // send data  
    if ((send(sockfd, s_send, strlen(s_send), 0)) == -1) {  
        perror("send error\n");  
        return 1;  
    } else {  
        printf("send:\t%s\n", s_send);  
    }  
  
    int recv_size;  
    // receive data  
    if ((recv_size = recv(sockfd, buf, MAX_DATA_SIZE, 0)) == -1) {  
        perror("recv error\n");  
        return 1;  
    }  
    if (recv_size) {  
        buf[recv_size] = '\0';  
        printf("receive:\t%s\n", buf);  
    }  
  
    // close socket  
    close(sockfd);  
    return 0;  
}  
  
int main() {  
    return tcpclient();  
}  