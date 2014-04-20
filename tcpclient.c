#include<winsock2.h>

void main(void)
{
  WSADATA wsaData;
  SOCKET s;
  SOCKADDR_IN ServerAddr;
  int Port = 445;
  
  WSAStartup(MAKEWORD(2, 2), &wsaData);

  s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  ServerAddr.sin_family = AF_INET;
  ServerAddr.sin_port = htons(Port);
  ServerAddr.sin_addr.s_addr = inet_addr("192.168.3.138");
  
  connect(s, (SOCKADDR *) &ServerAddr, sizeof(ServerAddr));
  closesocket(s);
  WSACleanup();
}
