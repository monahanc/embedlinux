obj-m += test.o

all:
	make -C ../vendor/linux M=$(shell pwd) modules

clean:
	make -C ../vendor/linux M=$(shell pwd) clean
