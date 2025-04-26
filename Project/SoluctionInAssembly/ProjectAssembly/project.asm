section .text
global SumTotal

; Assinatura: void SumTotal(char* a, char* b, char* result, int size, int maxSize)
SumTotal:
    push    ebp
    mov     ebp, esp

    mov     esi, [ebp+8]     ; a
    mov     edi, [ebp+12]    ; b
    mov     edx, [ebp+16]    ; result
    mov     ecx, [ebp+20]    ; size
    mov     eax, [ebp+24]    ; maxSize

.loop:
    cmp     ecx, 0
    jle     .done

    ; carrega 16 bytes de a e b para xmm
    movdqu  xmm0, [esi]
    movdqu  xmm1, [edi]

    ; soma signed chars com saturação
    paddsb  xmm0, xmm1

    ; guarda no array de resultado
    movdqu  [edx], xmm0

    ; avança 16 posições
    add     esi, 16
    add     edi, 16
    add     edx, 16
    sub     ecx, 16
    jmp     .loop


.done:
    pop     ebp
    ret
__________________________________________________________

section .text
global _array_average_asm

; void array_average_asm(const char* arr1, const char* arr2, char* result, unsigned int size)
SumTotal:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; Load parameters
    mov esi, [ebp+8]    ; arr1
    mov edi, [ebp+12]   ; arr2
    mov edx, [ebp+16]   ; result
    mov ecx, [ebp+20]   ; size

    ; Prepare SIMD rounding constant (16 bytes of 1's)
    mov eax, 0x01010101
    movd xmm3, eax
    pshufd xmm3, xmm3, 0x00  ; Broadcast to all 4 dwords

.simd_loop:
    cmp ecx, 16
    jl .scalar_loop

    ; Load 16 bytes from each array
    movdqu xmm0, [esi]  ; Load arr1[0..15]
    movdqu xmm1, [edi]  ; Load arr2[0..15]

    ; Calculate average with rounding: (a + b + 1) / 2
    paddb xmm0, xmm1    ; a + b
    paddb xmm0, xmm3    ; +1 for rounding
    psrlw xmm0, 1       ; /2 (arithmetic shift right)

    ; Store result
    movdqu [edx], xmm0

    ; Advance pointers
    add esi, 16
    add edi, 16
    add edx, 16
    sub ecx, 16
    jmp .simd_loop

.scalar_loop:
    test ecx, ecx
    jz .done

    ; Process remaining elements (1-15)
    mov al, [esi]       ; Load from arr1
    add al, [edi]       ; Add from arr2
    inc al              ; +1 for rounding
    sar al, 1           ; /2 (arithmetic shift)
    mov [edx], al       ; Store result

    ; Advance pointers
    inc esi
    inc edi
    inc edx
    dec ecx
    jmp .scalar_loop

.done:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

section .data
align 16
ones: times 16 db 1     ; Constant for rounding