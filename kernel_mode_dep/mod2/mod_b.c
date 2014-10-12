#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>


static int func2(void)
{
	extern int func1(void);
	func1();
	printk("in %s\n", __func__);
	return 0;
}

static int __init hello_init(void)
{
	printk("Module 2 init\n");
	func2();
	return 0;
}

static void __exit hello_exit(void)
{
	printk("Module 2 exit\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
