.MODEL FLAT, C
; --- Seção de Dados Constantes ---
.DATA
    align 16
mask128 BYTE 16 DUP(80h)   ; 16 bytes com o valor 0x80 (128 decimal)

.CODE

average_arrays PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    mov esi, [ebp + 8]        ; arrayOne
    mov edi, [ebp + 12]       ; arrayTwo
    mov edx, [ebp + 16]       ; arrayResult e array prenchido com constante 128 
    mov ecx, [ebp + 20]       ; arraySize
    
    xor eax, eax              ; index i = 0
    movdqu xmm2, [edx + eax]  ; load 16 bytes from array Result

    ; Process elements 16 at a time using SIMD
SIMDLoop:
    cmp eax, ecx
    jge Done
    
    movdqu xmm0, [esi + eax]  ; load 16 bytes from arrayOne
    movdqu xmm1, [edi + eax]  ; load 16 bytes from arrayTwo
    
    paddb xmm0, xmm2          ; soma 128 aos elementos do arrayUm
    paddb xmm1, xmm2          ; soma 128 aos elementos do arrayDois
    pavgb xmm0, xmm1          ; packed average with rounding
    psubb xmm0, xmm2          ; subtrai 128 do resultado
    movdqu [edx + eax], xmm0  ; store result
    
    add eax, 16
    cmp eax, ecx
    jl SIMDLoop
    
    ; Process remaining elements one by one
ProcessRemaining:
    cmp eax, ecx
    jge Done
    
    ; Carrega bytes (8 bits) e estende para 16 bits (evita overflow)
    movzx bx, byte ptr [esi + eax]  ; bx = arrayOne[i] (zero-extend)
    movzx dx, byte ptr [edi + eax]  ; dx = arrayTwo[i] (zero-extend)
    
    ; Soma 128 a ambos (agora em 16 bits)
    add bx, 128
    add dx, 128
    
    ; Calcula média: (bx + dx + 1) / 2
    add bx, dx
    inc bx
    shr bx, 1
    
    ; Subtrai 128 e armazena o resultado (8 bits)
    sub bl, 128
    mov [edx + eax], bl
    
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