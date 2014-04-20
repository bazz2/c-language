#include<stdio.h>
#include<string.h>

void generate_device_name(char *dest, const char *dir)
{
	const char *dirp = dir;
	while(*dirp) {
		if(*dirp == '/')
			strncat(dest, "-", 1);
		else if(*dirp == '-')
			strncat(dest, "--", 2);
		else
			strncat(dest, dirp, 1);
		dirp++;
	}
	if(*dest == '-')
		*dest = '_';
}
void main()
{
	const char *vg = "/dev/_--vg/l_v";
	char device[512] = {0};
	generate_device_name(device, vg);
	printf("%s\n", device);
}
