#include <string.h>
#include <stdio.h>
int main(void)
{
        char input[16] = "";
        //char input[16] = ",ab,c,d";
        char *p;
        p = strtok(input, ",");
        if(p) printf("%s\n", p);
        else printf("p is not exist\n");
        p = strtok(NULL, ",");
        if(p) printf("%s\n", p);
        p = strtok(NULL, ",");
        if(p) printf("%s\n", p);
        return 0;
}
