#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 10
//extern "C" void Sinal(char one[], char two[], char result[], int arraySize);
// Função simplificada para comparar magnitudes
void SinalSimples(char A[], char B[], char R[], int n) {
    for (int i = 0; i < n; i++) {
        // Calcula valores absolutos
        char absA = A[i] < 0 ? -A[i] : A[i];
        char absB = B[i] < 0 ? -B[i] : B[i];

        // Compara e armazena o resultado
        if (absA > absB) {
            R[i] = A[i] < 0 ? -1 : 1;
        }
        else if (absB > absA) {
            R[i] = B[i] < 0 ? -1 : 1;
        }
        else if (absA == absB) {
            if ((A[i] == -B[i]) || -A[i] == B[i]) {
                R[i] = 0;
            }
        }
        else {
            R[i] = 0;
        }
    }
}

int main() {
    char A[SIZE], B[SIZE], ResultadoC[SIZE], ResultadoASM[SIZE];

    // Inicializa gerador de números aleatórios
    srand(time(NULL));

    // Preenche os arrays com valores entre -128 e 127
    for (int i = 0; i < SIZE; i++) {
        A[i] = (rand() % 256) - 128;
        B[i] = (rand() % 256) - 128;
    }


    // Chama a função
    SinalSimples(A, B, ResultadoC, SIZE);
    //Sinal(A, B, ResultadoASM, SIZE);
    // Mostra os resultados
    printf("A\tB\tResultadoemC\tResultadoemASM\n");
    printf("-----------------------\n");
    for (int i = 0; i < SIZE; i++) {
        printf("%d\t%d\t%d\t\n", A[i], B[i], ResultadoC[i]);
    }

    return 0;
}