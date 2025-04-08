;Colby Wirth
;COS 255
;Assignment 5
;Version 8 April 2025

section .data ;declared values
    mes1 db "Please type in your name:", 13, 10
    mes1_len equ $ - mes1
    
    mes2 db "Nice to meet you!", 13,10
    mes2_len equ $ - mes2

    username_len dd 0
    

section .bss ;undeclared values
    stdHandle resd 1
    chars_read resd 1
    username resb 32 ;32 bit buffer for username

section .text ;APIs
    extern _GetStdHandle@4, _WriteConsoleA@20, _ReadConsoleA@20, _ExitProcess@4
    global _start


_start:

_prompt:
    ;get the output handle:
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;push mes1 to console
    push 0
    push mes1_len
    push mes1
    push dword [stdHandle]
    call _WriteConsoleA@20

get_username:
    ;get the input handle
    push -10
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;get user input
    push chars_read
    push 32
    push username
    push dword [stdHandle]
    call _ReadConsoleA@20

calculate_username_len:
    xor eax, eax
    xor ecx, ecx
    mov eax, username
    mov ecx, 0

count_loop: ;gets the length of the username
    cmp byte [eax], 0
    je end_loop
    inc eax
    inc ecx
    jmp count_loop

end_loop:
    mov [username_len], ecx
    xor eax, eax

print_greeting:
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    push 0
    push mes2_len
    push mes2
    push dword [stdHandle]
    call _WriteConsoleA@20


print_username:
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax
    
    push 0
    push dword [username_len]
    push username
    push dword [stdHandle]
    call _WriteConsoleA@20


    ;exiting
    push 0
    call _ExitProcess@4