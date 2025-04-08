section .data
    
    prompt1 db "What do you want to do? (1-Add, 2-Sub, 3-Exit)", 13,10
    prompt1_len equ $-prompt1

    askFirstOp db "Type in the first operand", 13, 10
    askFirstOp_len equ $-askFirstOp

    askSecondOp db "Type in the second operand", 13.10
    askSecondOp_len equ $-askSecondOp
    
    addPrompt db "Perform addition operation!", 13, 10
    addPrompt_len equ $-addPrompt
    
    subPrompt db "Perform subtraction operation!", 13,10
    subPrompt_len equ $-subPrompt

    calcPrompt db "The calculation result is: ", 13, 10
    calcPrompt_len equ $-calcPrompt

    exitPrompt db "Exiting", 13, 10
    exitPrompt_len equ $-exitPrompt

section .bss
    stdHandle resd 1
    chars_read resd 1
    user_input_buf resb 1 ;1 byte buffer for 1 char
    ; operand1 db
    ; operabd2 db


section .text ;APIs
    extern _GetStdHandle@4, _WriteConsoleA@20, _ReadConsoleA@20, _ExitProcess@4
    global _start

_start:

loop_start:

    ;get output handle
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;push prompt:
    push 0
    push prompt1_len
    push prompt1
    push dword [stdHandle]
    call _WriteConsoleA@20

    ;get input handle for operand1
    push -10
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;get user input  for operand1
    push chars_read
    push 8
    push user_input_buf
    push dword [stdHandle]
    call _ReadConsoleA@20

    mov eax, [user_input_buf]
    sub eax, '0'

    ;get input handle for operand2
    xor eax, eax
    push -10
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;get user input for operand2
    push chars_read
    push 8
    push user_input_buf
    push dword [stdHandle]
    call _WriteConsoleA@20

    ;perform addition then convert back to string
    sub user_input_buf, '0'
    add eax, [user_input_buf]
    mov user_input_buf, eax

    ;get handle for output of operation
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    ;print sum
    push 0
    push 1
    push user_input_buf
    push dword [stdHandle]
    call _WriteConsoleA@20



;exiting
push 0
call _ExitProcess@4