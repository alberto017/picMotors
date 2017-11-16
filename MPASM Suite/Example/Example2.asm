;
;	File: Example2.asm
;	MPASM assembler/MPLINK linker example - file 2
;	Use with Example.asm 
;	17 May 2004
;	Updated: 26 Aug 2009
;

	list	 p=16f887
	#include p16f887.inc

	extern main, service	; These routines are in Example.asm

STARTUP	CODE 				; This area is defined in 
							;  the linker script

	goto main				; Jump to main code defined in Example.asm
	nop						; Pad out so interrupt
	nop						;  service routine gets
	nop						;    put at address 0x0004.
	goto service			; Points to interrupt service routine

	end
