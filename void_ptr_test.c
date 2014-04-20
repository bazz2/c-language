#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct type_one {
	char name[16];
	char one[16];
}type_one_t;

typedef struct type_two {
	char name[16];
	char two[16];
}type_two_t;

void print_struct(void *ptr, int len)
{
	printf("%s\n", ptr->name);
}

void main()
{
	type_one_t *to = (type_one_t*)malloc(sizeof(type_one_t));
	type_two_t *tt = (type_two_t*)malloc(sizeof(type_two_t));
	strcpy(to->name, "type one");
	strcpy(tt->name, "type two");
	print_struct(to);
	print_struct(tt);
}
