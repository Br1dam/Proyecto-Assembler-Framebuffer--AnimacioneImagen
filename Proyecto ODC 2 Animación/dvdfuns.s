.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


 Pixeldir:
	mov x0, 640			
	mul x0, x0, x4						
	add x0, x0, x3						
	lsl x0, x0, 2						 
	add x0, x0, x20
 ret	
 
 
 
 dibujartriangulo: 
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]

 
 	mov x12, x0
 	mov x8, x2
 	mov x5, 1
 	loopat:
     	 mov x9, x5
     	 mov x11, x12
     	 
     	coloreart:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,coloreart
	  mov x12, x11   
	  sub x8, x8, 1
	  sub x12, x12,2564
	  add x5, x5, 2
	  cbnz x8,loopat
	
 	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
 
 
 
 
 
 dibujarcuadrado:  //x3= x x4 = y x1/x9=Ancho x2/x8=Alto  w10 = color
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
 
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
	  
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr
	 
 DELAY:
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
	movz x9, 0xff,lsl 16 
	movk x9, 0xffff, lsl 00
	loop:
	subs x9, x9, 1
	b.ne loop
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8
        br lr


 	
dibujarsemicirculo:
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
      		
      		
      		mov x7, x3
		mov x8, x4

		add x5, x4,x1		// con x5 me fijo si llego a final de Y
		add x6, x3,x1		// con x6 me fijo si llega al final de X
					          
		
		mov x15, x3
		mov x16, x4
			
		
resetsY:
		cmp x3, x6
		b.gt ends
		sub x4, x5, x1
		sub x4, x4, x1      // Inicio Y
cirloops:
		cmp x4,x5
		b.eq next_filas

		sub x9, x3, x15			   
		mul x9, x9, x9				// x9 = (x0.fila - x3)**2 	
		
		sub x11, x4, x16			   
		mul x11, x11, x11			// x11 = (x0.columna - x4)**2

		add x13, x9, x11			// x13 = (x0.fila - x1)*2 + (x0.columna - x2)*2

		mov x12, x1
		mul x12, x12, x12			// x12 = radio**2

		cmp x12, x13
		B.GE colors					//si x13 <= x12 
		B skips
colors:		
		BL Pixeldir				// then pintar pixel
		stur w10,[x0]	
skips:
		add x4, x4, #1				// avanza pixel
		B cirloops
next_filas:
		add x3, x3, #1
		B resetsY
ends:
	mov x3, x7
	mov x4, x8
        ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
		

	

	
dibujarlogo:	
	
	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
	BL dibujarcuadrado
	mov x17, x3
	mov x18, x4
	movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 00
	add x4, x4, 40
	add x3 , x3, 10
	mov x1, 20
	BL Pixeldir
	BL dibujarsemicirculo
	add x3, x3, 5
	mov x1, 10
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00
	BL dibujarsemicirculo
	movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 00
	mov x2,18
	mov x3, x17
	mov x4, x18
	add x4, x4, 50
	add x3 , x3, 50 
	BL Pixeldir
	BL dibujartriangulo
	sub x4, x4, 7
	mov x2, 12
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00
	BL Pixeldir
	BL dibujartriangulo
	
	
	
	
	

	mov x3, x17
	mov x4, x18
	add x4, x4, 50
	add x3 , x3, 75     // 10-d(20)-10-v(20)-10-d-10-
	mov x1, 20
	movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 00
	BL Pixeldir
	BL dibujarsemicirculo
	add x3, x3, 5
	mov x1, 10
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00
	BL dibujarsemicirculo
	
	
	
	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
 
 

