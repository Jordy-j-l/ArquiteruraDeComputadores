#include <iostream>
#define size1 5
#define size2 4

int SumTotal(char arrayOne[], char arrayTwo[]) {
    int maxSize = size1 + size2 == 0 ? 2 : size1 + size2;// Se ambos os tamanhos forem 0, usa 2 como valor mínimo porque cada array tera 1 elemento
    int sumTotal = 0;

    for (int i = 0; i < maxSize; i++) {
        if (i < size1 && i < size2) {//ciclo if para confirmar se o i está diacordo com os size
            sumTotal += arrayOne[i] + arrayTwo[i];
        }
        else if (i < size1) {
            sumTotal += arrayOne[i];
        }
        else if (i < size2) {
            sumTotal += arrayTwo[i];
        }
        else {
            break;
        }
    }

    return sumTotal / maxSize;
}

int main() {
    char one[size1];
    char two[size2];

    /*for (char i = 0; i < size1; i++) {
        one[i] = i + 1;
    }
    for (char i = 0; i < size2; i++) {
        two[i] = i + 2;
    }*/

    

    _asm {
    SumTotal:

    mov eax, 0
    mov ecx, 0
    for1:
        add ecx, 1
        mov one[eax], cl
        inc eax
        mov ecx, eax
        cmp eax, size1
        jb for1 
    mov eax, 0
    mov ecx, 0
    for2:
        add ecx, 2
        mov two[eax], cl
        inc eax
        mov ecx, eax
        cmp eax, size2
        jb for2
    }
    for (char i = 0; i < size1; i++) {
        printf("One=%d\n", one[i]);
    }
    for (char i = 0; i < size2; i++) {
        printf("Two=%d\n", two[i]);
    }
    printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
}

