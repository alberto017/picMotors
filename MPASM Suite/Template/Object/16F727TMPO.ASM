;******************************************************************************
;   This file is a basic code template for code generation on the  PIC16F727. *
;   This file contains the basic code building blocks to build upon.          *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on features of *
;   the assembler.                                                            *
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
;    Files required: P16F727.INC                                              *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Features of the 16F727:                                                  *
;                                                                             *
;    Precision Internal Oscillator (16 MHz or 500 kHz operation)              *
;    On Chip 3.2 V Regulator                                                  *
;    Pinout compatible to other 28/40 pin PIC16CXXX and 16FXXX micros         *
;    Brownout reset with selectable trip points                               *
;    8 bit resolution and 14 channel A/D Converter                            *
;    Wide operating voltage range (1.8-5.5V)                                  *
;    A/D converter with selectable 1.024, 2.048, 4.096 voltage reference      *
;    AUSART, SPI, and IIC                                                     *
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

     LIST      p=16F727             ; list directive to define processor
     #INCLUDE <P16F727.INC>         ; processor specific variable definitions

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

     __CONFIG    _CONFIG1, _DEBUG_OFF & _PLL_DIS & _BORV_1_9 & _BOR_OFF & _CP_OFF & _MCLR_EN & _PWRT_EN & _WDT_OFF & _INTOSCIO 
     __CONFIG    _CONFIG2, _VCAP_DIS

;------------------------------------------------------------------------------
;
; VARIABLE DEFINITIONS
;
; Available Data Memory divided into Bank 0 through Bank 3.  Each Bank contains
; Special Function Registers and General Purpose Registers at the locations 
; below:  
;
;           SFR           GPR               SHARED GPR's
; Bank 0    0x00-0x1F     0x20-0x6F         0x70-0x7F    
; Bank 1    0x80-0x9F     0xA0-0xEF         0xF0-0xFF  
; Bank 2    0x100-0x10F   0x110-0x16F       0x170-0x17F
; Bank 3    0x180-0x18F   0x190-0x1EF       0x1F0-0x1FF
;
;------------------------------------------------------------------------------

; Example of using Shared Uninitialized Data Section
INT_VAR        UDATA_SHR       0x7D
W_TEMP         RES        1    ; w register for context saving (Shared)
STATUS_TEMP    RES        1    ; status used for context saving 
PCLATH_TEMP    RES        1    ; variable used for context saving

; Example of using GPR Uninitialized Data
GPR_VAR        UDATA           0x20
MYVAR1         RES        1    ; User variable located at address 0x20
MYVAR2         RES        1    ; User variable located at address 0x21
MYVAR3         RES        1    ; User variable located at address 0x22

;------------------------------------------------------------------------------
; RESET VECTOR
;------------------------------------------------------------------------------

RESET     CODE    0x0000            ; processor reset vector
          pagesel START
          GOTO    START             ; go to beginning of program

;------------------------------------------------------------------------------
; INTERRUPT SERVICE ROUTINE
;------------------------------------------------------------------------------

ISR       CODE    0x0004            ; interrupt vector location
;         Context saving for ISR
          MOVWF   W_TEMP            ; save off current W register contents
          MOVF    STATUS,W          ; move status register into W register
          MOVWF   STATUS_TEMP       ; save off contents of STATUS register
          MOVF    PCLATH,W          ; move pclath register into W register
          MOVWF   PCLATH_TEMP       ; save off contents of PCLATH register

;------------------------------------------------------------------------------
; USER INTERRUPT SERVICE ROUTINE GOES HERE
;------------------------------------------------------------------------------

;         Restore context before returning from interrupt

          MOVF    PCLATH_TEMP,W     ; retrieve copy of PCLATH register
          MOVWF   PCLATH            ; restore pre-isr PCLATH register contents
          MOVF    STATUS_TEMP,W     ; retrieve copy of STATUS register
          MOVWF   STATUS            ; restore pre-isr STATUS register contents
          SWAPF   W_TEMP,F
          SWAPF   W_TEMP,W          ; restore pre-isr W register contents
          RETFIE                    ; return from interrupt

;------------------------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------------------------

START

;------------------------------------------------------------------------------
; PLACE USER PROGRAM HERE
;------------------------------------------------------------------------------

          GOTO $

          END