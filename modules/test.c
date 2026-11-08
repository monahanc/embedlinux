#include <linux/init.h>
#include <linux/module.h>

static int __init test_init(void)
{
    printk(KERN_INFO "Among us\n");
    return 0;
}

static void __exit test_exit(void)
{
    printk(KERN_INFO "Vent\n");
}

module_init(test_init);
module_exit(test_exit);
MODULE_AUTHOR("Connor Monahan");
MODULE_DESCRIPTION("Sus kernel module");
MODULE_LICENSE("GPL");