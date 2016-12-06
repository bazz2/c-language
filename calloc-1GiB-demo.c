#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

const int LOOPS = 100;

float now()
{
    struct timespec t;
    if (clock_gettime(CLOCK_MONOTONIC, &t) < 0) {
        perror("clock_gettime");
        exit(1);
    }
    return t.tv_sec + (t.tv_nsec / 1e9);
}

int main(int argc, char** argv)
{
    float start = now();
    for (int i = 0; i < LOOPS; ++i) {
        free(calloc(1, 1 << 30));
    }
    float stop = now();
    printf("calloc+free 1 GiB: %0.2f ms\n", (stop - start) / LOOPS * 1000);

    start = now();
    for (int i = 0; i < LOOPS; ++i) {
        void* buf = malloc(1 << 30);
        memset(buf, 0, 1 << 30);
        free(buf);
    }
    stop = now();
    printf("malloc+memset+free 1 GiB: %0.2f ms\n", (stop - start) / LOOPS * 1000);
}
