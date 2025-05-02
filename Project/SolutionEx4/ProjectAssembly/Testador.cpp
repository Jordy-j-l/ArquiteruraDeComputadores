#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <chrono>

#define size1 537
#define size2 5000
#define MAIOR (size1 > size2 ? size1 : size2)

extern "C" int SumTotalASM(char* arrayOne, char* arrayTwo, int maxsize, int arraySize);

int SumTotalC(char arrayOne[], char arrayTwo[], int maxsize, int arraySize) {
    int sumTotal = 0;
    for (int i = 0; i < arraySize; i++) {
        sumTotal += arrayOne[i] + arrayTwo[i];
    }
    return sumTotal / maxsize;
}

int main() {
    // Aloca memória alinhada
    char one[MAIOR];
    char two[MAIOR];
    srand(time(NULL));
    int maxSize = size1 + size2 + 2;

    // Preenche os arrays
    for (int i = 0; i < MAIOR; i++) {
        one[i] = i < size1 ? rand() % 100 : 0;
        two[i] = i < size2 ? rand() % 100 : 0;
        //printf("one[%d] = %d, two[%d] = %d\n", i, one[i], i, two[i]); //está comentado para não atrasar o tempo de execução em C a imprimir os 2 arrays ao user
    }

    // Medir o tempo da função em C
    auto startC = std::chrono::high_resolution_clock::now();
    int resultadoC = SumTotalC(one, two, maxSize, MAIOR);
    auto endC = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoC = endC - startC;

    // Medir o tempo da função em Assembly
    auto startASM = std::chrono::high_resolution_clock::now();
    int resultadoASM = SumTotalASM(one, two, maxSize, MAIOR);
    auto endASM = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duracaoASM = endASM - startASM;

    // Mostrar os resultados
    printf("Resultado em C: %d\n", resultadoC);
    printf("Resultado em Assembly: %d\n", resultadoASM);
    printf("\n");
    printf("Tempo de execução em C: %.2f microssegundos\n", duracaoC.count());
    printf("Tempo de execução em Assembly: %.2f microssegundos\n", duracaoASM.count());

    system("pause");
    return 0;
}
