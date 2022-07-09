.data
	menu: .ascii "\n===== MENU =====\n1.Input arr\n2.Print arr\n"
		.ascii "3.List primes\n4.List perfects\n"
		.ascii "5.Count perfect-squares\n6.Sum all palindromes\n"
		.ascii "7.Find max value\n8.Sort increasingly\n9.Exit\n"
		.asciiz "=====================\n"
	
	optionPrompt: .asciiz "Input option: "
	invalidPrompt: .asciiz "Invalid option. Please input again!"
	
	arrSizePrompt: .asciiz "Input size of arr: "
	arrInputOpen: .asciiz "arr["
	arrInputClose: .asciiz "] = "
	
	printArr: .asciiz "The current arr: "
	printPrimes: .asciiz "Primes: "
	printPerfects: .asciiz "Perfects: "
	countSquares: .asciiz "Number of perfect-squares: "
	sumPalindromes: .asciiz "Sum of palindromes: "
	largestValue: .asciiz "Max value: "
	printSortedAsc: .asciiz "Sorted arr: "
	
	arrSize: .word 0
	arr: .space 400
.text
.globl main
main:
	li $v0, 4
	la $a0, arrSizePrompt #ask for size
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 #s0 stores arrSize
	
	la $s1, arr #s1 stores array's address
	
	# loop for inputting elements
	li $t0, 0
	main_WhileArrIn:
		li $v0, 4
		la $a0, arrInputOpen #print "arr["
		syscall
		
		li $v0, 1
		move $a0, $t0 #print i
		syscall
		
		li $v0, 4
		la $a0, arrInputClose #print "] ="
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, ($s1)
		addi $s1, $s1, 4
		
		addi $t0, $t0, 1
		blt $t0, $s0, main_WhileArrIn

PRINT_MENU:
	la $s1, arr #load array's address into $s1 each time printing the menu
	
	li $v0, 4
	la $a0, menu
	syscall
	
	li $v0, 4
	la $a0, optionPrompt
	syscall
	
	li $v0, 5
	syscall
	
	#switch case
	beq $v0, 1, main #to input a new array, jump back to main
	beq $v0, 2, PRINT_ARR
	beq $v0, 3, PRINT_PRIMES
	beq $v0, 4, PRINT_PERFECTS
	beq $v0, 5, COUNT_SQUARES
	beq $v0, 6, SUM_PALINDROMES
	beq $v0, 7, GET_LARGEST
	beq $v0, 8, SORT_ASC_AND_PRINT
	beq $v0, 9, EXIT
	
	li $v0, 4
	la $a0, invalidPrompt #if all cases fail, notify user and ask for reinput
	syscall
	
	b PRINT_MENU #loop back to menu until a valid case

PRINT_ARR:
	li $v0, 4
	la $a0, printArr
	syscall
	
	la $a1, arr #pass array's address as argument
	move $a2, $s0 #pass arrSize as argument
	jal _PRINT_ARR
	
	b PRINT_MENU

PRINT_PRIMES:
	li $v0, 4
	la $a0, printPrimes
	syscall
	
	la $a1, arr #pass array's address as argument
	move $a2, $s0 #pass arrSize as argument
	jal _PRINT_PRIMES
	
	b PRINT_MENU
	
PRINT_PERFECTS:
	li $v0, 4
	la $a0, printPerfects
	syscall
	
	la $a1, arr #pass array's address as argument
	move $a2, $s0 #pass arrSize as argument
	jal _PRINT_PERFECTS

	b PRINT_MENU
	
COUNT_SQUARES:
	li $v0, 4
	la $a0, countSquares
	syscall
	
	la $a0, arr #pass array's address as argument
	move $a1, $s0 #pass arrSize as argument
	jal _COUNT_SQUARES
	
	li $v0, 1
	move $a0, $v1 #print the result in $v1
	syscall
	
	b PRINT_MENU

