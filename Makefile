# Compiler + Flags
CC      = aarch64-none-elf-gcc
LD      = aarch64-none-elf-ld
OBJCOPY = aarch64-none-elf-objcopy

GCCFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles

# Source + Object
CFILES = $(wildcard *.c)
OFILES = $(CFILES:.c=.o)

all: clean kernel8.img

# Assembling boot file
boot.o: boot.S
	$(CC) $(GCCFLAGS) -c boot.S -o boot.o

# Compiling C files
%.o: %.c
	$(CC) $(GCCFLAGS) -c $< -o $@

# Link + make image
kernel8.img: boot.o $(OFILES)
	$(LD) -nostdlib boot.o $(OFILES) -T link.ld -o kernel8.elf
	$(OBJCOPY) -O binary kernel8.elf kernel8.img

# Clean
clean:
	/bin/rm -f kernel8.elf *.o *.img
