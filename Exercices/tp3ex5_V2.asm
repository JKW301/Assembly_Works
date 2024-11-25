; Ecrire un programme qui lit un entier et un tableau d'entiers au clavier et qui élimine toutes 
; les occurrences de l'entier dans le tableau en tassant les éléments restants.

extern printf
extern scanf

%define	BYTE	1
%define DWORD   4

global main

section .data
question1:  db  "Entrez l'élément %d : ",0
question2:	db	"Tapez 0 pour unt tableau prédéfini ou 1 pour remplir le tableau : ",0
affichage:  db  "t[%hhd]=%hhd",10,0
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet
ask2	db	"Entrez la valeur a supprimer : ",0

decal:	db	0
max:	db	10
tabpredef:	db	2,5,6,1,7,1,5,5,2,2

section .bss
i:    resb    1
ind1:	resb	1
reponse:	resb	1
tab:  	resb    10
val:    resb    1    
valeur:	resb	1
section .text
main:
push rbp

mov rdi,question2
mov rax,0
call printf

mov rdi,scanf_int
mov rsi, reponse
mov rax,0
call scanf

mov byte[i],0
cmp byte[reponse],0
je predefini
boucle_demande:        
        
	mov rdi,question1
	movzx rsi,byte[i]  ; On copie i dans rsi en l'étendant avec des zéros
	mov rax,0
	call printf 
        
	; lecture au clavier : donnée rangée dans 'val' 
	mov rdi,scanf_int
    mov rsi,val
	mov rax,0
	call scanf
        
	movzx ecx,byte[i]      ; on copie i dans ecx en l'étendant avec des zéros
    mov al,byte[val]        ; on met val dans al 
    mov [tab+ecx*BYTE],al   ; on met al dans la case i du tableau
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  9
	jb boucle_demande      ; si i<10, on saute à boucle_demande
	jmp affichage1

	;**********************************************
	; on utilisera le tableau prédéfini dans .data
	; on le recopie donc dans tab
	;**********************************************
predefini:
	movzx ecx,byte[i]
	mov al,byte[tabpredef+ecx*BYTE]
	mov byte[tab+ecx*BYTE],al
	inc byte[i]
	cmp byte[i],10
	jb predefini	
		
affichage1:	
	mov byte[i],0
	boucle_affichage:	
	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tab+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  9

	jb boucle_affichage    ; si i<10, on saute à boucle_affichage

	; saisie de la valeur à supprimer
	mov rdi,ask2
	mov rax,0
	call printf
	
	mov rdi,scanf_int
	mov rsi,valeur
	mov rax,0
	call scanf
	
	;***************************************************************
	; recherche dans le tableau de la valeur à supprimer 
	; on sort de la boucle quand on arrive à la dernière case
	;***************************************************************
	seek:
	movzx edx,byte[ind1]	; copie de ind1 dans edx
	mov al,[tab+edx*BYTE]	; al=tab[ind1]
	cmp byte[valeur],al	; si al==valeur à supprimer
	je remove		; on saute au label remove
	mov bl,byte[decal]	; on sauvegarde le nombre de décalages dans bl
	movzx ecx,byte[ind1]	; copie de l'indice courant dans ecx
	cmp byte[decal],0	; s'il y a au moins un décalage à faire
	ja decalage		; on saute au label decalage
	back_remove:
	inc byte[ind1]		; on incrémente l'indice de la case à traiter
	cmp byte[ind1],10	; si cet indice est inférieur à 10
	jb seek			; on recommence
	
	jmp fin	; si on est ici, c'est qu'on a parcouru tout le tableau
			; on passe donc à l'affichage.

	;*******************************************************
	; On a trouvé une valeur à supprimer :
	; on incrémente donc le nombre de décalages à effectuer
	; pour les valeurs suivantes
	;*******************************************************
	remove:
		inc byte[decal]		; nombre de décalages à effectuer
		dec byte[max]			; le tableau aura une case de moins
		jmp back_remove	; retour à l'analyse du tableau			

	;**************************************************************
	; Décalage des cases suivant le nombre de décalages à effectuer
	;**************************************************************
	decalage:
	dec ecx			; ecx=indice précédent celui de la case à traiter
	mov byte[tab+ecx*BYTE],al ; on y met la valeur de la case à décaler
	dec bl	; un décalage en moins à faire
	cmp bl,0 ; s'il y a encore des décalages à faire
	jne decalage	; on recommence
	jmp back_remove	; sinon on retourne à l'analyse du tableau

	fin:
	mov byte[i],0
	boucle_affichage_final:	
	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tab+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	mov bl,byte[max]
	cmp byte[i],bl         ; on compare i avec  10

	jb boucle_affichage_final    ; si i<10, on saute à boucle_affichage
	
pop rbp	
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall
ret
