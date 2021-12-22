#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define bits 5 //I was lazy and stupid

int findMostCommoninPos (FILE *fp, int pos);
const char * array2string (int array[]);
int linescount (FILE *fp);

int main (int argc, char *argv[]) {
    FILE *fp = fopen(argv[1], "r");
    int pos, gamma[bits], epsilon[bits];

    if (fp == NULL) {
        perror("Unable to open file!");
        return 1;
    }
    
    for (pos=0; pos<=bits-1; pos++) {
        gamma[pos] = findMostCommoninPos(fp, pos);
        if (gamma[pos] == 1) {
            epsilon[pos] = 0;
        } else {
            epsilon[pos] = 1;
        }
    }

    const char *G = array2string(gamma);
    const char *E = array2string(epsilon);
    printf("=========Part1=======\n");
    printf("Gamma: %s\n", G);
    printf("Epsilon: %s\n", E);
    printf("------\n");
    char *endptr;
    printf("Gamma as decimal: %ld\n", strtol(G, &endptr, 2));
    printf("Epsilon as decimal: %ld\n", strtol(E, &endptr, 2));
    printf("------\n");
    printf("Total power consumption: %ld\n", strtol(G, &endptr, 2)*strtol(E, &endptr, 2));

    // I didn't know someone should have told me...
    printf("=========Part2=======\n");
    int lines = linescount(fp);
    char *strarray[lines];
    int l = 0;
    char *line = NULL;
    size_t len = 0;
    while (getline(&line, &len, fp) != -1) {
        strarray[l] = strdup(line);
        l++;
    }
    free(line);

    for (int p=0; p<=bits; p++) {
        int most_common = findMostCommoninPos(fp, p);
        if (most_common == 1 || most_common == 2) {
            //keep the nums with 1 at p position
        } else {
            //keep the nums with 0 at o position
        }
    }
    
    fclose(fp);
    return 0;
}

int linescount(FILE *fp) {
    char *line = NULL;
    size_t len = 0;
    int lines_count = 0;
    while (getline(&line, &len, fp) != -1) {
        lines_count++;
    }
    rewind(fp);
    free(line);

    return lines_count;
}

// taking an the array as an argument and returns it as a single string
const char * array2string(int array[]) {
    char string[bits];
    int index = 0;
    for (int i=0; i<=bits-1; i++) {
        index += sprintf(&string[index], "%d", array[i]);
    }

    return strdup(string);
}

// finds the most common in x position
int findMostCommoninPos (FILE *fp, int pos) {
    char *line = NULL;
    size_t len = 0, nread;
    int zeroes = 0, ones = 0;
    int most_common;

    while ((nread = getline(&line, &len, fp)) != -1) {
        if (line[pos] == '0') {
            zeroes++;
        } else if (line[pos] == '1') {
            ones++;
        } else {
            perror("This is not 1 or 0!\n");
            exit(EXIT_FAILURE);
        }
    }

    if (zeroes > ones) {
        most_common = 0;
    } else if (zeroes < ones) {
        most_common = 1;
    } else {
        most_common = 2;
    }
    
    rewind(fp);
    free(line);
    return most_common; //return 1 if the ones are most common 0 if the zeroes are and 2 if both are equally common
}
