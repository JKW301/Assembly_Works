; Demandez une valeur entre 10 et 20 à l'utilisateur.
; S'il entre une valeur supérieure à 20 ou inférieure à 10, affichez le message "Erreur".

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez une valeur entre 10 et 20 :",0
scanf_int:  db  "%hhd",0
reponse1:   db  "Valeur erronée",10,0

section .bss
val:    resb    1

section .text
main:
push rbp

mov rdi,question1	; affichage de la question
mov rax,0
call printf

mov rdi,scanf_int	; lecture au clavier de 'val'
mov rsi,val
mov rax,0
call scanf

cmp byte[val],10	; comparaison de val et 10
jb  wrong		; si val<10 on saute au label 'wrong'
cmp byte[val],20	; sinon on compare val et 20
jbe fin			; si val<=20 on saute au label 'fin'
			; sinon on continue
wrong:
    mov rdi,reponse1	; affichage du message d'erreur
    mov rax,0
    call printf

fin:

pop rbp
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
