.MODEL FLAT, C
.CODE

; void Sinal(char *A, char *B, char *R, int n);
Sinal PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi

    mov     esi, [ebp+8]    ; esi = A
    mov     ebx, [ebp+12]   ; ebx = B
    mov     edi, [ebp+16]   ; edi = R
    mov     ecx, [ebp+20]   ; ecx = n
    xor     edx, edx        ; edx = i = 0

loop_start:
    cmp     edx, ecx
    jg     done

    mov     al, [esi+edx]   ; al = A[i]
    mov     ah, [ebx+edx]   ; ah = B[i]
    mov cl,al
    mov ch,ah
    cmp al,0
    jge CompararB
    neg al

    CompararB:
        cmp ah,0
        jge cmp_vals
        neg al
    cmp_vals:

    cmp     al, ah
    jl      storeA
    jg      storeB
    mov     byte ptr [edi+edx], 0
    jmp     next_iter

storeA:
    cmp     cl, 0
    jge     storeA_pos
    mov     byte ptr [edi+edx], -1
    jmp     next_iter
storeA_pos:
    mov     byte ptr [edi+edx], 1
    jmp  next_iter
storeB:
    cmp     ch, 0
    jge     storeB_pos
    mov     byte ptr [edi+edx], -1
    jmp     next_iter
 storeB_pos:
    mov     byte ptr [edi+edx], 1   

next_iter:
    inc     edx
    jmp     loop_start

done:
    pop     edi
    pop     esi
    pop     ebx
    pop     ebp
    ret
Sinal ENDP

END

