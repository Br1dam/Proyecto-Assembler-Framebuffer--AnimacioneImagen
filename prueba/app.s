.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
				
.include "dvdfuns.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------


	mov x15, 3	//vector movimiento en y
	mov x14, 3	//vector movimiento en x
	
	mov x21, 3
	mov x22, 3	// vector mov triangulo
	
	mov x5, 500	//pos.columna inicial
	mov x6, 300	//pos.fila inicial
	
	mov x17, 400	// pos inicial triangulo
	mov x18, 200
	
	movz x11, 0xff,lsl 16  
	movk x11, 0xffff, lsl 00
	


LOOP:
	
	BL dibujarfondo
	BL cuadrado
	BL triangulo
	BL DELAY
	B LOOP

