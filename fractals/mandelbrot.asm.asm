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
extern XDrawPoint

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
screen:		    resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		    resq	1
gc:		        resq	1
image_x:        resq    1
image_y:        resq    1

section .data
    event:		times	24 dq 0
    zoom: dq 100
    x1: dq -2.1
    x2: dq 0.6
    y1: dq -1.2
    y2: dq 1.2
    iteration_max: dq 50
    x: dq 0
    y: dq 0
    c_r: dq 0
    c_i: dq 0
    z_r: dq 0
    z_i: dq 0
    i: dq 0
    tmp: dq 0

section .text
;##################################################
;########### PROGRAMME PRINCIPAL ##################
;##################################################

main:

xor     rdi,rdi
call    XOpenDisplay   
mov     qword[display_name],rax    


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
mov rdx,131077 
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
mov rdx,0xFF0000    
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

dessin:
    movsd xmm0, qword[x2]
    movsd xmm1, qword[x1]
    mov rcx, qword[zoom]
    cvtsi2sd xmm2, rcx
    subsd xmm0, xmm1
    mulsd xmm0, xmm2
    movsd qword[image_x], xmm0
    movsd xmm0, qword[y2]
    movsd xmm1, qword[y1]
    mov rcx, qword[zoom]
    cvtsi2sd xmm2, rcx
    subsd xmm0, xmm1
    mulsd xmm0, xmm2
    movsd qword[image_y], xmm0
    

outer_loop:

    mov r12, qword[x]
    cmp r12, qword[image_x]
    jae outer_loop_end
    
    mov qword[y], 0
    

inner_loop:
    mov r11, qword[y]
    cmp r11, qword[image_y]
    jae inner_loop_end

    movsd xmm0, qword[x]
    movsd xmm1, qword[zoom]
    movsd xmm2, qword[x1]
    divsd xmm0, xmm1
    addsd xmm0, xmm2
    movsd qword[c_r], xmm0
    movsd xmm0, qword[y]
    movsd xmm2, qword[y1]
    divsd xmm0, xmm1
    addsd xmm0, xmm2
    movsd qword[c_i], xmm0
    
    mov qword[z_r], 0
    mov qword[z_i], 0
    mov qword[i], 0

do_while_loop:
    mov rax, qword[z_r]
    mov qword[tmp], rax
    movsd xmm0, qword[z_r]
    movsd xmm1, qword[z_i]
    movsd xmm2, qword[c_r]
    mulsd xmm0, xmm0
    mulsd xmm1, xmm1
    subsd xmm0, xmm1
    addsd xmm0, xmm2
    movsd qword[z_r], xmm0
    
    movsd xmm0, qword[z_i]
    movsd xmm1, qword[tmp]
    movsd xmm2, [c_i]
    addsd xmm0, xmm0
    mulsd xmm0, xmm1
    addsd xmm0, xmm2
    movsd [z_i], xmm0

    inc qword[i]
    movsd xmm0, qword[z_r]
    movsd xmm1, qword[z_i]
    mulsd xmm0, xmm0
    mulsd xmm1, xmm1
    addsd xmm0, xmm1
    mov eax, 4
    cvtsi2sd  xmm1, eax
    comisd xmm0, xmm1
    jae end_do_while
    mov rax, qword[iteration_max]
    cmp qword[i], rax
    jae end_do_while
    
    jmp do_while_loop
    
end_do_while:
    mov r12, qword[iteration_max]
    cmp qword[i], r12
    jne end_if
    
    ;
    mov rdi, [display_name]
    mov rsi, [gc]
    mov rdx, 0x0000FF
    call XSetForeground
    mov rsi, [window]
    mov rdx, [gc]
    mov rcx, [x]
    mov r8, [y]
    call XDrawPoint
    
end_if:
    inc qword[y]
    jmp inner_loop
inner_loop_end:
    inc qword[x]
    jmp outer_loop
outer_loop_end:



jmp flush ; Aller à la section de flush

flush:
    mov rdi, qword[display_name]
    call XFlush
    jmp boucle

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor        rdi,rdi
    call    exit
    ; ajout de ces lignes pour terminer prorement
    mov eax, 0       ; Code de retour 0
    ret
