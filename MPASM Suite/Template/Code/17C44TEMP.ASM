;**********************************************************************
;   This file is a basic code template  for assembly code generation  *
;   on the PIC17C44. This file contains the basic code                *
;   building blocks to build upon.                                    *  
;                                                                     *
;   If interrupts are not used all code presented for that interrupt  *
;   can be removed or commented out with a semicolon. Also the        *                         
;   interrupt code is structured for the microcontroller mode of      *
;   operation (up to 8K words of program memory) If desiring to use   *
;   this template for the extended microcontroller or microprocessor  *
;   modes (up to 64K words of program memory) the call or goto        *
;   instructions may need to be changed to the lcall or computed      *
;   long goto instructions.                                           *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;   Template file assembled with MPASMWIN V2.80.12                    *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P17C44.INC                                       *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************

	list p=17c44, f=INHX32 ;directive to define processor and file format
	#include <p17c44.inc>          ; processor specific variable definitions
	
	__CONFIG   _XT_OSC & _WDT_OFF & _MC_MODE

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.




;*******    RAM EQUATES
TEMP_WREG       EQU     0x1A
TEMP_ALUSTA     EQU     0x1B
TEMP_BSR        EQU     0x1C
TEMP_PCLATH     EQU     0x1D




;*******    MACROS
PUSH        MACRO                 ;macro for saving registers
            movpf   WREG,TEMP_WREG
            movpf   ALUSTA,TEMP_ALUSTA
            movpf   BSR,TEMP_BSR
            movpf   PCLATH,TEMP_PCLATH
            ENDM


POP         MACRO                 ;macro for restoring registers
            movfp   TEMP_PCLATH,PCLATH
            movfp   TEMP_BSR,BSR
            movfp   TEMP_ALUSTA,ALUSTA
            movfp   TEMP_WREG,WREG
            ENDM

	


;**********************************************************************
                ORG    0x000
;you may want to clear PCLATH and ALUSTA registers here      
                goto   start	


;************   INT PIN INTERRUPT VECTOR
                ORG    0x008
                PUSH              ;save specific registers
                goto   intpin_isr_handler
               

;************   TIMER0 INTERRUPT VECTOR
                ORG    0x010
                PUSH	          ;save specific registers
                goto   timer0_isr_handler
               

;************   T0CKI PIN INTERRUPT VECTOR
                ORG    0x018
                PUSH              ;save specific registers
                goto   t0cki_isr_handler
               

;************   PERIPHERAL INTERRUPT VECTOR
                ORG		0x020
                PUSH              ;save specific registers
; isr code can go here or be located as a call subroutine elsewhere
                POP               ;restore specific registers
                retfie            ;return from interrupt




;************************************************************************
;*****	MAIN PROGRAM *****
start		
              NOP                 ;first line of code (example)

; main program code goes here









 
;****** INT PIN INTERRUPT SERVICE HANDLER
intpin_isr_handler

;isr code goes here


                POP               ;restore registers
                retfie            ;return from interrupt



;****** TIMER0 INTERRUPT SERVICE HANDLER
timer0_isr_handler

;isr code goes here

                
                POP               ;restore registers
                retfie            ;return from interrupt



;****** T0CKI INTERRUPT SERVICE HANDLER
t0cki_isr_handler

;isr code goes here


                POP               ;restore registers
                retfie            ;return from interrupt

                END	              ;required directive
