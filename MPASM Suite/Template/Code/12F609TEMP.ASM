;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC12F609. This file contains the basic code               *
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
;    Filename:        xxx.asm                                         *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P12F609.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 12F609                                           *
;                                                                     *
;    Flash Program Memory                                             *
;    Internal 4/8MHz oscillator (software selectable)                 *
;    Comparator with hysterisis (user configurable)                   *
;    Mid-Range core with 35 Instruction, 8 Stack Levels               *
;    25mA Source/Sink current I/O                                     *
;    One 8-bit Timer (TMR0)                                           *
;    One 16-bit Timer (TMR1)                                          *
;    Watchdog Timer (WDT)                                             *
;    Enhanced Power-On/Off-Reset                                      *
;    Brown-Out Reset (BOR)                                            *
;    In Circuit Serial Programming (ICSP)                             *
;    Wide Operating Voltage (2.0V – 5.5V)                             *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes: 2/28/2007                                                 *
;                                                                     *
;    In order to debug the 12F609 with an ICD2, you will need a       *
;    special debug header (part AC162083) available from              *
;    http://microchipdirect.com/.  Refer to the 'Header Board         *
;    Specification' DS51292M as well the datasheet for the 12F609 to  *
;    make sure your jumper settings are correct.                      *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;   Revision History:                                                 *
;                                                                     *
;**********************************************************************


    list        p=12F609       ; list directive to define processor
    #include    <p12F609.INC>  ; processor specific variable definitions

    __CONFIG _BOD_OFF & _IOSCFS_8MHZ & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for this part for additional information on the 
; configuration word.

;------------------------------------------------------------------------------
; Variable Definitions
;
; Available General Purpose Memory divided into Bank 0 and Bank 1.  In 
; Bank 0 General Purpose Registers range from 0x40-0x7F.   In Bank 1 the only
; General Purpose Registers available are Access Bank Registers.  These are 
; actually shared between Bank 0 and Bank 1. The Access Bank Registers  
; range from 0x70-0x7F in Bank 0 address space, which is also 0xF0-0xFF in
; Bank 1 address space.  
;------------------------------------------------------------------------------

    CBLOCK 0x40 ;Define GPR variable register locations
        myvar1 ;address 0x40
        myvar2 ;address 0x41
        myvar3 ;address 0x42
    ENDC

w_temp         EQU    0x7E        ; variable used for interrupt context saving
status_temp    EQU    0x7F        ; variable used for interrupt context saving

;------------------------------------------------------------------------------
; Reset Vector
;------------------------------------------------------------------------------
    ORG     0x000             ; processor reset vector
    goto    START             ; When using debug header, ICD2 may not stop
                              ; on instruction 0 during reset.

;------------------------------------------------------------------------------
; Interrupt Service Routine
;------------------------------------------------------------------------------

    ORG     0x004             ; interrupt vector location
    movwf   w_temp            ; save off current W register contents
    movf    STATUS,w          ; move status register into W register
    movwf   status_temp      ; save off contents of STATUS register



    ; ISR code can go here or be located as a called subroutine elsewhere

    ; Clear the Timer 0 Interrupt Flag from the Sample Code
    BCF    INTCON, T0IF       ; This line may be removed. 



    movf    status_temp,w     ; retrieve copy of STATUS register
    movwf   STATUS            ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w          ; restore pre-isr W register contents
    retfie                    ; return from interrupt

START

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
    
    ; The TMR0 value will change after every instruction in this loop.  
    ; However, it will not necessarily increment when using the ICD2 as
    ; a debugger because the timer free-runs between single steps in 
    ; debug mode with the 12F609 header.  
    ;
    ; If using the Simulator, be sure that the oscillator frequency 
    ; (Q-cycle frequency) is set to the appropriate value in the Debugger >
    ; Settings > Osc/Trace tab to measure the time between interrupts with
    ; the stopwatch.  
    ; 
    ; To observe a TMR0 overflow place a breakpoint in the interrupt 
    ; service routine and run to the breakpoint.  Interrupts should happen
    ; every 512 instruction cycles.  Note that single stepping into an 
    ; interrupt service routine is not allowed by the ICD2 when used as 
    ; a debugger.  One must run (F9) to a breakpoint into an interrupt 
    ; service routine.  

LOOP
    NOP
    GOTO LOOP

;------------------------------------------------------------------------------
; End of removable sample code
;------------------------------------------------------------------------------

    END                       ; directive 'end of program'