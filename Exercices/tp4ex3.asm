; Ecrivez un programme qui donne la parité d'un nombre entré au clavier sans utiliser la division

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez la valeur 1 :",0
question2:  db  "Entrez la valeur 2 :",0
scanf_int:  db  "%hhd"
reponse1:   db  "Avant : val1=%d, val2=%d",10,0
reponse2:   db  "Après : val1=%d, val2=%d",10,0
resultat:	dd	0

section .bss
val1:  	resb    1
val2:	resb	1

    
section .text
main:
push rbp

mov rdi,question1   
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de la première valeur 
mov rsi,val1         ; valeur stockée dans la variable 'val1'
mov rax,0
call scanf

mov rdi,question2   
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de la seconde valeur
mov rsi,val2         ; valeur stockée dans la variable 'val1'
mov rax,0
call scanf

mov rdi,reponse1    ; on affiche le résultat
movzx rsi,byte[val1]
movzx rdx,byte[val2]
mov rax,0
call printf 

mov al,byte[val1]
mov bl,byte[val2]

xor al,bl	; a=a xor b
xor bl,al	; b=b xor a
xor al,bl	; a=a xor b

mov byte[val1],al
mov byte[val2],bl

mov rdi,reponse2    ; on affiche le résultat
movzx rsi,byte[val1]
movzx rdx,byte[val2]
mov rax,0
call printf

pop rbp
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall

ret
