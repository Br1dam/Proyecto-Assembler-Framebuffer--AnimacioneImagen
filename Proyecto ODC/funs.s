.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


 Pixeldir:
 
 	sub sp, sp, #8 // Guardo el puntero de retorno en el stack
      	stur lr, [sp]
      	
	mov x0, 640			
	mul x0, x0, x4						
	add x0, x0, x3						
	lsl x0, x0, 2						 
	add x0, x0, x20
 	
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
     	 mov x11, x12
     	 
     	colorear:	
	  stur w10,[x12]	   
	  add x12,x12,4	   
	  sub x9,x9,1	  
	  cbnz x9,colorear
	  mov x12, x11   
	  sub x8, x8, 1
	  add x12, x12,2560
	  cbnz x8,loopa
	
 	ldur lr, [sp] // Recupero el puntero de retorno del stack
        add sp, sp, #8 

        br lr
 
 
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
 

	
 
 
 
