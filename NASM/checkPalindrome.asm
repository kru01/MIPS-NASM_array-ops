%include "io.inc"

extern _printf
extern _scanf
extern _getch

section .data
    input db "Input integer: ", 0
    isPalin db " is palindrome", 0
    notPalin db " is not palindrome", 0
    fmtD db "%d", 0
    fmtDsp db "%d ", 0
    
section .bss
    num resd 1
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    push input
    call _printf
    add esp, 4
    
    push num
    push fmtD
    call _scanf
    add esp, 8
    
    push dword [num]
    call _checkPalin
    add esp, 4
    push eax

    push dword [num]
    push fmtDsp
    call _printf
    add esp, 8
    
    pop eax
    cmp eax, 0
    je PRINT_NOT_PALIN
    
    push isPalin
    call _printf
    add esp, 4
    
    jmp EXIT
    
PRINT_NOT_PALIN:
    push notPalin
    call _printf
    add esp, 4
    
EXIT:
    xor eax, eax
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