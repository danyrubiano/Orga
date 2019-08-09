.data

    A: .word 168 695 415 988 90 496 84 1017 534 607 433 660 646 940 64 916 954 671 663 308 955 352 822 153 709 429 1011 475 394 956 400 718 370 961 742 457 1023 969 965 419 948 913 460 659 532 206 251 17 51 644 877 214 234 677 539 558 402 941 548 776 568 799 697 824 158 239 860 981 876 679 497 763 616 891 401 533 74 652 932 499 693 851 332 516 249 16 1020 549 618 43 873 847 746 282 637 906 794 238 487 276 # Declaracion del vector A 
    i: .word 0
    suma: .word 0
    espacio: .asciiz " "
    salto: .asciiz "\n"

.text

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

.macro PRINT_int_register(%X)
	move $a0,%X
 	li $v0, 1
	syscall
.end_macro

.macro PRINT_string_asciiz(%X)
	la $a0, %X
 	li $v0, 4
	syscall
.end_macro

.macro suma(%acumulador, %valor)
        add $t2, %acumulador, %valor
        move $s2, $t2
.end_macro

main:
	
	## ------------- Despliegue y solicitud de los datos ------------- 
	
	# 
	la $s0,A		# $s0 tiene la direccion base del vector A
	lw $s1,i		# $s1 se asocia a la variable i
	lw $s2,suma		# $s2 esta asociada a la variable suma

ingresar_elemento:
    # Reservamos mem para un nodo
    addi $a0, $zero, 8 	# 8 bytes
    addi $v0, $zero, 9	# syscall 9
    syscall
    add $t8, $v0, $zero # Este nodo esta en $t8
    
    get_arreglo($s1)
    sw $t1, 0($t8)      # El elemento que guarda este nodo es 1
    add $a1, $t8, $zero # guarda la dirección del nodo
    addi $s1, $s1, 1
    
    loop:
    
        bgt $s1,100,end
	get_arreglo($s1)
	
        # Reservamos mem para otro nodo
        addi $a0, $zero, 8 	# 8 bytes
        addi $v0, $zero, 9	# syscall 9
        syscall
        add $t9, $v0, $zero # El nodo lo guardamos en  $t9

        sw $t1, 0($t9)      # Este nodo guarda 2
        sw $t9, 4($a1)      # El nodo anterior en $t8 apunta a este nuevo nodo en $t9
        add $a1, $t9, $zero # guarda la dirección del nodo anterior
        
        addi $s1,$s1,1
        j loop
    
    end:
        add $t1, $zero, $zero 
        sw $t1, 4($t9)      # Y el nuevo nodo apunta a 0 o NULL
        
        add $a0, $zero, $t8     # Le damos como argumento a la función el primer nodo
        jal funcion 
        #PRINT_string_asciiz(salto)
        PRINT_int_register($s2)
        li $v0, 10 		# 10 is the exit syscall.
	syscall 		# do the syscall.
	
funcion:
    lw $t0, 4($a0)              # Cargamos el puntero de este nodo
    beq $t0, $zero, FIN         # ¿Es el puntero NULL?, si lo es vamos a FIN
    add $t1, $zero, $a0         # copiamos a $t1 el nodo
    lw $a1, 0($a0)              # cargamos el elemento en el nodo actual a $a0 para imprimirlo
    #PRINT_int_register($a1)
    #PRINT_string_asciiz(espacio)
    suma($s2, $a1)    
    addi $sp, $sp, -8           # necesitamos guardar dos registros en el stack
    sw $t1, 0($sp)              # $t1 tenia el nodo actual
    sw $ra, 4($sp)              # guardamos ra para para recursiva
    lw $a0, 4($t1)              # cargamos la direccion de memoria que apunta el siguiente nodo
    jal funcion         
    lw $ra, 4($sp)              # cuando termina la funcion recuperamos ra
    lw $a0, 0($sp)              # y recuperamos el nodo original
    addi $sp, $sp, 8            # restauramos el stack
    jr $ra                      # volvemos

FIN:                        # caso en que el siguiente nodo sea null
    lw $a1, 0($a0)              # igual tiene un elemento asi que lo cargamos
    #PRINT_int_register($a1)
    suma($s2, $a1)
    jr $ra                      # retornamos

