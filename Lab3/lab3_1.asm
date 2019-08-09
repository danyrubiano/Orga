# ************ Declaracion de variables ***********************
.data
	A: .word 168 695 415 988 90 496 84 1017 534 607 433 660 646 940 64 916 954 671 663 308 955 352 822 153 709 429 1011 475 394 956 400 718 370 961 742 457 1023 969 965 419 948 913 460 659 532 206 251 17 51 644 877 214 234 677 539 558 402 941 548 776 568 799 697 824 158 239 860 981 876 679 497 763 616 891 401 533 74 652 932 499 693 851 332 516 249 16 1020 549 618 43 873 847 746 282 637 906 794 238 487 276 # Declaracion del vector A 
	suma: .word 0			# Declaracion variable suma
	i: .word 0

# ********************* Codigo del programa ***********************

.macro suma(%acumulador, %valor)
        add $t9, %acumulador, %valor
        move $s2, $t9
.end_macro

# retorno en registro $t1
# ingreso el index 0 a (n-1) del arreglo
.macro get_arreglo(%X)
    la $t3, A       
    move $t2, %X           
    add $t2, $t2, $t2    
    add $t2, $t2, $t2    
    add $t4, $t2, $t3    
    lw $t1, 0($t4)       # get
.end_macro
        
.text
main:
	
	## ------------- Despliegue y solicitud de los datos ------------- 
	
	# 
	la $s0,A		# $s0 tiene la direccion base del vector A
	lw $s1,i		# $s1 se asocia a la variable i
	lw $s2,suma		# $s2 esta asociada a la variable suma

## Loop para acceder al vector y sumar cada uno de los elementos del array
loop:	bgt $s1,100, end
	get_arreglo($s1)
	suma($s2, $t1)
	addi $s1,$s1,1
	j loop
end:	# Almacenamiento de los resultados
	move $a0, $s2 		
	li $v0, 1 		
	syscall 		
	## exit the program.
	li $v0, 10 		# 10 is the exit syscall.
	syscall 		# do the syscall.
	

# end ejemplo5.asm
