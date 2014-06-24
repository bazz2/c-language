#include <stdio.h>
#include <stdint.h>

#define CONF_DIR "/etc"
#define CONF_FILE "osmcd.conf"
#define TMP_FILE "."CONF_FILE"~"

#define FILE_PATH CONF_DIR"/"CONF_FILE
#define TMP_PATH CONF_DIR"/"TMP_FILE

#define FMT_UINT64_T "%lu"

void main()
{
	uint64_t size = 1234567890;
	printf("%s\n", TMP_FILE);
	printf("%s\n", FILE_PATH);
	printf("%s\n", TMP_PATH);
	printf("size is "FMT_UINT64_T" Bytes\n", size);
}
