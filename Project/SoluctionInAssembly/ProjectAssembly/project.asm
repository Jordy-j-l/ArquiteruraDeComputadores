.Model FLAT, C
.DATA                   ; Início da seção de dados
; Variáveis podem ser definidas aqui se necessário

.CODE                   ; Início da seção de código

; Função: SumTotalASM
; Parâmetros (passados na pilha):
;   [ebp+8]  - arrayOne
;   [ebp+12] - arrayTwo
;   [ebp+16] - valorMaximo
;   [ebp+20] - tamanhoDosArrays
; Retorna:
;   eax - média dos arrays
;________________________________________________________________________________
SumTotalASM PROC
    push ebp
    mov ebp, esp
    ; Salva registos que serão usados
    push ebx
    push esi
    push edi
    ; Inicialização dos registos
    xor eax, eax            ; sumTotal = 0
    mov esi, [ebp+8]        ; arrayOne
    mov edi, [ebp+12]       ; arrayTwo
    mov ecx, [ebp+20]       ; tamanho dos arrays
    
    ; Verifica se podemos processar com SIMD (pelo menos 16 elementos)
    cmp ecx, 16         ; Compara tamanho com 16
    jl elementosRestantes ; Se menor, pula para processamento escalar
    
    ; Prepara para processamento SIMD em blocos de 16 bytes
    mov edx, ecx        ; Copia tamanho para edx
    shr edx, 4          ; Divide por 16 (calcula quantos blocos de 16 completos)
    and ecx, 0Fh        ; Calcula resto da divisão por 16 (elementos restantes)
    mov ebx, edx  
    LoopPrincipal:
        movdqu xmm0, [esi]    ; Carrega 16 bytes do arrayOne em xmm0
        movdqu xmm1, [edi]    ; Carrega 16 bytes do arrayTwo em xmm1
        
        ; Soma os bytes
        pxor xmm2, xmm2
        paddb xmm2, xmm0
        paddb xmm2, xmm1
        ;Podiamos fazer  paddb xmm1, xmm0
        ; Soma todos os elementos que são resultado da soma anterior
        pxor xmm3, xmm3
        psadbw xmm4, xmm2;equivalente a fazer uma soma de todos os elemntos de um array
        ;No outro caso aqui ficava psadbw xmm4, xmm1
        ; Extrai resultado
        movd edx, xmm4 ; Copia os primeiros 32 bits de xmm4 para edx
        add eax, edx ;Equivalente a fazer SomTotal+=Result[i]
        
        ; Avança ponteiros
        add esi, 16; Avança 16 bytes no arrayOne
        add edi, 16; Avança 16 bytes no arrayTwo
        dec ebx ; Decrementa contador de blocos
        cmp ebx, 0
        jne LoopPrincipal; Repete se ainda houver blocos
        ; Processa elementos restantes (menos de 16)
    elementosRestantes:
        cmp ecx, 0; Verifica se há elementos restantes
        je done;Se não houver terminar
        
                ; Processa elementos um a um
        xor ebx, ebx         ; Zera ebx (usará para carregar bytes)
        xor edx, edx         ; Zera edx (usará para carregar bytes)
        
    loopElementoPorElemento:
        movzx ebx, byte ptr [esi]
        movzx edx, byte ptr [edi]
        add ebx, edx
        add eax, ebx
        ; Avança para próximo elemento
        inc esi              ; Incrementa ponteiro do arrayOne
        inc edi              ; Incrementa ponteiro do arrayTwo
        dec ecx              ; Decrementa contador
        cmp ecx,0
        jne loopElementoPorElemento ; Repete até ecx = 0
    
    ; Finalização - calcula média e retorna
    done:
        cdq               ; Estende sinal de eax para edx:eax (prepara para divisão)
        idiv dword ptr [ebp+16] ; Divide eax por maxsize (resultado em eax)
        
        ; Epílogo da função - restaura registradores
        pop edi          ; Restaura edi
        pop esi          ; Restaura esi
        pop ebx          ; Restaura ebx
        mov esp, ebp     ; Restaura stack pointer
        pop ebp          ; Restaura base pointer
        ret              ; Retorna da função (resultado em eax)
SumTotalASM ENDP

END SumTotalASM; Fim do arquivo assembly


