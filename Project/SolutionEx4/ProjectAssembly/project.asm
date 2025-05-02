.MODEL FLAT, C
.DATA
    ; Variaveis podem ser definidas aqui

.CODE

;___________________________________________________________________
; Funcao: SumTotalASM
; Calcula a media da soma de dois arrays de chars
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
    paddb xmm0, xmm1        ; soma os bytes de xmm0 com os bytes de xmm1
    
    ; Soma todos os elementos do resultado
    pxor xmm2, xmm2         ; zera xmm2
    psadbw xmm0, xmm2       ; faz a diferença absoluta de xmm0 com xmm2 (neste caso e zero) e depois soma tudo
                            ; a soma dos primeiros 8 bytes fica no low 64 bits e a soma dos ultimos 8 bytes fica no high 64 bits
    
    ; Combina as metades da soma
    movhlps xmm1, xmm0      ; copia os high 64 bits de xmm0 para os low 64 bits de xmm1
    paddd xmm0, xmm1        ; soma valores de 32 bits dentro dos registos xmm0 e xmm1
    
    ; Pega o resultado final
    movd edx, xmm0          ; move apenas os primeiros 32 bits de um registo xmm para um registo normal
    add eax, edx            ; Acumula no total
    
    ; Avanca os ponteiros
    add esi, 16             ;avança 16 posições no array
    add edi, 16             ;avança 16 posições no array
    
    ; Controla o loop
    dec ebx                 ;quando chegar a 0 é porque já não existem blocos de 16 bytes completos para serem somados
    jnz LoopPrincipal

elementosRestantes:
    ; Processa elementos que sobraram (<16)
    cmp ecx, 0              ;verifica se ainda existem valores para somar que não caibam num bloco de 16 bytes
    je done                 ;se já não existirem avança para o label done para calcular a média
    
    xor ebx, ebx            ; Zera o registo ebx
    xor edx, edx            ; Zera o registo edx

loopElementoPorElemento:
    ; Soma elemento por elemento
    movzx ebx, byte ptr [esi]  ; Pega byte do arrayOne
    movzx edx, byte ptr [edi]  ; Pega byte do arrayTwo
    add ebx, edx               ; Soma os dois
    add eax, ebx               ; Acumula
    
    ; Proximo elemento
    inc esi                    ; Incrementa para iterar o proximo elemento
    inc edi                    ; Incrementa para iterar o proximo elemento
    dec ecx                    ; Decrementa mais um valor dos elementos restantes
    jnz loopElementoPorElemento

done:
    ; Calcula a media final
    cdq                        ; Expande o valor do registo eax de 32 bits para 64 bits, guardando o sinal em edx (idiv necessita de valores de 64 bits)
    idiv dword ptr [ebp+16]    ; Divide pelo valor maximo
    
    ; Restaura Registos ao seu estado Inicial
    pop edi                    ; Efetua um pop para deixar a stack como ela estava anteriormente
    pop esi                    ; Efetua um pop para deixar a stack como ela estava anteriormente
    pop ebx                    ; Efetua um pop para deixar a stack como ela estava anteriormente
    mov esp, ebp               ; Restaura o stack pointer (esp) para o valor salvo no início da função (ebp)
    pop ebp                    ; Efetua um pop para deixar a stack como ela estava anteriormente
    ret                        ; Sai da função
SumTotalASM ENDP

; Fim do arquivo
END