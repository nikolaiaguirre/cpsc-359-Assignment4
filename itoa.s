//CONVERT SUM FROM INT TO ASCII
.section .text
.globl ItoaS
ItoaS:
	
	push		{r4-r10, lr}
	mov		r3, #2
startConvert:
	ldr		r2, =asciiScore
	mov		r1, r0						//r1 = numerator
	mov		r0, #0						//r7 = denominator
ItoaSDivideLoop:
	cmp		r1, #10
	blt		ItoaSloop
	add		r0, #1						//r0 = r0 + 1 
	sub		r1, #10						//Subtract the numerator by the denomintaor
	b		ItoaSDivideLoop				//r1 = Remainder
ItoaSloop:
	add		r1, #48				//Add 48 to the	remainder
	mov		r4, r3, LSL #2				
	str		r1, [r2, r4]				//Store the character into r6
	sub		r3, #1
	cmp		r0, #10						//Loop back if > 0 
	bge		startConvert
	cmp		r0, #0
	addne		r0, #48
	mov		r4, r3, LSL #2	
	strne		r0, [r2, r4]
	pop		{r4-r10, lr}
	bx	lr
	
.section .data
.globl	asciiScore
asciiScore:
	.rept 8
	.byte 0
	.endr
