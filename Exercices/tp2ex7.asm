; Demandez 2 valeurs à l'utilisateur.
; Affichez le quotient de ces 2 valeurs en n'utilisant que inc et/ou dec.

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez la valeur 1 :",0
question2:  db  "Entrez la valeur 2 :",0
scanf_int:  db  "%hhd"
reponse1:   db  "Résultat: %d",10,0
reponse1bis:   db  "Reste: %d",10,0
reponse2:   db  "Division par zéro interdite",10,0
resultat:	db	0

section .bss
val1:  	resb    1
val2:	resb	1


; Ce programme effectue une division RISC entre les 2 nombres entrés au clavier. 
 
section .text
main:
push rbp
mov rdi,question1
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de la première valeur : le divisé
mov rsi,val1         ; valeur stockée dans la variable 'val1'
mov rax,0
call scanf

cmp byte[val1],0		; si val1==0, on affiche directement l résultat
je fin_good

mov rdi,question2
mov rax,0
call printf

mov rdi,scanf_int   ; lecture de la seconde valeur : le diviseur
mov rsi,val2         ; valeur stockée dans la variable 'val2'
mov rax,0
call scanf

cmp byte[val2],0		; si val2==0, division par zéro : on termine.
je fin_bad

mov al,byte[val2]	; on sauve val2 dans al
cmp byte[val1],al	; si le divisé est plus petit que le diviseur
jb fin_good			; on va directement afficher le résultat.

boucle1:
	mov byte[val2],al
	boucle2: ; dans cette boucle, on décrémente val1 de la valeur val2
		dec byte[val1] ; on décrémente val1
		dec byte[val2] ; on décrémente val2
		cmp byte[val2],0 ; jusqu'à ce que val2 soit nul
		jne boucle2	; à la fin de la boucle : val1=val1-val2
	inc byte[resultat]	; on incrémente le résultat
	cmp byte[val1],al	; tant que val1 est plus grand que val2
	jae boucle1		; on continue

fin_good:
mov rdi,reponse1    ; fin correcte : on affiche le résultat
movzx rsi,byte[resultat]
mov rax,0
call printf

mov rdi,reponse1bis    ; on affiche le reste
movzx rsi,byte[val1]
mov rax,0
call printf 
jmp fin

fin_bad:
mov rdi,reponse2    ; Tentative de division par zéro : message d'erreur.
mov rax,0
call printf   

                    
fin:
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
