cmd_/opt/c-language/kobject_example/kobject.ko.unsigned := ld -r -m elf_x86_64 -T /usr/src/kernels/2.6.32-220.infonix.x86_64/scripts/module-common.lds --build-id -o /opt/c-language/kobject_example/kobject.ko.unsigned /opt/c-language/kobject_example/kobject.o /opt/c-language/kobject_example/kobject.mod.o 