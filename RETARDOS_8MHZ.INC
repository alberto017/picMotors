;************************* Librería "RETARDOS_8MHZ.INC"******************************
;
;      Librería de retardos para oscilador de 8 MHz.
;
;      Web: http://electronica-pic.blogspot.com
;
;************************************************************************************

; Retardo = 1e-05 segundos
; Clock frequency = 8 MHz

; Retardo actual = 1e-05 segundos = 20 ciclos
; Error = 0 %

	cblock
	r1
	endc

Retardo_10micros
			;16 ciclos
	movlw	0x05
	movwf	r1
Retardo_10micros_0
	decfsz	r1, f
	goto	Retardo_10micros_0

			;4 ciclos (incluyendo call)
	return

;----------------------------------------------------------------------------------------

; Retardo = 5e-06 segundos.
; Frecuencia reloj = 8 MHz

; Retardo actual = 5e-06 segundos = 10 ciclos
; Error = 0 %

Retardo_5micros
			;6 ciclos
	goto	$+1
	goto	$+1
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 4e-06 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 4e-06 segundos = 8 ciclos
; Error = 0 %

Retardo_4micros
			;4 ciclos
	goto	$+1
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.0005 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.0005 segundos = 1000 ciclos
; Error = 0 %

	cblock
	r2
	r3
	endc

Retardo_500micros
			;993 ciclos
	movlw	0xC6
	movwf	r2
	movlw	0x01
	movwf	r3
Retardo_500micros_0
	decfsz	r2, f
	goto	$+2
	decfsz	r3, f
	goto	Retardo_500micros_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.0002 segundos
; Frecuancia reloj = 8 MHz

; Retardo actual = 0.0002 segundos = 400 ciclos
; Error = 0 %

	cblock
	r4
	endc

Retardo_200micros
			;394 ciclos
	movlw	0x83
	movwf	r4
