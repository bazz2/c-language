#include <stdio.h>
#include <stdint.h>
#include <memory.h>

void main()
{
    char str[2];
    uint16_t i = 0xff00;
    memcpy(str, &i, sizeof (uint16_t));
    printf("0x%x VS 0x%.2x 0x%.2x\n", i, str[0], str[1]);
}
