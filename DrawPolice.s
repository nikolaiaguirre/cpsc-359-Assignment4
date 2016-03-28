//.section    .init
//.globl     _start

//_start:
   // b       drawBrick
    
.section .text
.globl drawPoliceCar
drawPoliceCar:
	push	{r4-r10, lr}
	mov 	r5, r0
	mov	r6, r1
   	 mov     sp, #0x8000
	bl		EnableJTAG
	bl		InitFrameBuffer
	
DrawLoop:

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	column		.req	r7
	ldr		chAdr,	=policeCar		
	lsl		px, #5
	mov		r9, px
	lsl		py, #5
	add		r10, px, #32
	add		r8, py, #32
				
charLoop$:
	mov		px,		r9				

rowLoop$:
	cmp		px,		r10		
	beq		nextRow
	ldrh		r2,	[chAdr]
	ldr		r3, 	#FF69B4
	cmp		r2,	r3//color we want transparent
	beq		loopcont
	mov		r0,		px
	mov		r1,		py
	ldrh		r2,		[chAdr], #2		
	bl		DrawPixel
loopcont:			
	add		px,		#1			
	bl		rowLoop$
nextRow:
	add		py,		#1			
	cmp		py, r8
	beq		end
	bl		charLoop$

end:
	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	column
	pop		{r4-r10, lr}
	bx		lr
	//b	haltLoop$
.section .data

.align 4
policeCar:

