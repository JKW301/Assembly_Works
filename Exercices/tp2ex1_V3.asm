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

cmp byte[nb],0
jle fin

; on utilise le registre bl car il n'est pas modifié par printf/scanf
mov bl,0	; initialisation de bl à 0
boucle: ; for (bl=0;bl<nb;bl++)
    mov rdi,message1	; affichage de "Bonjour !"
    mov rax,0
    call printf
    inc bl	; incrémentation de bl
    cmp bl,byte[nb]  	; on compare bl et nb
    jb boucle       	; si bl<nb alors on saute à boucle

fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall
ret
