; Un tableau t de 10 cases contient 9 valeurs entières triées par ordre croissant. La 10ième
; valeur est indéfinie. Insérer une valeur val donnée au clavier dans le tableau t de manière 
; à obtenir un tableau de 10 valeurs triées.


extern printf
extern scanf

%define	BYTE	1
%define DWORD   4

global main

section .data
question1:  db  "Entrez l'élément %d : ",0
affichage:  db  "t[%hhd]=%hhd",10,0
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet
ask2:		db	"Entrez la valeur a insérer : ",0
previous:	db	0

section .bss
i:    resb    1
ind1:	resb	1
tab:  	resb    10
val:    resb    1    
valeur:	resb	1
section .text
main:

push rbp 

mov byte[i],0
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
        
     	mov al,byte[val]        ; on met val dans al 
	cmp byte[previous],al
	ja boucle_demande      ; si l'élément entré est plus grand que le précédent, on redemande
	movzx ecx,byte[i]      ; on copie i dans ecx en l'étendant avec des zéros
     	mov [tab+ecx*BYTE],al   ; on met al dans la case i du tableau
	mov byte[previous],al
	inc byte[i]             ; on incrémente i
	cmp byte[i],9         ; on compare i avec  9
	jb boucle_demande      ; si i<9, on saute à boucle_demande

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
	cmp byte[i],9         ; on compare i avec  9

	jb boucle_affichage    ; si i<10, on saute à boucle_affichage

	;***************************************************************
	; recherche dans le tableau d'une valeur 
	; plus grande que la valeur à insérer
	; s'il n'y en a pas, on sort quand on arrive à la dernière case
	;***************************************************************

	mov rdi,ask2
	mov rax,0
	call printf

	mov rdi,scanf_int  ; lecture de 'valeur' au clavier
	mov rsi,valeur
	mov rax,0
	call scanf

	mov byte[ind1],0

	seek:
	movzx edx,byte[ind1]
	mov al,byte[tab+edx*BYTE]	; al=tab[ind1]
	cmp byte[valeur],al        ; on compare la valeur à insérer à l'élément lu
	jb insertion       ; si elle est inférieure, on l'insère
	inc byte[ind1]     ; sinon on continue de parcourir le tableau
	cmp byte[ind1],10
	jb seek
	
	dec byte[ind1]	; si on est ici, c'est qu'on n'a pas trouvé
			; de valeur supérieure à la valeur à insérer dans le tableau
			; on se positionne donc sur la dernière case 
			; pour insérer la valeur.
	
	;**************************************************************
	; insertion de la valeur dans le tableau à la position voulue :
	; soit à la place de la première valeur qui lui est supérieure
	; soit à la dernière case
	;**************************************************************
	insertion:
		movzx ecx,byte[ind1]	; edx=indice de la case où insérer
		mov bl,byte[tab+ecx*BYTE]	; ebx=contenu de cette case
		mov dl,byte[valeur]	; ecx=valeur à insérer
		mov byte[tab+ecx*BYTE],dl ; ; on insère la valeur à la case voulue
		cmp ecx,9	; Si l'insertion se fait dans la dernière case
					; pas de décalage à faire
		jae	fin		; on saute donc directement à l'affichage
		
		;************************************************************
		; Décalage des cases suivant la case où on a inséré la valeur
		;************************************************************
		inc ecx	; on passe à la case suivante
		decalage:	; on va décaler les éléments restants sur la droite
		mov al,bl	; al= bl=valeur sauvegardée de la case précédente
		mov bl,byte[tab+ecx*BYTE]	; ebx=valeur dans la case qu'on va écraser
		mov [tab+ecx*BYTE],al ; on met dans cette case la valeur de la case précédente
		inc ecx	; on incrémente l'indice
		cmp ecx,10
		jb decalage			
	
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
	cmp byte[i],10         ; on compare i avec  10

	jb boucle_affichage_final    ; si i<10, on saute à boucle_affichage
	
pop rbp	
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall
ret
