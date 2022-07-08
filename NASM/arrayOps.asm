%include "io.inc"

extern _printf
extern _scanf

section .data
    menu db `\n===== MENU =====\n1.Input arr\n2.Print arr\n`
         db `3.List primes\n4.List perfects\n`
         db `5.Count perfect-squares\n6.Sum all palindromes\n`
         db `7.Find max value\n8.Sort increasingly\n9.Exit\n`
         db `=====================\n`, 0
         
    optPrompt db "Input option: ", 0
    invalidOpt db "Invalid option. Please input again!", 0
    
    arrSizePrompt db "Input size of arr: ", 0
    arrDataIn db "arr[%d] = ", 0
    
    printArr db "The current arr: ", 0
    printPrimes db "Primes: ", 0
    printPerfects db "Perfects: ", 0
    countSquares db "Number of perfect-squares: ", 0
    sumPalins db "Sum of palindromes: ", 0
    getMax db "Max value: ", 0
    printSorted db "Sorted arr: ", 0
    
    fmtDec db "%d", 0
    fmtDecSp db "%d ", 0
    
section .bss
    arrSize resd 1
    arr resd 100 ; int arr because real numbers would be impossible for most of the functions
    tempInt resd 1 ; int for utilities
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    jmp INPUT_ARR
    
OPTION_MENU:
    push menu ; print menu
    call _printf
    add esp, 4
    
    push optPrompt ; ask for choice
    call _printf
    add esp, 4
    
    push tempInt ; input choice
    push fmtDec
    call _scanf
    add esp, 8
    
    ; switch cases
    cmp dword [tempInt], 1
    je INPUT_ARR
    cmp dword [tempInt], 2
    je PRINT_ARR
    cmp dword [tempInt], 3
    je PRINT_PRIMES
    cmp dword [tempInt], 4
    je PRINT_PERFECTS
    cmp dword [tempInt], 5
    je COUNT_SQUARES
    cmp dword [tempInt], 6
    je SUM_PALINS
    cmp dword [tempInt], 7
    je GET_MAX
    cmp dword [tempInt], 8
    je SORT_INC
    cmp dword [tempInt], 9
    je EXIT
    
    push invalidOpt ; if all cases failed, notify user and ask for reinput
    call _printf
    add esp, 4
    
    jmp OPTION_MENU ; loop back to menu until valid choice
    
INPUT_ARR:
    push arrSizePrompt ; ask for size
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push arrSize ; pass arrSize's address as argument
    call _inputArr
    add esp, 8
    
    jmp OPTION_MENU

PRINT_ARR:
    push printArr ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _printArr
    add esp, 8
    
    jmp OPTION_MENU

PRINT_PRIMES:
    push printPrimes ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _printPrimes
    add esp, 8
    
    jmp OPTION_MENU

PRINT_PERFECTS:
    push printPerfects ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _printPerfects
    add esp, 8
    
    jmp OPTION_MENU
    
COUNT_SQUARES:
    push countSquares ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _countSquares
    add esp, 8
    
    push eax ; print the count stored in eax
    push fmtDec
    call _printf
    add esp, 8
    
    jmp OPTION_MENU
    
SORT_INC:
    push printSorted ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _insertionSortInc
    add esp, 8
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _printArr
    add esp, 8
    
    jmp OPTION_MENU

SUM_PALINS:
    push sumPalins ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _sumPalins
    add esp, 8
    
    push eax ; print the sum stored in eax
    push fmtDec
    call _printf
    add esp, 8
    
    jmp OPTION_MENU
    
GET_MAX:
    push getMax ; print intro
    call _printf
    add esp, 4
    
    push arr ; pass arr's address as argument
    push dword [arrSize] ; pass arrSize as argument
    call _getMax
    add esp, 8
    
    push eax ; print the max stored in eax
    push fmtDec
    call _printf
    add esp, 8
    
    jmp OPTION_MENU
    
EXIT:
    xor eax, eax
    ret
      
global _inputArr
_inputArr: ; args: arr's address, arrSize's address | return void
    push ebp
    mov ebp, esp
    sub esp, 64
   
    push edx ; arr's base address
    push esi ; arrSize's address
    push ecx ; index
    
    mov esi, [ebp + 8]
    push esi ; input size
    push fmtDec
    call _scanf
    add esp, 8
    
    cmp dword [esi], 0 ; if(size <= 0) return
    jle _inputArr.End
    
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]
    
    _inputArr.While:
        push ecx ; preserve ecx and edx since printf and scanf might modify them
        push edx
        
        push ecx ; print "arr[i] = "
        push arrDataIn
        call _printf
        add esp, 8
        
        pop edx ; get edx back for arr input
        push edx ; preserve again
        
        push edx ; input arr[i]
        push fmtDec
        call _scanf
        add esp, 8
        
        pop edx ; get edx back
        pop ecx ; get ecx back
         
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [esi] ; if(index < size) loop
        jl _inputArr.While
    
    _inputArr.End:
        pop ecx
        pop esi
        pop edx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret
        
