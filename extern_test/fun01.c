#include<stdio.h>
#include"extern.h"

extern const int HEAD;
void func01()
{
	HEAD = 2;
	printf("%d\n", HEAD);
}
