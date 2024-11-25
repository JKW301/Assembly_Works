; Demandez son âge à l'utilisateur.
; S'il entre une valeur inférieure à 18, affichez le message "Trop jeune"
; Sinon, affichez le message "Bienvenue"

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez votre âge :",0
scanf_int:  db  "%hhd",0
reponse1:   db  "Vous êtes trop jeune",10,0
reponse2:   db  "Bienvenue !",10,0

section .bss
age:    resb    1

section .text
main:
    push rbp

    mov rdi,question1	; afichage de la demande d'âge
    mov rax,0
    call printf

    mov rdi,scanf_int	; lecture de 'age' au clavier
    mov rsi,age
    mov rax,0
    call scanf

    cmp byte[age],18    ; Si age>=18
    jae  welcome         ; alors saute au label 'welcome'
    mov rdi,reponse1    ; sinon affichage de "Vous êtes trop jeune"
    mov rax,0 
    call printf
    jmp fin             ; on saute à la fin du programme

welcome:            ; affichage de "Bienvenue"
    mov rdi,reponse2
    mov rax,0
    call printf

fin:

pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
