#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <chrono>

#define size 20


extern "C" void Sinal( char one[],  char two[],  char result[], int arraySize);



int main() {
    // Aloca memória para os arrays
     char one[size];
     char two[size];
     char resultASM[size];
     char resultC[size];

    srand(time(NULL));

    // Preenche os arrays com valores aleatórios entre 0 e 255
    for (int i = 0; i < size; i++) {
        one[i] = (rand() % 256) - 128;

    }
    for (int i = 0; i < size; i++) {
        two[i] = (rand() % 256) - 128;

    }
    Sinal(one, two, resultASM, size);

    // Mostrar os resultados de alguns elementos para verificação
    printf("Resultados:\n");
    for (int i = 0; i < size; i++) {
        printf("ArayOne[%d] = % d\t ArayTwo[%d] = % d |\tASM[%d] = %d\n", i, one[i], i, two[i], i, resultASM[i]);
    }
    system("pause");
    return 0;
}
