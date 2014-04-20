obj-m:= kobject.o

KDIR:=/lib/modules/2.6.32-220.infonix.x86_64/build
all:
	make -C $(KDIR) M=`pwd` modules
clean:
	make -C $(KDIR) M=`pwd` modules clean
	rm -f modules.order *.o
