#include <stdio.h>

int main() {
    int i = 0;
    int i10=0;

    while (i10) {
        printf("%d", i);
        i++;
        if (i10) {
            printf("%d", i);
        }
    }

    return 0;
}
