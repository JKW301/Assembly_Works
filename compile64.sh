#!/bin/bash
# compile64.sh

# Vérifier si un fichier a été fourni
if [ -z "$1" ]; then
    echo "Usage: $0 <fichier.asm>"
    exit 1
fi

file_base=$(basename "$1" .asm)
asm_file="${file_base}.asm"
obj_file="${file_base}.o"
exec_file="${file_base}_executable"

# Compilation avec NASM
nasm -f elf64 -o "$obj_file" "$asm_file"

# Vérifier si le fichier source contient "global main" ou "global _start"
if grep -q "global main" "$asm_file"; then
    echo "Compilation avec la libc (main détecté)"
    gcc -m64 -no-pie -o "$exec_file" "$obj_file"
elif grep -q "global _start" "$asm_file"; then
    echo "Compilation sans libc (_start détecté)"
    ld -o "$exec_file" "$obj_file"
else
    echo "Erreur : ni 'main' ni '_start' détecté. Vérifiez votre code assembleur."
    rm "$obj_file"
    exit 1
fi

# Vérification de la réussite de la compilation
if [ $? -eq 0 ]; then
    echo "Compilation réussie. Exécutable généré : $exec_file"
    rm "$obj_file"
else
    echo "Erreur lors de la compilation."
    exit 1
fi

