#include <stdio.h>  
#include <string.h>  
#include <sys/socket.h>  
#include <netinet/in.h>  
  
static int SERVER_PORT = 10001;  
static int MAX_REQUEST_QUEUE = 5;  
static int MAX_DATA_SIZE = 100;  
/** 
 * start tcp server 
 */  
int tcpserver() {  
    int sockfd, newfd;  
    struct sockaddr_in server_addr, client_addr;  
    char buf[MAX_DATA_SIZE + 1];  
	int optval;
  
    // create socket  
    sockfd = socket(AF_INET, SOCK_STREAM, 0);  
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
          (const void *)&optval , sizeof(int)) < 0) {
          return 0;
    }
  
    // set server address  
    bzero((char *) &server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;  
    server_addr.sin_port = htons(SERVER_PORT);  
    server_addr.sin_addr.s_addr = INADDR_ANY;  
  
    // bind  
    if (bind(sockfd, (struct sockaddr *) &server_addr, sizeof(struct sockaddr)) == -1) {  
        perror("bind error\n");  
        return 1;  
    }  
  
    // listen  
    if (listen(sockfd, MAX_REQUEST_QUEUE) == -1) {  
        perror("listen error\n");  
        return 1;  
    }  
  
    int recv_size;  
    int sin_size = sizeof(struct sockaddr_in);  
    while (1) {  
        // accepte  
        if ((newfd = accept(sockfd, (struct sockaddr *) &client_addr, &sin_size)) == -1) {  
            perror("accept error\n");  
            continue;  
        };  
  
        // receive data  
        if ((recv_size = recv(newfd, buf, MAX_DATA_SIZE, 0)) == -1) {  
            perror("recv error\n");  
            continue;  
        }  
        if (recv_size) {  
            buf[recv_size] = '\0';  
            printf("receive:\t%s\n", buf);  
        }  
  
        char *s_send = "hi client!";  
        // send data  
        if (send(newfd, s_send, strlen(s_send), 0) == -1) {  
            perror("send error\n");  
            continue;  
        } else {  
            printf("send:\t%s\n", s_send);  
        }  
  
        // close incomming socket  
        close(newfd);  
        printf("\n");  
    }  
    return 0;  
}  
int main() {  
    return tcpserver();  
}  
