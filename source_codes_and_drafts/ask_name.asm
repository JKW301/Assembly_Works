extern printf
extern scanf

global main

section .data
    fmt_scan:   db  "%s",0                ; Format pour scanf (chaîne de caractères)
    fmt_print:  db  "Votre prénom et nom complet : %s %s",10,0  ; Message final
    ask_first:  db  "Entrez votre prénom :",0
    ask_last:   db  "Entrez votre nom :",0

section .bss
    prenom:    resb  20                   ; Réserve 20 octets pour le prénom
    nom:       resb  20                   ; Réserve 20 octets pour le nom

section .text
main:
    push rbp

    ; Demande le prénom
    mov rdi, ask_first
    mov rax, 0
    call printf

    mov rdi, fmt_scan ; qui est un byte
    mov rsi, prenom ; rdi=64, mais on peut aussi utiliser esi=32
    mov rax, 0
    call scanf

    ; Demande le nom
    mov rdi, ask_last
    mov rax, 0
    call printf

    mov rdi, fmt_scan
    mov rsi, nom
    mov rax, 0
    call scanf

    ; Affiche le prénom et le nom ensemble
    mov rdi, fmt_print
    mov rsi, prenom
    mov rdx, nom
    mov rax, 0
    call printf

    pop rbp
    mov rax, 60         ; syscall pour quitter
    mov rdi, 0
    syscall
    ret