SUM_PALINDROMES:
	li $v0, 4
	la $a0, sumPalindromes
	syscall
	
	la $a0, arr #pass array's address as argument
	move $a1, $s0 #pass arrSize as argument
	jal _SUM_PALIN
	
	li $v0, 1
	move $a0, $v1 #print the result in $v1
	syscall
	
	b PRINT_MENU
	
GET_LARGEST:
	li $v0, 4
	la $a0, largestValue
	syscall
	
	la $a0, arr #pass array's address as argument
	move $a1, $s0 #pass arrSize as argument
	jal _GET_LARGEST
	
	li $v0, 1
	move $a0, $v1 #print the result in $v1
	syscall
	
	b PRINT_MENU

SORT_ASC_AND_PRINT:
	li $v0, 4
	la $a0, printSortedAsc
	syscall
	
	la $a0, arr #pass array's address as argument
	move $a1, $s0 #pass arrSize as argument
	jal _INSERTION_SORT_ASC
	
	la $a1, arr #pass array's address as argument
	move $a2, $s0 #pass arrSize as argument
	jal _PRINT_ARR
	
	b PRINT_MENU
	
EXIT:
	li $v0, 10
	syscall
	
_PRINT_ARR: #$a1: array, $a2: size, $a0 is reserved for printing
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	
	li $t0, 0
	bge $t0, $a2, _PRINT_ARR_End #i >= size, return
	
	_PRINT_ARR_WhileArrOut:
		li $v0, 1
		lw $a0, ($a1)
		syscall
		
		li $v0, 11
		li $a0, 32 #print space
		syscall
		
		addi $a1, $a1, 4
		addi $t0, $t0, 1
		blt $t0, $a2, _PRINT_ARR_WhileArrOut
		
	_PRINT_ARR_End:	
		lw $ra, ($sp)
		lw $t0, 4($sp)
	
		addi $sp, $sp, 100
		jr $ra

_PRINT_PRIMES: #$a1: array, $a2: size, $a0 is reserved for printing
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	
	li $t0, 0
	bge $t0, $a2, _PRINT_PRIMES_End #i >= size, return
	
	_PRINT_PRIMES_While:
		lw $a0, ($a1) #pass each element as argument
		jal _CHECK_PRIME
		
		beqz $v0, _PRINT_PRIMES_NotPrime
		
		li $v0, 1
		lw $a0, ($a1)
		syscall
		
		li $v0, 11
		li $a0, 32
		syscall
		
		_PRINT_PRIMES_NotPrime:
		addi $a1, $a1, 4
		addi $t0, $t0, 1
		blt $t0, $a2, _PRINT_PRIMES_While

	_PRINT_PRIMES_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		
		addi $sp, $sp, 100
		jr $ra
	
_CHECK_PRIME: #$a0: integer | return $v0: 1 for prime, 0 for non-prime
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #temp
	sw $t2, 12($sp) #remainder
	
	ble $a0, 1, _CHECK_PRIME_False #integer <= 1, return false
	ble $a0, 3, _CHECK_PRIME_True #integer <= 3, return true
	
	li $t0, 2
	div $a0, $t0
	mfhi $t2 #$t2 = integer % 2
	beqz $t2, _CHECK_PRIME_False #integer % 2 == 0, return false
	
	li $t0, 3
	div $a0, $t0
	mfhi $t2 #$t2 = integer % 3
	beqz $t2, _CHECK_PRIME_False #integer % 3 == 0, return false
	
	li $t0, 5
	mul $t1, $t0, $t0 #i * i
	bgt $t1, $a0, _CHECK_PRIME_True #i * i > integer, return true
	
	_CHECK_PRIME_While:
		div $a0, $t0
		mfhi $t2
		beqz $t2, _CHECK_PRIME_False #integer % i == 0, return false
		
		mul $t1, $t0, $t0
		addi $t0, $t0, 1 #i++
		ble $t1, $a0, _CHECK_PRIME_While #i * i <= integer, continue
	
	_CHECK_PRIME_True:
		li $v0, 1
		b _CHECK_PRIME_End
		
	_CHECK_PRIME_False:
		li $v0, 0

	_CHECK_PRIME_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
	
		addi $sp, $sp, 100
		jr $ra

