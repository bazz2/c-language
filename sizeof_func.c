#include <stdio.h>

typedef int (fun_t) (void);

int main(void)
{
	printf("%d\n", sizeof (fun_t));
}
