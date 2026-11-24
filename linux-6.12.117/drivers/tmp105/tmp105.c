#include <linux/module.h>
#include <linux/cdev.h>  /* struct cdev */
#include <linux/i2c.h>   /* struct i2c_client */
#include <linux/types.h> /* dev_t, u8 */

MODULE_AUTHOR("Andrija Stanojkovic");
MODULE_DESCRIPTION("Driver for temperature sensor 105");
MODULE_LICENSE("GPL");
struct tmp105_data {
	struct i2c_client *client; /* I2C client used to access the sensor. */
	struct cdev cdev;          /* Character device for /dev/tmp105_0. */
	dev_t devt;                /* Major and minor device numbers. */
	u8 config;                 /* Cached value of the configuration register. */
};
static const struct of_device_id tmp105_idtable[] = {
      { .compatible = "ti,tmp105" },
      { }
};
MODULE_DEVICE_TABLE(of, tmp105_idtable);

static int tmp105_probe(struct i2c_client *client){
    pr_info("probed/n");
    return 0;
}
static void tmp105_remove(struct i2c_client *client){
    pr_info("removed/n");
}

static struct i2c_driver tmp105_driver = {
    .driver = {
        .name = "tmp105",
        .of_match_table = tmp105_idtable,
    },
    .probe = tmp105_probe,
    .remove = tmp105_remove
};
module_i2c_driver(tmp105_driver);