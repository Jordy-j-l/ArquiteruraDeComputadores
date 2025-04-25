section .text
    global SumArrays

; Assinatura: void SumArrays(char* a, char* b, char* result, int size, int maxSize)
SumArrays:
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
