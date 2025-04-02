section .data
    oper1 db1
    oper2 db2
    res db2

section .bss

section .text
    global _start

_start:
    mov eax, 1
    cmp [eax], 190
    jg if_branch
    je else_if_branch
    jmp else_brnach ; default case

if_branch:
    add eax 1
    jmp _end_else_if

else_if_branch:
    mov eax, 2
    add eax 2
    jmp end_else_if

else_if_branch:
    mov eax 3,
    add eax 3
    jmp end_else_if



end_else_if: 
    ;code here to print the result