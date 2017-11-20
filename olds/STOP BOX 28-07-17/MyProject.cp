#line 1 "C:/Users/Salvatore/Desktop/STOP BOX def/MyProject.c"







sbit LCD_RS at LATC14_bit;
sbit LCD_EN at LATB0_bit;
sbit LCD_D4 at LATC13_bit;
sbit LCD_D5 at LATB3_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB1_bit;

sbit LCD_RS_Direction at TRISC14_bit;
sbit LCD_EN_Direction at TRISB0_bit;
sbit LCD_D4_Direction at TRISC13_bit;
sbit LCD_D5_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB1_bit;


void InitTimer1();
void InitExternalInterrupt();
void Endurance();
void Acceleration();
void SendData(int mills, int sec);

unsigned int virgolette = 249;
int lap = -1;
int y = 1;
int x = 1;
int counter = 0;
int counter2 = 0;
int flag = 0;
int temp = 0;
int temp2 = 0;
int mode = 0;
int accStart = 0;
int mario = 0;
int tempDelay = 0;

char txtDataSend[8] = "";
char txtTime[6] = "Time:";
char txtMills[4] = "";
char txtSec[3] = "";
char txtPrim[2] = "";
char txtLap[2] = "";

void startAcceleration() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO
{
 IFS0bits.U1RXIF = 0;
 UART1_Read();
 if(!mode && lap > 0 && mario)
 {
 counter2 = counter;
 temp2 = temp;
 SendData(counter2, temp2);
 Lcd_Out(1,14, "INT");
 mario = 0;
 }
 else if(mode && !accStart)
 {
 InitTimer1();
 accStart = 1;
 Lcd_Out(1,15,"OK");
 }

}


void interruptTimer1(void) iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO
{
 IFS0bits.T1IF = 0;
 counter++;
 if(counter == 1000)
 {
 counter = 0;
 temp++;
 }
}

void whiteButton() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO
{
 delay_ms(350);
 IFS0bits.INT0IF = 0;

 if(x)
 {
 if(!mode)
 {
 mode = 1;
 Lcd_Out(2,1,"                ");
 Lcd_Out(2,1, "Acceleration" );
 }
 else if(mode)
 {
 mode = 0;
 Lcd_Out(2,1,"                ");
 Lcd_Out(2,1, "Endurance" );
 }
 }
 else if(!x)
 {
 tempDelay = temp;

 y = 0;
 }
}

void redButton() iv IVT_ADDR_INT2INTERRUPT ics ICS_AUTO
{
 delay_ms(350);
 IFS1bits.INT2IF = 0;
 x = 0;
 y = 1;
}

void interruptPhoto() iv IVT_ADDR_INT1INTERRUPT ics ICS_AUTO
{
 IFS1bits.INT1IF = 0;

 if(!x)
 {
 if (!mode)
 {
 if (lap == -1)
 lap++;
 if(!lap)
 {
 InitTimer1();
 Lcd_Out(1,15,"OK");
 lap++;
 mario = 1;
 }
 else if(lap > 0 && temp > 2)
 {
 counter2 = counter;
 temp2 = temp;
 counter = 0;
 temp = 0;
 SendData(counter2, temp2);
 Lcd_Out(1,14,"END");
 lap++;
 mario = 1;
 }
 }
 if (mode && accStart)
 {
 counter2 = counter;
 temp2 = temp;
 SendData(counter2, temp2);
 accStart = 0;
 counter = 0;
 temp = 0;
 }
 }
}

void main()
{
 ADPCFG = 0xFFFF;
 TRISB = 0b0000000011000000;
 TRISC = 0b0000000000000000;
 TRISD = 0b0000000000000001;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 UART1_Init( 9600 );
 Delay_ms(100);

 InitExternalInterrupt();

 while(1)
 {
 mode = 0;
 lap = -1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,2, "Test DP9 2017" );
 Delay_ms(2000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1, "White Button" );
 Lcd_Out(2,1, "Endurance" );

 while(x);

 if (!mode)
 Endurance();
 else
 Acceleration();

 x = 1;
 }
}

void InitExternalInterrupt()
{
 INTCON2 = 0;


 INTCON2bits.INT1EP = 0;
 IFS1bits.INT1IF = 0;
 IPC3bits.CNIP = 0x05;
 IEC1bits.INT1IE = 1;


 INTCON2bits.INT0EP = 1;
 IFS0bits.INT0IF = 0;
 IPC0bits.INT0IP = 0x05;
 IEC0bits.INT0IE = 1;


 INTCON2bits.INT2EP = 1;
 IFS1bits.INT2IF = 0;
 IPC0bits.INT0IP = 0x02;
 IEC1bits.INT2IE = 1;


 IFS0bits.U1RXIF = 0;
 IPC2bits.U1RXIP = 0x05;
 U1STAbits.URXISEL = 00;
 IEC0bits.U1RXIE = 1;
}

void InitTimer1( void ){
 T1CON = 0;
 T1CONbits.TSYNC = 0;
 T1CONbits.TCS = 0;
 T1CONbits.TCKPS0 = 0;
 T1CONbits.TCKPS1 = 0;
 T1CONbits.TGATE = 0;
 IFS0bits.T1IF = 0;
 IPC0bits.T1IP = 0x04;
 IEC0bits.T1IE = 1;
 TMR1 = 0;
 PR1 = 10000;
 T1CONbits.TON = 1;

 counter = 0;
 temp = 0;
}

void SendData(int mills, int sec)
{
 int prim = sec/60;
 sec = sec-prim*60;
 if (mills < 100)
 if (mills < 10)
 sprintf(txtMills, "00%d", mills);
 else
 sprintf(txtMills, "0%d", mills);
 else
 sprintf(txtMills, "%d", mills);

 if (sec < 10)
 sprintf(txtSec, "0%d", sec);
 else
 sprintf(txtSec, "%d", sec);

 sprintf(txtPrim, "%d", prim);
 sprintf(txtLap, "%d", lap);
 sprintf(txtDataSend, "%s%s%s\n", txtPrim, txtSec, txtMills);
 UART1_Write_Text(txtDataSend);


 if(!mode)
 {
 Lcd_Out(2,1,txtLap);
 }


 Lcd_Out(2,4,txtPrim);
 Lcd_Out(2,5,"'");
 Lcd_Out(2,7,txtSec);
 Lcd_Out(2,9,"\"");
 Lcd_Out(2,11,txtMills);

 if(mode)
 Lcd_Out(1,15,"  ");
}


void Endurance()
{
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,  "Endurance" );
 while (y)
 {

 }
}

void Acceleration()
{
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,  "Acceleration" );
 while (y)
 {
 if(temp > 8 && accStart)
 {
 accStart = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,  "Acceleration" );
 }
 }
}
