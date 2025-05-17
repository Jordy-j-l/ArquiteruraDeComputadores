.MODEL FLAT, C
.Data
valores BYTE 128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128
.CODE

average_arrays PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    ; Carrega parâmetros
    mov esi, [ebp + 8]        ; arrayOne
    mov edi, [ebp + 12]       ; arrayTwo
    mov edx, [ebp + 16]       ; arrayResult
    mov ecx, [ebp + 20]       ; arraySize
   movdqa xmm2, XMMWORD PTR [valores] ; carrega os 16 bytes de 128 que estão na memeoria
    xor eax, eax              ; índice i = 0
    
    ; Processa 16 elementos por vez
SIMDLoop:
    cmp eax, ecx
    jge ProcessRemaining       ; Se i >= size, vai para o processamento escalar
    
    ; Carrega 16 bytes de cada array
    movdqu xmm0, [esi + eax]  ; XMM0 = arrayOne[i..i+15]
    movdqu xmm1, [edi + eax]  ; XMM1 = arrayTwo[i..i+15]
    
    ; Converte de signed (-128..127) para unsigned (0..255) somando 128
    paddb xmm0, xmm2         ; arrayOne[i] +128
    paddb xmm1, xmm2         ; arrayTwo[i] +128
    
    ; Calcula média unsigned com arredondamento
    pavgb xmm0, xmm1          ; XMM0 = (XMM0 + XMM1 + 1) / 2
    
    ; Converte de volta para signed subtraindo 128
    psubb xmm0, xmm2         ; XMM0 -= 128 (com saturação signed)
    
    ; Armazena o resultado
    movdqu [edx + eax], xmm0  ; arrayResult[i..i+15] = XMM0
    
    add eax, 16               ; Avança 16 bytes
    jmp SIMDLoop

    ; Processa elementos restantes (1 a 15) um a um
ProcessRemaining:
    cmp eax, ecx
    jge Done
    
    ; Carrega bytes com extensão de sinal para 16 bits
    movsx bx, byte ptr [esi + eax]  ; BX = arrayOne[i] (sign-extended)
    movsx dx, byte ptr [edi + eax]  ; DX = arrayTwo[i] (sign-extended)
    
    ; Calcula média com arredondamento: (a + b + 1) / 2
    add bx, dx                ; BX = arrayOne[i] + arrayTwo[i]
    inc bx                    ; BX += 1 (para arredondamento)
    sar bx, 1                 ; BX /= 2 (shift aritmético preserva sinal)
    
    ; Armazena o resultado (apenas o byte inferior)
    mov [edx + eax], bl
    
    inc eax
    jmp ProcessRemaining
    
Done:
    pop ebx
    pop edi
    pop esi
    pop ebp
    ret
average_arrays ENDP

END