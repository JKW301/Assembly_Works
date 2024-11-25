; Ecrire un programme qui supprime la première occurrence d'une chaîne de caractères ch1 
; dans une chaîne de caractères ch et qui la remplace par le caractère '-'

extern printf
extern scanf

%define DWORD 4
%define BYTE 	1

global main

section .data
question1:  db  "Entrez une chaine de caractères (sans espaces) : ",0
question2:	db	"Entrez la chaîne à supprimer : ",0
scanf_string:  db  "%s",0
aff_result:  db  "Résultat : %s",10,0
crlf	db	10,0

i:	db 0
taille_ch2:	db	0
nbegal:	db	0

section .bss
chaine_init:  	resb    50
chaine_suppr:	resb	10
adr:	resq	1

section .text
main:
push rbp
	mov rdi,question1 
	mov rax,0
	call printf

	mov rdi,scanf_string
	mov rsi,chaine_init 
	mov rax,0
	call scanf
	
	mov rdi,question2 
	mov rax,0
	call printf

	mov rdi,scanf_string
	mov rsi,chaine_suppr 
	mov rax,0
	call scanf
	
	mov rdi,crlf
	mov rax,0
	call printf
	
; Calcul de la taille de chaine_suppr
mov eax,0	; eax=indice du caractère traité
pour2:
	cmp byte[chaine_suppr+eax*BYTE],0	; on compare le caractère en cours avec la valeur 0 (fin de chaîne)
	je fin_ch2			; s'ils sont égaux : fin de chaîne donc fin de traitement
	inc byte[taille_ch2]		; sinon on incrémente la taille de ch2
	inc eax				; incrémentation de l'indice
	jmp pour2			; on recommence
fin_ch2:

mov eax,0	; indice de parcours de chaine_init dans eax 
mov ebx,0	; indice de parcours de chaine_suppr dans ebx 

boucle:
	mov cl,byte[chaine_init+eax*BYTE]	; cl=chaine_init[eax]
	cmp cl,byte[chaine_suppr+ebx*BYTE]	; on compare cl avec le caractère de ch2
	je egalite		; s'ils sont égaux, on saute au label egalite
				; sinon, on n'a pas trouvé chaine_suppr entièrement donc :
	sub al,byte[nbegal]	;  - on recule dans chaine_init du nombre de caractères consécutifs égaux
	mov byte[nbegal],0	;  - on réinitialise le nombre de caractères consécutifs égaux à 0
	mov ebx,0		;  - on repart du début de ch2
	back:
	inc eax			; on incrémente  l'indice de ch1
	cmp byte[chaine_init+eax*BYTE],0	; si on n'est pas à la fin de ch1
jne boucle				; on recommence

jmp fin

egalite:
inc byte[nbegal]		; on incrémente le nombre de caractères égaux consécutifs
inc ebx			; on avance dans ch2
mov dl,byte[taille_ch2]	
cmp byte[nbegal],dl	; on compare nbegal avec la taille de ch2
jne back		; s'ils sont égaux on a terminé et trouvé.

delete:
mov byte[chaine_init+eax*BYTE],'-'	; on écrit le caractère "-" dans ch1
dec eax					; on recule d'un caractère dans ch1
dec byte[taille_ch2]			; on décrémente taille_ch2
cmp byte[taille_ch2],0		; tant que taille_ch2 >0
jne delete				; on recommence

fin:
mov rdi,aff_result
mov rsi,chaine_init
mov rax,0
call printf


pop rbp
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
