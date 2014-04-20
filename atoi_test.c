#include<stdio.h>
#include<string.h>

int equal(int num, char *str)
{
	int i = atoi(str);
	return (num == i);
}
void main()
{
	int i = 12;
	char num_str[5] = {"12"};
	int j = equal(i, num_str);
	printf("%d\n", j);
	
	unsigned int t = atoi("-12qw");
	if(t > 1000)
	printf("t > 1000\n");
}
