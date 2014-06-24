#include<stdio.h>
void main()
{
	char p[10][5];
	int q[10][5];
	printf("int: %d\n", sizeof(int));
	printf("double: %d\n", sizeof(double));
	printf("float: %d\n", sizeof(float));
	printf("unsigned long: %d\n", sizeof(unsigned long));
	printf("long: %d\n", sizeof(long));
	printf("p[10][5]: %d\n", sizeof (p));
	printf("q[10][5]: %d\n", sizeof (q));
}
