SECTIONS
{
    . = 0x80000; /* Kernel load address for AArch64 */
    .text : { KEEP(*(.text.boot)) *(.text .text.* .gnu.linkonce.t*) } /* Defines output section - text -> sets what
                                                                         input section patterns place in this
                                                                         Keep ensures not discarded - places boot first, then code  */
    .rodata : { *(.rodata .rodata.* .gnu.linkonce.r*) }               /* read-only data */
    PROVIDE(_data = .);                                               /* Defines data section if not already defined */
    .data : { *(.data .data.* .gnu.linkonce.d*) }                     /* data section */
    .bss (NOLOAD) : {                                                 /* BSS section */
        . = ALIGN(16);                                                /* Aligns counter to 16 bits -> rounds up, easier for CPU */
        __bss_start = .;                                              /* Sets start of bss to current address */
        *(.bss .bss.*);                                               /* Calls all input sections named .bss and stores them here */
        *(COMMON)                                                     /* Stores common symbols - uninitialised global varaibles in C */
        __bss_end = .;                                                /* Sets end off bss to current address */
    }         
    _end = .;                                                         /* Defined _end to current address */

    /DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }      /* Discards input sections to be dropped from output */
}
__bss_size = (__bss_start - __bss_end) >> 3;