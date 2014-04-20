#include <stdio.h>
#include <string.h>

#if 0
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

#endif

#if 0
cpy_to_str(char *str)
{
	strcpy(str, "hello world");
}
void main()
{
	char str[128] = {0};
	cpy_to_str(str);
	printf("%s\n", str);
}
#endif

int _wwn_trans(char *dst, const char *src)
{
	char *tmp;
	int len, i = 0;

	if (!dst || !src)
		return -1;
	
	len = strlen(src);
	if (len <= 2)
		return -1;
	if (len % 2)
		return -1;

	src += 2;
	tmp = dst;
	while (*src) {
		*tmp++ = *src++;
		i++;
		if (!(i % 2))
			*tmp++ = ':';
	}

	len = strlen(dst);
	if (len < 1)
		return -1;

	dst[len-1] = 0;
	return len-1;
}

void main()
{
	char wwn_orig[128] = "0x21000024ff37236c";
	char wwn[128] = {0};
	int ret;

	ret = _wwn_trans(wwn, wwn_orig);
	printf("%s\n", wwn_orig);
	printf("%s\n", wwn);
	printf("%d VS %d\n", ret, strlen(wwn));
}
