    #include <iostream>
    #define size1 3
    #define size2 4

    int SumTotal(char arrayOne[], char arrayTwo[]) {
        int maxSize = size1 + size2 == 0 ? 2 : size1 + size2;// Se ambos os tamanhos forem 0, usa 2 como valor mínimo porque cada array tera 1 elemento
        int sumTotal = 0;
        if (size1 > size2) {
            char tree[size1];
            for (char i = 0;i < size1) {
                tree[i] = arrayOne[i] + arrayTwo[i];
            }
            for (char i = 0;i < size2) {
                sumTotal += tree[i];
            }
        }else {
            char tree[size2];
            for (char i = 0;i<size2) {
                tree[i] = arrayOne[i] + arrayTwo[i];
            }
            for (char i = 0;i < size2) {
                sumTotal += tree[i];
            }
        }

        return sumTotal / maxSize;
    }

    int main() {
        char one[size1];
        char two[size2];

        if (size1>size2){
            char tree[size1]
            for (char i = 0; i < size1; i++) {
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
        }
        else {
            char tree[size2]
            for (char i = 0; i < size2; i++) {
                if (i <= size1) {
                    one[i] = i+1;
                }
                else {
                    one[i] = 0;
                }
            }
            for (char i = 0; i < size1; i++) {
                    two[i] = i + 2;
            }
        }
        }


    
        printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
    }
