#include <stdio.h>
#include <string.h>
int parse_ip(char *ip)
{
	char tmp[4];
	char *p=NULL;
	int i, doc_sum=0,num_sum=0;
	for(i=0; i<strlen(ip);i++)
		if(ip[i] == '.')
			doc_sum++;
	if(doc_sum!=3)
		return 0;
	p = strtok(ip, ".");
	while(p)
	{
		num_sum++;
		if(strlen(p) > 3)
			return 0;
		strcpy(tmp, p);
		for(i=0; i<strlen(tmp);i++)
			if(tmp[i]<'0' || tmp[i]>'9')
				return 0;
		if(atoi(tmp)>255)
			return 0;
		p=strtok(NULL, ".");
	}
	if(num_sum != 4)
		return 0;
	return 1;
}

void main(int argc, char **argv)
{
	char ipaddr[16];
	strcpy(ipaddr, argv[1]);
	if(!parse_ip(ipaddr)) {
		printf("invalid IP\n");
	} else {
		printf("valid IP\n");
	}
}
