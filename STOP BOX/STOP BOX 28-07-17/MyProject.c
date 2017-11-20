#define BAUDRATE 9600
#define TXTLCDSTART "Test DP9 2017"
#define TXTSELECT1 "White Button"
#define TXTSELECT2 "Endurance"
#define TXTSELECT3 "Acceleration"

//LCDsettings
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
     if(!mode && lap > 0 && mario)      //endurance
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

//timer1 interrupt routine
void interruptTimer1(void) iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO
{
     IFS0bits.T1IF = 0;
     counter++;
     if(counter == 1000)
     {
        counter = 0;                               //increments milliseconds
        temp++;                                    //increments every seconds
     }
}

void whiteButton() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO
{
     delay_ms(350);
     IFS0bits.INT0IF = 0;       //set INT0
     
     if(x)
     {
           if(!mode)
           {
              mode = 1;
              Lcd_Out(2,1,"                ");
              Lcd_Out(2,1,TXTSELECT3);
           }
           else if(mode)
           {
              mode = 0;
              Lcd_Out(2,1,"                ");
              Lcd_Out(2,1,TXTSELECT2);
           }
     }
     else if(!x)
     {
          tempDelay = temp;

              y = 0;                      //Esco dalla modalità inserita e torno al menu attraverso il ciclo while principale del main
     }
}

void redButton() iv IVT_ADDR_INT2INTERRUPT ics ICS_AUTO
{
     delay_ms(350);
     IFS1bits.INT2IF = 0;       //set INT0 flag
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
                      InitTimer1();       //parte a contare
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

     Lcd_Init();                        // Initialize LCD
     Lcd_Cmd(_LCD_CLEAR);               // Clear display
     Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

     UART1_Init(BAUDRATE);              // Initialize UART module at 9600 bps
     Delay_ms(100);                     // Wait for UART module to stabilize

     InitExternalInterrupt();
     
     while(1)
     {
         mode = 0;
         lap = -1;
         Lcd_Cmd(_LCD_CLEAR);
         Lcd_Out(1,2,TXTLCDSTART);          // Write text in first row
         Delay_ms(2000);
         Lcd_Cmd(_LCD_CLEAR);
         Lcd_Out(1,1,TXTSELECT1);
         Lcd_Out(2,1,TXTSELECT2);
         
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
     INTCON2 = 0;               //reset configuration external interrupts

     //photocell configuration ----> INT1
     INTCON2bits.INT1EP = 0;
     IFS1bits.INT1IF = 0;
     IPC3bits.CNIP = 0x05;
     IEC1bits.INT1IE = 1;

     //black button configuration ----> INT0
     INTCON2bits.INT0EP = 1;    //set interrupt on negative edge for INT0
     IFS0bits.INT0IF = 0;       //set INT0 flag
     IPC0bits.INT0IP = 0x05;    //set INT0 priority
     IEC0bits.INT0IE = 1;       //enable INT0

     //red button configuration -----> INT2
     INTCON2bits.INT2EP = 1;    //set interrupt on negative edge for INT2
     IFS1bits.INT2IF = 0;       //set INT2 flag
     IPC0bits.INT0IP = 0x02;    //set INT2 priority
     IEC1bits.INT2IE = 1;       //enable INT2
     
     //uart configuration -----> UART1RX
     IFS0bits.U1RXIF = 0;
     IPC2bits.U1RXIP = 0x05;
     U1STAbits.URXISEL = 00;
     IEC0bits.U1RXIE = 1;
}

void InitTimer1( void ){
     T1CON = 0;                 /* ensure Timer 1 is in reset state */                            //11 = 1:256 prescale value
     T1CONbits.TSYNC = 0;
     T1CONbits.TCS = 0;         /* select internal timer clock FOSC/2 soit FCY */                 //10 = 1:64 prescale value
     T1CONbits.TCKPS0 = 0;      /* select Timer1 Input Clock Prescale */                          //01 = 1:8 prescale value
     T1CONbits.TCKPS1 = 0;      /* select Timer1 Input Clock Prescale */                          //00 = 1:1 prescale value
     T1CONbits.TGATE = 0;       /* select Timer1 Input Clock Prescale */
     IFS0bits.T1IF = 0;         /* reset Timer 1 interrupt flag */
     IPC0bits.T1IP = 0x04;      /* set Timer1 interrupt priority level to 6 */
     IEC0bits.T1IE = 1;         /* enable Timer 1 interrupt */
     TMR1 = 0;
     PR1 = 10000;               /* set Timer 1 period register */
     T1CONbits.TON = 1;         /* enable Timer 1 and start the count */
     
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
     Lcd_Out(1,1, TXTSELECT2);
     while (y)
     {

     }
}

void Acceleration()
{
     Lcd_Cmd(_LCD_CLEAR);
     Lcd_Out(1,1, TXTSELECT3);
     while (y)
     {
         if(temp > 8 && accStart)
         {
             accStart = 0;
             Lcd_Cmd(_LCD_CLEAR);
             Lcd_Out(1,1, TXTSELECT3);
         }
     }
}