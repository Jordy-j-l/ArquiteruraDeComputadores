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
    mov     edi, [ebp+12]   ; edi = B
    mov     edx, [ebp+16]   ; edx = R
    mov     ecx, [ebp+20]   ; ecx = n
    xor     eax, eax        ; eax = i = 0

loop_start:
    cmp     eax, ecx
    jge     done

    ; Carrega valores originais
    mov     bl, [esi+eax]   ; bl = A[i]
    mov     bh, [edi+eax]   ; bh = B[i]

    ; Calcula |A[i]|
    mov     cl, bl
    cmp     cl, 0
    jge     calc_abs_b
    neg     cl              ; cl = |A[i]|

calc_abs_b:
    ; Calcula |B[i]|
    mov     ch, bh
    cmp     ch, 0
    jge     compare
    neg     ch              ; ch = |B[i]|

compare:
    ; Compara magnitudes
    cmp     cl, ch
    ja      a_greater
    jb      b_greater

    ; Iguais
    mov     byte ptr [edx+eax], 0
    jmp     next

a_greater:
    ; A tem maior magnitude
    cmp     bl, 0
    jge     a_pos
    mov     byte ptr [edx+eax], -1
    jmp     next
a_pos:
    mov     byte ptr [edx+eax], 1
    jmp     next

b_greater:
    ; B tem maior magnitude
    cmp     bh, 0
    jge     b_pos
    mov     byte ptr [edx+eax], -1
    jmp     next
b_pos:
    mov     byte ptr [edx+eax], 1

next:
    inc     eax
    jmp     loop_start

done:
    pop     edi
    pop     esi
    pop     ebx
    pop     ebp
    ret
Sinal ENDP

END