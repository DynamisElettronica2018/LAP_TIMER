
_startAcceleration:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;MyProject.c,50 :: 		void startAcceleration() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO
;MyProject.c,52 :: 		IFS0bits.U1RXIF = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	IFS0bits, #9
;MyProject.c,53 :: 		UART1_Read();
	CALL	_UART1_Read
;MyProject.c,54 :: 		if(!mode && lap > 0 && mario)      //endurance
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA Z	L__startAcceleration71
	GOTO	L__startAcceleration58
L__startAcceleration71:
	MOV	_lap, W0
	CP	W0, #0
	BRA GT	L__startAcceleration72
	GOTO	L__startAcceleration57
L__startAcceleration72:
	MOV	#lo_addr(_mario), W0
	CP0	[W0]
	BRA NZ	L__startAcceleration73
	GOTO	L__startAcceleration56
L__startAcceleration73:
L__startAcceleration55:
;MyProject.c,56 :: 		counter2 = counter;
	MOV	_counter, W0
	MOV	W0, _counter2
;MyProject.c,57 :: 		temp2 = temp;
	MOV	_temp, W0
	MOV	W0, _temp2
;MyProject.c,58 :: 		SendData(counter2, temp2);
	MOV	_temp, W11
	MOV	_counter, W10
	CALL	_SendData
;MyProject.c,59 :: 		Lcd_Out(1,14, "INT");
	MOV	#lo_addr(?lstr1_MyProject), W12
	MOV	#14, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,60 :: 		mario = 0;
	CLR	W0
	MOV	W0, _mario
;MyProject.c,61 :: 		}
	GOTO	L_startAcceleration3
;MyProject.c,54 :: 		if(!mode && lap > 0 && mario)      //endurance
L__startAcceleration58:
L__startAcceleration57:
L__startAcceleration56:
;MyProject.c,62 :: 		else if(mode && !accStart)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA NZ	L__startAcceleration74
	GOTO	L__startAcceleration60
L__startAcceleration74:
	MOV	#lo_addr(_accStart), W0
	CP0	[W0]
	BRA Z	L__startAcceleration75
	GOTO	L__startAcceleration59
L__startAcceleration75:
L__startAcceleration54:
;MyProject.c,64 :: 		InitTimer1();
	CALL	_InitTimer1
;MyProject.c,65 :: 		accStart = 1;
	MOV	#1, W0
	MOV	W0, _accStart
;MyProject.c,66 :: 		Lcd_Out(1,15,"OK");
	MOV	#lo_addr(?lstr2_MyProject), W12
	MOV	#15, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,62 :: 		else if(mode && !accStart)
L__startAcceleration60:
L__startAcceleration59:
;MyProject.c,67 :: 		}
L_startAcceleration3:
;MyProject.c,69 :: 		}
L_end_startAcceleration:
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _startAcceleration

_interruptTimer1:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;MyProject.c,72 :: 		void interruptTimer1(void) iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO
;MyProject.c,74 :: 		IFS0bits.T1IF = 0;
	BCLR	IFS0bits, #3
;MyProject.c,75 :: 		counter++;
	MOV	#1, W1
	MOV	#lo_addr(_counter), W0
	ADD	W1, [W0], [W0]
;MyProject.c,76 :: 		if(counter == 1000)
	MOV	_counter, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA Z	L__interruptTimer177
	GOTO	L_interruptTimer17
L__interruptTimer177:
;MyProject.c,78 :: 		counter = 0;                               //increments milliseconds
	CLR	W0
	MOV	W0, _counter
;MyProject.c,79 :: 		temp++;                                    //increments every seconds
	MOV	#1, W1
	MOV	#lo_addr(_temp), W0
	ADD	W1, [W0], [W0]
;MyProject.c,80 :: 		}
L_interruptTimer17:
;MyProject.c,81 :: 		}
L_end_interruptTimer1:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _interruptTimer1

