#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <chrono>

#define size 537

extern "C" void average_arrays(unsigned char* one, unsigned char* two, unsigned char* result, int size);

void averageC(unsigned char* one, unsigned char* two, unsigned char* resultC, int size) {
    for (int i = 0; i < size; i++) {
        resultC[i] = (one[i] + two[i] + 1) / 2;  // M�dia com arredondamento
    }
}

int main() {
    // Aloca mem�ria para os arrays
    unsigned char one[size];
    unsigned char two[size];
    unsigned char resultASM[size];
    unsigned char resultC[size];

    srand(time(NULL));

    // Preenche os arrays com valores aleat�rios entre 0 e 255
    for (int i = 0; i < size; i++) {
        one[i] = rand() % 256;
        two[i] = rand() % 256;
    }

    // Medir o tempo de execu��o da fun��o em Assembly
    auto startASM = std::chrono::high_resolution_clock::now();
    average_arrays(one, two, resultASM, size);
    auto endASM = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoASM = endASM - startASM;

    // Medir o tempo de execu��o da fun��o em C
    auto startC = std::chrono::high_resolution_clock::now();
    averageC(one, two, resultC, size);
    auto endC = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoC = endC - startC;

    // Mostrar os resultados de alguns elementos para verifica��o
    printf("Resultados (primeiros 10 elementos):\n");
    for (int i = 0; i < 10; i++) {
        printf("C[%d] = %d\tASM[%d] = %d\n", i, resultC[i], i, resultASM[i]);
    }

    // Mostrar os tempos
    printf("\nTempo de execu��o em C: %.2f microssegundos\n", duracaoC.count());
    printf("Tempo de execu��o em Assembly: %.2f microssegundos\n", duracaoASM.count());

    system("pause");
    return 0;
}
