; Demandez une valeur entre 10 et 20 à l'utilisateur.
; S'il entre une valeur supérieure à 20 ou inférieure à 10, affichez le message "Erreur" et 
; affichez si la valeur entrée est trop grande ou trop petite.

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez une valeur entre 10 et 20 :",0
scanf_int:  db  "%hhd",0
rep_small:   db  "Valeur erronée : trop petite",10,0
rep_big:   db  "Valeur erronée : trop grande",10,0

section .bss
val:    resb    1

section .text
main:
push rbp
mov rdi,question1   ; Afichage du message de demande de la valeur
mov rax,0
call printf

mov rdi,scanf_int   ; Lecture de la valeur au clavier
mov rsi,val         ; stockée dans 'val'
mov rax,0
call scanf

cmp byte[val],10    ; on compare val et 10
jb  too_small       ; si val<10 on saute au label 'too_small'
cmp byte[val],20    ; on compare val et 20
jbe fin              ; si val<=20, on saute au label 'fin'
mov rdi,rep_big     ; sinon
mov rax,0           ; on affiche le message "Trop grand"
call printf
jmp fin

too_small:          ; affichage du message "Trop petit"
    mov rdi,rep_small
    mov rax,0
    call printf

fin: 

; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall
ret