_whiteButton:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;MyProject.c,83 :: 		void whiteButton() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO
;MyProject.c,85 :: 		delay_ms(350);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#18, W8
	MOV	#52559, W7
L_whiteButton8:
	DEC	W7
	BRA NZ	L_whiteButton8
	DEC	W8
	BRA NZ	L_whiteButton8
	NOP
;MyProject.c,86 :: 		IFS0bits.INT0IF = 0;       //set INT0
	BCLR	IFS0bits, #0
;MyProject.c,88 :: 		if(x)
	MOV	#lo_addr(_x), W0
	CP0	[W0]
	BRA NZ	L__whiteButton79
	GOTO	L_whiteButton10
L__whiteButton79:
;MyProject.c,90 :: 		if(!mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA Z	L__whiteButton80
	GOTO	L_whiteButton11
L__whiteButton80:
;MyProject.c,92 :: 		mode = 1;
	MOV	#1, W0
	MOV	W0, _mode
;MyProject.c,93 :: 		Lcd_Out(2,1,"                ");
	MOV	#lo_addr(?lstr3_MyProject), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,94 :: 		Lcd_Out(2,1,TXTSELECT3);
	MOV	#lo_addr(?lstr4_MyProject), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,95 :: 		}
	GOTO	L_whiteButton12
L_whiteButton11:
;MyProject.c,96 :: 		else if(mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA NZ	L__whiteButton81
	GOTO	L_whiteButton13
L__whiteButton81:
;MyProject.c,98 :: 		mode = 0;
	CLR	W0
	MOV	W0, _mode
;MyProject.c,99 :: 		Lcd_Out(2,1,"                ");
	MOV	#lo_addr(?lstr5_MyProject), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,100 :: 		Lcd_Out(2,1,TXTSELECT2);
	MOV	#lo_addr(?lstr6_MyProject), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,101 :: 		}
L_whiteButton13:
L_whiteButton12:
;MyProject.c,102 :: 		}
	GOTO	L_whiteButton14
L_whiteButton10:
;MyProject.c,103 :: 		else if(!x)
	MOV	#lo_addr(_x), W0
	CP0	[W0]
	BRA Z	L__whiteButton82
	GOTO	L_whiteButton15
L__whiteButton82:
;MyProject.c,105 :: 		tempDelay = temp;
	MOV	_temp, W0
	MOV	W0, _tempDelay
;MyProject.c,107 :: 		y = 0;                      //Esco dalla modalità inserita e torno al menu attraverso il ciclo while principale del main
	CLR	W0
	MOV	W0, _y
;MyProject.c,108 :: 		}
L_whiteButton15:
L_whiteButton14:
;MyProject.c,109 :: 		}
L_end_whiteButton:
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _whiteButton

_redButton:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;MyProject.c,111 :: 		void redButton() iv IVT_ADDR_INT2INTERRUPT ics ICS_AUTO
;MyProject.c,113 :: 		delay_ms(350);
	MOV	#18, W8
	MOV	#52559, W7
L_redButton16:
	DEC	W7
	BRA NZ	L_redButton16
	DEC	W8
	BRA NZ	L_redButton16
	NOP
;MyProject.c,114 :: 		IFS1bits.INT2IF = 0;       //set INT0 flag
	BCLR.B	IFS1bits, #7
;MyProject.c,115 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;MyProject.c,116 :: 		y = 1;
	MOV	#1, W0
	MOV	W0, _y
;MyProject.c,117 :: 		}
L_end_redButton:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _redButton

_interruptPhoto:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;MyProject.c,119 :: 		void interruptPhoto() iv IVT_ADDR_INT1INTERRUPT ics ICS_AUTO
;MyProject.c,121 :: 		IFS1bits.INT1IF = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR.B	IFS1bits, #0
;MyProject.c,123 :: 		if(!x)
	MOV	#lo_addr(_x), W0
	CP0	[W0]
	BRA Z	L__interruptPhoto85
	GOTO	L_interruptPhoto18
