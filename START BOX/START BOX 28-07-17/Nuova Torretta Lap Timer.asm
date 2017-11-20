
_photocell:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Nuova Torretta Lap Timer.c,8 :: 		void photocell() iv IVT_ADDR_INT0INTERRUPT ics ICS_AUTO {
;Nuova Torretta Lap Timer.c,9 :: 		UART1_Write_Text("s");
	PUSH	W10
	MOV	#lo_addr(?lstr1_Nuova_32Torretta_32Lap_32Timer), W10
	CALL	_UART1_Write_Text
;Nuova Torretta Lap Timer.c,10 :: 		Delay_ms(3000);
	MOV	#153, W8
	MOV	#38577, W7
L_photocell0:
	DEC	W7
	BRA NZ	L_photocell0
	DEC	W8
	BRA NZ	L_photocell0
	NOP
	NOP
;Nuova Torretta Lap Timer.c,12 :: 		IFS0bits.INT0IF = 0;
	BCLR	IFS0bits, #0
;Nuova Torretta Lap Timer.c,13 :: 		}
L_end_photocell:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _photocell

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Nuova Torretta Lap Timer.c,17 :: 		void main() {
;Nuova Torretta Lap Timer.c,18 :: 		InitExternalInterrupt();
	PUSH	W10
	PUSH	W11
	CALL	_InitExternalInterrupt
;Nuova Torretta Lap Timer.c,20 :: 		UART1_Init(BAUDRATE);
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Nuova Torretta Lap Timer.c,21 :: 		Delay_ms(200);
	MOV	#11, W8
	MOV	#11309, W7
L_main2:
	DEC	W7
	BRA NZ	L_main2
	DEC	W8
	BRA NZ	L_main2
;Nuova Torretta Lap Timer.c,23 :: 		while(x);
L_main4:
	MOV	#lo_addr(_x), W0
	CP0	[W0]
	BRA NZ	L__main8
	GOTO	L_main5
L__main8:
	GOTO	L_main4
L_main5:
;Nuova Torretta Lap Timer.c,24 :: 		}
L_end_main:
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_InitExternalInterrupt:

;Nuova Torretta Lap Timer.c,28 :: 		void InitExternalInterrupt() {
;Nuova Torretta Lap Timer.c,29 :: 		INTCON2 = 0;
	CLR	INTCON2
;Nuova Torretta Lap Timer.c,31 :: 		INTCON2bits.INT0EP = 0;
	BCLR	INTCON2bits, #0
;Nuova Torretta Lap Timer.c,32 :: 		IFS0bits.INT0IF = 0;
	BCLR	IFS0bits, #0
;Nuova Torretta Lap Timer.c,33 :: 		IPC3bits.CNIP = 0x05;
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC3bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC3bits
;Nuova Torretta Lap Timer.c,34 :: 		IEC0bits.INT0IE = 1;
	BSET	IEC0bits, #0
;Nuova Torretta Lap Timer.c,35 :: 		}
L_end_InitExternalInterrupt:
	RETURN
; end of _InitExternalInterrupt
