#include <sys/socket.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include<stdlib.h>

//#define DEFAULT_PORT  5050
#define DEFAULT_PORT 7001
#define DATA_BUFFER 1024
int main()
{
    int sClient;
    int iPort = DEFAULT_PORT;
    int iLen;
    char buf[DATA_BUFFER];
    struct sockaddr_in    ser;

    memset(buf,0,sizeof(buf));

    ser.sin_family = AF_INET;
    ser.sin_port = htons(iPort);
    ser.sin_addr.s_addr = inet_addr("127.0.0.1");

    sClient=socket(AF_INET,SOCK_STREAM,0);
    connect(sClient,(struct sockaddr*)&ser, sizeof(ser));
    int i;
    for(i=0; i<100; i++)
    {
        sprintf(buf, "[%d]%s.", i, "<Hello world");

        iLen = send(sClient, buf, sizeof(buf), 0);
        printf("client send: %s\n", buf);
        /*
        iLen = recv(sClient, buf, sizeof(buf), 0);
        printf("client recv: %s\n\n", buf);
        */

        sleep(5);
    }
    close(sClient);
    return 0;
}
