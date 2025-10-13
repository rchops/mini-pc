.section ".text.boot"

.global _start

_start:
    mrs x0, mpidr_el1       // read mpdir_el1 register in x0 to get Core ID
    and x0, x0, #0xFF       // mask to get the core ID - always lower 8 bits
    cbz x0, load
    b hang
    
hang:
    wfe                     // wait for event - not at core 0
    b hang                  // infinite loop for cores not 0

load:                       // now on main core
    ldr x1, =_start         // load address of _start into x1 for stack ptr
    mov sp, x1              // set stack pointer to _start

    ldr x1, = __bss_start   // start address
    ldr w2, = __bss_size    // size of section

clear:
    cbz w2, done            // if size is 0, move on -> want to clear bss to 0 - random memory in RAM
    str xzr, [x1], #8       // store 0 in x1 and increment by 8 bytes - 64 bit reg
    sub w2, w2, #1          // decrement size of bss by 1
    cbnz w2, clear          // if size not zero, repeat

done:
    bl  main                // jump to main() function in C
    b   hang                // if main returns, halt master core