global _printArr
_printArr: ; args: arr's address, arrSize | return void
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _printArr.End
    
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]
    
    _printArr.While:
        push edx ; preserve edx and ecx
        push ecx
        
        push dword [edx] ; print arr[i]
        push fmtDecSp
        call _printf
        add esp, 8
        
        pop ecx ; restore
        pop edx
        
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _printArr.While
    
    _printArr.End:
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

global _printPrimes
_printPrimes: ; args: arr's address, arrSize | return void
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _printPrimes.End
    
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]

    _printPrimes.While:
        push edx ; preserve edx and ecx
        push ecx
        
        push dword [edx] ; pass arr[i] as argument
        call _checkPrime
        add esp, 4
        
        test eax, eax ; returned == 0 means false
        je _printPrimes.NotPrime
        
        push dword [edx] ; print prime
        push fmtDecSp
        call _printf
        add esp, 8
        
        _printPrimes.NotPrime:
        pop ecx ; restore
        pop edx
        
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _printPrimes.While
    
    _printPrimes.End:
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

_checkPrime: ; args: int | return 1 for prime, 0 for non-prime in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; loop i
    push edx ; remainder, temp
    push esi ; divisor
    
    cmp dword [ebp + 8], 1 ; int <= 1, return false
    jle _checkPrime.False
    cmp dword [ebp + 8], 3 ; int <= 3, return true
    jle _checkPrime.True
    
    mov edx, 0 ; clear dividend, high
    mov eax, [ebp + 8] ; dividend, low
    mov esi, 2 ; divisor = 2
    div esi ; eax = quotient, edx = remainder
    cmp edx, 0 ; if(int % 2 == 0) return false
    je _checkPrime.False
    
    mov edx, 0 ; clear dividend, high
    mov eax, [ebp + 8] ; dividend, low
    mov esi, 3 ; divisor
    div esi ; eax = quotient, edx = remainder
    cmp edx, 0 ; if(int % 3 == 0) return false
    je _checkPrime.False
    
    mov edx, 0 ; clear edx
    mov eax, 5
    mov ecx, 5 ; i = 5
    mul ecx ; edx:eax = i * i
    cmp eax, [ebp + 8] ; if(i * i > int) return true
    jg _checkPrime.True
    
    _checkPrime.While:
        mov edx, 0 ; clear dividend, high
        mov eax, [ebp + 8] ; dividend, low
        mov esi, ecx ; divisor = i
        div esi ; eax = quotient, edx = remainder
        cmp edx, 0 ; if(int % i == 0) return false
        je _checkPrime.False
        
        mov edx, 0 ; clear edx
        mov eax, ecx
        mul ecx ; edx:eax = i * i
        inc ecx ; i++
        cmp eax, [ebp + 8] ; if(i * i <= int) loop
        jle _checkPrime.While
        
    _checkPrime.True:
        mov eax, 1
        jmp _checkPrime.End

    _checkPrime.False:
        mov eax, 0
    
    _checkPrime.End:
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret
        
global _printPerfects
_printPerfects: ; args: arr's address, arrSize | return void
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _printPerfects.End
    
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]

    _printPerfects.While:
        push edx ; preserve edx and ecx
        push ecx
        
        push dword [edx] ; pass arr[i] as argument
        call _checkPerfect
        add esp, 4
        
        test eax, eax ; returned == 0 means false
        je _printPerfects.NotPerfect
        
        push dword [edx] ; print perfect
        push fmtDecSp
        call _printf
        add esp, 8
        
        _printPerfects.NotPerfect:
        pop ecx ; restore
        pop edx
        
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _printPerfects.While
    
    _printPerfects.End:
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

