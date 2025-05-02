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
; Retorna: eax = m�dia (soma total / valorMaximo)
;___________________________________________________________________
SumTotalASM PROC

   ; Fun��o: void average_arrays(unsigned char* one, unsigned char* two, unsigned char* result, int size)
    push ebp                  ; Salva o ponteiro base (EBP)
    mov ebp, esp              ; Configura o quadro da pilha

    push esi                  ; Salva o registo de �ndice da fonte (ESI)
    push edi                  ; Salva o registo de �ndice de destino (EDI)
    push ebx                  ; Salva o registo tempor�rio (EBX)

    ; Carrega os par�metros da fun��o nos registos:
    mov esi, [ebp + 8]        ; Carrega o endere�o do primeiro array (one) no ESI
    mov edi, [ebp + 12]       ; Carrega o endere�o do segundo array (two) no EDI
    mov edx, [ebp + 16]       ; Carrega o endere�o do array de resultado (result) no EDX
    mov ecx, [ebp + 20]       ; Carrega o tamanho (length) dos arrays no ECX

    xor eax, eax              ; Inicializa o �ndice i = 0

.simd_loop:                  ; La�o principal para processar os arrays em blocos de 16 bytes
    cmp ecx, eax              ; Compara i com o tamanho (size)
    jl .ElementosRestantes    ; Se i >= size, salta para o processamento dos elementos restantes

    mov ebx, ecx              ; Copia o tamanho para EBX
    sub ebx, eax              ; Calcula os elementos restantes (size - i)
    cmp ebx, 16               ; Verifica se h� pelo menos 16 elementos restantes
    jl .ElementosRestantes    ; Se menos de 16, vai para o processamento dos elementos restantes

    ; Processa 16 bytes de cada vez usando SIMD:
    movdqu xmm0, [esi + eax]  ; Carrega 16 bytes do array one para o xmm0
    movdqu xmm1, [edi + eax]  ; Carrega 16 bytes do array two para o xmm1
    pavgb xmm0, xmm1          ; Executa a m�dia SIMD (arredondando para baixo) nos dois arrays
    movdqu [edx + eax], xmm0  ; Armazena o resultado da m�dia no array de resultado

    add eax, 16               ; Incrementa o �ndice de 16 (processando 16 bytes de uma vez)
    jmp .simd_loop            ; Repete o la�o

.ElementosRestantes:         ; La�o para processar os bytes restantes (menos de 16)
    cmp eax, ecx              ; Compara o �ndice i com o tamanho
    jge .done                 ; Se i >= size, terminamos

    mov al, [esi + eax]       ; Carrega one[i] (byte do array one) no AL
    mov bl, [edi + eax]       ; Carrega two[i] (byte do array two) no BL

    ; Calcula a m�dia (arredondando o resultado para o inteiro mais pr�ximo):
    add ax, bx                ; Soma os valores de one[i] e two[i] (ax = one[i] + two[i])
    add ax, 1                 ; Adiciona 1 ao resultado para arredondar a m�dia (a + b + 1)
    shr ax, 1                 ; Divide a soma por 2 (m�dia arredondada)

    mov [edx + eax], al       ; Armazena o resultado (m�dia) no result[i] (usando o byte inferior de AX)

    inc eax                   ; Incrementa o �ndice
    jmp .ElementosRestantes   ; Repete o la�o para os pr�ximos elementos restantes

.done:                        ; Fim da fun��o
    pop ebx                   ; Restaura o registo tempor�rio (EBX)
    pop edi                   ; Restaura o registo de �ndice de destino (EDI)
    pop esi                   ; Restaura o registo de �ndice da fonte (ESI)
    pop ebp                   ; Restaura o ponteiro base (EBP)
    ret                       ; Retorna da fun��o

SumTotalASM ENDP

; Fim do arquivo
END