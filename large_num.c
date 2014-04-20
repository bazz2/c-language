#include <stdio.h>
#include <string.h>
#include <stdint.h>

#define MAX_ATTR_LEN 60

uint64_t atoi_large(const char *src)
{
	uint64_t res = 0;
	const char *p = src;

	if (!src)
		return 0;
	while (p) {
		if (*p <= '9' && *p >= '0')
			res = res*10 + *p - '0';
		else
			break;
		p++;
	}
	return res;
}

static int size_tune(char *dest, uint64_t src)
{
        float size;

        if (!dest)
                return 0;

	if (src/1024/1024/1024/1024/1024){
		size = src/1024/1024;
		size = size/1024/1024/1024;
                snprintf(dest, MAX_ATTR_LEN, "%.2fPB", size);
	}
        else if (src/1024/1024/1024/1024) {
		size = src/1024;
		size = size/1024/1024/1024;
                snprintf(dest, MAX_ATTR_LEN, "%.2fTB", size);
	}
        else if (size = src/1024/1024/1024) {
		size = src/1024/1024;
		size = size/1024;
                snprintf(dest, MAX_ATTR_LEN, "%.2fGB", size);
	}
        else if (size = src/1024/1024)
                snprintf(dest, MAX_ATTR_LEN, "%luMB", size);
        else if (size = src/1024)
                snprintf(dest, MAX_ATTR_LEN, "%luKB", size);
        else
                snprintf(dest, MAX_ATTR_LEN, "%luB", src);

        return 1;
}

void main()
{

	char size[64] = {0};
	uint64_t i;

	strcpy(size, "34900053480830299900"); //3TB
	i = atoi_large(size);
	printf("%s: %lu --> ", size, i);
	size_tune(size, i);
	printf("%s\n", size);

	strcpy(size, "2250468753408"); //2TB
	i = atoi_large(size);
	printf("%s: %lu --> ", size, i);
	size_tune(size, i);
	printf("%s\n", size);
}
