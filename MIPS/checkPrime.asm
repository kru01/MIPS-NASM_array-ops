.data
	inputNum: .asciiz "Input a positive integer: "
	isPrime: .asciiz " is prime"
	notPrime: .asciiz " is not prime"
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
	jal _CHECK_PRIME
	move $t0, $v0
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	beqz $t0, NOT_PRIME
	
	li $v0, 4
	la $a0, isPrime
	syscall
	
	j EXIT

NOT_PRIME:
	li $v0, 4
	la $a0, notPrime
	syscall

EXIT:
	li $v0, 10
	syscall
	
_CHECK_PRIME:
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	
	ble $a0, 1, _CHECK_PRIME_FALSE
	ble $a0, 3, _CHECK_PRIME_TRUE
	
	li $t0, 2
	div $a0, $t0
	mfhi $t2
	beqz $t2, _CHECK_PRIME_FALSE
	
	li $t0, 3
	div $a0, $t0
	mfhi $t2
	beqz $t2, _CHECK_PRIME_FALSE
	
	li $t0, 5
	mul $t1, $t0, $t0
	bgt $t1, $a0, _CHECK_PRIME_TRUE
	
	_CHECK_PRIME_While:
		div $a0, $t0
		mfhi $t2
		beqz $t2, _CHECK_PRIME_FALSE
		
		mul $t1, $t0, $t0
		addi $t0, $t0, 6
		ble $t1, $a0, _CHECK_PRIME_While
		
	b _CHECK_PRIME_TRUE
		
_CHECK_PRIME_FALSE:
	li $v0, 0
	b _CHECK_PRIME_END
	
_CHECK_PRIME_TRUE:
	li $v0, 1

_CHECK_PRIME_END:
	lw $ra, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	
	addi $sp, $sp, 100
	jr $ra
