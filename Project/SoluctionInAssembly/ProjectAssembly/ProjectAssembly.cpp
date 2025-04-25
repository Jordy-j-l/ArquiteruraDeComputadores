int main() {

    if (size1 > size2) {
        char one[size1];
        char two[size1];
        for (char i = 0; i < size1; i++) {
            one[i] = -i;
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
            one[i] = i < size1 ? -i : 0;
            printf("%d >>\n", one[i]);

        }
        for (char i = 0; i < size2; i++) {
            two[i] = i + 2;
            printf("%d >>\n", two[i]);
        }
        printf("A media dos dois arrays e: %d\n", SumTotal(one, two));
    }

}