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
 
 
 dibujarcuadrado:  //x3= x x4 = y x1/x9=Ancho x2/x8=Alto  w10 = color
 
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
	
 ret
 
 
