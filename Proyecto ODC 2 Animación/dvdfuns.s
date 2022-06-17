.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ limite,          	300 

/*
Funciones aqui:
	- Pixeldir
	-Delay
	- dibujarcuadrado
	- dibujarCirculo
	- NO_SIGNAL
	- linea_estatica
	- dibujar_triangulo

*/

Pixeldir:
	mov x0, 640			
	mul x0, x0, x4						
	add x0, x0, x3						
	lsl x0, x0, 2						 
	add x0, x0, x20
 ret	
 
 DELAY:
	movz x9, 0xff,lsl 16 
	movk x9, 0xffff, lsl 00
	loop:
	subs x9, x9, 3
	b.GT loop
ret
 
 dibujarcuadrado:  
 //x3= x, x4 = y, x1/x9=Ancho, x2/x8=Alto  w10 = color
 
 	mov x12, x0
 	mov x8, x2
 	loopa:
     	 mov x9, x1
     	 mov x7, x12
     	 
     	colorear:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,colorear
	  mov x12, x7   
	  sub x8, x8, 1
	  add x12, x12,2560
	  cbnz x8,loopa
	
 ret
 


  dibujarCirculo:
/*
	parametros:
				centro = (x3, x4);  x3 es la columna, x4 la fila
				radio = x1
				w10 = color
						
	comportamiento:
				x0 empieza en esquina superior izquierdo del cuadrado que contiene el circulo
				y va recorriendo el cuadrado y si se cumple que x0 esta dentro del circulo dado por
					(x0.fila - x3)*2 + (x0.columna - x4)2 <= x1*2
					\------x9-----/     \------x11-----/   \--x12--/
					   \-------------x13-------------/							 
				se pinta el pixel

*/              
		
		sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      		stur lr, [sp]

		add x5, x4,x1		// con x5 me fijo si llego a final de Y
		add x6, x3,x1		// con x6 me fijo si llega al final de X
					          
		
		mov x15, x3
		mov x16, x4
		sub x3, x3, x1      // Inicio X		
		
resetY:
		cmp x3, x6
		b.gt end
		sub x4, x5, x1
		sub x4, x4, x1      // Inicio Y
cirloop:
		cmp x4,x5
		b.eq next_fila

		sub x9, x3, x15			   
		mul x9, x9, x9				// x9 = (x0.fila - x3)**2 	
		
		sub x11, x4, x16			   
		mul x11, x11, x11			// x11 = (x0.columna - x4)**2

		add x13, x9, x11			// x13 = (x0.fila - x1)*2 + (x0.columna - x2)*2

		mov x12, x1
		mul x12, x12, x12			// x12 = radio**2

		cmp x12, x13
		B.GE color					//si x13 <= x12 
		B skip
color:		
		BL Pixeldir				// then pintar pixel
		stur w10,[x0]	
skip:
		add x4, x4, #1				// avanza pixel
		B cirloop
next_fila:
		add x3, x3, #1
		B resetY
end:
        ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
		
	ret
 
NO_SIGNAL:
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
    stur lr, [sp]

	mov x19, 200
loop_signal:
// COLUMNA BLANCO
	movz x10, 0xFF,lsl 16  
	movk x10, 0xFFFF, lsl 00
	
	mov x1, 80 // ancho de cada columna, SCREEN_WIDTH/cant de columnas
	mov x2, SCREEN_HEIGH
	mov x3, 0	// pos.columna
	mov x4, 0	// pos.fila

	BL Pixeldir
	BL dibujarcuadrado
// COLUMNA AMARILLO
	movz x10, 0xf9,lsl 16  
	movk x10, 0xFb00, lsl 00
	
	add x3, x3, 80  // pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA verde-azul
	movz x10, 0x02,lsl 16  
	movk x10, 0xfeff, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA verde
	movz x10, 0x01,lsl 16  
	movk x10, 0xff00, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA violeta
	movz x10, 0xfd,lsl 16  
	movk x10, 0x00fb, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA violeta
	movz x10, 0xfb,lsl 16  
	movk x10, 0x0102, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA azul
	movz x10, 0x03,lsl 16  
	movk x10, 0x01fc, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

// COLUMNA negro
	movz x10, 0x00,lsl 16  
	movk x10, 0x0000, lsl 00
	
	add x3, x3, 80	// pos.columna

	BL Pixeldir
	BL dibujarcuadrado

	sub x19, x19, 1
	cmp x19, 0
	B.GT loop_signal

	mov x19, limite
	ldur lr, [sp] // Recupero el puntero de retorno del stack
    add sp, sp, #8 

    br lr



dibujarfondo:  //x3= x x4 = y x1/x9=Ancho x2/x8=Alto  w10 = color
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 	
 	add x17, x10, 3000
 	mov x12, x0
 	mov x8, x2
 	loopaf:
     	 mov x9, x1
     	 mov x7, x12
     	setx22:
     	mov x22, 4 
     	colorearf:
     	  	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	
	  sub x22, x22, 1  
	  cbz x9,filaterminada
	  cbz x22, setx21
	  B colorearf
	  
	filaterminada:
	  mov x12, x7  
	  sub x8, x8, 1
	  add x12, x12,2560
	  cbnz x8,loopaf
	  B fin
	setx21:
     	mov x21, 4 
	colorearfsigpix:
	  stur w17,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  sub x21, x21, 1  
	  cbz x9,filaterminada
	  cbz x21,setx22
	  B colorearfsigpix
	fin: 
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr
 

