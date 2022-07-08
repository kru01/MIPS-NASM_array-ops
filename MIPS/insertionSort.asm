.data
	sorted: .asciiz "\nSorted: "
	
	arrSize: .word 0
	arr: .space 400
.text
.globl main
main:
	la $s0, arr
	li $s1, 5
	
	li $t0, 3
	sw $t0, ($s0)
	addi $s0, $s0, 4
	
	li $t0, 5
	sw $t0, ($s0)
	addi $s0, $s0, 4
	
	li $t0, 3
	sw $t0, ($s0)
	addi $s0, $s0, 4
	
	li $t0, 2
	sw $t0, ($s0)
	addi $s0, $s0, 4
	
	li $t0, 9
	sw $t0, ($s0)
	addi $s0, $s0, 4
	
	la $s0, arr
	move $a1, $s1
	jal _PRINT_ARR
	
	la $a0, arr
	move $a1, $s1
	jal _INSERTION_SORT_ASC
	
	li $v0, 4
	la $a0, sorted
	syscall
	
	move $a1, $s1
	jal _PRINT_ARR
EXIT:
	li $v0, 10
	syscall
	
_PRINT_ARR:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	
	li $t0, 0
	bge $t0, $a1, _PRINT_ARR_End
	
	_PRINT_ARR_While:
		li $v0, 1
		lw $a0, ($s0)
		syscall
		
		li $v0, 11
		li $a0, 32
		syscall
		
		addi $s0, $s0, 4
		addi $t0, $t0, 1
		blt $t0, $a1, _PRINT_ARR_While
	
	_PRINT_ARR_End:
		la $s0, arr
		
		lw $ra, ($sp)
		lw $t0, 4($sp)
		
		addi $sp, $sp, 100
		jr $ra
		
_INSERTION_SORT_ASC: #$a0: array, $a1: size
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #j
	sw $t2, 12($sp) #arr[i] or arr[j]
	sw $t3, 16($sp) #x (key)
	sw $t4, 20($sp) #offset for arr[i] or arr[j]
	
	li $t0, 1
	bge $t0, $a1, _INSERTION_SORT_ASC_End
	
	_INSERTION_SORT_ASC_OuterWhile:
		sll $t4, $t0, 2 #offset = i * 4
		add $t4, $a0, $t4 #address of arr[i]
		lw $t3, ($t4) #key = arr[i]
		addi $t1, $t0, -1 #j = i - 1
		
		b _INSERTION_SORT_ASC_InnerWhileContinue
		
		_INSERTION_SORT_ASC_InnerWhile:
			sll $t4, $t1, 2 #offset = j * 4
			add $t4, $a0, $t4 #address of arr[j]
			lw $t2, ($t4) #arr[j]
			
			addi $t4, $t4, 4 #offset *= 4 (address of arr[j+1])
			sw $t2, ($t4) #arr[j+1] = arr[j]
			
			addi $t1, $t1, -1 #j--
			
			_INSERTION_SORT_ASC_InnerWhileContinue:
			bltz $t1, _INSERTION_SORT_ASC_OuterWhileContinue #j < 0, continue
			sll $t4, $t1, 2 #offset = j * 4
			add $t4, $a0, $t4 #address of arr[j]
			lw $t2, ($t4) #arr[j]
		
			#arr[j] <= key, continue
			ble $t2, $t3, _INSERTION_SORT_ASC_OuterWhileContinue
			b _INSERTION_SORT_ASC_InnerWhile
			
		_INSERTION_SORT_ASC_OuterWhileContinue:
		addi $t4, $t1, 1 #offset = j + 1
		sll $t4, $t4, 2 #offset *= 4
		add $t4, $a0, $t4 #address of arr[j+1]
		sw $t3, ($t4) #arr[j+1] = key
		
		addi $t0, $t0, 1 #i++
		blt $t0, $a1, _INSERTION_SORT_ASC_OuterWhile
		
	_INSERTION_SORT_ASC_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		
		addi $sp, $sp, 100
		jr $ra