L__interruptPhoto85:
;MyProject.c,125 :: 		if (!mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA Z	L__interruptPhoto86
	GOTO	L_interruptPhoto19
L__interruptPhoto86:
;MyProject.c,127 :: 		if (lap == -1)
	MOV	#65535, W1
	MOV	#lo_addr(_lap), W0
	CP	W1, [W0]
	BRA Z	L__interruptPhoto87
	GOTO	L_interruptPhoto20
L__interruptPhoto87:
;MyProject.c,128 :: 		lap++;
	MOV	#1, W1
	MOV	#lo_addr(_lap), W0
	ADD	W1, [W0], [W0]
L_interruptPhoto20:
;MyProject.c,129 :: 		if(!lap)
	MOV	#lo_addr(_lap), W0
	CP0	[W0]
	BRA Z	L__interruptPhoto88
	GOTO	L_interruptPhoto21
L__interruptPhoto88:
;MyProject.c,131 :: 		InitTimer1();       //parte a contare
	CALL	_InitTimer1
;MyProject.c,132 :: 		Lcd_Out(1,15,"OK");
	MOV	#lo_addr(?lstr7_MyProject), W12
	MOV	#15, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,133 :: 		lap++;
	MOV	#1, W1
	MOV	#lo_addr(_lap), W0
	ADD	W1, [W0], [W0]
;MyProject.c,134 :: 		mario = 1;
	MOV	#1, W0
	MOV	W0, _mario
;MyProject.c,135 :: 		}
	GOTO	L_interruptPhoto22
L_interruptPhoto21:
;MyProject.c,136 :: 		else if(lap > 0 && temp > 2)
	MOV	_lap, W0
	CP	W0, #0
	BRA GT	L__interruptPhoto89
	GOTO	L__interruptPhoto64
L__interruptPhoto89:
	MOV	_temp, W0
	CP	W0, #2
	BRA GT	L__interruptPhoto90
	GOTO	L__interruptPhoto63
L__interruptPhoto90:
L__interruptPhoto62:
;MyProject.c,138 :: 		counter2 = counter;
	MOV	_counter, W0
	MOV	W0, _counter2
;MyProject.c,139 :: 		temp2 = temp;
	MOV	_temp, W0
	MOV	W0, _temp2
;MyProject.c,140 :: 		counter = 0;
	CLR	W0
	MOV	W0, _counter
;MyProject.c,141 :: 		temp = 0;
	CLR	W0
	MOV	W0, _temp
;MyProject.c,142 :: 		SendData(counter2, temp2);
	MOV	_temp2, W11
	MOV	_counter2, W10
	CALL	_SendData
;MyProject.c,143 :: 		Lcd_Out(1,14,"END");
	MOV	#lo_addr(?lstr8_MyProject), W12
	MOV	#14, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,144 :: 		lap++;
	MOV	#1, W1
	MOV	#lo_addr(_lap), W0
	ADD	W1, [W0], [W0]
;MyProject.c,145 :: 		mario = 1;
	MOV	#1, W0
	MOV	W0, _mario
;MyProject.c,136 :: 		else if(lap > 0 && temp > 2)
L__interruptPhoto64:
L__interruptPhoto63:
;MyProject.c,146 :: 		}
L_interruptPhoto22:
;MyProject.c,147 :: 		}
L_interruptPhoto19:
;MyProject.c,148 :: 		if (mode && accStart)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA NZ	L__interruptPhoto91
	GOTO	L__interruptPhoto66
L__interruptPhoto91:
	MOV	#lo_addr(_accStart), W0
	CP0	[W0]
	BRA NZ	L__interruptPhoto92
	GOTO	L__interruptPhoto65
L__interruptPhoto92:
L__interruptPhoto61:
;MyProject.c,150 :: 		counter2 = counter;
	MOV	_counter, W0
	MOV	W0, _counter2
;MyProject.c,151 :: 		temp2 = temp;
	MOV	_temp, W0
	MOV	W0, _temp2
