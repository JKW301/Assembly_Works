extern printf
extern scanf

global main

section .data
ch1:	db	"Entrez un angle en degrés :",0
ch2:	db	"cosinus=%f",10,0
ch3:	db	"sinus=%f",10,0
lect:	db	"%d",0
demi:	dd	180.0
section .bss
angle:		resd	1
cosinus:	resq	1
sinus:		resq	1

section .text

main:
push rbp
mov rdi,ch1
mov rax,0
call printf

mov rdi,lect
mov rsi,angle
mov rax,0
call scanf

fldpi	; st0=PI
fimul dword[angle]	; st0=PI*angle
fdiv dword[demi]	; st0=(PI*angle)/180=angle en radians

fsincos ; st0=cos(angle en radians), st1=sin(angle en radians)

fstp qword[cosinus]	; st0=sin(angle en radians)
fstp qword[sinus]	; pile vide

mov rdi,ch2
movsd xmm0,qword[cosinus]	; conversion en 64 bits pour le printf
mov rax,1
call printf

mov rdi,ch3
movsd xmm0,qword[sinus]	; conversion en 64 bits pour le printf
mov rax,1
call printf
pop rbp
fin:
mov rax, 60         
mov rdi, 0
syscall
ret

