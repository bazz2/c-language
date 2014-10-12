#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int i = 1;

void *thread1(void *junk)
{
	for (i = 1; i <= 6; i++) {
		pthread_mutex_lock(&mutex);
		if (i % 3 == 0) {
			printf("thread1: cond signal #%d\n", i);
			pthread_cond_signal(&cond);
			sleep(1);
		}
		pthread_mutex_unlock(&mutex);
		sleep(5);
	}
}

void *thread2(void *junk)
{
	while (i < 6) {
		pthread_mutex_lock(&mutex);
		if (i % 3 != 0) {
			printf("thread2: cond signal #%d\n", i);
			pthread_cond_signal(&cond);
			printf("thread2: wait #%d\n", i);
			pthread_cond_wait(&cond, &mutex);
			printf("thread2: wait end #%d\n", i);
		}
		pthread_mutex_unlock(&mutex);
		sleep(5);
	}
}

int main(void)
{
	pthread_t t_a;
	pthread_t t_b;
	pthread_create(&t_a, NULL, thread1, (void*)NULL);
	pthread_create(&t_b, NULL, thread2, (void*)NULL);
	pthread_join(t_a, NULL);
	pthread_join(t_b, NULL);

	pthread_mutex_destroy(&mutex);
	pthread_cond_destroy(&cond);

	return 0;
}