;MyProject.c,152 :: 		SendData(counter2, temp2);
	MOV	_temp, W11
	MOV	_counter, W10
	CALL	_SendData
;MyProject.c,153 :: 		accStart = 0;
	CLR	W0
	MOV	W0, _accStart
;MyProject.c,154 :: 		counter = 0;
	CLR	W0
	MOV	W0, _counter
;MyProject.c,155 :: 		temp = 0;
	CLR	W0
	MOV	W0, _temp
;MyProject.c,148 :: 		if (mode && accStart)
L__interruptPhoto66:
L__interruptPhoto65:
;MyProject.c,157 :: 		}
L_interruptPhoto18:
;MyProject.c,158 :: 		}
L_end_interruptPhoto:
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _interruptPhoto

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;MyProject.c,160 :: 		void main()
;MyProject.c,162 :: 		ADPCFG = 0xFFFF;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#65535, W0
	MOV	WREG, ADPCFG
;MyProject.c,163 :: 		TRISB = 0b0000000011000000;
	MOV	#192, W0
	MOV	WREG, TRISB
;MyProject.c,164 :: 		TRISC = 0b0000000000000000;
	CLR	TRISC
;MyProject.c,165 :: 		TRISD = 0b0000000000000001;
	MOV	#1, W0
	MOV	WREG, TRISD
;MyProject.c,167 :: 		Lcd_Init();                        // Initialize LCD
	CALL	_Lcd_Init
;MyProject.c,168 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,169 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOV.B	#12, W10
	CALL	_Lcd_Cmd
;MyProject.c,171 :: 		UART1_Init(BAUDRATE);              // Initialize UART module at 9600 bps
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;MyProject.c,172 :: 		Delay_ms(100);                     // Wait for UART module to stabilize
	MOV	#6, W8
	MOV	#5654, W7
L_main29:
	DEC	W7
	BRA NZ	L_main29
	DEC	W8
	BRA NZ	L_main29
;MyProject.c,174 :: 		InitExternalInterrupt();
	CALL	_InitExternalInterrupt
;MyProject.c,176 :: 		while(1)
L_main31:
;MyProject.c,178 :: 		mode = 0;
	CLR	W0
	MOV	W0, _mode
;MyProject.c,179 :: 		lap = -1;
	MOV	#65535, W0
	MOV	W0, _lap
;MyProject.c,180 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,181 :: 		Lcd_Out(1,2,TXTLCDSTART);          // Write text in first row
	MOV	#lo_addr(?lstr9_MyProject), W12
	MOV	#2, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,182 :: 		Delay_ms(2000);
	MOV	#102, W8
	MOV	#47563, W7
L_main33:
	DEC	W7
	BRA NZ	L_main33
	DEC	W8
	BRA NZ	L_main33
	NOP
;MyProject.c,183 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,184 :: 		Lcd_Out(1,1,TXTSELECT1);
	MOV	#lo_addr(?lstr10_MyProject), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,185 :: 		Lcd_Out(2,1,TXTSELECT2);
	MOV	#lo_addr(?lstr11_MyProject), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,187 :: 		while(x);
L_main35:
	MOV	#lo_addr(_x), W0
	CP0	[W0]
	BRA NZ	L__main94
	GOTO	L_main36
L__main94:
	GOTO	L_main35
L_main36:
;MyProject.c,189 :: 		if (!mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA Z	L__main95
	GOTO	L_main37
L__main95:
;MyProject.c,190 :: 		Endurance();
	CALL	_Endurance
	GOTO	L_main38
L_main37:
;MyProject.c,192 :: 		Acceleration();
	CALL	_Acceleration
L_main38:
;MyProject.c,194 :: 		x = 1;
	MOV	#1, W0
	MOV	W0, _x
;MyProject.c,195 :: 		}
	GOTO	L_main31
;MyProject.c,196 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_InitExternalInterrupt:

;MyProject.c,198 :: 		void InitExternalInterrupt()
;MyProject.c,200 :: 		INTCON2 = 0;               //reset configuration external interrupts
	CLR	INTCON2
