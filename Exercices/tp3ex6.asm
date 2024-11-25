; Ecrire un programme qui met à zéro les éléments de la diagonale principale d'une matrice 
; carrée donnée.

extern printf
extern scanf

%define	BYTE	1
%define DWORD   4

%define NBCOL	5
%define NBCASES NBCOL*NBCOL

global main

section .data
question1:  db  "Entrez l'élément de la ligne %d, colonne %d : ",0
affichage:  db  9,"%hhd ",0 ; 9=code ASCII de la tabulation
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet

crlf:	db	10,0	; retour chariot

numcol:	db	0
numlig:	db	0

section .bss
i:    resb    1


ind1:	resb	1
matrice:  	resb    NBCASES
val:    resb    1    

section .text
main:
push rbp

boucle_demande:        
        
	mov rdi,question1
	movzx rsi,byte[numlig]  ; On copie numlig dans rsi en l'étendant avec des zéros
	movzx rdx,byte[numcol]  ; On copie numcol dans rdx en l'étendant avec des zéros
	mov rax,0
	call printf 
        
	; lecture au clavier : donnée rangée dans 'val' 
	mov rdi,scanf_int
        mov rsi,val
	mov rax,0
	call scanf
        
	movzx ecx,byte[i]      ; on copie i dans ecx en l'étendant avec des zéros
        mov al,byte[val]        ; on met val dans al 
        mov [matrice+ecx*BYTE],al   ; on met al dans la case i du tableau
	inc byte[numcol]
	cmp byte[numcol],NBCOL
	jb suite
	mov byte[numcol],0
	inc byte[numlig]
	suite:
	inc byte[i]             ; on incrémente i
	cmp byte[i],NBCASES         ; on compare i avec  9
	jb boucle_demande      ; si i<10, on saute à boucle_demande

	mov byte[i],0
	mov byte[numlig],0
	mov byte[numcol],0
	boucle_affichage:	
	movzx eax,byte[i]
	mov rdi,affichage
	movzx rsi,byte[matrice+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf  
	
	inc byte[numcol]
	cmp byte[numcol],NBCOL
	jb suite2
	mov byte[numcol],0
	mov rdi,crlf
	mov rax,0
	call printf 
	
	suite2:
	inc byte[i]             ; on incrémente i
	cmp byte[i],NBCASES         ; on compare i avec  9

	jb boucle_affichage    ; si i<10, on saute à boucle_affichage
	
	mov rdi,crlf
	mov rax,0
	call printf 

	;***************************************************************
	; on parcourt le tableau : si le numéro de colonne est égal 
	; au numéro de ligne, on met un 0 dans le tableau
	;***************************************************************
	mov byte[numcol],0
	mov byte[numlig],0
	mov byte[i],0
	boucle:
		mov al,byte[numcol]	; eax=numéro de colonne
		mov bl,byte[numlig]	; ebx=numéro de ligne
		cmp al,bl			; on compare eax et ebx
		jne case_suivante	; s'ils sont différents, on passe à la case suivante
		movzx ecx,byte[i]		; sinon on copie l'indice de la case acutelle dans ebx en DWORD 
		mov byte[matrice+ecx*BYTE],0	; on met 0 dans cette case
		case_suivante:
		inc byte[i]	; incrémentation de ind1
		inc byte[numcol]		; incrémentation du numéro de colonne
		cmp byte[numcol],NBCOL	; si le numéro de colonne est inférieur au nombre de colonnes
		jb next3		; on passe à la case suivante
		mov byte[numcol],0		; sinon on remet le numéro de colonne à 0
		inc byte[numlig]			; et on incrémente le numéro de ligne
		next3:
	cmp byte[i],NBCASES	; si ind1 est inférieur au nombre de cases du tableau
	jb boucle			; on recommence

	

	mov byte[i],0
	mov byte[numlig],0
	mov byte[numcol],0
	boucle_affichage_2:	
	mov rdi,affichage
	movzx eax,byte[i]
	movzx rsi,byte[matrice+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf  
	
	inc byte[numcol]
	cmp byte[numcol],NBCOL
	jb suite3
	mov byte[numcol],0 ; Saut de ligne à chaque fois qu'on atteint la dernière colonne
	mov rdi,crlf
	mov rax,0
	call printf 
	
	suite3:
	inc byte[i]             ; on incrémente i
	cmp byte[i],NBCASES         ; on compare i avec  9

	jb boucle_affichage_2    ; si i<10, on saute à boucle_affichage

pop rbp	
; Pour fermer le programme proprement :
mov    rax, 60
mov    rdi, 0
syscall
ret
