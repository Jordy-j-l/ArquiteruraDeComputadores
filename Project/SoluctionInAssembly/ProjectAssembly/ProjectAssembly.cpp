#include <iostream>
#include <cstdio>
#define size1 8
#define size2 6
#define MAIOR (size1 > size2 ? size1 : size2)


extern int SumTotalASM(char* arrayOne, char* arrayTwo, int maxsize, int arraySize);

// Função em C para comparação
int SumTotalC(char arrayOne[], char arrayTwo[], int maxsize, int arraySize) {
    int sumTotal = 0;
    for (int i = 0; i < arraySize; i++) {
        sumTotal += arrayOne[i] + arrayTwo[i];
    }
    return sumTotal / maxsize;
}




int main() {
    int maxSize = size1 + size2 + 2;
    char one[MAIOR];
    char two[MAIOR];

    for (int i = 0; i < MAIOR; i++) {

        one[i] = i < size1 ? i + 1 : 0;
        printf("%d >>\n", one[i]);
    }
    for (int i = 0; i < MAIOR; i++) {

        two[i] = i < size2 ? i + 2 : 0;
        printf("%d >>\n", two[i]);
    }
    printf("Resultado em C: %d\n", SumTotalC(arrayOne, arrayTwo, maxsize, ARRAY_SIZE));
    printf("Resultado em Assembly: %d\n", SumTotalASM(arrayOne, arrayTwo, maxsize, ARRAY_SIZE));




}