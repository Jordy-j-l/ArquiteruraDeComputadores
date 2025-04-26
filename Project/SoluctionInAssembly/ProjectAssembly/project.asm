; Define o modelo de mem�ria (flat) e conven��es de chamada C
.MODEL FLAT, C

; Se��o de dados - para declara��o de vari�veis globais
.DATA
    ; Vari�veis podem ser definidas aqui se necess�rio

; Se��o de c�digo - cont�m as instru��es do programa
.CODE

; ------------------------------------------------------------------------------
; Fun��o: SumTotalASM
; Descri��o: Calcula a m�dia da soma de dois char arrays 
; Par�metros (passados pela pilha):
;   [ebp+8]  - ponteiro para o primeiro array (arrayOne)
;   [ebp+12] - ponteiro para o segundo array (arrayTwo)
;   [ebp+16] - valor m�ximo para c�lculo da m�dia (valorMaximo)
;   [ebp+20] - tamanho dos arrays (tamanhoDosArrays)
; Retorna:
;   eax - m�dia dos arrays (soma total / valorMaximo)
; ------------------------------------------------------------------------------
SumTotalASM PROC
   
    push ebp           
    mov ebp, esp        
    
    ; Salva registos que ser�o utilizados
    push ebx
    push esi
    push edi
    ; Inicializa��o de registos
    xor eax, eax            ; Zera eax (sumTotal = 0)
    mov esi, [ebp+8]        ; Carrega endere�o do arrayOne em esi
    mov edi, [ebp+12]       ; Carrega endere�o do arrayTwo em edi
    mov ecx, [ebp+20]       ; Carrega tamanho dos arrays em ecx
    
    ; Verifica se h� elementos suficientes (SIMD)
    cmp ecx, 16             ; Compara tamanho com 16
    jl elementosRestantes   ; Se menor que 16, processa elemento por elemento
    
    ; Configura��o para processamento vetorial (16 elementos por itera��o)
    mov edx, ecx            ; Copia tamanho para edx
    shr edx, 4              ; Divide por 16 (n�mero de blocos completos)
    and ecx, 0Fh            ; Calcula resto (elementos restantes ap�s blocos de 16)
    
    xor ebx, ebx            ; Zera contador de blocos (ebx = 0)

; Loop principal - processa blocos de 16 bytes usando instru��es SIMD
LoopPrincipal:
    ; Carrega 16 bytes de cada array em registos XMM
    movdqu xmm0, [esi]      ; Carrega 16 bytes do arrayOne (n�o alinhado)
    movdqu xmm1, [edi]      ; Carrega 16 bytes do arrayTwo (n�o alinhado)
    
    ; Soma os bytes dos dois arrays
    paddb xmm0, xmm1        ; Soma os bytes (xmm0 = xmm0 + xmm1)
    
    ; Soma horizontal dos bytes no registos XMM
    pxor xmm2, xmm2         ; Zera xmm2 (para compara��o)
    psadbw xmm0, xmm2       ; Soma absoluta das diferen�as (resultado em xmm0[63:0])
    
    ; Extrai resultado para registos de prop�sito geral
    movd edx, xmm0          ; Move os 32 bits inferiores para edx
    add eax, edx            ; Acumula no total (eax += edx)
    
    ; Avan�a ponteiros para os pr�ximos 16 elementos
    add esi, 16             ; Avan�a arrayOne em 16 bytes
    add edi, 16             ; Avan�a arrayTwo em 16 bytes
    
    inc ebx                 ; Incrementa contador de blocos
    cmp ebx, edx            ; Compara com n�mero total de blocos
    jl LoopPrincipal        ; Repete se ainda houver blocos

; Processa elementos restantes (menos de 16) de forma escalar
elementosRestantes:
    test ecx, ecx           ; Verifica se h� elementos restantes
    jz done                 ; Se n�o, vai para o final
    
    ; Processamento elemento por elemento (modo escalar)
    xor ebx, ebx            ; Zera ebx (usar� para carregar bytes)
    xor edx, edx            ; Zera edx (usar� para carregar bytes)
    
loopElementoPorElemento:
    ; Carrega e soma elementos individuais
    movzx ebx, byte ptr [esi]  ; Carrega byte do arrayOne com extens�o para 32 bits
    movzx edx, byte ptr [edi]  ; Carrega byte do arrayTwo com extens�o para 32 bits
    add ebx, edx               ; Soma os dois bytes
    add eax, ebx               ; Acumula no total
    
    ; Avan�a para o pr�ximo elemento
    inc esi                   ; Incrementa ponteiro do arrayOne
    inc edi                   ; Incrementa ponteiro do arrayTwo
    dec ecx                   ; Decrementa contador de elementos
    jnz loopElementoPorElemento ; Repete at� ecx = 0

; Finaliza��o - calcula a m�dia e prepara retorno
done:
    ; Converte eax para edx:eax (prepara para divis�o)
    cdq
    
    ; Divide soma total pelo valor m�ximo
    idiv dword ptr [ebp+16]  ; eax = eax / valorMaximo (resultado da m�dia)
    
    ; restaura registos e pilha
    pop edi                  ; Restaura edi
    pop esi                  ; Restaura esi
    pop ebx                  ; Restaura ebx
    mov esp, ebp             ; Restaura stack pointer
    pop ebp                  ; Restaura base pointer
    ret                      ; Retorna da fun��o (resultado em eax)
SumTotalASM ENDP

; Fim do arquivo assembly - indica que n�o h� mais c�digo a ser processado
END