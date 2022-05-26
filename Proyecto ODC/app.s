
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.include "funs.s"

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------
	
 
//FONDO

 movz x10, 0x57,lsl 16  // Color de fondo : Celeste
 movk x10, 0xb7ff, lsl 00
 mov x1, SCREEN_WIDTH         // Tamaño X
 mov x2, SCREEN_HEIGH         // Tamaño Y
 mov x3, 0                    // Posicion inicial del cuadrado
 mov x4, 0
 BL Pixeldir                  
 BL dibujarcuadrado




//SOL
 movz x10, 0xEF, lsl 16   // Color sol: Amarillo
 movk x10, 0xFF00, lsl 00
 mov x1, 100   //Tamaño X
 mov x2, 100   // Tamaño Y
 mov x4, 20    //Posicion inicial del cuadrado           
 mov x3, 530
 BL Pixeldir			

 BL dibujarcuadrado									

//CALLE

movz x10, 0x7A, lsl 16 
movk x10, 0x788B, lsl 00
mov x1, 640  //Tamaño X
mov x2, 300  // Tamaño Y
mov x4, 390   //Posicion inicial del cuadrado   
mov x3, 0
BL Pixeldir
BL dibujarcuadrado

	//Lineas Calle
       
	movz x10, 0xDA, lsl 16 
	movk x10, 0xDA1C, lsl 00
	mov x1, 100  //Tamaño X
	mov x2, 20  // Tamaño Y
	mov x4, 424   //Posicion inicial del cuadrado   
	mov x3, 40
	BL Pixeldir
	BL dibujarcuadrado
	
	movz x10, 0xDA, lsl 16 
	movk x10, 0xDA1C, lsl 00
	mov x1, 100  //Tamaño X
	mov x2, 20  // Tamaño Y
	mov x4, 424   //Posicion inicial del cuadrado   
	mov x3, 200
	BL Pixeldir
	BL dibujarcuadrado
	
	movz x10, 0xDA, lsl 16 
	movk x10, 0xDA1C, lsl 00
	mov x1, 100  //Tamaño X
	mov x2, 20  // Tamaño Y
	mov x4, 424   //Posicion inicial del cuadrado   
	mov x3, 360
	BL Pixeldir
	BL dibujarcuadrado
	
	movz x10, 0xDA, lsl 16 
	movk x10, 0xDA1C, lsl 00
	mov x1, 100  //Tamaño X
	mov x2, 20  // Tamaño Y
	mov x4, 424   //Posicion inicial del cuadrado   
	mov x3, 520
	BL Pixeldir
	BL dibujarcuadrado


//CASA

movz x10, 0x7C, lsl 16 
movk x10, 0x3535, lsl 00
mov x1, 250  //Tamaño X
mov x2, 200  // Tamaño Y
mov x4, 190  //Posicion inicial del cuadrado   
mov x3, 195
BL Pixeldir
BL dibujarcuadrado
	
	//PUERTA
	movz x10, 0x2E, lsl 16 
	movk x10, 0x664E, lsl 00
	mov x1, 50  //Tamaño X
	mov x2, 100  // Tamaño Y
	mov x4, 290  //Posicion inicial del cuadrado   
	mov x3, 245
	BL Pixeldir
	BL dibujarcuadrado
	
















//---------------------------------------------------------------
// Infinite Loop 

InfLoop: 
	b InfLoop
