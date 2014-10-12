#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

void *thread0(void *arg)
{
printf("thread0 wait for lock\n");
	pthread_mutex_lock(&mutex);
printf("thread0 get lock\n");
printf("thread0 wait for cond\n");
	pthread_cond_wait(&cond, &mutex);
printf("thread0 get cond\n");
	pthread_mutex_unlock(&mutex);
printf("thread0 unlock\n");
	pthread_exit(NULL);
}

void *thread1(void *arg)
{
	sleep(4);
printf("thread1 wait for lock\n");
	pthread_mutex_lock(&mutex);
printf("thread1 get lock\n");
	pthread_cond_broadcast(&cond);
	pthread_mutex_unlock(&mutex);
printf("thread1 unlock\n");
	pthread_exit(NULL);
}

int main()
{
	pthread_t thid[2];

	if (pthread_create(&thid[0], NULL, thread0, NULL) != 0)
		exit(0);
	if (pthread_create(&thid[1], NULL, thread1, NULL) != 0)
		exit(0);
	sleep(2);
 
printf("main    cencel thread0\n");
	pthread_cancel(thid[0]);

	pthread_join(thid[0], NULL);
	pthread_join(thid[1], NULL);

	pthread_mutex_destroy(&mutex);
	pthread_cond_destroy(&cond);

	return 0;
}
