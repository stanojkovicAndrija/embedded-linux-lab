#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Andrija Stanojkovic");
MODULE_DESCRIPTION("My first Hello World kernel module");

static int __init hello_init(void)
{
    pr_info("hello: Hello World from my kernel module!\n");
    return 0;
}

static void __exit hello_exit(void)
{
    pr_info("hello: Goodbye from my kernel module!\n");
}

module_init(hello_init);
module_exit(hello_exit);

