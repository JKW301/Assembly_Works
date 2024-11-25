extern printf
extern scanf

global main

section .data
affich1:	db	"Entrez une valeur ",0
affich_fin1:	db	"Résultat Newton : %lf",10,0
affich_fin2:	db	"Résultat sqrtss : %lf",10,0
error:		db	"La valeur entrée ne peut être négative",10,0
lect:		db	"%f",0
un:		dd	1.0
deux:	dd	2.0
cpt:	db	0

section .bss
n:	resd	1
resultat:	resq	1
section .text

main:
push rbp
mov rdi,affich1
mov rax,0
call printf

mov rdi,lect
mov rsi,n
mov rax,1
call scanf

cmp dword[n],0
jl erreur

movss xmm1,[un]	; xmm1=X0
boucle:
movss xmm0,[n]
divss xmm0,xmm1			; xmm0=n/Xk
addss xmm0,xmm1			; xmm0=Xk+(n/Xk)
divss xmm0,[deux]	; xmm0=(Xk+(n/Xk))/2
movss xmm1,xmm0			; xmm1=Xk+1
inc byte[cpt]
cmp byte[cpt],10
jb boucle

mov rdi,affich_fin1
cvtss2sd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf

sqrtss xmm1,[n]
mov rdi,affich_fin2
cvtss2sd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf

jmp fin

erreur:
mov rdi,error
mov rax,0
call printf


pop rbp
fin:
mov rax, 60         
mov rdi, 0
syscall
ret

