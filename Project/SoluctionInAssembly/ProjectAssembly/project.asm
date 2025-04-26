; Media de Arrays 
section .text; Se��o de c�digo do programa
global SumTotalASM; Define o ponto de entrada global da fun��o para ser acess�vel externamente

; Fun��o: _SumTotal_ASM
; Par�metros (passados na pilha):
;   [ebp+8]  - arrayOne
;   [ebp+12] - arrayTwo
;   [ebp+16] - maxsize
;   [ebp+20] - tamanho dos arrays
; Retorna:
;   eax - m�dia dos arrays
;________________________________________________________________________________
SumTotalASM:; Fun��o: SumTotalASM
    push ebp
    mov ebp, esp
    ; Salva registos que ser�o usados
    push ebx
    push esi
    push edi
    ; Inicializa��o dos registos
    xor eax, eax            ; sumTotal = 0
    mov esi, [ebp+8]        ; arrayOne
    mov edi, [ebp+12]       ; arrayTwo
    mov ecx, [ebp+20]       ; tamanho dos arrays
    
    ; Verifica se podemos processar com SIMD (pelo menos 16 elementos)
    cmp ecx, 16         ; Compara tamanho com 16
    jl .elementosRestantes ; Se menor, pula para processamento escalar
    
   ; Prepara para processamento SIMD em blocos de 16 bytes
    mov edx, ecx        ; Copia tamanho para edx
    shr edx, 4          ; Divide por 16 (calcula quantos blocos de 16 completos)
    and ecx, 0xF        ; Calcula resto da divis�o por 16 (elementos restantes)
    mov ebx, edx  
    .LoopPrincipal:
        movdqu xmm0, [esi]    ; Carrega 16 bytes do arrayOne em xmm0
        movdqu xmm1, [edi]    ; Carrega 16 bytes do arrayTwo em xmm1
        
        ; Soma os bytes
        pxor xmm2, xmm2
        paddb xmm2, xmm0, xmm1
        
        ; Soma todos os elementos que s�o resultado da soma anterior
        pxor xmm3, xmm3
        psadbw xmm4, xmm2, xmm3;equivalente a fazer uma soma de todos os elemntos de um array
        
        ; Extrai resultado
        movd edx, xmm4 ; Copia os primeiros 32 bits de xmm4 para edx
        add eax, edx ;Equivalente a fazer SomTotal+=Result[i]
        
        ; Avan�a ponteiros
        add esi, 16; Avan�a 16 bytes no arrayOne
        add edi, 16; Avan�a 16 bytes no arrayTwo
        dec ebx ; Decrementa contador de blocos
        cmp ebx, 0
        jne .LoopPrincipal; Repete se ainda houver blocos
     ; Processa elementos restantes (menos de 16)
    .elementosRestantes:
        cmp ecx, 0; Verifica se h� elementos restantes
        je .done;Se n�o houver terminar
        
                ; Processa elementos um a um
        xor ebx, ebx         ; Zera ebx (usar� para carregar bytes)
        xor edx, edx         ; Zera edx (usar� para carregar bytes)
        
        .loopElementoPorElemnto:
            movzx ebx, byte [esi] ; Carrega byte do arrayOne com extens�o para 32 bits
            movzx edx, byte [edi] ; Carrega byte do arrayTwo com extens�o para 32 bits
            add ebx, edx          ; Soma os dois bytes
            add eax, ebx          ; Acumula no total
            
            ; Avan�a para pr�ximo elemento
            inc esi              ; Incrementa ponteiro do arrayOne
            inc edi              ; Incrementa ponteiro do arrayTwo
            dec ecx              ; Decrementa contador
            cmp ecx,0
            jne .loopElementoPorElemnto ; Repete at� ecx = 0
    
    ; Finaliza��o - calcula m�dia e retorna
    .done:
        cdq               ; Estende sinal de eax para edx:eax (prepara para divis�o)
        idiv dword [ebp+16] ; Divide eax por maxsize (resultado em eax)
        
        ; Ep�logo da fun��o - restaura registradores
        pop edi          ; Restaura edi
        pop esi          ; Restaura esi
        pop ebx          ; Restaura ebx
        mov esp, ebp     ; Restaura stack pointer
        pop ebp          ; Restaura base pointer
        ret              ; Retorna da fun��o (resultado em eax)