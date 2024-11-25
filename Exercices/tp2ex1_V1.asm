; Demandez une valeur à l'utilisateur
; Afficher la chaîne "Bonjour" autant de fois que la valeur entrée

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez un nombre : ",0
message1:   db  "Bonjour !",10,0
scanf_int:  db  "%hhd",0

section .bss
nb:     resb    1

section .text
main:
push rbp

mov rdi,question1	; affichage de "Entrez un nombre : "
mov rax,0
call printf

mov rdi,scanf_int	; lecture au clavier de 'nb'
mov rsi,nb
mov rax,0
call scanf

cmp byte[nb],0		; si la valeur entrée est inférieure
jle fin			; ou égale à 0, on ca à la fin du programme

boucle: ; for (nb;nb>0;nb--)
    mov rdi,message1	; affichage de "Bonjour !"
    mov rax,0
    call printf
    dec byte[nb]	; décrémentation de nb
    cmp byte[nb],0  	; on compare nb et 0
    ja boucle       	; si nb>0 alors on saute à boucle

fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall
ret
