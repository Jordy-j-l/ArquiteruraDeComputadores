#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <chrono>

#define size 200

extern "C" void average_arrays( char one[],  char two[],  char result[], int arraySize);

void averageC( char one[],  char two[],  char result[], int arraySize) {
    for (int i = 0; i < size; i++) {
       
        result[i] = (one[i] + two[i] + 1) / 2;  // Média com arredondamento
    }
}

int main() {
    char teste = 200;

   
     char one[size];
     char two[size];
     char resultASM[size];
     char resultC[size];

    srand(time(NULL));

    // Preenche os arrays com valores aleatórios entre 0 e 255
    for (int i = 0; i < size; i++) {
        one[i] = (rand() % 256)-128;

    }
    for (int i = 0; i < size; i++) {
        two[i] = (rand() % 256)-128;

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
