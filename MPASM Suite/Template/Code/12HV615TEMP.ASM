;**********************************************************************
;   This file is a basic relocatable code template for code generation*
;   on the  PIC12HV615. This file contains the basic code             *
;   building blocks to build upon.                                    *
;                                                                     *
;   If interrupts are not used all code relevant to the interrupts    *
;   may be erased.  In addition, the commented sample code that       *
;   sets up a TMR0 interrupt may be removed by the user or            *
;   uncommented for testing.                                          *
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
;    Files Required: P12HV615.INC                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 12HV615:                                         *
;                                                                     *
;    Flash Program Memory                                             *
;    Internal 4/8MHz Oscillator                                       *
;    Comparator with hysterisis (user configurable)                   *
;    Mid-Range core with 35 instruction, 8 stack levels               *
;    25 mA Source/Sink Current I/O                                    *
;    Two 8-bit Timers (TMR0/TMR2)                                     *
;    One 16-bit Timer (TMR1)                                          *
;    Watchdog Timer (WDT)                                             *
;    Enhanced Power-On/Off-Reset                                      *
;    Brown-Out Reset (BOR)                                            *
;    In Circuit Serial Programming (ICSP)                             *
;    Enhanced Capture Compare PWM (Pulse Width Modulation)            *
;    Wide Operating Voltage (2.0V - User Defined Max)                 *
;    Internal Shunt Regulator for High Voltage Vdd Support            *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes: 03/01/2007                                                *
;                                                                     *
;    In order to debug the 12HV615 with an ICD2, you will need a      *
;    special debug header (part AC162083) available from              *
;    http://microchipdirect.com/.  Refer to the 'Header Board         *
;    Specification' DS51292M as well the datasheet for the 12HV615 to *
;    make sure your jumper settings are correct.                      *
;                                                                     *
;    The biggest difference between the 12F615 and the 12HV615 is the *
;    addition of a permanent internal 5 Volt (nominal) shunt          *
;    regulator in parallel with the Vdd pin.  This eliminates the     *
;    need for an external voltage regulator in systems sourced by an  *
;    unregulated supply.  All external devices connected directly to  *
;    the Vdd pin will share the regulated supply voltage and          *
;    contribute to the total Vdd supply current.  For information     *
;    more information on the regulator, see chapter 12 of the         *
;    datasheet for the 12HV615.                                       *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Revision History:                                                *
;                                                                     *
;**********************************************************************

     list      p=12HV615            ; list directive to define processor
     #include <p12HV615.inc>        ; processor specific variable definitions

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
; range from 0x70-0x7F in Bank 0 address space, which is also 0xF0-0xFF in
; Bank 1 address space.  
;
;------------------------------------------------------------------------------

    CBLOCK 0x40 ;Define GPR variable register locations
        myvar1 ;address 0x40
        myvar2 ;address 0x41
        myvar3 ;address 0x42
    ENDC

w_temp        EQU     0x7E        ; variable used for interrupt context saving 
status_temp   EQU     0x7F        ; variable used for interrupt context saving

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

START     ORG     0x000             ; processor reset vector
          goto    MAIN              ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISR       ORG     0x004             ; interrupt vector location
     
;         Context saving for ISR
          MOVWF   w_temp            ; save off current W register contents
          MOVF    STATUS,w          ; move status register into W register
          MOVWF   status_temp       ; save off contents of STATUS register

;;         INSERT INTERRUPT CODE HERE
;
;;         -----SAMPLE CODE----- if the interrupt came from the timer, execute 
;;         the TMR0 interrupt service routine. 
;          BTFSC   INTCON, T0IF ; Uncomment this line to test sample code 
;          CALL    TMR0_ISR     ; Uncomment this line to test sample code     

;         Restore context before returning from interrupt
          MOVF    status_temp,w   ; retrieve copy of STATUS register
          MOVWF   STATUS          ; restore pre-isr STATUS register contents
          SWAPF   w_temp,f
          SWAPF   w_temp,w        ; restore pre-isr W register contents
          RETFIE                  ; return from interrupt

MAIN

; SET OSCILLATOR TO FACTORY FREQUENCY AND CLEAR GPR's 

          errorlevel -302     ; disable warning accessing register not in bank 0
          banksel OSCTUNE     ; select bank 1 using mpasm macro 
          movlw   0x00        ; set oscillator to factory calibrated frequency 
          movwf   OSCTUNE
          banksel GPIO        ; select bank 0 using mpasm macro 
          errorlevel +302     ; re-enable warning accessing register not in bank 0
clear_ram                     ; code sequence initializes all GPR's to 0x00
                              ; unnecessary if initalizing all variables before use
          movlw   0x40        ; initialize pointer
          movwf   FSR         ; to RAM
next  
          clrf    INDF        ; clear INDF register
          incf    FSR, F      ; inc pointer
          btfss   FSR,7       ; all done?
          goto    next        ; no clear next
continue                      ; yes continue
          nop

;------------------------------------------------------------------------------
; SAMPLE PROGRAM... REMAINDER OF YOUR PROGRAM GOES HERE
;------------------------------------------------------------------------------

;;----SAMPLE CODE-----
;
;; This is some example code that uses the timer 0 interrupt to branch to the 
;; Interrupt Service Routine.  This code is not necessary.
;          CLRF    TMR0              ; Uncomment this line to test sample code
;          BSF     INTCON, GIE       ; Uncomment this line to test sample code
;          BSF     INTCON, PEIE      ; Uncomment this line to test sample code
;          BSF     INTCON, T0IE      ; Uncomment this line to test sample code
;          errorlevel -302           ; Uncomment this line to test sample code
;          BANKSEL OPTION_REG        ; Uncomment this line to test sample code
;          BSF     OPTION_REG, PSA   ; Uncomment this line to test sample code
;          BCF     OPTION_REG, T0CS  ; Uncomment this line to test sample code
;          errorlevel +302           ; Uncomment this line to test sample code
;LOOP      GOTO    LOOP              ; Uncomment this line to test sample code
;
;;TIMER 0 Interrupt routine
;TMR0_ISR                            ; Uncomment this line to test sample code
;          BANKSEL INTCON            ; Uncomment this line to test sample code
;          BCF     INTCON, T0IF      ; Uncomment this line to test sample code
;          RETURN                    ; Uncomment this line to test sample code

          END
