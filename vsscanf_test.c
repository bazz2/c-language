#include <stdio.h>
#include <stdarg.h>

int multiscanf(const char *str, const char *format, ...)
{
	va_list args;
	int rc;

	va_start(args, format);
	rc = vsscanf(str, format, args);
	va_end(args);
	return rc;
}

int main()
{
	int a = 0, b = 0;
	char s[50];
	const char *str = "hello 1 world 2 !";
	multiscanf(str, "%s %d world %d !", s, &a, &b);

	printf("%s  %d  %d\n", s, a, b);
}
