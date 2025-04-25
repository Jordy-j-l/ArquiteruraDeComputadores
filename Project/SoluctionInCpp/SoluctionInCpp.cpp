    #include <iostream>
    #define size1 3
    #define size2 4

    int SumTotal(char arrayOne[], char arrayTwo[]) {
        int maxSize = size1 + size2 == 0 ? 2 : size1 + size2;// Se ambos os tamanhos forem 0, usa 2 como valor mínimo porque cada array tera 1 elemento
        int sumTotal = 0;
        if (size1 > size2) {
            char three[size1];
            for (char i = 0;i < size1;i++) {
                three[i] = arrayOne[i] + arrayTwo[i];
            }
            for (char i = 0;i < size1;i++) {
                sumTotal += three[i];
            }
        }else {
            char three[size2];
            for (char i = 0;i < size2;i++) {
                three[i] = arrayOne[i] + arrayTwo[i];
            }
            for (char i = 0;i < size2;i++) {
                sumTotal += three[i];
                printf("%d >>SumTotal\n", sumTotal);
            }
        }

        return sumTotal / maxSize;
    }

    int main() {

        if (size1 > size2) {
            char one[size1];
            char two[size1];
                for(char i = 0; i < size1; i++) {
                    one[i] = i + 1;
                    printf("%d >>\n", one[i]);
                }
                for (char i = 0; i < size1; i++) {
                   
                    two[i] = i < size2 ? i + 2 : 0;
                    printf("%d >>\n", two[i]);
                }
         printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
        }
        else {
            char one[size2];
            char two[size2];
            
                for (char i = 0; i < size2; i++) {
                    one[i] = i < size1 ? i + 1 : 0;
                    printf("%d >>\n", one[i]);
                    
                }
                for (char i = 0; i < size2; i++) {
                    two[i] = i + 2;
                    printf("%d >>\n", two[i]);
                }
            printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
        }
   
    }




    
