%include "io.inc"

extern _printf
extern _scanf
extern _getch

section .data
    input db "Input integer: ", 0
    isPerfect db " is perfect", 0
    notPerfect db " is not perfect", 0
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
    call _checkPerfect
    add esp, 4
    push eax

    push dword [num]
    push fmtDsp
    call _printf
    add esp, 8
    
    pop eax
    cmp eax, 0
    je PRINT_NOT_PERFECT
    
    push isPerfect
    call _printf
    add esp, 4
    
    jmp EXIT
    
PRINT_NOT_PERFECT:
    push notPerfect
    call _printf
    add esp, 4
    
EXIT:
    xor eax, eax
    ret

_checkPerfect: ; args: int | return 1 for perfect, 0 for non-perfect in eax
    push ebp
    mov ebp, esp
    sub esp, 64
    
    push ecx ; loop i
    push edx ; remainder, temp
    push esi ; divisor
    push edi ; sum of divisors - sumDivs
    
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