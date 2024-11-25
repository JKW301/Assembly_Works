extern printf
extern scanf

%define	DWORD	4

global main

section .data
ch1:	db	"Entrez un angle en degrés :",0
ch2:	db	"cosinus=%f",10,0
ch3:	db	"sinus=%f",10,0
lect:	db	"%d",0
demiangle:	dd	180
angle:	dd	0
section .bss
cosinus:	resd	361
sinus:		resd	361

section .text

main:
push rbp

calc_trigo:
	fldpi	; st0=PI
	fimul dword[angle]	; st0=PI*angle
	fidiv dword[demiangle]	; st0=(PI*angle)/demi=angle en radians
	fsincos		; st0=cos(angleradian), st1=sin(angleradian)
	mov ecx,dword[angle]
	fstp dword[cosinus+ecx*DWORD] ; cosinus[DWORD*angle]=st0=cos(angle) puis st0=sin(angle)
	fstp dword[sinus+ecx*DWORD] ; sinus[DWORD*angle]=st0=sin(angle) puis st0 vide
	inc dword[angle]
	cmp dword[angle],360
	jbe calc_trigo

mov rdi,ch1
mov rax,0
call printf

mov rdi,lect
mov rsi,angle
mov rax,0
call scanf	
	
mov rdi,ch2
mov ecx,dword[angle]
cvtss2sd xmm0,dword[cosinus+ecx*DWORD]	; conversion en 64 bits pour le printf
mov rax,1
call printf

mov rdi,ch2
mov ecx,dword[angle]
cvtss2sd xmm0,dword[sinus+ecx*DWORD]	; conversion en 64 bits pour le printf
mov rax,1
call printf

pop rbp
fin:
mov rax, 60         
mov rdi, 0
syscall
ret

