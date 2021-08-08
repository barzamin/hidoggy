	org 0x7c00		; start address

	; *******************
	; *** boop sector ***
	; *******************

	;; vars
	%define t 0x7e01

	;; start doing shit
	xor ax, ax		; ax = 0
	mov ds, ax		; ds = ax = 0
	xor cx, cx
	mov sp, 0

	; -- start at 0,0
	mov dx, 0		; dh : row, dl : col

	call cls		; clear screen

	; mov ah, 0x01
	; mov ch, 0x3f
	; int 0x10		; disable cursor

	mov byte [t], 0

	cld
	mov si, woof
	jmp load

unpack:
	; data is in AL
	mov cl, al		; copy to cx for count
	and cx, 0b111111	; mask off count

	cmp al, 0b111111	; if > this, we know we're printing a '.'
	jbe .print_nothing

	mov al, 0x3
	mov ah, 0x9		; ah = 0x9 : write char w attr at cursor
	mov bh, 0x0 		; page = 0
	mov bl, 0x0f		; attr 0x0f (white on black)
	int 0x10

.print_nothing:
	add dl, cl		; increment col by number of chars we 'wrote'
	cmp dl, 61		; is our col past end?
	jl .no_row_incr		; jump over if we don't need to update
	mov dl, 0 		; reset col
	add dh, 1		; increment row
.no_row_incr:
	mov ah, 0x02		; ah = 0x2 : set cursor position
	int 0x10		; set cursor pos using dx

load:
	lodsb
	or al, al
	jnz unpack		; if we're not done yet, loop

	; mov dx, 0

	; add byte [t], 1
	; mov si, woof
	; jmp .load

hang:
	jmp hang

cls:
	; -- clear screen by changing mode
	mov ah, 0x0
	mov al, 0x3		; 0x3 = text, 80x25, 16color
	int 0x10
	ret

woof:
	incbin "rle.dat"
	db 0x0 ; end marker

space:	db ' '
mark:	db 0x3 ;'♥'; an extra byte here gets loaded by cmova but we overwrite

	times 510-($-$$) db 0	; pad til end of sector
	dw 0xaa55		; magic