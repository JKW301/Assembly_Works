; Demandez à l'utilisateur de remplir un tableau de 10 cases d'entiers.
; Affichez ce tableau sous la forme tab[x]=y.

extern printf
extern scanf

%define DWORD 	4
%define BYTE 	1

global main

section .data
question:  db  "Entrez la valeur n°%hhd: ",0
scanf_int:  db  "%hhd"
affichage:  db  "t[%d]=%d",10,0
i:	db 0

section .bss
tab:  	resb    10


    
; Cette version de l'exercice 1 du TP3 n'utilise pas de variable intermédiaire dans laquelle on lit
; et qu'on range ensuite dans le tableau (scanf("%d",&var); puis tab[i]=var; en C))
; On va ici directement envoyer à scanf l'adresse de la case à remplir (soit scanf("%d",&tab[i]) en C).	
; Dans cette V2, on utilise directement un registre pour stocker l'adresse du tableau.
; On utilise le registre rbx car les conventions de l'assembleur font qu'il n'est pas modifié
; ni par printf, ni par scanf (cf chapitre 6 sur les fonctions, registres préservés)
	
section .text
main:
push rbp

mov rbx,tab				; on met l'adresse du tableau dans rbx

boucle:
	mov rdi,question 
	movzx rsi,byte[i]
	mov rax,0
	call printf

	mov rdi,scanf_int   ; lecture de la première valeur 
	mov rsi,rbx       ; la valeur lue sera stockée à l'adresse contenue dans rbx (soit l'adresse de la case du tableau)
	mov rax,0
	call scanf

	add rbx,BYTE	; on ajoute à rbx la taille d'une case pour qu'il pointe sur la case suivante
	inc byte[i]
	cmp byte[i],10		; tant que i<10, on boucle.
	jb boucle

mov byte[i],0	
boucle_affichage:	
	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros pour afficher le numéro de case 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tab+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  10

	jb boucle_affichage    ; si i<10, on saute à boucle_affichage
                    
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
