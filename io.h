void uart_init();
void uart_writeText(char* buffer);
void uart_writeByteBlockingActual(unsigned char ch);
void uart_loadOutputFIFO();
unsigned char uart_readByte();
unsigned char uart_isReadByteReady();
void uart_update();