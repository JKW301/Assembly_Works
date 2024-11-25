; external functions from X11 library
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XNextEvent

; external functions from stdio library (ld-linux-x86-64.so.2)    
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main

section .bss
display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1

section .data

event:		times	24 dq 0
section .data
    a dd 0.39
    b dd 0.6
    size dd 400
    xmin dd -1.25
    xmax dd 1.25
    ymin dd -1.25
    ymax dd 1.25
    iterationmax dd 200
    four dd 4.0

section .text
	
;##################################################
;########### PROGRAMME PRINCIPAL ##################
;##################################################

main:
xor     rdi,rdi
call    XOpenDisplay	
mov     qword[display_name],rax	

; display_name structure
; screen = DefaultScreen(display_name);
mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400	
mov r9,400	
push 0xFFFFFF	
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 ;131072
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000	
call XSetForeground

boucle: 
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	
je dessin							

cmp dword[event],KeyPress			
je closeDisplay						
jmp boucle

;#########################################
;#		DEBUT DE LA ZONE DE DESSIN         #
;#########################################
dessin:


    fld dword [a]
    fstp qword [r15] ; r15 pour a

    fld dword [b]
    fstp qword [r14] ; r14 pour b

  
    mov r13, [size]
    mov r12, [xmin]
    mov r11, [xmax]
    mov r10, [ymin]
    mov r9, [ymax]
    mov r8, [iterationmax]

 ; Boucle pour chaque ligne
    mov rdi, 0 
    ligne_loop:
    
        mov rsi, 0 
        colonne_loop:
            
            mov rax, 1 ; i = 1

            fld qword [r15] 
            fild dword [rsi] 
            fld qword [r11] 
            fld qword [r12] 
            fsub ; xmax - xmin
            fdiv ; (xmax - xmin) / taille
            fmul ; col * (xmax - xmin) / taille
            fadd ; xmin + col * (xmax - xmin) / taille
            fstp qword [r15] 

            fld qword [r14] 
            fild dword [rdi]
            fld qword [r9] 
            fld qword [r10] 
            fsub ; ymax - ymin
            fdiv ; (ymax - ymin) / taille
            fmul ; line * (ymax - ymin) / taille
            fsub ; ymax - line * (ymax - ymin) / taille
            fstp qword [r14] 

     
            fractale_loop:
                
                fld qword [r15] 
                fmul 
                fld qword [r14] 
                fmul 
                fadd 

               
                fld qword [four] 
                fcomip st0, st1 
                fstsw ax 
                sahf 
                jnbe fractale_draw 
                jmp fractale_end 

        fractale_draw:
            ; Dessiner en couleur (calculée par rapport à i)
            mov rax, 0x0000FF ; Bleu
            mov rdi, qword[display_name]
            mov rsi, qword[gc]
            mov rdx, rax
            call XSetForeground

            ; Dessiner aux coordonnées (col, line)
            mov rdi, qword[display_name]
            mov rsi, qword[window]
            mov rdx, qword[gc]
            mov ecx, edi      
	    mov r8d, esi
            mov r9d, edi      
            push rdi          
            call XDrawLine

        fractale_end:
                
                inc rax

                
                cmp rax, [iterationmax]
                jle fractale_loop 

            ; Incrémenter la colonne
            inc rsi
            cmp rsi, [size] ; Comparer avec la taille de la fractale
            jl colonne_loop ; Si la colonne < taille, on continue la boucle

        ; Incrémenter la ligne
        inc rdi
        cmp rdi, [size] ; Comparer avec la taille de la fractale
        jl ligne_loop ; Si la ligne < taille, on continue la boucle

    ; ############################
    ; # FIN DE LA ZONE DE DESSIN #
    ; ############################
    jmp flush ; Aller à la section de flush

flush:
    mov rdi, qword[display_name]
    call XFlush
    jmp boucle

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
	

