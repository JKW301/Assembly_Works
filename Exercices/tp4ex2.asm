; Calculez la somme, le produit et la moyenne entière d'une suite de chiffres non nuls entrés 
; au clavier, sachant que la suite est terminée par zéro. Retenez seulement les nombres entre 1 et 20
; lors de l'entrée des données.

extern printf
extern scanf

global main

section .data
question1:  db  "Entrez une valeur (0 pour arrêter) :",10,0
scanf_int:  db  "%d",0
reponse1:   db  "Résultats : somme=%d produit=%d moyenne=%d",10,0
reponse2:	db	"Aucune donnée entrée",10,0
cpt:		db	0

section .bss
val:    resd    1
produit:	resd	1

section .text
main:
push rbp
mov ebx,0	; ebx=somme
mov eax,1	; eax=produit
mov edx,0
boucle_saisie:
	push rax			; Sauvegarde du registre rax sur la pile en cas de modification par scanf ou printf

	mov rdi,question1   ; Affichage de la demande
	mov rax,0
	call printf

	mov rdi,scanf_int   ; 
	mov rsi,val         ; valeur stockée dans la variable 'val'
	mov rax,0
	call scanf
	
	pop rax				; récupération de rax sur la pile à la valeur avant scanf et printf
	
	cmp dword[val],0	; si val==0, 
	je calcul_moyenne	; on arrête la saisie
	cmp dword[val],20	; Si on entre un nombre supérieur à 20
	ja boucle_saisie	; on redemande la saisie

	add ebx,dword[val]	; ebx=ebx+val
	mul dword[val]		; eax=eax*val
	cmp edx,0
	jne fin
	inc byte[cpt]		; on incrémente le nombre de valeurs lues
	jmp boucle_saisie	; on recommence la saisie

calcul_moyenne:
	cmp byte[cpt],0			; s'il n'y a eu aucune valeur saisie
	je fin_rien				; on saute au label fin_rien
	mov dword[produit],eax	; on sauvegarde eax dans la variable 'produit'
	mov eax,ebx				; on met ebx (la somme) dans eax 
	movzx ecx,byte[cpt]		; on met 'cpt' dans ecx en l'étendant avec des zéros 
	mov edx,0				; on met edx à 0
	div ecx					; eax=eax/ecx=ebx/cpt=moyenne (somme/nombre de données)

affichage_final:
mov rdi,reponse1    		; affichage du résultat final
mov esi,ebx			; somme
mov edx,dword[produit]		; produit
mov ecx,eax			; moyenne
mov rax,0
call printf
jmp fin

fin_rien:              
mov rdi,reponse2	; Affichage erreur
mov rax,0
call printf

pop rbp 
fin:			  
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret
