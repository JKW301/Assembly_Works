; Demandez une valeur entre 10 et 20 à l'utilisateur.
; Redemandez la lui tant que la valeur entrée n'est pas correcte.


extern printf
extern scanf

%define	BYTE	1
%define DWORD   4

global main

section .data
question1:  	db  "Entrez l'élément %d : ",0
affichage:  	db  "t[%hhd]=%hhd",10,0
scanf_int:  	db  "%hhd",0  ; %hhd pour lire un octet
ask2:		db	"Entrez la valeur a rechercher : ",0
success:	db	"Valeur trouvee a la position %hhd",10,0
fail:		db	"La valeur n'existe pas dans le tableau",10,0
sup:		db	0
inf:		db	0
pos:		db	-1
previous:	db	0
tab:		db	1,3,4,6,7,8,9,11,12,14
section .bss
i:    resb    1
;tab:  	resb    10
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
        
	movzx ecx,byte[i]      ; on copie i dans ecx en l'étandant avec des zéros
    mov al,byte[val]        ; on met val dans al 
    mov [tab+ecx*BYTE],al   ; on met al dans la case i du tableau
	cmp byte[previous],al
	ja boucle_demande
	mov byte[previous],al
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  10
	jb boucle_demande      ; si i<10, on saute à boucle_demande

	mov rdi,ask2
	mov rax,0
	call printf
	
	mov rdi,scanf_int
	mov rsi,valeur
	mov rax,0
	call scanf

	
    mov byte[i],0

	mov byte[inf],0	; borne inférieure (première case du tableau)
	mov byte[sup],9	; borne supérieure	(dernière case du tableau)
	
	boucle:
		; calcul du milieu du tableau restant à explorer
		mov al,byte[sup]	; al=sup
		sub al,byte[inf]	; al=sup-inf
		shr al,1	; al=(sup-inf)/2
		add al,byte[inf]	; eax=inf+(sup-inf)/2=indice du milieu du tableau restant
		; comparaison du milieu du tableau avec la valeur recherchée
		mov bl, byte[tab+eax*BYTE]	; bl=valeur du milieu du tableau
		cmp bl,byte[valeur]
		ja plus_grand	; si milieu>valeur recherchée
		jb plus_petit	; si milieu<valeur recherchée
		mov byte[pos],al			; si milieu=valeur recherchée
		jmp fin_recherche	; alors recherche terminée
		plus_grand:
			dec al	; tab[eax]>valeur donc la borne sup sera eax-1
			mov byte[sup],al	; borne sup=eax-1
			cmp al,byte[inf]	
			jae boucle	; si sup>=inf alors on recommence
			jmp fin_recherche	; sinon on saute à la fin de la recherche
		plus_petit:
			inc al	; tab[eax]<valeur donc la borne inf sera eax+1
			mov byte[inf],al	; borne inf=eax+1
			cmp al,byte[sup]	; si inf<=sup alors on recommence
			jbe boucle
	
	fin_recherche:	; la recherche est terminée
		cmp byte[pos],0
		jl not_found	; si pos<0 alors la valeur n'a pas été trouvée
		mov rdi,success
		movzx rsi,byte[pos]
		mov rax,0
		call printf
		jmp fin
		
		not_found:	
		mov rdi,fail
		mov rax,0
		call printf
		
		fin:
pop rbp
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall
ret
