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
average_arrays PROC

   ; Função: void average_arrays(unsigned char* one, unsigned char* two, unsigned char* result, int size)
    push ebp                  ; Salva o ponteiro base (EBP)
    mov ebp, esp              ; Configura o quadro da pilha

    push esi                  ; Salva o registo de índice da fonte (ESI)
    push edi                  ; Salva o registo de índice de destino (EDI)
    push ebx                  ; Salva o registo temporário (EBX)

    ; Carrega os parâmetros da função nos registos:
    mov esi, [ebp + 8]        ; Carrega o endereço do primeiro array (one) no ESI
    mov edi, [ebp + 12]       ; Carrega o endereço do segundo array (two) no EDI
    mov edx, [ebp + 16]       ; Carrega o endereço do array de resultado (result) no EDX
    mov ecx, [ebp + 20]       ; Carrega o tamanho (length) dos arrays no ECX

    xor eax, eax              ; Inicializa o índice i = 0

.simd_loop:                  ; Laço principal para processar os arrays em blocos de 16 bytes
    cmp ecx, eax              ; Compara i com o tamanho (size)
    jl .ElementosRestantes    ; Se i >= size, salta para o processamento dos elementos restantes

    mov ebx, ecx              ; Copia o tamanho para EBX
    sub ebx, eax              ; Calcula os elementos restantes (size - i)
    cmp ebx, 16               ; Verifica se há pelo menos 16 elementos restantes
    jl .ElementosRestantes    ; Se menos de 16, vai para o processamento dos elementos restantes

    ; Processa 16 bytes de cada vez usando SIMD:
    movdqu xmm0, [esi + eax]  ; Carrega 16 bytes do array one para o xmm0
    movdqu xmm1, [edi + eax]  ; Carrega 16 bytes do array two para o xmm1
    pavgb xmm0, xmm1          ; Executa a média SIMD (arredondando para baixo) nos dois arrays
    movdqu [edx + eax], xmm0  ; Armazena o resultado da média no array de resultado

    add eax, 16               ; Incrementa o índice de 16 (processando 16 bytes de uma vez)
    jmp .simd_loop            ; Repete o laço

.ElementosRestantes:         ; Laço para processar os bytes restantes (menos de 16)
    cmp eax, ecx              ; Compara o índice i com o tamanho
    jge .done                 ; Se i >= size, terminamos

    mov al, [esi + eax]       ; Carrega one[i] (byte do array one) no AL
    mov bl, [edi + eax]       ; Carrega two[i] (byte do array two) no BL

    ; Calcula a média (arredondando o resultado para o inteiro mais próximo):
    add ax, bx                ; Soma os valores de one[i] e two[i] (ax = one[i] + two[i])
    add ax, 1                 ; Adiciona 1 ao resultado para arredondar a média (a + b + 1)
    shr ax, 1                 ; Divide a soma por 2 (média arredondada)

    mov [edx + eax], al       ; Armazena o resultado (média) no result[i] (usando o byte inferior de AX)

    inc eax                   ; Incrementa o índice
    jmp .ElementosRestantes   ; Repete o laço para os próximos elementos restantes

.done:                        ; Fim da função
    pop ebx                   ; Restaura o registo temporário (EBX)
    pop edi                   ; Restaura o registo de índice de destino (EDI)
    pop esi                   ; Restaura o registo de índice da fonte (ESI)
    pop ebp                   ; Restaura o ponteiro base (EBP)
    ret                       ; Retorna da função

average_arrays ENDP

; Fim do arquivo
END