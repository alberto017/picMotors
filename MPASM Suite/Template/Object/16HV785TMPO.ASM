;**********************************************************************
;   This file is a basic code template for code generation on the     *
;   on the  PIC16HV785. This file contains the basic code building    *
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
;    Files required: P16HV785.INC                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 16HV785:                                         *
;                                                                     *
;    Up to 12 channels of 10-bit A/D                                  *
;    2-Phase PWM with Asynchronous feedback via Comparators           *
;    2 Op amps with all input/output available externally             *
;    2 High-speed Comparators connected to 2-phase PWM                *
;    Bandgap Voltage Reference and Capture/Compare/PWM (CCP) module   *
;    8 MHz internal oscillator with software controlled clock divides *
;    Software selectable BOR                                          *
;    Data EEPROM                                                      *
;    Internal Shunt Regulator for High Voltage Vdd Support            *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes: 3/26/2007                                                 *
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
;    The difference between the 16F785 and the 16HV785 is the         *
;    addition of a permanent internal 5 Volt (nominal) shunt          *
;    regulator in parallel with the Vdd pin.  This eliminates the     *
;    need for an external voltage regulator in systems sourced by an  *
;    unregulated supply.  All external devices connected directly to  *
;    the Vdd pin will share the regulated supply voltage and          *
;    contribute to the total Vdd supply current.  For information     *
;    more information on the regulator, see chapter 16 of the         *
;    datasheet for the 16HV785.                                       *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Revision History:                                                *
;                                                                     *
;**********************************************************************


    LIST        P=16HV785       ; list directive to define processor
    #include    <P16HV785.INC>  ; processor specific variable definitions

    __CONFIG _CP_OFF & _WDT_OFF & _BOR_OFF & _MCLRE_ON & _PWRTE_ON & _INTOSCIO & _IESO_OFF & _FCMEN_OFF

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for this part for additional information on the 
; configuration word.

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0,1,2, and 3.  Each Bank contains 
; Special Function Registers, General Purpose Registers, and Access RAM at
; the locations below:  
;
;           SFR (not continuous)  GPR          ACCESS
; Bank 0    0x00-0x1F             0x20-0x7F    0x70-0x7F
; Bank 1    0x80-0x9F             0xA0-0xBF    0xF0-0xFF
; Bank 2    0x100-0x11D           NA           0x170-0x17F
; Bank 3    0x180-0x18C           NA           0x1F0-0x1FF
;
;------------------------------------------------------------------------------

; UDATA declares a section of uninitialized data
VARIABLES   UDATA           ; VARIABLES is the name of the section of memory
myvar1      RES     1       ; uninitialized data, placed by linker in GPR's. 
myvar2      RES     1

; UDATA_SHR declares a section of shared (across all banks) uninitialized data
INT_VAR     UDATA_SHR       ; INT_VAR is the section name in Access RAM
w_temp      RES     1       ; variable used for context saving 
status_temp RES     1       ; variable used for context saving

;------------------------------------------------------------------------------
; EEPROM INITIALIZATION
;
; The 16HV785 has 256 bytes of non-volatile EEPROM, starting at address 0x2100
; 
;------------------------------------------------------------------------------

eedata CODE  ; 'eedata' is the EEPROM section from the linker script
    DE    0x00, 0x01, 0x02, 0x03

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------
    CODE    0x0000          ; processor reset vector
    goto    START           ; When using debug header, first inst.
                            ; may be passed over by ICD2.  

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------
INTERRUPT   CODE    0x0004

ISR                 ; Interrupt Service Routine

    movwf    w_temp            ; save off current W register contents
    movf     STATUS,w          ; move status register into W register
    movwf    status_temp       ; save off contents of STATUS register

;------------------------------------------------------------------------------
; SAMPLE INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

;   If the interrupt came from the timer, execute the TMR0 interrupt 
;   service routine. This may be removed in addition to the sample 
;   program below.
    BTFSC   INTCON, T0IF         ; Uncomment this line to test sample code 
    CALL    TMR0_ISR             ; Uncomment this line to test sample code     

;------------------------------------------------------------------------------
; END OF SAMPLE INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

    movf    status_temp,w     ; retrieve copy of STATUS register
    movwf   STATUS            ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w          ; restore pre-isr W register contents
    retfie                    ; return from interrupt

MAIN_PROG   CODE    ; All code below is placed by the linker

START

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
    ; with a 16hv785 header.  To observe a TMR0 overflow overflow, place 
    ; a breakpoint in the interrupt service routine and run to that 
    ; breakpoint.  

LOOP
    NOP
    GOTO LOOP

; TIMER 0 Interrupt routine clears the TMR0 interrupt flag.  
TMR0_ISR                           ; 
    BANKSEL INTCON           ; 
    BCF     INTCON, T0IF     ; Clear TMR0 Interrupt Flag
    RETURN                   ; Return from subroutine

;------------------------------------------------------------------------------
; End of removable sample code
;------------------------------------------------------------------------------

    END                       ; directive 'end of program'
