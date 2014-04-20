#include<stdio.h>
void DelayMS(unsigned int x)
{
unsigned char i;
while(x--)
{
for(i=0;i<120;i++);
}
}

void main()
{
DelayMS(1500000);
}