;MyProject.c,203 :: 		INTCON2bits.INT1EP = 0;
	BCLR	INTCON2bits, #1
;MyProject.c,204 :: 		IFS1bits.INT1IF = 0;
	BCLR.B	IFS1bits, #0
;MyProject.c,205 :: 		IPC3bits.CNIP = 0x05;
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC3bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC3bits
;MyProject.c,206 :: 		IEC1bits.INT1IE = 1;
	BSET.B	IEC1bits, #0
;MyProject.c,209 :: 		INTCON2bits.INT0EP = 1;    //set interrupt on negative edge for INT0
	BSET	INTCON2bits, #0
;MyProject.c,210 :: 		IFS0bits.INT0IF = 0;       //set INT0 flag
	BCLR	IFS0bits, #0
;MyProject.c,211 :: 		IPC0bits.INT0IP = 0x05;    //set INT0 priority
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;MyProject.c,212 :: 		IEC0bits.INT0IE = 1;       //enable INT0
	BSET	IEC0bits, #0
;MyProject.c,215 :: 		INTCON2bits.INT2EP = 1;    //set interrupt on negative edge for INT2
	BSET	INTCON2bits, #2
;MyProject.c,216 :: 		IFS1bits.INT2IF = 0;       //set INT2 flag
	BCLR.B	IFS1bits, #7
;MyProject.c,217 :: 		IPC0bits.INT0IP = 0x02;    //set INT2 priority
	MOV.B	#2, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC0bits), W0
	MOV.B	W1, [W0]
;MyProject.c,218 :: 		IEC1bits.INT2IE = 1;       //enable INT2
	BSET.B	IEC1bits, #7
;MyProject.c,221 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #9
;MyProject.c,222 :: 		IPC2bits.U1RXIP = 0x05;
	MOV.B	#80, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC2bits), W0
	MOV.B	W1, [W0]
;MyProject.c,223 :: 		U1STAbits.URXISEL = 00;
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;MyProject.c,224 :: 		IEC0bits.U1RXIE = 1;
	BSET	IEC0bits, #9
;MyProject.c,225 :: 		}
L_end_InitExternalInterrupt:
	RETURN
; end of _InitExternalInterrupt

_InitTimer1:

;MyProject.c,227 :: 		void InitTimer1( void ){
;MyProject.c,228 :: 		T1CON = 0;                 /* ensure Timer 1 is in reset state */                            //11 = 1:256 prescale value
	CLR	T1CON
;MyProject.c,229 :: 		T1CONbits.TSYNC = 0;
	BCLR	T1CONbits, #2
;MyProject.c,230 :: 		T1CONbits.TCS = 0;         /* select internal timer clock FOSC/2 soit FCY */                 //10 = 1:64 prescale value
	BCLR	T1CONbits, #1
;MyProject.c,231 :: 		T1CONbits.TCKPS0 = 0;      /* select Timer1 Input Clock Prescale */                          //01 = 1:8 prescale value
	BCLR	T1CONbits, #4
;MyProject.c,232 :: 		T1CONbits.TCKPS1 = 0;      /* select Timer1 Input Clock Prescale */                          //00 = 1:1 prescale value
	BCLR	T1CONbits, #5
;MyProject.c,233 :: 		T1CONbits.TGATE = 0;       /* select Timer1 Input Clock Prescale */
	BCLR	T1CONbits, #6
;MyProject.c,234 :: 		IFS0bits.T1IF = 0;         /* reset Timer 1 interrupt flag */
	BCLR	IFS0bits, #3
;MyProject.c,235 :: 		IPC0bits.T1IP = 0x04;      /* set Timer1 interrupt priority level to 6 */
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;MyProject.c,236 :: 		IEC0bits.T1IE = 1;         /* enable Timer 1 interrupt */
	BSET	IEC0bits, #3
;MyProject.c,237 :: 		TMR1 = 0;
	CLR	TMR1
;MyProject.c,238 :: 		PR1 = 10000;               /* set Timer 1 period register */
	MOV	#10000, W0
	MOV	WREG, PR1
;MyProject.c,239 :: 		T1CONbits.TON = 1;         /* enable Timer 1 and start the count */
	BSET	T1CONbits, #15
;MyProject.c,241 :: 		counter = 0;
	CLR	W0
	MOV	W0, _counter
;MyProject.c,242 :: 		temp = 0;
	CLR	W0
	MOV	W0, _temp
;MyProject.c,243 :: 		}
L_end_InitTimer1:
	RETURN
