%include "io.inc"

extern _printf
extern _scanf
extern _getch

section .data
    input db "Input integer: ", 0
    isPrime db " is prime", 0
    notPrime db " is not prime", 0
    fmtD db "%d", 0
    fmtDsp db "%d ", 0
    
section .bss
    num resd 1
    
section .text
global CMAIN
CMAIN:
    ;write your code here
    push input
    call _printf
    add esp, 4
    
    push num
    push fmtD
    call _scanf
    add esp, 8
    
    push dword [num]
    call _checkPrime
    add esp, 4
    push eax

    push dword [num]
    push fmtDsp
    call _printf
    add esp, 8
    
    pop eax
    cmp eax, 0
    je PRINT_NOT_PRIME
    
    push isPrime
    call _printf
    add esp, 4
    
    jmp EXIT
    
PRINT_NOT_PRIME:
    push notPrime
    call _printf
    add esp, 4
    
EXIT:
    xor eax, eax
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
    mov esi, 2 ; divisor
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
        mov esi, ecx ; divisor
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