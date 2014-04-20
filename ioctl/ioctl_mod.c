#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include "ioctl_test.h"

static int __init test_init(void)
{
	printk("hello world~\n");
	return 0;
}

static void __exit test_exit(void)
{
	printk("good bye!\n");
}

static int __init test_ioctl(struct inode *node, struct file *filp, unsigned int cmd, unsigned long arg)
{
	int ret = 0;
	struct _test_t *dev = filp->private_data;

	switch(cmd) {
	case TEST_CLEAR:
		filp->f_pos = 0;
		ret = 0;
		break;
	default:
		ret = -EINVAL;
		break;
	}
	return ret;
}

module_init(test_init);
module_exit(test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("chenjt");
MODULE_VERSION("1.0");
