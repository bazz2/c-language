#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * ascii -> hex
 * return len of the dst string;
 */
static int _gsmString2Bytes(const char* pSrc, unsigned char* pDst, int nSrcLength)
{
    int i;
    const char *pSrc_buf = pSrc;
    char *pDst_buf = pDst;

    for(i=0; i<nSrcLength; i+=2)
    {
        if(*pSrc>='0' && *pSrc<='9')
        {
            *pDst = (*pSrc - '0') << 4;
        }
        else
        {
            *pDst = (*pSrc - 'A' + 10) << 4;
        }

        pSrc++;
        if(*pSrc>='0' && *pSrc<='9')
        {
            *pDst |= *pSrc - '0';
        }
        else
        {
            *pDst |= *pSrc - 'A' + 10;
        }
        pSrc++;
        pDst++;
    }
    nSrcLength /= 2;

    pDst = pDst_buf;
    char tmp;

    for (i = 0; i < nSrcLength; i += 2)
    {
        tmp = pDst[i];
        pDst[i] = pDst[i+1];
        pDst[i+1] = tmp;
    }

    return nSrcLength;
}

unsigned char *_UCS2toUTF8(unsigned short *ucs2, int count)
{
    unsigned short unicode;
    unsigned char bytes[4] = {0};
    int nbytes = 0;
    int i = 0, j = 0;
    int len=0;
    unsigned char *utf8;

    if(!ucs2)
        return NULL;

    if(count == 0)
        return NULL;

    utf8 = calloc(1, 512);

    for (i=0; i<count; i++)
    {
        unicode = ucs2[i];

        if (unicode < 0x80)
        {
            nbytes = 1;
            bytes[0] = unicode;
        }
        else if (unicode < 0x800)
        {
            nbytes = 2;
            bytes[1] = (unicode & 0x3f) | 0x80;
            bytes[0] = ((unicode << 2) & 0x1f00 | 0xc000) >> 8;
        }
        else
        {
            nbytes = 3;
            bytes[2] = (unicode & 0x3f) | 0x80;
            bytes[1] = ((unicode << 2) & 0x3f00 | 0x8000) >> 8;
            bytes[0] = ((unicode << 4) & 0x0f0000 | 0xe00000) >> 16;
        }

        for (j=0; j<nbytes; j++)
        {
            utf8[len] = bytes[j];
            len++;
        }
    }

    utf8[len] = '\0';
    return utf8;
}
static unsigned char *ucs22utf8(unsigned char *ascii)
{
    unsigned char ucs2[64] = {0};
    unsigned char *utf8;
    int len = _gsmString2Bytes(ascii, ucs2, strlen(ascii));
    utf8 = _UCS2toUTF8((unsigned short *)ucs2, len);

    return utf8;
}

int main()
{
    unsigned char ascii[512] = "006800650065006c006f751F751F4E164E16";
    unsigned char *dst;
    dst = ucs22utf8(ascii);
    printf("dst: %s\n", dst);
}
