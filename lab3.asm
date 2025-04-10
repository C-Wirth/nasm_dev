section .data
    
    prompt1 db "What do you want to do? (1-Add, 2-Sub, 3-Exit)", 13,10
    prompt1_len equ $-prompt1

    askFirstOp db "Type in the first operand", 13, 10
    askFirstOp_len equ $-askFirstOp

    askSecondOp db "Type in the second operand", 13, 10
    askSecondOp_len equ $-askSecondOp
    
    addPrompt db "Perform addition operation!", 13, 10
    addPrompt_len equ $-addPrompt
    
    subPrompt db "Perform subtraction operation!", 13,10
    subPrompt_len equ $-subPrompt

    calcPrompt db "The calculation result is: ", 13, 10
    calcPrompt_len equ $-calcPrompt

    exitPrompt db "Exiting", 13, 10
    exitPrompt_len equ $-exitPrompt 

    subtraction_flag db 0 ; flag for determining addition or subtraction, 0 = add, 1 = subtract

section .bss
    stdHandle resd 1
    chars_read resd 1
    user_input_buf resb 2 ;1 byte buffer for 1 char + null terminator
    operand1 resd 1
    operand2 resd 1
    result_buf resb 4 ; stores operand1 +/- operand 2

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

    ;get input handle for user decision
    push -10
    call _GetStdHandle@4
    
    mov [stdHandle], eax
    push chars_read
    push 8 ; 8 bits
    push user_input_buf
    push dword [stdHandle]
    call _ReadConsoleA@20

    movzx eax, byte [user_input_buf]

    ;make option based on 1,2,3
    cmp eax, '3'
    je exit_process
    
    cmp eax, '1'
    setne [subtraction_flag] ; set the subtraction flag if 1
    xor eax, eax

    ;;; next, get operands 1 and 2 ;;;

    ;prompt user for operand 1
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    push 0
    push askFirstOp_len
    push askFirstOp
    push dword [stdHandle]
    call _WriteConsoleA@20

    ;get input for operand1
    push -10
    call _GetStdHandle@4
    mov [stdHandle], eax
    push chars_read
    push 8
    push user_input_buf
    push dword [stdHandle]
    call _ReadConsoleA@20

    movzx eax, byte [user_input_buf]
    sub eax, '0' ; convert to int
    mov [operand1], eax

    ;prompt user for operand 2
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax
    push 0
    push askSecondOp_len
    push askSecondOp
    push dword [stdHandle]
    call _WriteConsoleA@20

    ;get input handle for operand2
    push -10
    call _GetStdHandle@4
    mov [stdHandle], eax
    push chars_read
    push 8
    push user_input_buf
    push dword [stdHandle]
    call _ReadConsoleA@20
    
    movzx eax, byte [user_input_buf]
    sub eax, '0' ; convert to int
    mov [operand2], eax

    xor eax, eax

    ; load operands to registers
    mov eax, [operand1]
    mov ebx, [operand2]

    ;get operation type
    cmp byte [subtraction_flag], 1
    je subtraction_block

    addition_block:
    ADD eax, ebx
    jmp convert_to_ASCII

    subtraction_block:
    SUB eax, ebx

    convert_to_ASCII:
    ADD eax, '0'
    mov [user_input_buf], al
    mov byte [user_input_buf+1], 0



    ;get handle to write output
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    push 0
    push calcPrompt_len
    push calcPrompt
    push dword [stdHandle]
    call _WriteConsoleA@20

    ;get handle to write result
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    push 0
    push 1
    push user_input_buf
    push dword [stdHandle]
    call _WriteConsoleA@20



;exiting
exit_process:
push 0
call _ExitProcess@4