extern printf
extern scanf

global main

section .data
affich1:	db	"Entrez une valeur ",0
affich_fin1:	db	"La moyenne est : %f",10,0
affich_fin2:	db	"La somme est : %f",10,0
lect:		db	"%f",0
zero:	dd	0.0
vingt:		dd	20.0
deux:	dd	2.0
cpt:	db	0
somme:  dd  0.0
section .bss
n:	resd	1
resultat:	resd	1
section .text

main:
push rbp

movss xmm1,dword[zero]
boucle_saisie:
mov rdi,affich1
mov rax,0
call printf

mov rdi,lect
mov rsi,n
mov rax,1
call scanf

movss xmm0,dword[n]
ucomiss xmm0,dword[zero]
jb fin_saisie

ucomiss xmm0,dword[vingt]
ja boucle_saisie

movss xmm1,dword[somme]
addss xmm1,xmm0
movss dword[somme],xmm1
inc byte[cpt]
jmp boucle_saisie

fin_saisie:
movss xmm1,dword[somme]
mov rdi,affich_fin2
cvtss2sd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf


cmp byte[cpt],0
je no_value

movzx ecx,byte[cpt]
cvtsi2ss xmm0,rcx
movss xmm1,dword[somme]
divss xmm1,xmm0

mov rdi,affich_fin1
cvtss2sd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf


no_value:
pop rbp
fin:
mov rax, 60         
mov rdi, 0
syscall
ret

