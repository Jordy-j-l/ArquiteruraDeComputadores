    #include <iostream>
    #define size1 3
    #define size2 4

    int SumTotal(char arrayOne[], char arrayTwo[]) {
        int maxSize = size1 + size2 == 0 ? 2 : size1 + size2;// Se ambos os tamanhos forem 0, usa 2 como valor m�nimo porque cada array tera 1 elemento
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
            }
        }

        return sumTotal / maxSize;
    }

    int main() {

        if (size1 > size2) {
            char three[size1];
            char one[size1];
            char two[size1];
                for(char i = 0; i < size1; i++) {
                    one[i] = i + 1;
                }
                for (char i = 0; i < size1; i++) {

                    if (i <= size2) {
                        two[i] = i + 2;
                    }
                    else {
                        two[i] = 0;
                    }

                }
         printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
        }
        else {
            char one[size2];
            char two[size2];
            char three[size2];
                for (char i = 0; i < size2; i++) {
                    if (i <= size1) {
                        one[i] = i + 1;
                    }
                    else {
                        one[i] = 0;
                    }
                }
                for (char i = 0; i < size1; i++) {
                    two[i] = i + 2;
                }
            printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
        }
   
    }




    
