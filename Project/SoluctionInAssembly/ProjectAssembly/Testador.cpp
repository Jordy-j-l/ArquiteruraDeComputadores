#include <iostream>
#include <cstdio>
#include <cstdlib> 
#define size1 16
#define size2 16
#define MAIOR (size1 > size2 ? size1 : size2)

extern "C" int SumTotalASM(char* arrayOne, char* arrayTwo, int maxsize, int arraySize);
// Função em C para comparação
int SumTotalC(char arrayOne[], char arrayTwo[], int maxsize, int arraySize) {
    int sumTotal = 0;
    for (int i = 0; i < arraySize; i++) {
        sumTotal += arrayOne[i] + arrayTwo[i];
    }
    return sumTotal / maxsize;
}

int main(){
    // Aloca memória alinhada para SSE
    char* one = (char*)_aligned_malloc(MAIOR, ALIGNMENT);
    char* two = (char*)_aligned_malloc(MAIOR, ALIGNMENT);
    int maxSize = (size1 + size2) ? (size1 + size2) : 2;

    // Preenche os arrays
    for (int i = 0; i < MAIOR; i++){
        one[i] = i < size1 ? i + 1 : 0;
        two[i] = i < size2 ? i + 2 : 0;

        printf("one[%d] = %d, two[%d] = %d\n", i, one[i], i, two[i]);
    }
    printf("Resultado em C: %d\n", SumTotalC(one, two, maxSize, MAIOR));
    printf("Resultado em Assembly: %d\n", SumTotalASM(one, two, maxSize, MAIOR));
    // Libera memória alinhada
    _aligned_free(one);
    _aligned_free(two);
    return 0;
}