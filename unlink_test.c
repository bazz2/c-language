#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int main(void)
{
    if (open("tempfile", O_RDWR) < 0)
        exit(0);
    if (unlink("tempfile") < 0)
        exit(0);
    printf("file unlinked\n");
    sleep(15);
    printf("done\n");
    exit(0);
}
