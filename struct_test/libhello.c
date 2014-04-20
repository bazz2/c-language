#include <stdio.h>
#include <string.h>
#include "libhello.h"

struct world {
	char *string;
};
void print(struct world *w)
{
	printf("%s\n",w->string);
}
void set(struct world *w)
{
	w->string = strdup("world");
}
