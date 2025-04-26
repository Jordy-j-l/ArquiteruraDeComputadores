#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
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
    int maxSize = size1 + size2;

    // Preenche os arrays
    for (int i = 0; i < MAIOR; i++) {
        one[i] = i < size1 ? rand() % 100 : 0;
        two[i] = i < size2 ? rand() % 100 : 0;
        printf("one[%d] = %d, two[%d] = %d\n", i, one[i], i, two[i]);
    }

    printf("Resultado em C: %d\n", SumTotalC(one, two, maxSize, MAIOR));
    printf("Resultado em Assembly: %d\n", SumTotalASM(one, two, maxSize, MAIOR));

    system("pause");
    return 0;
}