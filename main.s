; PIC18F45K50 Configuration Bit Settings

; Assembly source line config statements

#include <xc.inc>

; CONFIG1L
  CONFIG  PLLSEL = PLL4X        ; PLL Selection (4x clock multiplier)
  CONFIG  CFGPLLEN = OFF        ; PLL Enable Configuration bit (PLL Disabled (firmware controlled))
  CONFIG  CPUDIV = NOCLKDIV     ; CPU System Clock Postscaler (CPU uses system clock (no divide))
  CONFIG  LS48MHZ = SYS24X4     ; Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection (Internal oscillator)
  CONFIG  PCLKEN = ON           ; Primary Oscillator Shutdown (Primary oscillator enabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  nPWRTEN = OFF         ; Power-up Timer Enable (Power up timer disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
  CONFIG  BORV = 190            ; Brown-out Reset Voltage (BOR set to 1.9V nominal)
  CONFIG  nLPBOR = OFF          ; Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)

; CONFIG2H
  CONFIG  WDTEN = ON            ; Watchdog Timer Enable bits (WDT enabled in hardware (SWDTEN ignored))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = RC1          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
  CONFIG  T3CMX = RC0           ; Timer3 Clock Input MUX bit (T3CKI function is on RC0)
  CONFIG  SDOMX = RB3           ; SDO Output MUX bit (SDO function is on RB3)
  CONFIG  MCLRE = ON            ; Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)

; CONFIG5L
  CONFIG  CP0 = OFF             ; Block 0 Code Protect (Block 0 is not code-protected)
  CONFIG  CP1 = OFF             ; Block 1 Code Protect (Block 1 is not code-protected)
  CONFIG  CP2 = OFF             ; Block 2 Code Protect (Block 2 is not code-protected)
  CONFIG  CP3 = OFF             ; Block 3 Code Protect (Block 3 is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protect (Boot block is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protect (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Block 0 Write Protect (Block 0 (0800-1FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Block 1 Write Protect (Block 1 (2000-3FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Block 2 Write Protect (Block 2 (04000-5FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Block 3 Write Protect (Block 3 (06000-7FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Registers Write Protect (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protect (Boot block (0000-7FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protect (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Block 0 Table Read Protect (Block 0 is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Block 1 Table Read Protect (Block 1 is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Block 2 Table Read Protect (Block 2 is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Block 3 Table Read Protect (Block 3 is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protect (Boot block is not protected from table reads executed in other blocks)

;**************** Definitions*********************************
PSECT	    udata
	TEMP:
		DS	1

;CONSTANT	MASK	0xF
;*************************************************
PSECT	    CODE
ORG	    0x000			;vector de reset 
	    GOTO	MAIN		;goes to main program

INIT:	    
	    MOVLB	0x0F
	    CLRF	ANSELB
	    SETF	LATB
	    SETF	TRISB		;input port
	    CLRF	ANSELD
	    CLRF	LATD
	    CLRF	TRISD		;output port
	    
	    RETURN			;leaving initialization subroutine

			    
MAIN:	    CALL	INIT
			    
LOOP:
	    MOVF	PORTB, W, C
	    ANDLW	0xF0	      ;a mask preserves RB0 and RB1 only
	    MOVWF	TEMP, C		  ;data stored in reg TEMP
	    RRNCF	TEMP, 1, 0  ;right shift
	    RRNCF	TEMP, 1, 0  ;right shift
	    RRNCF	TEMP, 1, 0  ;right shift
	    RRNCF	TEMP, 1, 0  ;right shift

	    MOVF	PORTB,  W, C
	    ANDLW	0x0F	;a mask preserves RB0 and RB1 only
	    ADDWF	TEMP, W, C
	    MOVWF	TEMP, C

	    MOVLW	0x00
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_0
	    MOVLW	0x01
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_1
	    MOVLW	0x02
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_2
	    MOVLW	0x03
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_3
	    MOVLW	0x04
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_4
	    MOVLW	0x05
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_5
	    MOVLW	0x06
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_6
	    MOVLW	0x07
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_7
	    MOVLW	0x08
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_8
	    MOVLW	0x09
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_9
	    MOVLW	0x0A
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_A
	    MOVLW	0x0B
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_B
	    MOVLW	0x0C
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_C
	    MOVLW	0x0D
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_D
	    MOVLW	0x0E
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_E
	    MOVLW	0x0F
	    SUBWF	TEMP, W, C
	    BZ		OUTPUT_F
	    MOVLW	0b11111111
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_0:
	    MOVLW	0b00111111
	    MOVWF	PORTD, C
	    GOTO	LOOP

OUTPUT_1:
	    MOVLW	0b00000110
	    MOVWF	PORTD, C
	    GOTO	LOOP

OUTPUT_2:
	    MOVLW	0b01011011
	    MOVWF	PORTD, C
	    GOTO	LOOP

OUTPUT_3:
	    MOVLW	0b01001111
	    MOVWF	PORTD, C
	    GOTO	LOOP	
	    
OUTPUT_4:
	    MOVLW	0b01100110
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_5:
	    MOVLW	0b01101101
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_6:
	    MOVLW	0b01111101
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_7:
	    MOVLW	0b00000111
	    MOVWF	PORTD, C
	    GOTO	LOOP	
	    
OUTPUT_8:
	    MOVLW	0b01111111
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_9:
	    MOVLW	0b01101111
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_A:
	    MOVLW	0b01110111
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_B:
	    MOVLW	0b01111100
	    MOVWF	PORTD, C
	    GOTO	LOOP	    
	    
OUTPUT_C:
	    MOVLW	0b00111001
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_D:
	    MOVLW	0b01011110
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_E:
	    MOVLW	0b01111001
	    MOVWF	PORTD, C
	    GOTO	LOOP
	    
OUTPUT_F:
	    MOVLW	0b01110001
	    MOVWF	PORTD, C
	    GOTO	LOOP	    
	    
	    END				 ;end of program



