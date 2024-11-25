; Demandez à l'utilisateur une valeur entière.
; Calculez la factorielle du nombre entré.

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez une valeur :",0
scanf_int:  db  "%d",0
reponse1:   db  "Résultat : %ld",10,0
reponse2:   db	"Valeur trop grande : dépassement de capacité",10,0

section .bss
val:    resq    1

section .text
main:
push rbp

mov rdi,question1   ; Affichage de la demande
mov rax,0
call printf

mov rdi,scanf_int  
mov rsi,val         ; valeur stockée dans la variable 'val'
mov rax,0
call scanf

mov rax,1
cmp qword[val],1		; si val==0 ou val==1 alors val! ==1
jbe affichage_final		; on passe directement à l'affichage du résultat.

boucle:
		mul qword[val]		; rax=rax*val
		cmp rdx,0		; si rdx différent de 0, cela signifie que le résultat ne tient pas sur rax seul
		jne fin_bad		; Comme on affiche rax à la fin, on a dépassé la capacité de rax.
		dec qword[val]		; val=val-1
		cmp qword[val],1	; Tant que val>1
		ja boucle		; on recommence la boucle

affichage_final:
mov rdi,reponse1    ; affichage du résultat final
mov rsi,rax
mov rax,0
call printf
jmp fin

fin_bad:
mov rdi,reponse2	; Affichage erreur
mov rax,0
call printf

fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
