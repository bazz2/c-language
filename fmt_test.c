#include <stdio.h>
#include <stdarg.h>

void usage(const char *fmt, ...)
{
	char buf[1024];
	va_list ap;
	va_start(ap, fmt);
	vsnprintf(buf, 1024, fmt, ap);
	printf("%s", buf);
	va_end(ap);
}
void main()
{
	char string[128] = "Hello world";
	usage("%s\n", string);
}
