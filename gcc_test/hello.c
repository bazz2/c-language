#include <stdio.h>

void self_add(void)
{
	static sum = 0;
	sum++;
	printf("%d\n", sum);
}


main() {
	self_add();
	self_add();
	self_add();
}

