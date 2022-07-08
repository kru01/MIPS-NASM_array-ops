%include "io.inc"

extern _printf
extern _scanf
extern _getch

section .data
    input db "Input integer: ", 0
    isSquare db " is perfect square", 0
    notSquare db " is not perfect square", 0
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
    call _checkSquare
    add esp, 4
    push eax

    push dword [num]
    push fmtDsp
    call _printf
    add esp, 8
    
    pop eax
    cmp eax, 0
    je PRINT_NOT_SQUARE
    
    push isSquare
    call _printf
    add esp, 4
    
    jmp EXIT
    
PRINT_NOT_SQUARE:
    push notSquare
    call _printf
    add esp, 4
    
EXIT:
    xor eax, eax
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