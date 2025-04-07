;Colby Wirth
;COS 255
;Assignment 5
;Version 7 April 2025

section .data ;declared values
    mes1 db "Please type in your name:" 
    mes1_len equ $ - mes1
    
    mes2 db "Nice to meet you!"
    mes2_len equ $ - mes2

section .bss ;undeclared values
    stdHandle resd 1
    username resb 32 ;32 bit buffer for username

section .text ;APIs
    extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start


_start:
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

    ;exiting
    push 0
    call _ExitProcess@4