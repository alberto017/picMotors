;
;	File: Example.asm
;	MPASM assembler/MPLINK linker example - file 1
;	Use with Example2.asm 
;	17 May 2004
;	Updated: 26 Aug 2009
;

	list	 p=16f887
	#include p16f887.inc
	
	
;   Set configuration bits using definitions from the include file, p16f84.inc
	__config	_CONFIG1, _LP_OSC & _PWRTE_OFF & _WDT_OFF & _CP_OFF

	
;   Set User ID Memory
	__idlocs	0x1234



PROG	CODE		; Set the start of code from linker script

main				; Min code entry called from Example2.asm
	global	main	; Define as global so can be used in Example2.asm
	nop				; Main does nothing -- Put your code here
	goto	main	; Our sample "main" is just an infinite loop

service 			; Interrupt routine, called from Example2.asm
	global service	; Define as global so can be used in Example2.asm
	nop				; Interrupt code would go here
	nop
	retfie


	end
