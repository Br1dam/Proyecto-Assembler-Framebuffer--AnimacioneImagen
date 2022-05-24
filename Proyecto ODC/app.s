
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------
	
    Pixeldir:
	 mov x0, 640			
	 mul x0, x0, x4						
	 add x0, x0, x3						
	 lsl x0, x0, 2						 
	 add x0, x0, x20	

    mov x0, x20
	movz x10, 0x57,lsl 16
	movk x10, 0xb7ff, lsl 00
	movz x11, 0xEF, lsl 16
	movk x11, 0xFF00, lsl 00
	movz x12, 0x7A, lsl 16 
	movk x12, 0x788B, lsl 00
	

	mov x2, SCREEN_HEIGH         // Y Size 
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]	   // Set color of pixel N
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	 
	cbnz x1,loop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,loop1	   // if not last row, jump

	mov x4, 101
	mov x3, 630

					
	mov x4, 100
	mov x3, 100
										
	loopa:
     mov x3, 100
        
	dibujarcuadrado:
		stur w11,[x0]	   // Set color of pixel N
		sub x0,x0,4	   // Next pixel
		sub x3,x3,1	   // decrement X counter
		cbnz x3,dibujarcuadrado   // If not end row jump
		sub x4, x4, 1
		sub x0, x0,2160
		cbnz x4,loopa




	mov x4, 390
	mov x3, 0
	BL Pixeldir		

	mov x4, 300
	mov x3, 640
	loopb:
      mov x3, 640
        
	dibujarcalle:
		stur w12,[x0]	   // Set color of pixel N
		add x0,x0,4	   // Next pixel
		sub x1,x3,1   // decrement X counter
		cbnz x3,dibujarcalle              
		sub x4,x4,1	   // Decrement Y counter
		cbnz x4,loopb	   // if not last row, jump



















//---------------------------------------------------------------
// Infinite Loop 

InfLoop: 
	b InfLoop
