/*
 * TasterLeuchtanzeige.asm
 *
 *  Created: 02.07.2014 15:46:04
 *   Author: jburre
 */ 


 .include "m644PAdef.inc"

 .cseg

	.org 0
	jmp start

	.equ Licht1 = 10
	.equ Licht2 = 21

	.org 2*INT_VECTORS_SIZE

start:

; ----- Initialisierung der grundlegenden Funktionen -----
	; Initialisieren des Stacks am oberen Ende des RAM
    ; 16 bit SP wird als SPH:SPL im IO-Space angesprochen 
    ldi r16, LOW(RAMEND)	; low-Byte von RAMEND nach r16
    out SPL, r16	; in low-byte des SP ausgeben
					; der SP liegt im IO-Space 
    ldi r16, HIGH(RAMEND)	; high-Byte von RAMEND nach r16
    out SPH, r16		; in high-byte des SP ausgeben
    ; ab hier kann der Stack verwendet werden

	sei

	ldi R17, 0x1F		;Vorbereitung der Portausgabe auf A
	out DDRA, R17		;Ausgabe auf den ersten 5 Pins

	ldi r17, 0xC0
	out PORTA, R17

mainloop:
	call Muster1
	call waitForPin6
	call Muster2
	call waitForPin7
	jmp mainloop

waitForPin7:
	push r17 ; macht r17 frei
	in r17, sreg ; sichert status register
	push r17 ; status register auf stack
	push r18 ; r18 frei machen
	ldi R17, 0x00
	ldi R18, 0xFF
	waitForPin7Loop:
	in r17, pina ; pin a einlesen
	andi r17, 0x80 ; pin 7 extrahieren
	cpi r18, 0x00 ; alter pin 7 wert muss gesetzt sein
	mov r18, r17 ; neuer wert ist alter wert; möglich da mv keine flags setzt
	brne waitForPin7Loop ; wenn obrige bediengung erfüllt: abbrechen; sonst weiter
	cpi r17, 0x80 ; neuer pin 7 wert muss 0 sein
	brne waitForPin7Loop; wenn nicht, dann abbrechen; sonst weiter
	pop r18 ; alles wieder zurück
	pop r17
	out sreg, R17
	pop r17
	ret

waitForPin6:
	push r17 ; macht r17 frei
	in r17, sreg ; sichert status register
	push r17 ; status register auf stack
	push r18 ; r18 frei machen
	ldi R17, 0x00
	ldi R18, 0xFF
	waitForPin6Loop:
	in r17, pina ; pin a einlesen
	andi r17, 0x40 ; pin 7 extrahieren
	cpi r18, 0x00 ; alter pin 7 wert muss gesetzt sein
	mov r18, r17 ; neuer wert ist alter wert; möglich da mv keine flags setzt
	brne waitForPin6Loop ; wenn obrige Bedingung erfüllt: abbrechen, sonst weiter
	cpi r17, 0x40 ; neuer pin 7 wert muss 0 sein
	brne waitForPin6Loop; wenn nicht, dann abbrechen; sonst weiter
	pop r18 ; alles wieder zurück
	pop r17
	out sreg, R17
	pop r17
	ret

Muster1:
	push R18			
	ldi R18, Licht1		;Pins 2 und 4 Leuchten lassen
	ori R18, 0xC0
	out PORTA, R18		;auf Port A ausgeben
	pop R18
	ret					;Rücksprung
Muster2:
	push R18			
	ldi R18, Licht2		;Pin 1,3 und 5 leuchten lassen
	ori R18, 0xC0
	out PORTA, R18		;auf Port A ausgeben
	pop R18
	ret					;Rücksprung