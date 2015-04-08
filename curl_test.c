#if 0
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>

#define MAX_BUFFER_LEN (2014*1024*10) // no more than 10MByte

#define TEST_URL "ftp://10.7.0.15/pre-cfg/463_eNodeB_Data_Model_TR_196_based.xml"
#define TEST_FILE "./463_eNodeB_Data_Model_TR_196_based.xml"
#define TEST_USER_KEY "omsftp:omsftp"

void main(void)
{
	CURL *curl;
	char *buffer = NULL;
	int res = 0;

	curl = curl_easy_init();
	curl_easy_setopt(curl, CURLOPT_USERPWD, TEST_USER_KEY);
	curl_easy_setopt(curl, CURLOPT_URL, TEST_URL);
	curl_easy_setopt(curl, CURLOPT_HEADER, 1);
	curl_easy_setopt(curl, CURLOPT_NOBODY, 1);

printf("#1\n");
	curl_easy_perform(curl);
printf("#2\n");
	curl_easy_getinfo(curl, CURLINFO_CONTENT_LENGTH_DOWNLOAD, &res);
printf("res: %d\n", res);

/*
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, buffer);

	if (CURLE_OK != curl_easy_perform(curl)) {
		printf("Perform failed\n");
		goto error;
	}

error:
*/
	if (curl)
		curl_easy_cleanup(curl);
}
#endif



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <curl/curl.h>
//#include <curl/types.h>
#include <curl/easy.h>

#define TEST_URL "ftp://10.7.0.15/pre-cfg/463_eNodeB_Data_Model_TR_196_based.xml"
#define TEST_FILE "./463_eNodeB_Data_Model_TR_196_based.xml"
#define TEST_USER_KEY "omsftp:omsftp"

struct MemoryStruct {
  char *memory;
  size_t size;
};

static void *myrealloc(void *ptr, size_t size)
{
  /* There might be a realloc() out there that doesn't like reallocing
     NULL pointers, so we take care of it here */
  if(ptr)
    return realloc(ptr, size);
  else
    return malloc(size);
}

static size_t
WriteMemoryCallback(void *ptr, size_t size, size_t nmemb, void *data)
{
  size_t realsize = size * nmemb;
  struct MemoryStruct *mem = (struct MemoryStruct *)data;

	if (!data) {
		return -1;
	}

  mem->memory = myrealloc(mem->memory, mem->size + realsize + 1);
  if (mem->memory) {
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
  }
  return realsize;
}

int main(int argc, char **argv)
{
  CURL *curl_handle;

  struct MemoryStruct chunk;

  chunk.memory=NULL; /* we expect realloc(NULL, size) to work */
  chunk.size = 0;    /* no data at this point */

  curl_global_init(CURL_GLOBAL_ALL);

  curl_handle = curl_easy_init();
  curl_easy_setopt(curl_handle, CURLOPT_USERPWD, TEST_USER_KEY);
  curl_easy_setopt(curl_handle, CURLOPT_URL, TEST_URL);
  /* send all data to this function  */
  curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);

  /* we pass our 'chunk' struct to the callback function */
  curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&chunk);

  /* some servers don't like requests that are made without a user-agent
     field, so we provide one */
  //curl_easy_setopt(curl_handle, CURLOPT_USERAGENT, "libcurl-agent/1.0");

  /* get it! */
  curl_easy_perform(curl_handle);

printf("%s\n", chunk.memory);

  /* cleanup curl stuff */
  curl_easy_cleanup(curl_handle);

  /*
   * Now, our chunk.memory points to a memory block that is chunk.size
   * bytes big and contains the remote file.
   *
   * Do something nice with it!
   *
   * You should be aware of the fact that at this point we might have an
   * allocated data block, and nothing has yet deallocated that data. So when
   * you're done with it, you should free() it as a nice application.
   */

  if(chunk.memory)
    free(chunk.memory);

  /* we're done with libcurl, so clean it up */
  curl_global_cleanup();

  return 0;
}


