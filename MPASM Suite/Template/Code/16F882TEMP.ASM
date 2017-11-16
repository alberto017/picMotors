;**********************************************************************
;   This file is a basic code template for code generation on the     *
;   on the  PIC16F882. This file contains the basic code building     *
;   blocks to build upon.                                             *
;                                                                     *
;   If interrupts are not used the interrupt service routines may be  *
;   removed.  In addition, the sample program and sample code within  *
;   the interrupt service routine is merely there to demonstrate      *
;   interrupts happening, and may be removed.  If the internal RC     *
;   oscillator is not implemented then the oscillator will not need   *
;   set to the factory frequency and this code may also be removed.   *
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
;    Files Required: P16F882.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 16F882:                                          *
;                                                                     *
;    2K Words Flash Program Memory                                    *
;    128 Bytes Data Memory (RAM)                                      *
;    Internal 8MHz oscillator                                         *
;    Comparator Module                                                *
;    Mid-Range core with 35 Instruction, 8 stack levels               *
;    25 mA Source/Sink current I/O                                    *
;    Two 8-bit Timers (TMR0 & TMR2)                                   *
;    One 16-bit Timer (TMR1) with Gate Enable Feature                 *
;    Enhanced Low Current Watchdog Timer (WDT)                        *
;    Brown-Out Reset (BOR)                                            *
;    2K Words of EEPROM                                               *
;    In Circuit Serial Programming (ICSP)                             *
;    Wide Operating Voltage (2.0V - 5.5 V)                            *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes: 03/14/2007                                                *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Revision History:                                                *
;                                                                     *
;**********************************************************************

     LIST      p=16F882            ; list directive to define processor
     #INCLUDE <p16F882.inc>        ; processor specific variable definitions

     __CONFIG _CONFIG1, _LVP_OFF & _FCMEN_OFF & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT 

     __CONFIG _CONFIG2, _WRT_OFF & _BOR40V

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.
; Note that the _DEBUG_ON is changed by selecting a debugger or programmer.  
; There isn't much advantage to setting it in the code.  

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory (also RAM) is divided into 4 Banks.  Special Function 
; Registers, General Purpose Registers, and Access Registers are shown below:
;
;           Bank 0       Bank 1       Bank 2         Bank 3
; SFR       0x00-0x1F    0x80-0x9F    0x100-0x10F    0x180-0x18D
; GPR       0x20-0x7F    0xA0-0xBF    -              -
; ACCESS    0x70-0x7F    0xF0-0xFF    0x170-0x17F    0x1F0-0x1FF
;
; The Access Bank Registers are mutual across each address space.  
;
;------------------------------------------------------------------------------

    CBLOCK 0x20 ;Define GPR variable register locations
        myvar1  ;address 0x20
        myvar2  ;address 0x21
        myvar3  ;address 0x22
    ENDC

w_temp        EQU     0x7E        ; variable used for interrupt context saving 
status_temp   EQU     0x7F        ; variable used for interrupt context saving

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 16F882 has 128 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

          ORG   0x2100
          DE    0x00, 0x01, 0x02, 0x03

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET     ORG     0x000                  ; processor reset vector
          GOTO    START                  ; go to beginning of program

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
          BTFSS   FSR, 7      ; all done?
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
