#include <stdio.h>
#include <string.h>
main()
{
char *s="Golden Global View";
char *l="lob";
char *p;

p=strstr(s,l);
if(p)
printf("%s",p);
else
printf("Not Found!");
getchar();
return 0;
}
