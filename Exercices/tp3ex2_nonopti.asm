; Même question que l'exercice 1 mais triez le tableau avant de l'afficher avec un tri à bulles.

extern printf
extern scanf

%define	BYTE	1

global main

section .data
question1:  db  "Entrez l'élément %d : ",0
affichage:  db  "t[%hhd]=%hhd",10,0
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet
max:	db	10

section .bss
i:    resb    1
tab:  	resb    10
val:    resb    1

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

	movzx ecx,byte[i]      ; on copie i dans ecx en l'étendant avec des zéros
        mov al,byte[val]        ; on met val dans al 
        mov [tab+ecx*BYTE],al   ; on met al dans la case i du tableau

	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  10
	jb boucle_demande      ; si i<10, on saute à boucle_demande

bubble:
		mov byte[i],1	; i=compteur de boucle
		boucle:
			movzx ebx,byte[i]	; ebx=i
			mov cl,byte[tab+ebx*BYTE] ; cl=tab[i]
			dec ebx	; ebx=i-1
			mov dl,byte[tab+ebx*BYTE] ; dl=tab[i-1]
			cmp cl,dl
		jae noswap ; si cl>=dl, pas d'échange : saut à noswap

			;Echange
			mov byte[tab+ebx*BYTE],cl	; tab[i-1]=tab[i]
			inc ebx	; ebx=i
			mov byte[tab+ebx*BYTE],dl	; tab[i]=tab[i-1]

			noswap:
				inc byte[i]		; i est incrémenté
				mov al,byte[max]	; on copie max dans al
				cmp byte[i],al   	; on compare i et max
				jb boucle	; si i<max on saute à boucle
	dec byte[max]	; on a un élément bien placé dans le tableau donc un de moins à traiter
	cmp byte[max],1	
	ja bubble	; tant qu'il reste plus d'un élément à traiter, on saute à bubble pour recommencer


mov byte[i],0
boucle_affichage:	
	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
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
