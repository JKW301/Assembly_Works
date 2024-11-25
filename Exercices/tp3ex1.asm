; Demandez à l'utilisateur de remplir un tableau de 10 cases d'entiers.
; Affichez ce tableau sous la forme tab[x]=y.


extern printf
extern scanf

%define	BYTE	1

global main

section .data
question1:  db  "Entrez l'élément %d : ",0
affichage:  db  "t[%d]=%d",10,0
scanf_int:  db  "%hhd",0  ; %hhd pour lire un octet signé
i:    db    0


section .bss
tab:  	resb    10
val:    resb    1

section .text
main:
push rbp

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
    mov [tab+ecx*BYTE],al   ; on met al dans la case i du tableau : tab[i]=val

	inc byte[i]             ; on incrémente i
	cmp byte[i],10         ; on compare i avec  10
	jb boucle_demande      ; si i<10, on saute à boucle_demande

mov byte[i],0
boucle_affichage:
	movzx ecx,byte[i]  ; on copie i dans ecx en l'étendant avec des zéros 

	mov rdi,affichage
	movzx rsi,byte[i]  ; on copie i dans rsi en l'étendant avec des zéros 
	movzx rdx,byte[tab+ecx*BYTE] ; on copie tab[i] dans rdx en l'étendant avec des zéros  
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
