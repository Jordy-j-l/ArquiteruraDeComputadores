.MODEL FLAT, C
.DATA
    ; Variaveis podem ser definidas aqui

.CODE

;___________________________________________________________________
; Funcao: SumTotalASM
; Calcula a media da soma de dois arrays de bytes
; parametros:
;   [ebp+8]  _ arrayOne (ponteiro)
;   [ebp+12] _ arrayTwo (ponteiro)
;   [ebp+16] _ valorMaximo (int)
;   [ebp+20] _ tamanhoDosArrays (int)
; Retorna: eax = média (soma total / valorMaximo)
;___________________________________________________________________
SumTotalASM PROC

    push ebp
    mov ebp, esp
    
    ; Salva registos
    push ebx
    push esi
    push edi
    
    ; Inicia  os registos
    xor eax, eax            ; sumTotal = 0
    mov esi, [ebp+8]        ; arrayOne
    mov edi, [ebp+12]       ; arrayTwo
    mov ecx, [ebp+20]       ; tamanhoDosArrays
    
    ; Verifica se tem elementos suficientes para processar em blocos
    cmp ecx, 16
    jl elementosRestantes
    
    ; Configura processamento em blocos de 16
    mov edx, ecx
    shr edx, 4              ; edx = numero de blocos
    mov ebx, edx            ; ebx = contador de blocos
    and ecx, 0Fh            ; ecx = elementos restantes
    cmp edx, 0
    je elementosRestantes

LoopPrincipal:
    ; Carrega 16 bytes de cada array
    movdqu xmm0, [esi]      ; arrayOne
    movdqu xmm1, [edi]      ; arrayTwo
    
    ; Soma os bytes
    paddb xmm0, xmm1
    
    ; Soma todos os elementos do resultado
    pxor xmm2, xmm2
    psadbw xmm0, xmm2
    
    ; Combina as metades da soma
    movhlps xmm1, xmm0
    paddd xmm0, xmm1
    
    ; Pega o resultado final
    movd edx, xmm0
    add eax, edx            ; Acumula no total
    
    ; Avanca os ponteiros
    add esi, 16
    add edi, 16
    
    ; Controla o loop
    dec ebx
    jnz LoopPrincipal

elementosRestantes:
    ; Processa elementos que sobraram (<16)
    cmp ecx, 0
    je done
    
    xor ebx, ebx
    xor edx, edx

loopElementoPorElemento:
    ; Soma elemento por elemento
    movzx ebx, byte ptr [esi]  ; Pega byte do arrayOne
    movzx edx, byte ptr [edi]  ; Pega byte do arrayTwo
    add ebx, edx               ; Soma os dois
    add eax, ebx               ; Acumula
    
    ; Proximo elemento
    inc esi
    inc edi
    dec ecx
    jnz loopElementoPorElemento

done:
    ; Calcula a media final
    cdq
    idiv dword ptr [ebp+16]  ; Divide pelo valor maximo
    
    ; Restaura Registos ao seu estado Inicial
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
SumTotalASM ENDP

; Fim do arquivo
END