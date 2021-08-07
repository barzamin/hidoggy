	org 0x7c00		; start address

	; *******************
	; *** boop sector ***
	; *******************
	xor ax, ax		; ax = 0
	mov ds, ax		; ds = ax = 0
	xor cx, cx

	; -- clear screen by changing mode
	mov ah, 0x0
	mov al, 0x3		; 0x3 = text, 80x25, 16color
	int 0x10

	mov si, woof
	cld
	jmp .load

.unpack:
	; data is in AL
	mov cl, al		; copy to cx for count
	and cx, 0b111111	; mask off count

	cmp al, 0b111111	; if > this, we know we're printing a '.'
	mov al, [space]
	cmova ax, [mark]	; al should now contain approprate char
				; al = (al > 0b111111) ? '.' : ' '

	mov ah, 0x9
	mov bh, 0x0
	mov bl, 0x0
	int 0x10

.load:
	lodsb
	jnz .unpack		; if we're nto done yet, loop

hang:
	jmp hang

woof:
	incbin "rle.dat"
	db 0x0 ; end marker

space:	db ' '
mark:	db '.'
        db 0x0 			; required bc we cmova all 16 bytes to ax from this

	times 510-($-$$) db 0	; pad til end of sector
	dw 0xaa55		; magic