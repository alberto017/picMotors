;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F785. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:                                                        *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required: P16F785.INC                                      *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;    In order to debug the 16F/HV785 with an ICD2, you will need a    *
;    special debug header (part AC162060) available from              *
;    http://microchipdirect.com/.  Note that if you are getting a     *
;    warning regarding the device id, it is likely that your jumper   *
;    wire configuration on this headerboard is not correct.  Refer to *
;    the 'Header Board Specification' DS51292M as well as the         *
;    datasheet for the 16F/HV785 to make sure your jumper settings    *
;    are correct.  For 16HV785 setting, use jumpers 2-3.  For the     *
;    16F785, use jumper settings 1-2.                                 *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************

    list        p=16f785       ; list directive to define processor
    #include    <p16f785.inc>  ; processor specific variable definitions

    __CONFIG _CP_OFF & _WDT_OFF & _BOR_OFF & _MCLRE_ON & _PWRTE_ON & _INTOSCIO & _IESO_OFF & _FCMEN_OFF

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for this part for additional information on the 
; configuration word.

;------------------------------------------------------------------------------
; Variable Definitions
;------------------------------------------------------------------------------
INT_VAR    UDATA
w_temp         res    1        ; variable used for context saving
status_temp    res    1        ; variable used for context saving

;------------------------------------------------------------------------------
; Reset Vector
;------------------------------------------------------------------------------
    CODE    0x0000            ; processor reset vector
    goto    start             ; When using debug header, first inst.
                              ; may be passed over by ICD2.  

;------------------------------------------------------------------------------
; Interrupt Service Routine
;------------------------------------------------------------------------------
INTERRUPT   CODE    0x0004

ISR                 ; Interrupt Service Routine

    movwf    w_temp            ; save off current W register contents
    movf     STATUS,w          ; move status register into W register
    movwf    status_temp       ; save off contents of STATUS register

    ; isr code can go here or be located as a call subroutine elsewhere

    movf    status_temp,w     ; retrieve copy of STATUS register
    movwf   STATUS            ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w          ; restore pre-isr W register contents
    retfie                    ; return from interrupt

MAIN_PROG   CODE   ; All code below is placed by the linker

start

    ; Your code goes here

;------------------------------------------------------------------------------
; This sample code causes Timer 0 to generate an interrupt.  Place a break-
; point in the interrupt service routine to observe the interrupt happen.  
;------------------------------------------------------------------------------

    banksel TMR0
    clrf TMR0    ; Clear Timer 0
    banksel INTCON
    MOVLW 0xA0
    MOVWF INTCON ; Set GIE, TMR0IE
    MOVLW 0xD0   ; Set int. clock, assign presc. to TMR0, prescaler 1:2
    errorlevel -302
    banksel OPTION_REG
    MOVWF OPTION_REG
    errorlevel +302
    
    ; The TMR0 value should change (not increment) after every instruction
    ; in this loop.  The timer will not necessarily increment because for 
    ; the 16F/HV785 the timer free-runs between single steps in debug mode
    ; with a 16F/HV785 header.  To observe a TMR0 overflow overflow, place 
    ; a breakpoint in the interrupt service routine and run to that 
    ; breakpoint.  

LOOP
    NOP
    GOTO LOOP

;------------------------------------------------------------------------------
; End of removable sample code
;------------------------------------------------------------------------------

    END                       ; directive 'end of program'
