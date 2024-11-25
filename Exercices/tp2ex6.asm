; Demandez 2 valeurs à l'utilisateur.
; Affichez le produit de ces 2 valeurs en n'utilisant que inc et/ou dec

extern printf
extern scanf

global main

section .data
question1:  	db  	"Entrez la valeur 1 :",0
question2:  	db  	"Entrez la valeur 2 :",0
scanf_int:  	db  	"%hhd"
reponse1:   	db  	"Résultat: %d",10,0
resultat:	dw	0
affich:		db	"resultat intermediaire : %d",10,0

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

cmp byte[val1],0		; si val1==0, on termine
je fin

mov rdi,question2
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de la seconde valeur
mov rsi,val2         ; valeur stockée dans la variable 'val1'
mov rax,0
call scanf

cmp byte[val2],0		; si val2==0, on termine
je fin

boucle1: ; tourne val1 fois
	mov bl,byte[val2]		; al prend la valeur de val2
	boucle2: ; on y incrémente resultat de la valeur de val2
		inc word[resultat]	; on incrémente résultat
		dec bl			; on décrémente al
		cmp bl,0
		jne boucle2		; on continue tant que al différent de 0
	; affichage valeurs de résultat
	mov rdi,affich
	movzx esi,word[resultat]
	mov rax,0
	call printf
	dec byte[val1]		; on décrémente val1
	cmp byte[val1],0	; on recommence jusqu'à ce que val1 soit nulle
	jne boucle1

fin:
mov rdi,reponse1    ; on affiche le résultat
movzx esi,word[resultat]
mov rax,0
call printf 

pop rbp
; Pour fermer le programme proprement :
mov    rax, 60 
mov    rdi, 0
syscall

ret
