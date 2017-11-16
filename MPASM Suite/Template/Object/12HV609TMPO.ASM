;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC12HV609. This file contains the              *
;   basic code building blocks to build upon.                         *
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
;    Files required: P12HV609.INC                                     *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Features of the 12HV609                                          *
;                                                                     *
;    Internal Shunt Regulator for High Voltage Vdd Support            *
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
;
;    The biggest difference between the 12F609 and the 12HV609 is the *
;    addition of a permanent internal 5 Volt (nominal) shunt          *
;    regulator in parallel with the Vdd pin.  This eliminates the     *
;    need for an external voltage regulator in systems sourced by an  *
;    unregulated supply.  All external devices connected directly to  *
;    the Vdd pin will share the regulated supply voltage and          *
;    contribute to the total Vdd supply current.  For information     *
;    more information on the regulator, see chapter 12 of the         *
;    datasheet for the 12HV609.                                       *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;   Revision History:                                                 *
;                                                                     *
;**********************************************************************


    list        p=12HV609       ; list directive to define processor
    #include    <p12HV609.INC>  ; processor specific variable definitions

    __CONFIG _BOD_OFF & _IOSCFS_8MHZ & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See data sheet for this part for additional information on the 
; configuration word.

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;
; Available General Purpose Memory divided into Bank 0 and Bank 1.  In 
; Bank 0 General Purpose Registers range from 0x40-0x7F.   In Bank 1 the only
; General Purpose Registers available are Access Bank Registers.  These are 
; actually shared between Bank 0 and Bank 1. The Access Bank Registers  
; range from 0x70-0x7F in Bank 0 address space, which is also 0xF0-0xFF in
; Bank 1 address space.  
;------------------------------------------------------------------------------

; UDATA declares a section of uninitialized data
VARIABLES   UDATA           ; VARIABLES is the name of the section of memory
myvar1      RES     1       ; uninitialized data, placed by linker in GPR's. 
myvar2      RES     1

; UDATA_SHR declares a section of shared (across all banks) uninitialized data
INT_VAR         UDATA_SHR       ; INT_VAR is the name of the section in Access RAM
w_temp          RES     1       ; variable used for context saving 
status_temp     RES     1       ; variable used for context saving

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET_VECTOR    CODE   0x0000
    goto    START             ; When using debug header, ICD2 may not stop
                              ; on instruction 0 during reset.

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECTOR      CODE   0x0004 ; Interrupt Vector Location

INTERRUPT                     ; Relocatable Interrupt Service Routine

    movwf   w_temp            ; save off current W register contents
    movf    STATUS,w          ; move status register into W register
    movwf   status_temp       ; save off contents of STATUS register

    ; ISR code can go here or be located as a called subroutine elsewhere

    movf    status_temp,w     ; retrieve copy of STATUS register
    movwf   STATUS            ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w          ; restore pre-isr W register contents
    retfie                    ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

MAIN    CODE

START                         

LOOP
    NOP
    GOTO LOOP


    END                       ; directive 'end of program'