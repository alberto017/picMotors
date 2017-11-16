;******************************************************************************
;   This file is a basic relocatable code template for code generation        *
;   on the  PIC12HV615. This file contains the basic code                     *
;   building blocks to build upon.                                            *
;                                                                             *
;   If interrupts are not used all code presented between the ORG             *
;   0x004 directive and the label main can be removed. In addition            *
;   the variable assignments for 'w_temp' and 'status_temp' can               *
;   be removed. If the internal RC oscillator is not implemented              *
;   then the first four instructions following the label 'main' can           *
;   be removed.  The TMR0 sample code may be uncommented for test.            *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on             *
;   features of the assembler.                                                *
;                                                                             *
;   Refer to the respective data sheet for additional                         *
;   information on the instruction set.                                       *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:         xxx.asm                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: P12HV615.INC                                             *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 12HV615:                                                 *
;                                                                             *
;    Flash Program Memory                                                     *
;    Internal 4/8MHz Oscillator                                               *
;    Comparator with hysterisis (user configurable)                           *
;    Mid-Range core with 35 instruction, 8 stack levels                       *
;    25 mA Source/Sink Current I/O                                            *
;    Two 8-bit Timers (TMR0/TMR2)                                             *
;    One 16-bit Timer (TMR1)                                                  *
;    Watchdog Timer (WDT)                                                     *
;    Enhanced Power-On/Off-Reset                                              *
;    Brown-Out Reset (BOR)                                                    *
;    In Circuit Serial Programming (ICSP)                                     *
;    Enhanced Capture Compare PWM (Pulse Width Modulation)                    *
;    Wide Operating Voltage (2.0V - User Defined Max)                         *
;    Internal Shunt Regulator for High Voltage Vdd Support                    *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes: 2/28/2007                                                         *
;                                                                             *
;    In order to debug the 12HV615 with an ICD2, you will need a              *
;    special debug header (part AC162083) available from                      *
;    http://microchipdirect.com/.  Refer to the 'Header Board                 *
;    Specification' DS51292M as well the datasheet for the 12HV615 to         *
;    make sure your jumper settings are correct.                              *
;                                                                             *
;    The biggest difference between the 12F615 and the 12HV615 is the         *
;    addition of a permanent internal 5 Volt (nominal) shunt                  *
;    regulator in parallel with the Vdd pin.  This eliminates the             *
;    need for an external voltage regulator in systems sourced by an          *
;    unregulated supply.  All external devices connected directly to          *
;    the Vdd pin will share the regulated supply voltage and                  *
;    contribute to the total Vdd supply current.  For information             *
;    more information on the regulator, see chapter 12 of the                 *
;    datasheet for the 12HV615.                                               *
;                                                                             *
;                                                                             *
;                                                                             *
;******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      p=12HV615              ; list directive to define processor
     #INCLUDE <P12HV615.INC>          ; processor specific variable definitions

;------------------------------------------------------------------------------
;
; CONFIGURATION WORD SETUP
;
; The 'CONFIG' directive is used to embed the configuration word within the 
; .asm file. The lables following the directive are located in the respective 
; .inc file.  See the data sheet for additional information on configuration 
; word settings.
;
;------------------------------------------------------------------------------

     __CONFIG   _CP_OFF & _BOR_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT

;------------------------------------------------------------------------------
; VARIABLE DEFINITIONS
;------------------------------------------------------------------------------

; Example of using GPR (SEPERATE) Uninitialized Data Section
GPR_VAR           UDATA           
MYVAR1         RES        1      ; User var linker places in seperate GPR's
MYVAR2         RES        1      ; User var linker places in seperate GPR's
MYVAR3         RES        1      ; User var linker places in seperate GPR's

; Example of using Shared (OVERLAPPING) Uninitialized Data Section
INT_VAR           UDATA_SHR       
W_TEMP         RES        1      ; Interrupt Context Saving W
STATUS_TEMP    RES        1      ; Interrupt Context Saving STATUS
MYVAR4         RES        1      ; User var linker places in overlapping GPR's
MYVAR5         RES        1      ; User var linker places in overlapping GPR's
MYVAR6         RES        1      ; User var linker places in overlapping GPR's

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

START             CODE    0x0000      ; processor reset vector
          goto    START               ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECTOR        CODE   0x0004     ; Interrupt Vector Location

INTERRUPT                           ; Relocatable Interrupt Service Routine

;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          MOVF    STATUS,W          ; move status register into W register
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register

          ; Place ISR here 

;         Restore context before returning from interrupt
          MOVF    STATUS_TEMP, W    ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   W_TEMP, F
          SWAPF   W_TEMP, W         ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt


;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

MAIN_PROG CODE                      ; main program code is placed by linker

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $

          END
