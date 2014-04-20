obj-m:= first_module_test.o

KDIR:=/lib/modules/2.6.32-71.el6.x86_64/build
all:
	make -C $(KDIR) M=`pwd` modules
clean:
	make -C $(KDIR) M=`pwd` modules clean
	rm -f modules.order *.o
