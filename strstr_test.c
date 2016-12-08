#include <stdio.h>
#include <string.h>

int main()
{
    char s[128]={0};
    char *p;
    int i, index;

    strcpy(s, "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20");
    printf("origin: [%s]\n", s);
    i = 0;
    index = 0;
    do {
        p = strstr(s+index, ",");
        if (p == NULL)
            break;

        index = (p-s) + 1;
        i++;
        if (i % 5 == 0) {
            *p = '|';
            i = 0;
            printf("s: [%s]\n", s);
        }
    } while (1);

    return 0;
}
