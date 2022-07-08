.data
	inputPrompt: .asciiz "Enter a positive integer: "
	isPalin: .asciiz " is Palindrome"
	notPalin: .asciiz " is not Palindrome"
.text
.globl main
main:
	li $v0, 4
	la $a0, inputPrompt
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	move $a0, $s0
	jal _CHECK_PALIN
	move $t0, $v0
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	beqz $t0, NOT_PALIN
	
	li $v0, 4
	la $a0, isPalin
	syscall
	
	j EXIT

NOT_PALIN:
	li $v0, 4
	la $a0, notPalin
	syscall

EXIT:
	li $v0, 10
	syscall
	
_CHECK_PALIN:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	
	move $t0, $a0
	jal _GET_REVERSE
	move $t1, $v0
	beq $t0, $t1, _CHECK_PALIN_True
	
	li $v0, 0
	b _CHECK_PALIN_End
	
	_CHECK_PALIN_True:
		li $v0, 1
		
	_CHECK_PALIN_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		
		addi $sp, $sp, 100
		jr $ra
		
_GET_REVERSE:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	
	li $t0, 0
	li $t1, 10
	ble $a0, 0, _GET_REVERSE_End

	_GET_REVERSE_While:
		div $a0, $t1
		mfhi $t2
		mflo $a0
		
		mul $t0, $t0, $t1
		add $t0, $t0, $t2
		
		bgtz $a0, _GET_REVERSE_While
	
	_GET_REVERSE_End:
		move $v0, $t0
		
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		
		addi $sp, $sp, 100
		jr $ra