#include<stdio.h>
#include<signal.h>
#include<pthread.h>

#if 0
void print1()
{
	printf("child thread%d\n", pthread_self());
}

void thread()
{
	signal(SIGUSR1, print1);
	int i = 0;
	while(1)
	{
		printf("thread%d run %d second\n",pthread_self(), i);
		sleep(2);
		i += 2;
	}
}
void print()
{
	printf("main thread\n");
}
void main()
{
	pthread_t thid[3];
	pthread_create(&thid[0], NULL, (void*)thread, NULL);
	pthread_detach(thid[0]);
	pthread_create(&thid[1], NULL, (void*)thread, NULL);
	pthread_detach(thid[1]);
	pthread_create(&thid[2], NULL, (void*)thread, NULL);
	pthread_detach(thid[2]);
	sleep(3);
	signal(SIGUSR1, print);
	sleep(3);
	printf("send kill thread%d\n", thid[0]);
	pthread_kill(thid[0], SIGUSR1);
	sleep(3);
	printf("send kill thread%d\n", thid[1]);
	pthread_kill(thid[1], SIGUSR1);
	sleep(100);
}
#else
void child_thread()
{
	pthread_t thid = pthread_self();
	printf("child: %d\n", thid);
}
void thread()
{
	signal(SIGALRM, child_thread);
	pthread_t thid = pthread_self();
	printf("parent: %d\n", thid);
	while(1){;}
}

void main()
{
	pthread_t thid;
	pthread_create(&thid, NULL, (void*)thread, NULL);
	pthread_detach(thid);
	sleep(1);
	pthread_kill(thid, SIGALRM);
	sleep(1);
}
#endif
