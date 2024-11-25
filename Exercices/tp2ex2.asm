; Demandez son âge à l'utilisateur.
; S'il entre une valeur inférieure à 18, affichez le message "Trop jeune"

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez votre âge :",0
scanf_int:  db  "%hhd",0
reponse1:   db  "Vous êtes trop jeune",10,0

section .bss
age:    resb    1

section .text
main:
push rbp
mov rdi,question1   ; Affichage de la demande d'âge
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de l'âge
mov rsi,age         ; valeur stockée dans la variable 'age'
mov rax,0
call scanf

cmp byte[age],18    ; on compare age avec la valeur 18
jae fin             ; si age>=18 alors on saute au label 'fin'

mov rdi,reponse1    ; sinon on affiche le message "Vous êtes trop jeune"
mov rax,0
call printf

fin:

pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
