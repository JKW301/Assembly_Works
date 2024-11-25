; Ecrivez un programme qui inverse deux valeurs entrées au clavier sans utiliser de variable
; intermédiaire.

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez une valeur :",0
scanf_int:  db  "%hhd",0
paire:   db  "La valeur entrée est paire",10,0
impaire:	db	"La valeur entrée est impaire",10,0

section .bss
val:    resb    1
    
section .text
main:
push rbp
; Si le bit de poids faible d'un nombre binaire est égal à 1, le nombre est impair
; Si le bit de poids faible d'un nombre binaire est égal à 0, le nombre est pair

mov rdi,question1   ; Affichage de la demande
mov rax,0
call printf

mov rdi,scanf_int  
mov rsi,val         ; valeur stockée dans la variable 'val'
mov rax,0
call scanf

and byte[val],1 ; si le bit de poids faible de val est égal à 0 
		; and détruit [val], on peut utiliser test à la place qui maintient la valeur de val
jnz val_impaire         ; sinon, c'est que le bit de poids fable est à 1
mov rdi,paire
mov rax,0
call printf
jmp fin

val_impaire:
mov rdi,impaire
mov rax,0
call printf

fin:			  
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
