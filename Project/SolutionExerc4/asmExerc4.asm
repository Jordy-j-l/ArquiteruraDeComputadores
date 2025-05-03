.MODEL FLAT, C
.CODE

average_arrays PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    mov esi, [ebp + 8]        ; arrayOne
    mov edi, [ebp + 12]       ; arrayTwo
    mov edx, [ebp + 16]       ; arrayResult
    mov ecx, [ebp + 20]       ; arraySize
    
    xor eax, eax              ; index i = 0
    
    ; Process elements 16 at a time using SIMD
SIMDLoop:
    cmp eax, ecx
    jge Done
    
    movdqu xmm0, [esi + eax]  ; load 16 bytes from arrayOne
    movdqu xmm1, [edi + eax]  ; load 16 bytes from arrayTwo
    pavgb xmm0, xmm1          ; packed average with rounding
    movdqu [edx + eax], xmm0  ; store result
    
    add eax, 16
    cmp eax, ecx
    jl SIMDLoop
    
    ; Process remaining elements one by one
ProcessRemaining:
    cmp eax, ecx
    jge Done
    
    mov bl, [esi + eax]       ; load byte from arrayOne
    mov bh, [edi + eax]       ; load byte from arrayTwo
    
    ; Calculate average with rounding: (a + b + 1) / 2
    xor ebx, ebx              ; clear upper bits
    mov bl, [esi + eax]       ; reload to ensure clean register
    add bl, [edi + eax]       ; add two bytes
    adc bh, 0                ; handle carry
    inc bx                   ; add 1 for rounding
    shr bx, 1                ; divide by 2
    
    mov [edx + eax], bl       ; store result
    
    inc eax
    jmp ProcessRemaining
    
Done:
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
average_arrays ENDP

END