#include<stdio.h>
#include<fcntl.h>
#include<libxml/parser.h>
#include<libxml/tree.h>
#define SCHEDULE_FILE "Created.xml"
int main(int argc, char **argv)
{
	char str[32] = "osn_{**chen*******}";
	char str2[32] = "hello world";
#if 0 
	if (access(SCHEDULE_FILE, F_OK) == -1) {
		return 0;
	}
	xmlDocPtr doc = xmlReadFile(SCHEDULE_FILE, "UTF-8", XML_PARSE_RECOVER);
	xmlNodePtr root_node = xmlDocGetRootElement(doc);
#else
	xmlDocPtr doc = xmlNewDoc(BAD_CAST"1.0");
	xmlNodePtr root_node = xmlNewNode(NULL,BAD_CAST"CSocketMsgInfo");
	xmlDocSetRootElement(doc,root_node);
#endif

/*
	xmlNodePtr new_node = xmlNewNode(NULL, "");
	xmlAddChild(root_node, new_node);
	new_node = xmlNewNode(NULL, "string");
	xmlNewProp(new_node, BAD_CAST"Mode", str2);
	xmlAddChild(root_node, new_node);
*/

	xmlSaveFormatFileEnc(SCHEDULE_FILE, doc, "UTF-8", 1);
//	xmlChar *xmlbuff;
//	int buffersize;
//	xmlDocDumpFormatMemory(doc, &xmlbuff, &buffersize, 1);
//	xmlSaveFile("Created1.xml", doc);
	xmlFreeDoc(doc);

	return 1;
}



