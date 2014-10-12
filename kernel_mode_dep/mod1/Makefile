obj-m := mod1.o
mod1-y := mod_a.o

KERNELDIR := /lib/modules/`uname -r`/build
PWD := `pwd`

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	rm -rf *.o *.mod.c modules.order Module.symvers *.ko *.ko.unsigned .*
