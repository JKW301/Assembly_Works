; Demandez à l'utilisateur une valeur entière inférieure à 256.
; Affichez la valeur du nombre en binaire.
extern printf
extern scanf

global main

%define BYTE	1

section .data
question1:  db  "Entrez une valeur (inférieure à 256) :",0
scanf_int:  db  "%hd",0
resultat:	db	"Conversion : %s",10,0
chresult:	db	"00000000",10,0

section .bss
val:    resw    1
valbyte:	resb	1

section .text
main:
push rbp

demande:
mov rdi,question1   ; Affichage de la demande
mov rax,0
call printf

mov rdi,scanf_int  
mov rsi,val         ; valeur stockée dans la variable 'val'
mov rax,0
call scanf

mov ecx,0

cmp word[val],255	; Si val>255 (occupe plus d'un octet) alors on réitère la demande
ja demande
mov al,byte[val]	; on récupère l'octet de poids faible de val dans al

boucle:
cmp al,0		; si al==0 alors on n'a plus que des zéros dans le nombre à convertir,
je fin			; on a donc terminé

shl al,1		; on décale al de 1 bit vers la gauche, le bit sortant est dans CF
jnc suite			; si CF==0, on saute au label 'suite' (on ne fait rien)
mov byte[chresult+ecx*BYTE],'1'	; sinon on range le caractère '1' dans la chaine résultat
suite:
inc ecx			; on avance dans la chaîne résultat
jmp boucle

fin:
mov rdi,resultat
mov rsi,chresult
mov rax,0
call printf

pop rbp 
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
