#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <chrono>

#define size 545

extern "C" void average_arrays(unsigned char one[], unsigned char two[], unsigned char result[], int arraySize);

void averageC(unsigned char one[], unsigned char two[], unsigned char result[], int arraySize) {
    for (int i = 0; i < size; i++) {
        result[i] = (one[i] + two[i] + 1) / 2;  // Média com arredondamento
    }
}
void average_arrays_signed(char one[], char two[], char result[], char signs[], int size) {
    // Passo 2: Criar array de sinais e converter para complemento
    for (int i = 0; i < size; i++) {
        // Determinar sinal do maior em módulo
        if (abs(one[i]) >= abs(two[i])) {
            signs[i] = (one[i] < 0) ? -1 : 1;
        }
        else {
            signs[i] = (two[i] < 0) ? -1 : 1;
        }

        // Converter para complemento se negativo
        if (one[i] < 0) one[i] = ~one[i] + 1;
        if (two[i] < 0) two[i] = ~two[i] + 1;
    }

    // Passo 4: Calcular média (usando pavgb via assembly)
    average_arrays(one, two, result, size);

    // Passo 5: Aplicar sinal
    for (int i = 0; i < size; i++) {
        result[i] *= signs[i];
    }
}
int main() {
    // Aloca memória para os arrays
    unsigned char one[size];
    unsigned char two[size];
    unsigned char resultASM[size];
    unsigned char resultC[size];

    srand(time(NULL));

    // Preenche os arrays com valores aleatórios entre 0 e 255
    for (int i = 0; i < size; i++) {
        one[i] = rand() % 256;

    }
    for (int i = 0; i < size; i++) {
        two[i] = rand() % 256;

    }
    averageC(one, two, resultC, size);
    average_arrays(one, two, resultASM, size);

    // Mostrar os resultados de alguns elementos para verificação
    printf("Resultados:\n");
    for (int i = 0; i < size; i++) {
        printf("ArayOne[%d] = % d\t ArayTwo[%d] = % d | C[%d] = %d\tASM[%d] = %d\n", i, one[i], i, two[i], i, resultC[i], i, resultASM[i]);
    }
    // Medir o tempo de execução da função em Assembly
    /*auto startASM = std::chrono::high_resolution_clock::now();
    average_arrays(one, two, resultASM, size);
    auto endASM = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoASM = endASM - startASM;

    // Medir o tempo de execução da função em C
    auto startC = std::chrono::high_resolution_clock::now();
    averageC(one, two, resultC, size);
    auto endC = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoC = endC - startC;
    // Mostrar os tempos
    printf("\nTempo de execução em C: %.2f microssegundos\n", duracaoC.count());
    printf("Tempo de execução em Assembly: %.2f microssegundos\n", duracaoASM.count());
    */
    system("pause");
    return 0;
}
