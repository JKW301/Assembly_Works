; On dispose de deux tableaux t1 et t2 (de dimensions respectives 10 et 5), triés par ordre 
; croissant. 
; Fusionner les éléments de t1 et t2 dans un troisième tableau tfinal trié par ordre croissant.

extern printf
extern scanf

%define	BYTE	1
%define DWORD   4

global main

section .data
question1:  db  "Entrez l'élément %d de tab1 : ",0
question2:  db  "Entrez l'élément %d de tab2 : ",0
affichtab1:  db  "tab1[%hhd]=%hhd",10,0
affichtab2:  db  "tab2[%hhd]=%hhd",10,0
affichage:  db  "tab_fusion[%hhd]=%hhd",10,0
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet
crlf:	db	10,0	; saut de ligne

previous:	db	0
ind1:	db	0
ind2:	db	0
indfin:	db	0

section .bss
i:    resb    1
tab1:  	resb    10
tab2:  	resb    5
tabfin:	resb	15
val:    resb    1    
valeur:	resb	1

section .text
main:
push rbp

boucle_demande_tab1:        
        
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
	cmp byte[previous],al
	ja boucle_demande_tab1
        mov [tab1+ecx*BYTE],al   ; on met al dans la case i du tableau
	mov byte[previous],al
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  9
	jb boucle_demande_tab1      ; si i<10, on saute à boucle_demande
	
	mov byte[previous],0
	mov byte[i],0
	
	mov rdi,crlf
	mov rax,0
	call printf 
	
boucle_demande_tab2:                
	mov rdi,question2
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
	cmp byte[previous],al
	ja boucle_demande_tab2
    	mov [tab2+ecx*BYTE],al   ; on met al dans la case i du tableau
	mov byte[previous],al
	inc byte[i]             ; on incrémente i
	cmp byte[i],5         ; on compare i avec  9
	jb boucle_demande_tab2      ; si i<10, on saute à boucle_demande	
		
	mov byte[i],0
	boucle_affichage_1:	
	mov rdi,affichtab1
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tab1+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  9

	jb boucle_affichage_1    ; si i<10, on saute à boucle_affichage
	
	mov rdi,crlf
	mov rax,0
	call printf 
	
	mov byte[i],0
	boucle_affichage_2:	
	mov rdi,affichtab2
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tab2+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	cmp byte[i],5         ; on compare i avec  9

	jb boucle_affichage_2    ; si i<10, on saute à boucle_affichage
	
	mov rdi,crlf
	mov rax,0
	call printf 
	
	;***************************************************
	; fusion des deux tableaux tab1 et tab2 dans tabfin
	;***************************************************
	fusion:
	cmp byte[ind1],10	; si ind1>=10 (i.e. on a fini de copier tab1)
	jae recopie_tab2	; on copie les éléments de tab2
	cmp byte[ind2],5	; si ind2>=5 (i.e. on a fini de copier tab2)
	jae recopie_tab1	; on copie les éléments de tab1
	movzx ecx,byte[ind1]
	movzx edx,byte[ind2]
	mov al,byte[tab1+ecx*BYTE]	; al=tab1[ind1]
	cmp al,byte[tab2+edx*BYTE] ; on compare tab1[ind1] et tab2[ind2]
	jb recopie_tab1	;si tab1[ind1]<tab2[ind2] on va au label recopie_tab1
			;sinon (tab2[ind2]<tab1[ind1]), copie de l'élément de tab2 dans tabfin
	recopie_tab2:
		movzx edx,byte[ind2]
		mov cl,byte[tab2+edx*BYTE]	; cl=tab2[ind2]
		movzx edx,byte[indfin]	; edx=indice du tableau final
		mov byte[tabfin+edx*BYTE],cl	; tabfin[indfin]=tab2[ind2]
		inc byte[ind2]	; incrémentation du compteur de tab2
		inc byte[indfin]	; incrémentation du compteur de tabfin
		cmp byte[indfin],15	; si on n'a pas rempli tous les éléments de tabfin
		jb  fusion		; on repart au label fusion
		jmp fin	; sinon on part au label affichage
	recopie_tab1:	;copie de l'élément de tab1 dans tabfin
		movzx ecx,byte[ind1]	
		mov dl,byte[tab1+ecx*BYTE]	; dl=tab1[ind1]
		movzx ecx,byte[indfin]	; ecx=indice du tableau final
		mov byte[tabfin+ecx*BYTE],dl	; tabfin[indfin]=tab1[ind1]
		inc byte[ind1]	; incrémentation du compteur de tab1
		inc byte[indfin]	; incrémentation du compteur de tabfin
		cmp byte[indfin],15	; si on n'a pas rempli tous les éléments de tabfin
		jb	fusion		; on repart au label fusion
		; sinon on continue vers le label affichage
	
	fin:
	mov byte[i],0
	boucle_affichage_final:	
	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx eax,byte[i]  ; on copie i dans eax en l'étendant avec des zéros 
	movzx rdx,byte[tabfin+eax*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
	mov rax,0
	call printf   
	
	inc byte[i]             ; on incrémente i
	cmp byte[i],15         ; on compare i avec 15

	jb boucle_affichage_final    ; si i<10, on saute à boucle_affichage
pop rbp	
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall
ret