_PRINT_PERFECTS: #$a1: array, $a2: size, $a0 is reserved for printing
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i

	li $t0, 0
	bge $t0, $a2, _PRINT_PERFECTS_End #i >= size, return
	
	_PRINT_PERFECTS_While:
		lw $a0, ($a1) #pass each element as argument
		jal _CHECK_PERFECT
		
		beqz $v0, _PRINT_PERFECTS_NotPerfect
		
		li $v0, 1
		lw $a0, ($a1)
		syscall
		
		li $v0, 11
		li $a0, 32
		syscall
		
		_PRINT_PERFECTS_NotPerfect:
		
		addi $a1, $a1, 4
		addi $t0, $t0, 1
		blt $t0, $a2, _PRINT_PERFECTS_While
	
	_PRINT_PERFECTS_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		
		addi $sp, $sp, 100
		jr $ra
		
_CHECK_PERFECT: #$a0: integer | return $v0: 1 for perfect, 0 for non-perfect
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #sum of divisors
	sw $t2, 12($sp) #temp
	sw $t3, 16($sp) #quotient
	
	li $t0, 2
	li $t1, 1
	
	mul $t2, $t0, $t0
	bgt $t2, $a0, _CHECK_PERFECT_Test #i * i > integer, skip the loop
	
	_CHECK_PERFECT_While:
		div $a0, $t0
		mfhi $t2 #integer % i
		mflo $t3 #integer / i
		bnez $t2, _CHECK_PERFECT_WhileContinue #integer % i != 0, continue
		
		mul $t2, $t0, $t0
		bne $t2, $a0, _CHECK_PERFECT_WhileIf #if(i * i != integer), do
		
		add $t1, $t1, $t0 #sum += i
		b _CHECK_PERFECT_WhileContinue
		
		_CHECK_PERFECT_WhileIf:
			add $t1, $t1, $t0 #sum += i
			add $t1, $t1, $t3 #sum += integer / i
			
		_CHECK_PERFECT_WhileContinue:
		addi $t0, $t0, 1
		mul $t2, $t0, $t0
		ble $t2, $a0, _CHECK_PERFECT_While #i * i <= integer, continue
		
	_CHECK_PERFECT_Test:
		bne $t1, $a0, _CHECK_PERFECT_False #sum != integer, return false
		beq $a0, 1, _CHECK_PERFECT_False #integer == 1, return false
		
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
		
_COUNT_SQUARES: #$a0: array, $a1: size | return count in $v1
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #count
	sw $t2, 12($sp) #array's address
	
	move $t2, $a0
	li $t1, 0
	li $t0, 0
	bge $t0, $a1, _COUNT_SQUARES_End #i >= size, return 0
	
	_COUNT_SQUARES_While:
		lw $a0, ($t2) #pass each element as argument
		jal _CHECK_SQUARE
		beqz $v0, _COUNT_SQUARES_NotSquare
		
		addi $t1, $t1, 1
		
		_COUNT_SQUARES_NotSquare:
		addi $t2, $t2, 4
		addi $t0, $t0, 1
		blt $t0, $a1, _COUNT_SQUARES_While
	
	move $v1, $t1
	
	_COUNT_SQUARES_End:
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		
		addi $sp, $sp, 100
		jr $ra
	
_CHECK_SQUARE: #$a0: integer | return $v0: 1 for perfect square, 0 for non-perfect square
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #left
	sw $t1, 8($sp) #right
	sw $t2, 12($sp) #mid
	sw $t3, 16($sp) #temp
	
	li $t0, 1 #left = 1
	move $t1, $a0 #right = integer
	
	bgt $t0, $t1, _CHECK_SQUARE_False #left > right, return 0
	
	_CHECK_SQUARE_While:
		add $t2, $t0, $t1 #mid = left + right
		srl $t2, $t2, 1 #mid /= 2
		mul $t3, $t2, $t2 #temp = mid * mid
		
		beq $t3, $a0, _CHECK_SQUARE_True #temp == integer, return true
		blt $t3, $a0, _CHECK_SQUARE_WhileIf #temp < integer, do
		
		addi $t1, $t2, -1 #right = mid - 1
		b _CHECK_SQUARE_WhileContinue
		
		_CHECK_SQUARE_WhileIf:
			addi $t0, $t2, 1 #left = mid + 1
		
		_CHECK_SQUARE_WhileContinue:
		ble $t0, $t1, _CHECK_SQUARE_While #while(left <= right)
	
	_CHECK_SQUARE_False:
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

