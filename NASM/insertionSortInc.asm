%include "io.inc"

extern _printf
extern _scanf
extern _getch

section .data
    printSorted db "Sorted: ", 0
    fmtD db "%d", 0
    fmtDsp db "%d ", 0
    
    arr dd 99, 75, 52, 33, 10
    arrSize dd 5
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    push arr
    push dword [arrSize]
    call _insertionSortInc
    add esp, 8
    
    push printSorted
    call _printf
    add esp, 4
    
    push arr
    push dword [arrSize]
    call _printArr
    add esp, 8
    
EXIT:
    xor eax, eax
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
        push fmtDsp
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