_checkPerfect: ; args: int | return 1 for perfect, 0 for non-perfect in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; loop i
    push edx ; remainder, temp
    push esi ; divisor
    push edi ; sum of divisors (sumDivs)
    
    mov edi, 1 ; sumDivs = 1
    
    mov edx, 0 ; clear edx
    mov eax, 2
    mov ecx, 2 ; i = 5
    mul ecx ; edx:eax = i * i
    cmp eax, [ebp + 8] ; if(i * i > int) skip the loop
    jg _checkPerfect.Test
    
    _checkPerfect.While:
        mov edx, 0 ; clear dividend, high
        mov eax, [ebp + 8] ; dividend, low
        mov esi, ecx ; divisor = i
        div esi ; eax = quotient, edx = remainder
        cmp edx, 0 ; if(int % i != 0) return false
        jne _checkPerfect.WhileContinue
        
        push eax ; store quotient for WhileIf
        mov edx, 0 ; clear edx
        mov eax, ecx
        mul ecx ; edx:eax = i * i
        cmp eax, [ebp + 8] ; if(i * i != int) jump to WhileIf
        jne _checkPerfect.WhileIf
        
        pop eax ; discard quotient when WhileIf is not satisfied
        add edi, ecx ; sumDivs += i
        jmp _checkPerfect.WhileContinue
        
        _checkPerfect.WhileIf:
        add edi, ecx ; sumDivs += i
        pop eax ; get quotient
        add edi, eax ; sumDivs += int / i
    
        _checkPerfect.WhileContinue:
        inc ecx
        mov edx, 0 ; clear edx
        mov eax, ecx
        mul ecx ; edx:eax = i * i
        cmp eax, [ebp + 8] ; if(i * i <= int) loop
        jle _checkPerfect.While
        
    _checkPerfect.Test:
        cmp edi, [ebp + 8] ; if(sumDivs != int) return false
        jne _checkPerfect.False
        cmp dword [ebp + 8], 1 ; if(int == 1) return false
        je _checkPerfect.False
        
        mov eax, 1
        jmp _checkPerfect.End

    _checkPerfect.False:
        mov eax, 0
    
    _checkPerfect.End:
        pop edi
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

global _countSquares
_countSquares: ; args: arr's address, arrSize | return count as int in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    push esi ; squaresCount
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _countSquares.End
    
    mov esi, 0 ; squaresCount = 0
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]

    _countSquares.While:        
        push dword [edx] ; pass arr[i] as argument
        call _checkSquare
        add esp, 4
        
        test eax, eax ; returned == 0 means false
        je _countSquares.NotSquare
        inc esi ; squaresCount++
        
        _countSquares.NotSquare:
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _countSquares.While
        
    _countSquares.End:
        mov eax, esi ; return the count in eax
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

_checkSquare: ; args: int | return 1 for perfect square, 0 for non-perfect-square in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; left
    push edx ; right
    push esi ; mid
    push edi ; temp
    
    mov ecx, 1 ; left = 1
    mov edx, [ebp + 8] ; right = int
    cmp ecx, edx ; if(left > right) return false
    jg _checkSquare.False
    
    _checkSquare.While:
        mov edi, ecx ; temp = left
        add edi, edx ; temp += right
        mov esi, edi ; mid = temp (mid = left + right)
        shr esi, 1 ; mid /= 2
       
        push edx ; store right
        mov edx, 0 ; clear edx
        mov eax, esi
        mul esi ; edx:eax = mid * mid
        mov edi, eax ; temp = mid * mid
        pop edx ; get right back
        
        cmp edi, [ebp + 8]
        je _checkSquare.True ; if(temp == int) return true
        jl _checkSquare.WhileIf ; if(temp < int) jump to WhileIf
        
        mov edx, esi ; right = mid
        dec edx ; right--
        jmp _checkSquare.WhileContinue
        
        _checkSquare.WhileIf:
        mov ecx, esi ; left = mid
        inc ecx ; left++
        
        _checkSquare.WhileContinue:
        cmp ecx, edx ; if(left <= right) loop
        jle _checkSquare.While
    
    _checkSquare.False:
        mov eax, 0
        jmp _checkSquare.End
        
    _checkSquare.True:
        mov eax, 1
    
    _checkSquare.End:
        pop edi
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

global _sumPalins
_sumPalins: ; args: arr's address, arrSize | return sum as int in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    push esi ; palinsSum
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _sumPalins.End
    
    mov esi, 0 ; palinsSum = 0
    mov ecx, 0 ; index = 0
    mov edx, [ebp + 12] ; base address = arr[0]

    _sumPalins.While:        
        push dword [edx] ; pass arr[i] as argument
        call _checkPalin
        add esp, 4
        
        test eax, eax ; returned == 0 means false
        je _sumPalins.NotPalin
        add esi, [edx] ; palinsSum += arr[i]
        
        _sumPalins.NotPalin:
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _sumPalins.While
        
    _sumPalins.End:
        mov eax, esi ; return the sum in eax
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

_checkPalin: ; args: int | return 1 for palindrome, 0 for non-palindrome in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; reversed
    
    push dword [ebp + 8] ; pass int's value as argument
    call _getReversed
    add esp, 4
    
    mov ecx, eax ; reversed = returned
    cmp ecx, [ebp + 8] ; if(reversed == int) return true
    je _checkPalin.True
    
    mov eax, 0
    jmp _checkPalin.End
        
    _checkPalin.True:
        mov eax, 1
    
    _checkPalin.End:
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret
        
