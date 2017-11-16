;******************************************************************************
;   This file is a basic code template for code generation on the             *
;   PIC12CE673. This file contains the basic code building blocks to build    *
;   upon.                                                                     *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on features    *
;   of the assembler.                                                         *
;                                                                             *
;   Refer to the respective data sheet for additional information on the      *
;   instruction set.                                                          *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:         xxx.asm                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Files required: P12CE673.INC                                             *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 12CE673:                                                 *
;                                                                             *
;    Four-channel, 8-bit A/D converter                                        *
;    8-bit real time clock/counter (TMR0) with 8-bit programmable prescaler   *
;    In-Circuit Serial Programming (ICSP)                                     *
;    Internal 4 MHz oscillator with programmable calibration                  *
;    Selectable clockout                                                      *
;    Power-on Reset (POR)                                                     *
;    Power-up Timer (PWRT) and Oscillator Start-up                            *
;    Timer (OST)                                                              *
;    Watchdog Timer (WDT) with its own on-chip RC oscillator for reliable     *
;    operation                                                                *
;    Programmable code protection                                             *
;    Power saving SLEEP mode                                                  *
;    Interrupt-on-pin change (GP0, GP1, GP3)                                  *
;    Internal pull-ups on I/O pins (GP0, GP1, GP3)                            *
;    Internal pull-up on MCLR pin                                             *
;    Selectable oscillator options:                                           *
;    Precision internal 4 MHz oscillator                                      *
;    External low-cost RC oscillator                                          *
;    Standard crystal/resonator                                               *
;    High speed crystal/resonator                                             *
;    Power saving, low frequency crystal                                      *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Notes:                                                                   *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Revision History:                                                        *
;                                                                             *
;******************************************************************************

;------------------------------------------------------------------------------
; PROCESSOR DECLARATION
;------------------------------------------------------------------------------

     LIST      p=12CE673              ; list directive to define processor
     #INCLUDE <P12CE673.INC>          ; processor specific variable definitions

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

     __CONFIG    _MCLRE_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 and Bank 1.  Each Bank contains 
; Special Function Registers and General Purpose Registers at the locations 
; below:  
;
;           SFR         OVERLAPPING GPR   SEPERATE GPR
; Bank 0    0x00-0x05
; Bank 0    0x0A-0x0C
; Bank 0    0x1E-0x1F
; Bank 0                0x70-0x7F         0x20-0x6F
; Bank 1    0x80-0x85
; Bank 1    0x8A-0x8C
; Bank 1    0x8E-0x8F
; Bank 1    0x9F
; Bank 1                0xF0-0xFF         0xA0-0xBF
;
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
 
OSC               CODE    0x3FF             ; store move instruction here

; Internal RC calibration value is placed at location 0x3FF by Microchip as
; a MOVLW K instruction, where the K is a literal value to be loaded into 
; the OSCCAL register.  

;------------------------------------------------------------------------------
; RESTORE OSCILLATOR CALIBRATION VALUE
;------------------------------------------------------------------------------

RESET             CODE    0x0000    ; processor reset vector
          banksel OSCCAL            ; select data memory bank of OSCCAL
          errorlevel -302
          MOVWF   OSCCAL            ; set oscillator tuning value     
          errorlevel +302
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

INT_VECTOR        CODE   0x0004     ; Interrupt Vector Location

INTERRUPT                           ; Relocatable Interrupt Service Routine

;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          MOVF    STATUS,W          ; move status register into W register
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register


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