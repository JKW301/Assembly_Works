extern printf
extern scanf

global main

section .data
affich1:	db	"Entrez une valeur ",0
affich_fin1:	db	"Résultat Newton : %lf",10,0
affich_fin2:	db	"Résultat sqrtss : %lf",10,0
lect:		db	"%lf",0
un:		dq	1.0
deux:	dq	2.0
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


movsd xmm1,qword[un]	; xmm1=X0
boucle:
movsd xmm0,qword[n]
divsd xmm0,xmm1			; xmm0=n/Xk
addsd xmm0,xmm1			; xmm0=Xk+(n/Xk)
divsd xmm0,[deux]	; xmm0=(Xk+(n/Xk))/2
movsd xmm1,xmm0			; xmm1=Xk+1
inc byte[cpt]
cmp byte[cpt],10
jb boucle


mov rdi,affich_fin1
movsd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf

sqrtsd xmm1,[n]
mov rdi,affich_fin2
movsd xmm0,xmm1	; conversion en 64 bits pour le printf
mov rax,1
call printf

pop rbp
fin:
mov rax, 60         
mov rdi, 0
syscall
ret