; end of _InitTimer1

_SendData:
	LNK	#2

;MyProject.c,245 :: 		void SendData(int mills, int sec)
;MyProject.c,247 :: 		int prim = sec/60;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#60, W2
	REPEAT	#17
	DIV.S	W11, W2
	MOV	W0, W1
	MOV	W1, [W14+0]
;MyProject.c,248 :: 		sec = sec-prim*60;
	MOV	#60, W0
	MUL.SS	W1, W0, W0
	SUB	W11, W0, W0
	MOV	W0, W11
;MyProject.c,249 :: 		if (mills < 100)
	MOV	#100, W0
	CP	W10, W0
	BRA LT	L__SendData100
	GOTO	L_SendData39
L__SendData100:
;MyProject.c,250 :: 		if (mills < 10)
	CP	W10, #10
	BRA LT	L__SendData101
	GOTO	L_SendData40
L__SendData101:
;MyProject.c,251 :: 		sprintf(txtMills, "00%d", mills);
	PUSH	W11
	PUSH	W10
	MOV	#lo_addr(?lstr_12_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtMills), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
	POP	W11
	GOTO	L_SendData41
L_SendData40:
;MyProject.c,253 :: 		sprintf(txtMills, "0%d", mills);
	PUSH	W11
	PUSH	W10
	MOV	#lo_addr(?lstr_13_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtMills), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
	POP	W11
L_SendData41:
	GOTO	L_SendData42
L_SendData39:
;MyProject.c,255 :: 		sprintf(txtMills, "%d", mills);
	PUSH	W11
	PUSH	W10
	MOV	#lo_addr(?lstr_14_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtMills), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
	POP	W11
L_SendData42:
;MyProject.c,257 :: 		if (sec < 10)
	CP	W11, #10
	BRA LT	L__SendData102
	GOTO	L_SendData43
L__SendData102:
;MyProject.c,258 :: 		sprintf(txtSec, "0%d", sec);
	PUSH	W11
	MOV	#lo_addr(?lstr_15_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtSec), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
	GOTO	L_SendData44
L_SendData43:
;MyProject.c,260 :: 		sprintf(txtSec, "%d", sec);
	PUSH	W11
	MOV	#lo_addr(?lstr_16_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtSec), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
L_SendData44:
;MyProject.c,262 :: 		sprintf(txtPrim, "%d", prim);
	ADD	W14, #0, W0
	PUSH	[W0]
	MOV	#lo_addr(?lstr_17_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtPrim), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
;MyProject.c,263 :: 		sprintf(txtLap, "%d", lap);
	PUSH	_lap
	MOV	#lo_addr(?lstr_18_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtLap), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#6, W15
;MyProject.c,264 :: 		sprintf(txtDataSend, "%s%s%s\n", txtPrim, txtSec, txtMills);
	MOV	#lo_addr(_txtMills), W0
	PUSH	W0
	MOV	#lo_addr(_txtSec), W0
	PUSH	W0
	MOV	#lo_addr(_txtPrim), W0
	PUSH	W0
	MOV	#lo_addr(?lstr_19_MyProject), W0
	PUSH	W0
	MOV	#lo_addr(_txtDataSend), W0
	PUSH	W0
	CALL	_sprintf
	SUB	#10, W15
;MyProject.c,265 :: 		UART1_Write_Text(txtDataSend);
	MOV	#lo_addr(_txtDataSend), W10
	CALL	_UART1_Write_Text
