section .data
   ; fmt_scan:   db  "%d",0
   ; fmt_print:  db  "Vous avez entré la valeur : %d",10,0
   ; ask:        db  "Entrez une valeur entière :",0
   
   ; 'db' signifie 'define byte' de taille 8 bits ou 1 octet
   ; 'dw' signifie 'define word' de taille 16 bits ou 2 octets
   ; 'dd' signifie 'define double word', de 32 bits ou 4 octets
   ; 'dq' signifie 'define quad word', de 64 bits ou 8 octets

   ; db - 8 bits - db 255 - db 127 signé
   ; dw - 16 bits - db 65535 - db 32767 signé
   ; dd - 32 bits - 4,294,967,295 - 2,147,483,647
   ; dq - 64 bits - 18,446,744,073,709,551,615 - 9,223,372,036,854,775,807

section .bss
   ; reponse : resb    1
   
   ; 'resb' est une directive, par exemple ici : réserver 1 octet de mémoire à 'réponse'
    
section .text
global main

; ci-dessous, les instructions minimales de tout programme ASM

main:
    push rbp           ; Sauvegarde de l'ancien rbp
    mov rbp, rsp       ; Initialise le cadre de pile
    
    ; Ici, le code principal du programme

    pop rbp            ; Restaure l'ancien rbp avant de quitter
    mov rax, 60        ; Appel système pour "exit"
    mov rdi, 0         ; Code de retour 0
    syscall            ; Exécution de l'appel système
