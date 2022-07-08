.data
	inputNum: .asciiz "Input a positive integer: "
	isPerfect: .asciiz " is perfect"
	notPerfect: .asciiz " is not perfect"
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
	jal _CHECK_PERFECT
	move $t0, $v0
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	beqz $t0, NOT_PERFECT
	
	li $v0, 4
	la $a0, isPerfect
	syscall
	
	j EXIT

NOT_PERFECT:
	li $v0, 4
	la $a0, notPerfect
	syscall
	
EXIT:
	li $v0, 10
	syscall
	
_CHECK_PERFECT:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	li $t0, 2
	li $t1, 1
	
	mul $t2, $t0, $t0
	bgt $t2, $a0, _CHECK_PERFECT_Test
	
	_CHECK_PERFECT_While:
		div $a0, $t0
		mfhi $t2
		mflo $t3
		bnez $t2, _CHECK_PERFECT_WhileContinue
		
		mul $t2, $t0, $t0
		bne $t2, $a0, _CHECK_PERFECT_WhileIf
		
		add $t1, $t1, $t0
		b _CHECK_PERFECT_WhileContinue
		
		_CHECK_PERFECT_WhileIf:
			add $t1, $t1, $t0
			add $t1, $t1, $t3
			
		_CHECK_PERFECT_WhileContinue:
		addi $t0, $t0, 1
		mul $t2, $t0, $t0
		ble $t2, $a0, _CHECK_PERFECT_While
		
	_CHECK_PERFECT_Test:
		bne $t1, $a0, _CHECK_PERFECT_False
		beq $a0, 1, _CHECK_PERFECT_False
		
		li $v0, 1
		b _CHECK_PERFECT_End
	
	_CHECK_PERFECT_False:
		li $v0, 0
		
	_CHECK_PERFECT_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		
		addi $sp, $sp, 100
		jr $ra