Retardo_200micros_0
	decfsz	r4, f
	goto	Retardo_200micros_0

			;2 ciclos
	goto	$+1

			;4 ciclos (including call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.0001 segundos
; Frecuencia reloj = 8 MHz

; retardo actual = 0.0001 segundos = 200 ciclos
; Error = 0 %

	cblock
	r5
	endc

Retardo_100micros
			;196 ciclos
	movlw	0x41
	movwf	r5
Retardo_100micros_0
	decfsz	r5, f
	goto	Retardo_100micros_0

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 5e-05 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 5e-05 segundos = 100 ciclos
; Error = 0 %

	cblock
	r6
	endc

Retardo_50micros
			;94 ciclos
	movlw	0x1F
	movwf	r6
Retardo_50micros_0
	decfsz	r6, f
	goto	Retardo_50micros_0

			;2 ciclos
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 2e-05 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 2e-05 segundos = 40 ciclos
; Error = 0 %

	cblock
	r7
	endc

Retardo_20micros
			;34 ciclos
	movlw	0x0B
	movwf	r7
Retardo_20micros_0
	decfsz	r7, f
	goto	Retardo_20micros_0

			;2 ciclos
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.2 segundos
; Frecuancia reloj = 8 MHz

; Retardo actual = 0.2 segundos = 400000 ciclos
; Error = 0 %

	cblock
	r8
	r9
	r10
	endc

Retardo_200ms
			;399992 ciclos
	movlw	0x35
	movwf	r8
	movlw	0xE0
	movwf	r9
	movlw	0x01
	movwf	r10
Retardo_200ms_0
	decfsz	r8, f
	goto	$+2
	decfsz	r9, f
	goto	$+2
	decfsz	r10, f
	goto	Retardo_200ms_0

			;4 ciclos
	goto	$+1
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.1 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.1 segundos = 200000 ciclos
; Error = 0 %

	cblock
	r11
	r12
	endc

Retardo_100ms
			;199993 ciclos
	movlw	0x3E
	movwf	r11
	movlw	0x9D
	movwf	r12
Retardo_100ms_0
	decfsz	r11, f
	goto	$+2
	decfsz	r12, f
	goto	Retardo_100ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.05 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.05 segundos = 100000 ciclos
; Error = 0 %

	cblock
	r13
	r14
	endc

Retardo_50ms
			;99993 ciclos
	movlw	0x1E
	movwf	r13
	movlw	0x4F
	movwf	r14
Retardo_50ms_0
	decfsz	r13, f
	goto	$+2
	decfsz	r14, f
	goto	Retardo_50ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.02 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.02 segundos = 40000 ciclos
; Error = 0 %

	cblock
	r15
	r16
	endc

Retardo_20ms
			;39993 ciclos
	movlw	0x3E
	movwf	r15
	movlw	0x20
	movwf	r16
Retardo_20ms_0
	decfsz	r15, f
	goto	$+2
	decfsz	r16, f
	goto	Retardo_20ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.01 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.01 segundos = 20000 ciclos
; Error = 0 %

	cblock
	r17
	r18
	endc

Retardo_10ms
			;19993 ciclos
	movlw	0x9E
	movwf	r17
	movlw	0x10
	movwf	r18
Retardo_10ms_0
	decfsz	r17, f
	goto	$+2
	decfsz	r18, f
	goto	Retardo_10ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.005 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.005 segundos = 10000 ciclos
; Error = 0 %

	cblock
	r19
	r20
	endc

Retardo_5ms
			;9993 ciclos
	movlw	0xCE
	movwf	r19
	movlw	0x08
	movwf	r20
Retardo_5ms_0
	decfsz	r19, f
	goto	$+2
	decfsz	r20, f
	goto	Retardo_5ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.002 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.002 segundos = 4000 ciclos
; Error = 0 %

	cblock
	r21
	r22
	endc

Retardo_2ms
			;3993 ciclos
	movlw	0x1E
	movwf	r21
	movlw	0x04
	movwf	r22
Retardo_2ms_0
	decfsz	r21, f
	goto	$+2
	decfsz	r22, f
	goto	Retardo_2ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.001 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.001 segundos = 2000 ciclos
; Error = 0 %

	cblock
	r23
	r24
	endc

Retardo_1ms
			;1993 ciclos
	movlw	0x8E
	movwf	r23
	movlw	0x02
	movwf	r24
Retardo_1ms_0
	decfsz	r23, f
	goto	$+2
	decfsz	r24, f
	goto	Retardo_1ms_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 20 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 20 segundos = 40000000 ciclos
; Error = 0 %

	cblock
	r25
	r26
	r27
	endc

Retardo_20s
			;39999993 ciclos
	movlw	0x6C
	movwf	r25
	movlw	0x32
	movwf	r26
	movlw	0x58
	movwf	r27
Retardo_20s_0
	decfsz	r25, f
	goto	$+2
	decfsz	r26, f
	goto	$+2
	decfsz	r27, f
	goto	Retardo_20s_0

			;3 ciclos
	goto	$+1
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 10 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 10 segundos = 20000000 ciclos
; Error = 0 %

	cblock
	r28
	r29
	r30
	endc

Retardo_10s
			;19999992 ciclos
	movlw	0xB5
	movwf	r28
	movlw	0x99
	movwf	r29
	movlw	0x2C
	movwf	r30
Retardo_10s_0
	decfsz	r28, f
	goto	$+2
	decfsz	r29, f
	goto	$+2
	decfsz	r30, f
	goto	Retardo_10s_0

			;4 ciclos
	goto	$+1
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 5 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 5 segundos = 10000000 ciclos
; Error = 0 %

	cblock
	r31
	r32
	r33
	endc

Retardo_5s
			;9999995 ciclos
	movlw	0x5A
	movwf	r31
	movlw	0xCD
	movwf	r32
	movlw	0x16
	movwf	r33
Retardo_5s_0
	decfsz	r31, f
	goto	$+2
	decfsz	r32, f
	goto	$+2
	decfsz	r33, f
	goto	Retardo_5s_0

			;1 ciclos
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 2 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 2 segundos = 4000000 ciclos
; Error = 0 %

	cblock
	r34
	r35
	r36
	endc

Retardo_2s
			;3999994 ciclos
	movlw	0x23
	movwf	r34
	movlw	0xB9
	movwf	r35
	movlw	0x09
	movwf	r36
Retardo_2s_0
	decfsz	r34, f
	goto	$+2
	decfsz	r35, f
	goto	$+2
	decfsz	r36, f
	goto	Retardo_2s_0

			;2 ciclos
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 1 segundo
; Frecuencia reloj = 8 MHz

; Retardo actual = 1 segundo = 2000000 ciclos
; Error = 0 %

	cblock
	r37
	r38
	r39
	endc

Retardo_1s
			;1999996 ciclos
	movlw	0x11
	movwf	r37
	movlw	0x5D
	movwf	r38
	movlw	0x05
	movwf	r39
Retardo_1s_0
	decfsz	r37, f
	goto	$+2
	decfsz	r38, f
	goto	$+2
	decfsz	r39, f
	goto	Retardo_1s_0

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 0.5 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 0.5 segundos = 999990 ciclos
; Error = 0 %

cblock
	r40
	r41
	r42
	endc

Retardo_500ms
			;999990 ciclos
	movlw	0x07
	movwf	r40
	movlw	0x2F
	movwf	r41
	movlw	0x03
	movwf	r42
Retardo_500ms_0
	decfsz	r40, f
	goto	$+2
	decfsz	r41, f
	goto	$+2
	decfsz	r42, f
	goto	Retardo_500ms_0

			;6 ciclos
	goto	$+1
	goto	$+1
	goto	$+1

			;4 cicles (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 60 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 30 segundos = 59999994 ciclos
; Error = 0 %

cblock
	r43
	r44
	r45
	endc

Retardo_30s
			;59999994 ciclos
	movlw	0x23
	movwf	r43
	movlw	0xCB
	movwf	r44
	movlw	0x83
	movwf	r45
Retardo_30s_0
	decfsz	r43, f
	goto	$+2
	decfsz	r44, f
	goto	$+2
	decfsz	r45, f
	goto	Retardo_30s_0

			;2 ciclos
	goto	$+1

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------

; Retardo = 60 segundos
; Frecuencia reloj = 8 MHz

; Retardo actual = 60 segundos = 999990 ciclos
; Error = 0 %

	cblock
	r46
	r47
	r48
	r49
	endc

Retardo_60s
			;119999995 ciclos
	movlw	0x54
	movwf	r46
	movlw	0x74
	movwf	r47
	movlw	0xCC
	movwf	r48
	movlw	0x01
	movwf	r49
Retardo_60s_0
	decfsz	r46, f
	goto	$+2
	decfsz	r47, f
	goto	$+2
	decfsz	r48, f
	goto	$+2
	decfsz	r49, f
	goto	Retardo_60s_0

			;1 ciclo
	nop

			;4 ciclos (incluyendo call)
	return

;-----------------------------------------------------------------------------------------
;
;      Librería de retardos para oscilador de 8 MHz.
;
;      Web: http://electronica-pic.blogspot.com
;
;*****************************************************************************************