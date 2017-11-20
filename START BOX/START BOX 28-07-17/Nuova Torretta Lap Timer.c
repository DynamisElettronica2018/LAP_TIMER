#define BAUDRATE 9600

void InitExternalInterrupt();

int x=1;


void photocell() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO {
     UART1_Write_Text("s");
     Delay_ms(3000);

     IFS0bits.INT0IF = 0;
}



void main() {
     InitExternalInterrupt();

     UART1_Init(BAUDRATE);
     Delay_ms(200);

     while(x);
}



void InitExternalInterrupt() {
     INTCON2 = 0;

     INTCON2bits.INT0EP = 0;
     IFS0bits.INT0IF = 0;
     IPC3bits.CNIP = 0x05;
     IEC0bits.INT0IE = 1;
}