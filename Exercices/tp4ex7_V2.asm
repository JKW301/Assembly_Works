; tp4 ex 15

extern printf
extern scanf

global main

%define BYTE	1

section .data
question1:  db  "Entrez une valeur (inférieure à 256) :",0
scanf_int:  db  "%hd",0
resultat:   db  "Conversion : %s",10,0
chresult:   db  "0000",10,0   ; 4 caractères pour un nombre hexadécimal

section .bss
val:        resw    1
valbyte:    resb    1

section .text
main:
    push rbp

    demande:
    mov rdi,question1   ; Affichage de la demande
    mov rax,0
    call printf

    mov rdi,scanf_int  
    mov rsi,val         ; valeur stockée dans la variable 'val'
    mov rax,0
    call scanf

    mov ecx,0   ; utilisé pour parcourir la chaîne résultat

    cmp word[val],255    ; Si val>255 (occupe plus d'un octet) alors on réitère la demande
    ja demande
    mov al,byte[val]    ; on récupère l'octet de poids faible de val dans al

    boucle:
    cmp al,0        ; si al==0 alors on n'a plus que des zéros dans le nombre à convertir,
    je fin          ; on a donc terminé

    shl al,4        ; on décale al de 4 bits vers la gauche
    jc un           ; si CF==1, on saute au label 'un'
    mov dl,'0'      ; sinon on met le caractère '0' dans dl
    jmp next_digit  ; on va ranger dl dans la chaîne résultat
    un:
    mov dl,'1'      ; on met le caractère '1' dans dl 
    add dl, 'A' - 10 ; ajustement pour les lettres A-F
    next_digit:
    mov byte[chresult+ecx*BYTE],dl   ; on range le caractère contenu dans dl dans la chaîne résultat
    inc ecx         ; on avance dans la chaîne résultat
    jmp boucle

    fin:
    mov rdi,resultat
    mov rsi,chresult
    mov rax,0
    call printf

    pop rbp 
    ; Pour fermer le programme proprement :
    mov    rax, 60         
    mov    rdi, 0
    syscall

    ret
