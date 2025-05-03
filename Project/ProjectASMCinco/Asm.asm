.686
.MODEL FLAT,C
.STACK 4096

PUBLIC Sinal
.CODE

; void Sinal(char *A, char *B, char *R, int n);
Sinal PROC C
    push    ebp
    mov     ebp,esp
    push    ebx
    push    esi
    push    edi

    mov     esi,[ebp+8]    ; A
    mov     edi,[ebp+12]   ; B
    mov     ebx,[ebp+16]   ; R
    mov     ecx,[ebp+20]   ; n
    xor     edx,edx        ; i=0

.loop:
    cmp     edx,ecx
    jge     .done

    mov     al,[esi+edx]   ; A[i]
    mov     bl,[edi+edx]   ; B[i]

    ; |A[i]| → AH
    mov     ah,al
    cmp     ah,0
    jge     .absA_ok
    neg     ah
.absA_ok:

    ; |B[i]| → BH
    mov     bh,bl
    cmp     bh,0
    jge     .compare
    neg     bh
.compare:

    cmp     ah,bh
    ja      .storeA
    jb      .storeB

    mov     byte ptr [ebx+edx],0
    jmp     .next

.storeA:
    cmp     al,0
    jl      .storeA_neg
    mov     byte ptr [ebx+edx],1
    jmp     .next
.storeA_neg:
    mov     byte ptr [ebx+edx],-1
    jmp     .next

.storeB:
    cmp     bl,0
    jl      .storeB_neg
    mov     byte ptr [ebx+edx],1
    jmp     .next
.storeB_neg:
    mov     byte ptr [ebx+edx],-1

.next:
    inc     edx
    jmp     .loop

.done:
    pop     edi
    pop     esi
    pop     ebx
    pop     ebp
    ret
Sinal ENDP

END Sinal
