#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

static int file_filter(const struct dirent *s)
{
	if (!strcmp(s->d_name, ".") || !strcmp(s->d_name, "..") || strstr(s->d_name, ".c"))
		return 0;
	
	return 1;
}

void main()
{
	struct dirent **namelist;
	int n;
	n = scandir(".", &namelist, file_filter, alphasort);
	if (n == -1) {
		printf("not found any thing.\n");
		return;
	}

	while (n--) {
		printf("%s\n", namelist[n]->d_name);
		free(namelist[n]);
	}
	free(namelist);
}