;MyProject.c,268 :: 		if(!mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA Z	L__SendData103
	GOTO	L_SendData45
L__SendData103:
;MyProject.c,270 :: 		Lcd_Out(2,1,txtLap);
	MOV	#lo_addr(_txtLap), W12
	MOV	#1, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,271 :: 		}
L_SendData45:
;MyProject.c,274 :: 		Lcd_Out(2,4,txtPrim);
	MOV	#lo_addr(_txtPrim), W12
	MOV	#4, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,275 :: 		Lcd_Out(2,5,"'");
	MOV	#lo_addr(?lstr20_MyProject), W12
	MOV	#5, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,276 :: 		Lcd_Out(2,7,txtSec);
	MOV	#lo_addr(_txtSec), W12
	MOV	#7, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,277 :: 		Lcd_Out(2,9,"\"");
	MOV	#lo_addr(?lstr21_MyProject), W12
	MOV	#9, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,278 :: 		Lcd_Out(2,11,txtMills);
	MOV	#lo_addr(_txtMills), W12
	MOV	#11, W11
	MOV	#2, W10
	CALL	_Lcd_Out
;MyProject.c,280 :: 		if(mode)
	MOV	#lo_addr(_mode), W0
	CP0	[W0]
	BRA NZ	L__SendData104
	GOTO	L_SendData46
L__SendData104:
;MyProject.c,281 :: 		Lcd_Out(1,15,"  ");
	MOV	#lo_addr(?lstr22_MyProject), W12
	MOV	#15, W11
	MOV	#1, W10
	CALL	_Lcd_Out
L_SendData46:
;MyProject.c,282 :: 		}
L_end_SendData:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _SendData

_Endurance:

;MyProject.c,285 :: 		void Endurance()
;MyProject.c,287 :: 		Lcd_Cmd(_LCD_CLEAR);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,288 :: 		Lcd_Out(1,1, TXTSELECT2);
	MOV	#lo_addr(?lstr23_MyProject), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,289 :: 		while (y)
L_Endurance47:
	MOV	#lo_addr(_y), W0
	CP0	[W0]
	BRA NZ	L__Endurance106
	GOTO	L_Endurance48
L__Endurance106:
;MyProject.c,292 :: 		}
	GOTO	L_Endurance47
L_Endurance48:
;MyProject.c,293 :: 		}
L_end_Endurance:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Endurance

_Acceleration:

;MyProject.c,295 :: 		void Acceleration()
;MyProject.c,297 :: 		Lcd_Cmd(_LCD_CLEAR);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,298 :: 		Lcd_Out(1,1, TXTSELECT3);
	MOV	#lo_addr(?lstr24_MyProject), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,299 :: 		while (y)
L_Acceleration49:
	MOV	#lo_addr(_y), W0
	CP0	[W0]
	BRA NZ	L__Acceleration108
	GOTO	L_Acceleration50
L__Acceleration108:
;MyProject.c,301 :: 		if(temp > 8 && accStart)
	MOV	_temp, W0
	CP	W0, #8
	BRA GT	L__Acceleration109
	GOTO	L__Acceleration69
L__Acceleration109:
	MOV	#lo_addr(_accStart), W0
	CP0	[W0]
	BRA NZ	L__Acceleration110
	GOTO	L__Acceleration68
L__Acceleration110:
L__Acceleration67:
;MyProject.c,303 :: 		accStart = 0;
	CLR	W0
	MOV	W0, _accStart
;MyProject.c,304 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;MyProject.c,305 :: 		Lcd_Out(1,1, TXTSELECT3);
	MOV	#lo_addr(?lstr25_MyProject), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;MyProject.c,301 :: 		if(temp > 8 && accStart)
L__Acceleration69:
L__Acceleration68:
;MyProject.c,307 :: 		}
	GOTO	L_Acceleration49
L_Acceleration50:
;MyProject.c,308 :: 		}
L_end_Acceleration:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Acceleration
