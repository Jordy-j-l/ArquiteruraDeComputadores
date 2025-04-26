    #include <iostream>
    #include <cstdio>
    #define size1 8
    #define size2 6
    #define MAIOR (size1 > size2 ? size1 : size2)
   
    int SumTotal(char arrayOne[], char arrayTwo[], int maxsize) {
        int sumTotal = 0;
        int three[MAIOR];
        for (int i = 0;i < MAIOR;i++) {
            three[i] = arrayOne[i] + arrayTwo[i];
        }
        for (int i = 0;i < MAIOR;i++) {
            sumTotal += three[i];
        }
        return sumTotal / maxsize;
    }

    int SumTotalC(char arrayOne[], char arrayTwo[], int maxsize, int arraySize) {
        int sumTotal = 0;
        for (int i = 0; i < arraySize; i++) {
            sumTotal += arrayOne[i] + arrayTwo[i];
        }
        return sumTotal / maxsize;
    }//Resolução pensada depois de programar em assembly

    int main(){
        int maxSize = size1 + size2 == 0 ? 2 : size1 + size2;// Se ambos os tamanhos forem 0, usa 2 como valor mínimo porque cada array tera 1 elemento
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
        printf("A media dos dois arrays e: %d\n", SumTotal(one, two,maxSize));
        printf("A media dos dois arrays e: %d\n", SumTotalC(one, two, maxSize, MAIOR));
    
    
    
    
    }