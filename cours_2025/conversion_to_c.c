#include <stdlib.h>
#include <stdio.h>


int main() {
    // move eax, 5 (in C)
    int eax = 5;
    // cmp eax, 10
    if (eax < 10) {
        printf("eax is less than 10\n");
    } else {
        printf("eax is greater than or equal to 10\n");
    }
    //jl else_if (in C, call function else_if in jl is true)
    if (eax < 10) {
        else_if();
    }

    // move ebx, 1
    int ebx = 1;

    // jmp end_if
    end_if();
}


int else_if(){
    // move ebc, 2
    int ebx = 2;
    
    // jmp end_if
    end_if();
}

int end_if(){
    // end program
    exit(0);
}