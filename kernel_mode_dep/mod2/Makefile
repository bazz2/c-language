obj-m := mod2.o
mod2-y := mod_b.o

KBUILD_EXTRA_SYMBOLS=/opt/c-language/kernel_mode_dep/mod1/Module.symvers

KERNELDIR := /lib/modules/`uname -r`/build
PWD := `pwd`

#modules: Module.symvers
modules: Module.symvers
	cat $(KBUILD_EXTRA_SYMBOLS)
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

#Module.symvers:
#	cp $(KBUILD_EXTRA_SYMBOLS) $(PWD)
clean:
	rm -rf *.o *.mod.c modules.order *.ko *.ko.unsigned .mod_b.o.d .*
