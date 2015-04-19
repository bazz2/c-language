#include <sys/socket.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#define MAXLINE 512
#define OPEN_MAX 100
#define LISTENQ 20
#define SERV_PORT 5000
#define INFTIM 1000

void setnonblocking(int sock)
{
    int opts;
    opts=fcntl(sock,F_GETFL);
    if(opts<0)
    {
        perror("fcntl(sock,GETFL)");
        return;
    }
    opts = opts|O_NONBLOCK;
    if(fcntl(sock,F_SETFL,opts)<0)
    {
        perror("fcntl(sock,SETFL,opts)");
        return;
    }
}

void CloseAndDisable(int sockid, struct epoll_event ee)
{
    close(sockid);
    ee.data.fd = -1;
}

int main()
{
    int i, maxi, listenfd, connfd, sockfd,epfd,nfds, portnumber;
    char line[MAXLINE];
    socklen_t clilen;

    portnumber = 5000;

    struct epoll_event ev,events[20];

    epfd=epoll_create(256);
    struct sockaddr_in clientaddr;
    struct sockaddr_in serveraddr;
    listenfd = socket(AF_INET, SOCK_STREAM, 0);

    memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    serveraddr.sin_port=htons(portnumber);

        bind(listenfd,(struct sockaddr *)&serveraddr, sizeof(serveraddr));
    listen(listenfd, LISTENQ);

    ev.data.fd=listenfd;
    ev.events=EPOLLIN|EPOLLET;
    ev.events=EPOLLIN;

    epoll_ctl(epfd,EPOLL_CTL_ADD,listenfd,&ev);

    maxi = 0;

    int bOut = 0;
    for ( ; ; )
    {
        if (bOut == 1)
            break;

        nfds=epoll_wait(epfd,events,20,-1);

        for(i=0;i<nfds;++i)
        {
            if(events[i].data.fd==listenfd)
            {
                connfd = accept(listenfd,(struct sockaddr *)&clientaddr, &clilen);
                if(connfd<0){
                    perror("connfd<0");
                    return (1);
                }


                char *str = inet_ntoa(clientaddr.sin_addr);
                printf("accept conn from %s\n", str);

                setnonblocking(connfd);
                ev.data.fd=connfd;

                ev.events=EPOLLIN | EPOLLET;

                epoll_ctl(epfd,EPOLL_CTL_ADD,connfd,&ev);
            }
            else if(events[i].events & EPOLLIN)
            {
                printf("EPOLLIN\n");
                if ( (sockfd = events[i].data.fd) < 0)
                    continue;

                char * head = line;
                int recvNum = 0;
                int count = 0;
                int bReadOk = 0;
                while(1)
                {
                    recvNum = recv(sockfd, head + count, MAXLINE, 0);
                    if(recvNum < 0)
                    {
                        if(errno == EAGAIN)
                        { /* there is no data in cache */
                            bReadOk = 1;
                            break;
                        }
                        else if (errno == ECONNRESET)
                        { /* peer send RST*/
                            CloseAndDisable(sockfd, events[i]);
                            printf("peer send out RST\n");
                            break;
                        }
                        else if (errno == EINTR)
                        { /* interuppted */
                            continue;
                        }
                        else
                        {
                            CloseAndDisable(sockfd, events[i]);
                            printf("unrecovable error\n");
                            break;
                        }
                    }
                    else if( recvNum == 0)
                    { /* peer closed socket, and have sent FIN */
                        CloseAndDisable(sockfd, events[i]);
                        printf("peer closed socket\n");
                        break;
                    }

                    count += recvNum;
                    if ( recvNum == MAXLINE)
                    {
                        continue;
                    }
                    else
                    {
                        bReadOk = 1;
                        break;
                    }
                }

                if (bReadOk == 1)
                { /* have received all datas */
                    line[count] = '\0';

                    printf("receive from peer: %s\n", line);

                    ev.data.fd=sockfd;
                    ev.events = EPOLLOUT | EPOLLET;
                    epoll_ctl(epfd,EPOLL_CTL_MOD,sockfd,&ev);
                }
            }
            else if(events[i].events & EPOLLOUT)
            {
                memset(line, 0, sizeof (line));
                strcpy(line, "world");
                printf("send to peer: %s\n", line);
                sockfd = events[i].data.fd;

                int bWritten = 0;
                int writenLen = 0;
                int count = 0;
                char * head = line;
                while(1)
                {
                    writenLen = send(sockfd, head + count, MAXLINE, 0);
                    if (writenLen == -1)
                    {
                        if (errno == EAGAIN)
                        { /* nonblocking, so it has sent all datas */
                            bWritten = 1;
                            break;
                        }
                        else if(errno == ECONNRESET)
                        { /* peer sent RST to me */
                            CloseAndDisable(sockfd, events[i]);
                            printf("peer send RST\n");
                            break;
                        }
                        else if (errno == EINTR)
                        {
                            continue;
                        }
                        else
                        {
                        }
                    }

                    if (writenLen == 0)
                    { /* peer closed socket */
                        CloseAndDisable(sockfd, events[i]);
                        printf("peer close socket\n");
                        break;
                    }

                    count += writenLen;
                    if (writenLen == MAXLINE)
                    {
                        continue;
                    }
                    else
                    {
                        bWritten = 1;
                        break;
                    }
                }

                if (bWritten == 1)
                {
                    ev.data.fd=sockfd;

                    ev.events=EPOLLIN | EPOLLET;

                    epoll_ctl(epfd,EPOLL_CTL_MOD,sockfd,&ev);
                }
            }
        }
    }
    return 0;
}
