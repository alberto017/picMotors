;**********************************************************************
;   This file is a basic code template for code generation on the     *
;   on the  PIC16F610. This file contains the basic code building     *
;   blocks to build upon.                                             *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler.                                        *
;                                                                     *
;   Refer to the respective data sheet for additional                 *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:         xxx.asm                                        *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F610.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 16F610:                                          *
;                                                                     *
;    Flash Program Memory                                             *
;    Internal 4/8MHz oscillator                                       *
;    Comparator with hysterisis (user configurable)                   *
;    Mid-Range core with 35 Instruction, 8 stack levels               *
;    25 mA Source/Sink current I/O                                    *
;    One 8-bit Timer (TMR0)                                           *
;    One 16-bit Timer (TMR1)                                          *
;    Watchdog Timer (WDT)                                             *
;    Enhanced Power-On/Off-Reset                                      *
;    Brown-Out Reset (BOR)                                            *
;    In Circuit Serial Programming (ICSP)                             *
;    Wide Operating Voltage (2.0V - 5.5 V)                            *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes: 03/01/2007                                                *
;                                                                     *
;    In order to debug the 16F610 with an ICD2, you will need a       *
;    special debug header (part AC162083) available from              *
;    http://microchipdirect.com/.  Refer to the 'Header Board         *
;    Specification' DS51292M as well the datasheet for the 16F610 to  *
;    make sure your jumper settings are correct.                      *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Revision History:                                                *
;                                                                     *
;**********************************************************************

     LIST      p=16F610            ; list directive to define processor
     #INCLUDE <p16F610.inc>        ; processor specific variable definitions

     __CONFIG   _CP_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _IOSCFS_8MHZ

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.

;------------------------------------------------------------------------------
; Variable Definitions
;
; Available General Purpose Memory divided into Bank 0 and Bank 1.  In 
; Bank 0 General Purpose Registers range from 0x40-0x7F.   In Bank 1 the only
; General Purpose Registers available are Access Bank Registers.  These are 
; actually shared between Bank 0 and Bank 1. The Access Bank Registers  
; range from 0x70-0x7F in Bank 0 address space and overlap the General Purpose
; Register address space.  The Access Bank Registers also range from 0xF0 to 
; 0xFF in Bank 1 address space.  
;
;------------------------------------------------------------------------------

    CBLOCK 0x40 ;Define GPR variable register locations
        myvar1 ;address 0x40
        myvar2 ;address 0x41
        myvar3 ;address 0x42
    ENDC

w_temp        EQU     0x7E        ; variable used for context saving 
status_temp   EQU     0x7F        ; variable used for context saving

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET     ORG     0x000                  ; processor reset vector
          GOTO    START                   ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISR       ORG     0x004                  ; interrupt vector location

;         Context saving for ISR
          MOVWF   w_temp            ; save off current W register contents
          MOVF    STATUS,w          ; move status register into W register
          MOVWF   status_temp       ; save off contents of STATUS register

;------------------------------------------------------------------------------
; SAMPLE INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

;         If the interrupt came from the timer, execute the TMR0 interrupt 
;         service routine. This may be removed in addition to the sample 
;         program below.
          BTFSC   INTCON, T0IF         ; Uncomment this line to test sample code 
          CALL    TMR0_ISR             ; Uncomment this line to test sample code     

;------------------------------------------------------------------------------
; END OF SAMPLE INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

;         Restore context before returning from interrupt
          MOVF    status_temp,w     ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   w_temp,f
          SWAPF   w_temp,w          ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

START

;------------------------------------------------------------------------------
; SET OSCILLATOR TO FACTORY FREQUENCY AND CLEAR GPR's
;------------------------------------------------------------------------------

          ERRORLEVEL -302     ; disable warning accessing register not in bank 0
          BANKSEL OSCTUNE     ; select bank 1 using mpasm macro 
          MOVLW   0x00        ; set oscillator to factory calibrated frequency 
          MOVWF   OSCTUNE
          BANKSEL STATUS      ; select bank 0 using mpasm macro... STATUS is arbitrary
          ERRORLEVEL +302     ; re-enable warning accessing register not in bank 0
CLEAR_RAM                     ; code sequence initializes all GPR's to 0x00
                              ; unnecessary if initalizing all variables before use
          MOVLW   0x20        ; initialize pointer
          MOVWF   FSR         ; to RAM
NEXT  
          CLRF    INDF        ; clear INDF register
          INCF    FSR, F      ; inc pointer
          BTFSS   FSR,7       ; all done?
          GOTO    NEXT        ; no clear NEXT
CONTINUE                      ; yes CONTINUE
          NOP

;------------------------------------------------------------------------------
; SAMPLE PROGRAM... REMAINDER OF YOUR PROGRAM GOES HERE
;------------------------------------------------------------------------------

; This is some example code that uses the timer 0 interrupt to branch to the 
; Interrupt Service Routine.  The TMR0 is cleared, the interrupts are enabled, 
; and the TMR0 is configured.  GOTO LOOP stops the PC to wait for the interrupt. 
          CLRF    TMR0             ; Clear Timer 0
          BSF     INTCON, GIE      ; Enable Interrupts
          BSF     INTCON, PEIE     ; 
          BSF     INTCON, T0IE     ; 
          ERRORLEVEL -302          ; Disable banking message
          BANKSEL OPTION_REG       ; Configure Option Register and TMR0
          BSF     OPTION_REG, PSA  ; 
          BCF     OPTION_REG, T0CS ; 
          ERRORLEVEL +302          ; Enable banking message
LOOP      GOTO    LOOP             ; Hold program counter here

; TIMER 0 Interrupt routine clears the TMR0 interrupt flag.  
TMR0_ISR                           ; 
          BANKSEL INTCON           ; 
          BCF     INTCON, T0IF     ; Clear TMR0 Interrupt Flag
          RETURN                   ; Return from subroutine

;------------------------------------------------------------------------------
; END OF SAMPLE PROGRAM
;------------------------------------------------------------------------------

          END