_getReversed: ; args: int | return reversed as int in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; reversed
    push edx ; remainder
    push esi ; divisor or multiplicand
    
    mov ecx, 0 ; reversed = 0
    cmp dword [ebp + 8], 0 ; if(int <= 0) return reversed
    jle _getReversed.End
    
    _getReversed.While:
        mov edx, 0 ; clear dividend, high
        mov eax, [ebp + 8] ; dividend, low
        mov esi, 10 ; divisor = 10
        div esi ; eax = quotient, edx = remainder
        push edx ; store remainder
        
        mov dword [ebp + 8], eax ; int = quotient (int /= 10)
        
        mov edx, 0 ; clear edx
        mov eax, ecx
        mov esi, 10 ; multiplicand = 10
        mul esi ; edx:eax = reversed * 10
        mov ecx, eax ; reversed *= 10
        
        pop edx ; get remainder
        add ecx, edx ; reversed += remainder
        
        cmp dword [ebp + 8], 0 ; if(int > 0) loop
        jg _getReversed.While
        
    _getReversed.End:
        mov eax, ecx ; return reversed in eax
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

global _getMax
_getMax: ; args: arr's address, arrSize | return max as int in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; index
    push edx ; arr's base address
    push esi ; max
    
    mov esi, -999 ; set max = -999
    cmp dword [ebp + 8], 0 ; if(size <= 0) return max
    jle _getMax.End
    
    mov ecx, 1 ; index = 1
    mov edx, [ebp + 12] ; base address = arr[0]
    mov esi, [edx] ; choose first element to be max
    add edx, 4 ; move to second element
    
    cmp ecx, [ebp + 8] ; if(i >= size) return max
    jge _getMax.End

    _getMax.While:        
        cmp esi, [edx] ; if(max >= arr[i]) continue
        jge _getMax.WhileContinue
        mov esi, [edx] ; max = arr[i]
        
        _getMax.WhileContinue:
        add edx, 4 ; arr += 4
        inc ecx ; index++
        cmp ecx, [ebp + 8] ; if(index < size) loop
        jl _getMax.While
        
    _getMax.End:
        mov eax, esi ; return the max in eax
        pop esi
        pop edx
        pop ecx
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret

global _insertionSortInc
_insertionSortInc: ; args: arr's address, arrSize | return void
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push eax ; temp
    push ebx ; arr[i] or arr[j]
    push ecx ; loop i
    push edx ; loop j
    push esi ; key
    push edi ; offset for arr[i] or arr[j]
    
    cmp dword [ebp + 8], 0 ; if(size <= 0) return
    jle _insertionSortInc.End
    
    mov ecx, 1 ; i = 1
    cmp ecx, [ebp + 8] ; if(i >= size) return
    jge _insertionSortInc.End
    
    _insertionSortInc.OutWhile:
        mov edi, ecx ; offset = i
        shl edi, 2 ; offset *= 4 (offset = i * 4)
        
        mov eax, [ebp + 12] ; temp = arr[0]'s address
        add eax, edi ; temp += offset (arr[i]'s address)
        mov esi, [eax] ; key = arr[i]
        
        mov edx, ecx ; j = i
        dec edx ; j--
        jmp _insertionSortInc.InWhileContinue
        
        _insertionSortInc.InWhile:
            mov edi, edx ; offset = j
            shl edi, 2 ; offset *= 4 (offset = j * 4)
            
            mov eax, [ebp + 12] ; temp = arr[0]'s address
            add eax, edi ; temp += offset (arr[j]'s address)
            mov ebx, [eax] ; ebx = arr[j]
            
            add eax, 4 ; temp += 4 (arr[j + 1]'s address)
            mov dword [eax], ebx ; arr[j + 1] = arr[j]
            dec edx ; j--
            
            _insertionSortInc.InWhileContinue:
            cmp edx, 0 ; if(j < 0) continue
            jl _insertionSortInc.OutWhileContinue
            
            mov edi, edx ; offset = j
            shl edi, 2; offset *= 4 (offset = j * 4)
            mov eax, [ebp + 12] ; temp = arr[0]'s address
            add eax, edi ; temp += offset (arr[j]'s address)
            mov ebx, [eax] ; ebx = arr[j]
            
            cmp ebx, esi ; if(arr[j] <= key) continue
            jle _insertionSortInc.OutWhileContinue
            jmp _insertionSortInc.InWhile
        
        _insertionSortInc.OutWhileContinue:
        mov edi, edx ; offset = j
        inc edi ; offset++ (offset = j + 1)
        shl edi, 2 ; offset *= 4
        
        mov eax, [ebp + 12] ; temp = arr[0]'s address
        add eax, edi ; temp += offset (arr[j + 1]'s address)
        mov dword [eax], esi ; arr[j + 1] = key
        
        inc ecx ; i++
        cmp ecx, [ebp + 8] ; if(i < size) loop
        jl _insertionSortInc.OutWhile
        
    _insertionSortInc.End:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax
        
        add esp, 64
        mov esp, ebp
        pop ebp
        ret