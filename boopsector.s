	org 0x7c00		; start address

	; *******************
	; *** boop sector ***
	; *******************
	xor ax, ax		; ax = 0
	mov ds, ax		; ds = ax = 0
	xor cx, cx

	; -- start at 0,0
	mov dh, 0		; row
	mov dl, 0		; col

	; -- clear screen by changing mode
	mov ah, 0x0
	mov al, 0x3		; 0x3 = text, 80x25, 16color
	int 0x10

	cld
	mov si, woof
	jmp .load

.unpack:
	; data is in AL
	mov cl, al		; copy to cx for count
	and cx, 0b111111	; mask off count

	cmp al, 0b111111	; if > this, we know we're printing a '.'
	mov al, [space]
	cmova ax, [mark]	; al should now contain approprate char
				; al = (al > 0b111111) ? '.' : ' '

	mov bh, 0x0 		; page 0
	mov ah, 0x02		; ah = 0x2 : set cursor position
	int 0x10 		; set cursor pos using dx

	mov ah, 0x9		; ah = 0x9 : write char w attr at cursor
	mov bl, dh		; attr 0x0f (white on black)
	int 0x10

	add dl, cl		; increment col by number of chars we wrote
	cmp dl, 61		; is our col past end?
	jl .coord_jumpover	; jump over if we don't need to update
	mov dl, 0 		; reset col
	add dh, 1		; increment row
.coord_jumpover:

.load:
	lodsb
	or al, al
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