; Define o modelo de memória (flat) e convenções de chamada C
.MODEL FLAT, C

; Seção de dados - para declaração de variáveis globais
.DATA
    ; Variáveis podem ser definidas aqui se necessário

; Seção de código - contém as instruções do programa
.CODE

; ------------------------------------------------------------------------------
; Função: SumTotalASM
; Descrição: Calcula a média da soma de dois char arrays 
; Parâmetros (passados pela pilha):
;   [ebp+8]  - ponteiro para o primeiro array (arrayOne)
;   [ebp+12] - ponteiro para o segundo array (arrayTwo)
;   [ebp+16] - valor máximo para cálculo da média (valorMaximo)
;   [ebp+20] - tamanho dos arrays (tamanhoDosArrays)
; Retorna:
;   eax - média dos arrays (soma total / valorMaximo)
; ------------------------------------------------------------------------------
SumTotalASM PROC
   
    push ebp           
    mov ebp, esp        
    
    ; Salva registos que serão utilizados
    push ebx
    push esi
    push edi
    ; Inicialização de registos
    xor eax, eax            ; Zera eax (sumTotal = 0)
    mov esi, [ebp+8]        ; Carrega endereço do arrayOne em esi
    mov edi, [ebp+12]       ; Carrega endereço do arrayTwo em edi
    mov ecx, [ebp+20]       ; Carrega tamanho dos arrays em ecx
    
    ; Verifica se há elementos suficientes (SIMD)
    cmp ecx, 16             ; Compara tamanho com 16
    jl elementosRestantes   ; Se menor que 16, processa elemento por elemento
    
    ; Configuração para processamento vetorial (16 elementos por iteração)
    mov edx, ecx            ; Copia tamanho para edx
    shr edx, 4              ; Divide por 16 (número de blocos completos)
    and ecx, 0Fh            ; Calcula resto (elementos restantes após blocos de 16)
    
    xor ebx, ebx            ; Zera contador de blocos (ebx = 0)

; Loop principal - processa blocos de 16 bytes usando instruções SIMD
LoopPrincipal:
    ; Carrega 16 bytes de cada array em registos XMM
    movdqu xmm0, [esi]      ; Carrega 16 bytes do arrayOne (não alinhado)
    movdqu xmm1, [edi]      ; Carrega 16 bytes do arrayTwo (não alinhado)
    
    ; Soma os bytes dos dois arrays
    paddb xmm0, xmm1        ; Soma os bytes (xmm0 = xmm0 + xmm1)
    
    ; Soma horizontal dos bytes no registos XMM
    pxor xmm2, xmm2         ; Zera xmm2 (para comparação)
    psadbw xmm0, xmm2       ; Soma absoluta das diferenças (resultado em xmm0[63:0])
    
    ; Extrai resultado para registos de propósito geral
    movd edx, xmm0          ; Move os 32 bits inferiores para edx
    add eax, edx            ; Acumula no total (eax += edx)
    
    ; Avança ponteiros para os próximos 16 elementos
    add esi, 16             ; Avança arrayOne em 16 bytes
    add edi, 16             ; Avança arrayTwo em 16 bytes
    
    inc ebx                 ; Incrementa contador de blocos
    cmp ebx, edx            ; Compara com número total de blocos
    jl LoopPrincipal        ; Repete se ainda houver blocos

; Processa elementos restantes (menos de 16) de forma escalar
elementosRestantes:
    test ecx, ecx           ; Verifica se há elementos restantes
    jz done                 ; Se não, vai para o final
    
    ; Processamento elemento por elemento (modo escalar)
    xor ebx, ebx            ; Zera ebx (usará para carregar bytes)
    xor edx, edx            ; Zera edx (usará para carregar bytes)
    
loopElementoPorElemento:
    ; Carrega e soma elementos individuais
    movzx ebx, byte ptr [esi]  ; Carrega byte do arrayOne com extensão para 32 bits
    movzx edx, byte ptr [edi]  ; Carrega byte do arrayTwo com extensão para 32 bits
    add ebx, edx               ; Soma os dois bytes
    add eax, ebx               ; Acumula no total
    
    ; Avança para o próximo elemento
    inc esi                   ; Incrementa ponteiro do arrayOne
    inc edi                   ; Incrementa ponteiro do arrayTwo
    dec ecx                   ; Decrementa contador de elementos
    jnz loopElementoPorElemento ; Repete até ecx = 0

; Finalização - calcula a média e prepara retorno
done:
    ; Converte eax para edx:eax (prepara para divisão)
    cdq
    
    ; Divide soma total pelo valor máximo
    idiv dword ptr [ebp+16]  ; eax = eax / valorMaximo (resultado da média)
    
    ; restaura registos e pilha
    pop edi                  ; Restaura edi
    pop esi                  ; Restaura esi
    pop ebx                  ; Restaura ebx
    mov esp, ebp             ; Restaura stack pointer
    pop ebp                  ; Restaura base pointer
    ret                      ; Retorna da função (resultado em eax)
SumTotalASM ENDP

; Fim do arquivo assembly - indica que não há mais código a ser processado
END