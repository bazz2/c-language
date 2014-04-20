#include<stdio.h>
#include<libxml/parser.h>
#include<libxml/tree.h>
#define SCHEDULE_FILE "Created.xml"
int main(int argc, char **argv)
{
	loadXMLDoc(SCHEDULE_FILE);
}
