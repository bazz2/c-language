#include <stdlib.h>
#include "libhello.h"

void main()
{
	w_t w;
	w = malloc(100);
	set(w);
	print(w);
}
