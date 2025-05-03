.MODEL FLAT, C
.CODE

; Função auxiliar: abs_complement - converte para complemento se negativo
; Entrada: AL = valor
; Saída: AL = valor absoluto em complemento
abs_complement PROC
    test al, al
    jns positive
    neg al          ; Complemento de 2 para números negativos
positive:
    ret
abs_complement ENDP

average_arrays_signed PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    push ecx
    push edx
    
    mov esi, [ebp+8]    ; array one
    mov edi, [ebp+12]   ; array two
    mov edx, [ebp+16]   ; result
    mov ebx, [ebp+20]   ; signs array
    mov ecx, [ebp+24]   ; size
    
    xor eax, eax        ; índice i = 0
    
process_signs:
    cmp eax, ecx
    jge process_averages
    
    ; Determinar sinal do maior em módulo
    mov bl, [esi+eax]   ; one[i]
    mov bh, [edi+eax]   ; two[i]
    
    ; Calcular valores absolutos para comparação
    mov dl, bl
    neg dl
    cmovl dl, bl        ; dl = abs(bl)
    
    mov dh, bh
    neg dh
    cmovl dh, bh        ; dh = abs(bh)
    
    ; Comparar magnitudes
    cmp dl, dh
    jge use_one_sign
    
    ; Usar sinal de two[i]
    mov bl, bh
    
use_one_sign:
    ; Armazenar sinal (BL tem o valor com sinal do maior)
    sar bl, 7           ; Extende sinal: 0xFF se negativo, 0x00 se positivo
    or bl, 1            ; Converte para -1 ou +1
    mov [ebx+eax], bl   ; signs[i] = (maior < 0) ? -1 : 1
    
    ; Converter para complemento se negativo
    mov bl, [esi+eax]
    call abs_complement
    mov [esi+eax], al
    
    mov bl, [edi+eax]
    call abs_complement
    mov [edi+eax], al
    
    inc eax
    jmp process_signs

process_averages:
    ; Chamar função original de média
    push ecx            ; size
    push edx            ; result
    push edi            ; array two
    push esi            ; array one
    call average_arrays
    add esp, 16
    
apply_signs:
    xor eax, eax        ; reset índice
    
apply_loop:
    cmp eax, ecx
    jge done
    
    ; Multiplicar pelo sinal
    mov bl, [ebx+eax]   ; signs[i]
    mov dl, [edx+eax]   ; result[i]
    imul dl, bl         ; result[i] *= signs[i]
    mov [edx+eax], dl
    
    inc eax
    jmp apply_loop

done:
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
average_arrays_signed ENDP

END