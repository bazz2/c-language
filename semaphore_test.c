#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/ipc.h>
#include<sys/sem.h>

#define SEMKEY 1234L
#define PERMS 0666

struct sembuf op_down = {0, -1, 0};
struct sembuf op_up = {0, 1, 0};

int semid = -1;
int res;

void init_sem()
{
	printf("create semaphore\n");
	semid = semget(SEMKEY, 0, IPC_CREAT |PERMS);
	if(semid < 0) {
		printf("failed to create semaphore\n");
		exit(-1);
	}
	printf("semctl()\n");
	res = semctl(semid, 0, SETVAL, 1);
}

void down()
{
	printf("semop(down)\n");
	res = semop(semid, &op_down, 1);
}

void up()
{
	printf("semop(up)\n");
	res = semop(semid, &op_up, 1);
}

int main()
{
	init_sem();
	down();
	sleep(10);
	up();
	return 0;
}
