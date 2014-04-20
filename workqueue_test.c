#include<stdio.h>
#include<workqueue.h>

typedef struct user_struct {
	char *name;
	struct work_struct my_work;
} user_struct_t;

void show_work_struct_name(struct work_struct *w)
{
	user_struct_t *us = container_of(w, user_struct_t, my_work);
	printk(KERN_INFO,"Hello world, my name is %s!\n", us->name);
}

void main()
{
	struct workqueue_struct *wqueue = create_workqueue("my workqueue");
	user_struct_t users;
	users.name = "Chenjt";
	INIT_WORK(&(users.my_work), show_work_struct_name);
	queue_work(wqueue, &mywork);
	destroy_workqueue(wqueue);
}
