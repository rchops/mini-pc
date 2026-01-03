#include "io.h"

// must have buffer as 16-byte alignment because only upper 28 bits of address passed via mailbox
// therefore must tell it its 32 bits or will read/write wrong
volatile unsigned int __attribute__((aligned(16))) mbox[36];

enum{
    VIDEOCORE_MBOX = (PERIPHERAL_BASE + 0x0000B880),
    MBOX_READ = (VIDEOCORE_MBOX + 0x0),
    MBOX_POLL = (VIDEOCORE_MBOX + 0x10),
    MBOX_SENDER = (VIDEOCORE_MBOX + 0x14), 
    MBOX_STATUS = (VIDEOCORE_MBOX + 0x18),
    MBOX_CONFIG = (VIDEOCORE_MBOX + 0x1C),
    MBOX_WRITE = (VIDEOCORE_MBOX + 0x20),
    MBOX_RESPONSE = 0x80000000,
    MBOX_FULL = 0x80000000,
    MBOX_EMPTY = 0x40000000 
};

unsigned int mbox_call(unsigned char ch){
    
    // this is 28 bit address (mbox address) and lower 4 bits for channel
    unsigned int r = ((unsigned int)((long)&mbox) & ~0xF) | (ch & 0xF);
 
    // wait until able to write
    while(mmio_read(MBOX_STATUS) & MBOX_FULL);

    // write address of buffer (message) to mailbox with channel added
    mmio_write(MBOX_WRITE, r);

    // wait for response
    while(1){
        // wait for response
        while(mmio_read(MBOX_STATUS) & MBOX_EMPTY);

        if(r == mmio_read(MBOX_READ)){
            return mbox[1] == MBOX_RESPONSE;
        }
    }
    return 0;
}