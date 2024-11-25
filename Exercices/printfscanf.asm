extern printf
extern scanf

global main

section .data
    fmt_scan:   db  "%d",0
    fmt_print:  db  "Vous avez entré la valeur : %d",10,0
    ask:        db  "Entrez une valeur entière :",0

section .bss
    reponse : resb    1
    
section .text
main:
push rbp
    mov rdi,ask		; affichage de la question
    mov rax,0		; pas d'arguments flottants
    call printf
    
    mov rdi,fmt_scan	; format du scanf
    mov rsi,reponse	; adresse de la variable où stocker la saisie
    mov rax,0		; pas d'arguments flottants
    call scanf
 
    mov rdi,fmt_print		; format du second printf
    movzx rsi,byte[reponse]	; valeur de l'argument entier à afficher
    mov rax,0			; pas d'arguments flottants
    call printf

pop rbp
    mov    rax, 60         
    mov    rdi, 0
    syscall
    ret
