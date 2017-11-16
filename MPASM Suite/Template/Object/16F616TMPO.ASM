;   This file is a basic relocatable code template for code generation*
;   on the PIC16F616. This file contains the basic code               *
;   building blocks to build upon.                                    *
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
;    Files required: P16F616.INC                                      *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Revision History:                                                *
;                                                                     *
;**********************************************************************

     list      p=16F616            ; list directive to define processor
     #include <p16F616.inc>        ; processor specific variable definitions

     __CONFIG   _CP_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT

; '__CONFIG' directive is used to embed configuration word within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for additional information on configuration word settings.

;***** VARIABLE DEFINITIONS


;***** VARIABLE DEFINITIONS (examples)

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR     
w_temp      RES     1       ; variable used for context saving 
status_temp RES     1       ; variable used for context saving

;**********************************************************************
START     CODE    0x0000                 ; processor reset vector
          goto    MAIN                   ; go to beginning of program

ISR       CODE    0x0004                 ; interrupt vector location

INTERRUPT     

;         Context saving for ISR
          MOVWF   w_temp            ; save off current W register contents
          MOVF    STATUS,w          ; move status register into W register
          MOVWF   status_temp       ; save off contents of STATUS register

;         INSERT INTERRUPT CODE HERE

;;         -----SAMPLE CODE----- if the interrupt came from the timer, execute the
;;         TMR0 interrupt service routine. This is not necessary and can be deleted. 
;          BTFSC   INTCON, T0IF         ; Uncomment this line to test sample code 
;          CALL    TMR0_ISR             ; Uncomment this line to test sample code     

;         Restore context before returning from interrupt
          MOVF    status_temp,w     ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   w_temp,f
          SWAPF   w_temp,w          ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt
;**********************************************************************

MAIN_PROG CODE                           ; relocatable section

MAIN

; SET OSCILLATOR TO FACTORY FREQUENCY AND CLEAR GPR's 

          errorlevel -302     ; disable warning accessing register not in bank 0
          banksel OSCTUNE     ; select bank 1 using mpasm macro 
          movlw   0x00        ; set oscillator to factory calibrated frequency 
          movwf   OSCTUNE
          banksel STATUS      ; select bank 0 using mpasm macro... STATUS is arbitrary
          errorlevel +302     ; re-enable warning accessing register not in bank 0
clear_ram                     ; code sequence initializes all GPR's to 0x00
                              ; unnecessary if initalizing all variables before use
          movlw   0x20        ; initialize pointer
          movwf   FSR         ; to RAM
next  
          clrf    INDF        ; clear INDF register
          incf    FSR, F      ; inc pointer
          btfss   FSR,7       ; all done?
          goto    next        ; no clear next
continue                      ; yes continue
          nop

;REMAINDER OF YOUR PROGRAM GOES HERE

;----SAMPLE CODE-----

;; This is some example code that uses the timer 0 interrupt to branch to the 
;; Interrupt Service Routine.  The TMR0 is cleared, the interrupts are enabled, 
;; and the TMR0 is configured.  GOTO LOOP stops the PC to wait for the interrupt. 
;          CLRF    TMR0             ; Uncomment this line to test sample code
;          BSF     INTCON, GIE      ; Uncomment this line to test sample code
;          BSF     INTCON, PEIE     ; Uncomment this line to test sample code
;          BSF     INTCON, T0IE     ; Uncomment this line to test sample code
;          errorlevel -302          ; Uncomment this line to test sample code
;          BANKSEL OPTION_REG       ; Uncomment this line to test sample code
;          BSF     OPTION_REG, PSA  ; Uncomment this line to test sample code
;          BCF     OPTION_REG, T0CS ; Uncomment this line to test sample code
;          errorlevel +302          ; Uncomment this line to test sample code
;LOOP      GOTO    LOOP             ; Uncomment this line to test sample code
;
;; TIMER 0 Interrupt routine clears the TMR0 interrupt flag.  
;TMR0_ISR                           ; Uncomment this line to test sample code
;          BANKSEL INTCON           ; Uncomment this line to test sample code
;          BCF     INTCON, T0IF     ; Uncomment this line to test sample code
;          RETURN                   ; Uncomment this line to test sample code
          END