_SUM_PALIN: #$a0: array, $a1: size | return sum in $v1
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #sum
	sw $t2, 12($sp) #temp
	sw $t3, 12($sp) #array's address
	
	move $t3, $a0
	li $t1, 0
	li $t0, 0
	bge $t0, $a1, _SUM_PALIN_End #i >= size, return 0
	
	_SUM_PALIN_While:
		lw $a0, ($t3) #pass each element as argument
		move $t2, $a0
		jal _CHECK_PALIN
		beqz $v0, _SUM_PALIN_NotPalin
		
		add $t1, $t1, $t2
		
		_SUM_PALIN_NotPalin:
		addi $t3, $t3, 4
		addi $t0, $t0, 1
		blt $t0, $a1, _SUM_PALIN_While
	
	_SUM_PALIN_End:
		move $v1, $t1
	
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		
		addi $sp, $sp, 100
		jr $ra
	
_CHECK_PALIN: #$a0: integer | return $v0: 1 for palindrome, 0 for non-palindrome
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #integer
	sw $t1, 8($sp) #reversed
	
	move $t0, $a0
	jal _GET_REVERSE
	move $t1, $v1
	beq $t0, $t1, _CHECK_PALIN_True #integer == reversed, return true
	
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
		
_GET_REVERSE: #$a0: integer | return reversed in $v1
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #reversed
	sw $t1, 8($sp) #holds 10 as a divisor for div usage
	sw $t2, 12($sp) #remainder
	
	li $t0, 0
	li $t1, 10
	ble $a0, 0, _GET_REVERSE_End #integer <= 0, return 0

	_GET_REVERSE_While:
		div $a0, $t1
		mfhi $t2 #integer % 10
		mflo $a0 #integer /= 10
		
		mul $t0, $t0, $t1 #reversed *= 10
		add $t0, $t0, $t2 #reversed += remainder
		
		bgtz $a0, _GET_REVERSE_While #while(integer > 0)
	
	_GET_REVERSE_End:
		move $v1, $t0
		
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		
		addi $sp, $sp, 100
		jr $ra

_GET_LARGEST: #$a0: array, $a1: size | return largest in $v1
	addi $sp, $sp, -100
	sw $ra, ($sp)
	sw $t0, 4($sp) #i
	sw $t1, 8($sp) #largest
	sw $t2, 12($sp) #curr
	
	lw $t1, ($a0) #choose the first element to be the largest
	addi $a0, $a0, 4
	
	li $t0, 1
	bge $t0, $a1, _GET_LARGEST_End #i >= size, return first element
	
	_GET_LARGEST_While:
		lw $t2, ($a0)
		ble $t2, $t1, _GET_LARGEST_WhileContinue #curr <= largest, continue
		move $t1, $t2 #largest = curr
		
		_GET_LARGEST_WhileContinue:
		addi $a0, $a0, 4
		addi $t0, $t0, 1
		blt $t0, $a1, _GET_LARGEST_While #while(i < size)
	
	_GET_LARGEST_End:
		move $v1, $t1
		
		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
	
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
			
			addi $t4, $t4, 4 #offset += 4 (address of arr[j+1])
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
		blt $t0, $a1, _INSERTION_SORT_ASC_OuterWhile #while(i < size)
		
	_INSERTION_SORT_ASC_End:
 		lw $ra, ($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		
		addi $sp, $sp, 100
		jr $ra
