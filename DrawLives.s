.section .text
.globl drawLives
drawLives:
	push	{r4-r10, lr}
	mov	r5, r0
	//break:
    mov     sp, #0x8000
	
	bl		EnableJTAG
	bl		InitFrameBuffer
	mov		r0, r5
	bl		ItoaS
	ldr		r10, =asciiScore
	ldr		r2, [r10, #8]
	mov		r5, 		#500
	mov		r6,		#30			
	bl		DrawChar
end:
	pop	{r4-r10, lr}
	bx	lr

DrawChar:

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font		// load the address of the font map
	mov		r0,		r2		// load the character into r0
	add		chAdr,	r0, lsl #4	// char address = font base + (char * 16)
	mov		r9, px

charLoop$:
	mov		px,		r9			// init the X coordinate

	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r0,		px
	mov		r1,		py
	mov		r2,		#0xF800		// red
	bl		DrawPixel			// draw red pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	bl	end
.section .data

.align 4
font:		.incbin	"font.bin"
