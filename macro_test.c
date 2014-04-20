#include <stdio.h>

#define CONF_DIR "/etc"
#define CONF_FILE "osmcd.conf"
#define TMP_FILE "."CONF_FILE"~"

#define FILE_PATH CONF_DIR"/"CONF_FILE
#define TMP_PATH CONF_DIR"/"TMP_FILE

void main()
{
	printf("%s\n", TMP_FILE);
	printf("%s\n", FILE_PATH);
	printf("%s\n", TMP_PATH);
}
