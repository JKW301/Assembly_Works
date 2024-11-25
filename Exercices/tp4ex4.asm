; tp4 ex 12
extern printf
extern scanf

global main

section .data
question1:  	db  "Entrez une valeur :",0
scanf_int:  	db  "%hhd",0
paire:		db  "La valeur entrée est paire",10,0
impaire:	db	"La valeur entrée est impaire",10,0

section .bss
val:    resb    1

section .text
main:
push rbp
; Si le bit de poids faible d'un nombre binaire est égal à 1, le nomre est impair
; Si le bit de poids faible d'un nombre binaire est égal à 0, le nomre est pair

mov rdi,question1   ; Affichage de la demande
mov rax,0
call printf

mov rdi,scanf_int  
mov rsi,val         ; valeur stockée dans la variable 'val'
mov rax,0
call scanf

shr byte[val],1		; on décale val de 1 bit vers la droite : CF reçoit le bit sortant
jc val_impaire		; si CF==1 alors le bit sortant est 1 et le nombre est impair
mov rdi,paire		; sinon, le nombre est pair
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
