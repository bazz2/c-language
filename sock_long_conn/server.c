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
#define DEFAULT_PORT 5050
int main( )
{
    int        iPort=DEFAULT_PORT;
    int sListen, sAccept;
    int iLen;
    int iSend;
    int iRecv;
    char buf[1024];
    struct sockaddr_in ser, cli;

    sListen=socket(AF_INET,SOCK_STREAM,0);
    ser.sin_family=AF_INET;
    ser.sin_port=htons(iPort);
    ser.sin_addr.s_addr=htonl(INADDR_ANY);

    bind(sListen,(struct sockaddr *)&ser,sizeof(ser));
    listen(sListen,5);
    iLen=sizeof(cli);
    sAccept=accept(sListen,(struct sockaddr*)&cli,&iLen);

    while(1)
    {
        memset(buf, 0, 1024);
        iRecv = recv(sAccept, buf, 1, 0);
        iRecv = recv(sAccept, buf+1, sizeof(buf)-1, 0);
        printf("server recv: %s\n", buf);
        iRecv = send(sAccept, buf, sizeof(buf), 0);
        printf("server send: %s\n\n", buf);

    }

    close(sAccept);
    close(sListen);
    return 0;
}

