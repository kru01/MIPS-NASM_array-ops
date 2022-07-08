.data
	inputNum: .asciiz "Input a positive integer: "
	isSquare: .asciiz " is perfect-square"
	notSquare: .asciiz " is not perfect-square"
.text
.globl main
main:
	li $v0, 4
	la $a0, inputNum
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	move $a0, $s0
	jal _CHECK_SQUARE
	move $t0, $v0
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	beqz $t0, NOT_SQUARE
	
	li $v0, 4
	la $a0, isSquare
	syscall
	
	j EXIT

NOT_SQUARE:
	li $v0, 4
	la $a0, notSquare
	syscall
	
EXIT:
	li $v0, 10
	syscall
	
_CHECK_SQUARE:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	li $t0, 1 #left
	move $t1, $a0 #right
	
	bgt $t0, $t1, _CHECK_SQUARE_End
	
	_CHECK_SQUARE_While:
		add $t2, $t0, $t1
		srl $t2, $t2, 1 #mid
		mul $t3, $t2, $t2
		
		beq $t3, $a0, _CHECK_SQUARE_True
		blt $t3, $a0, _CHECK_SQUARE_WhileIf
		
		addi $t1, $t2, -1
		b _CHECK_SQUARE_WhileContinue
		
		_CHECK_SQUARE_WhileIf:
			addi $t0, $t2, 1
		
		_CHECK_SQUARE_WhileContinue:
		ble $t0, $t1, _CHECK_SQUARE_While
	
	li $v0, 0
	b _CHECK_SQUARE_End
			
	_CHECK_SQUARE_True:
		li $v0, 1
		
	_CHECK_SQUARE_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		
		addi $sp, $sp, 100
		jr $ra