; Author  : Colby Wirth
; Course  : COS 255
; Lab 3   : Simple Calculator
; Version : 21 April 2025
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
    is_neg_flag db 0

    newline db 13, 10
    newline_len equ $-newline


section .bss
    stdHandle resd 1
    chars_read resd 1
    user_input_buf resb 4
    operand1 resd 1
    operand2 resd 1
    result_buf resb 5
    output_size resb 1 ; 1 byte to store the output size

section .text ;APIs
    extern _GetStdHandle@4, _WriteConsoleA@20, _ReadConsoleA@20, _ExitProcess@4
    global _start

_start:

loop_start:
    xor eax, eax
    mov byte [subtraction_flag], 0
    mov byte [is_neg_flag], 0
    xor [result_buf], eax

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
    
    cmp eax, '2'
    sete [subtraction_flag] ; sets subtraction flag
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
    jmp convert_to_ASCII


    convert_to_ASCII:

        xor ecx, ecx ;ecx used for loop
        xor edx, edx
        mov ebx, 10 ; dividing by 10 to get next digit in loop
        mov esi, 0 ; will use for reversing the digits
        mov edi, result_buf 

        cmp eax, 0
        jge convert_loop ; else condition, the value is negative
        mov byte [is_neg_flag], 1 ; account for the '-'
        neg eax


    convert_loop:
    
        xor edx, edx
        div ebx ; divide EAX by 10 to get the next integer
        add dl, '0' ;; convert to ascii
        mov [edi + esi], dl ; store the ascii digit at offset 
        inc esi ; increment the offset
        inc ecx ;increment the digit count
        test eax, eax ; check quotient ==0 ?
        jnz convert_loop

        ; deal with negative numbers
        cmp byte [is_neg_flag], 0
        je skip_neg
        mov byte [edi + esi], '-' ; append with '-' for a negative string
        inc esi
        inc ecx

    skip_neg:
        mov [output_size], ecx ; output_size used for the _WriteConsole sys acll

    xor eax, eax ; initialize eax and ebx as pointers to reverse outputs in the output string
    mov ebx, ecx 
    dec ebx                
    reverse_elements_loop:

        cmp eax, ebx ; check if eax and ebx have not passed eachother
        jge done

        ; swap elements
        mov dl, [edi + eax] ; load left element into dl
        xchg dl, [edi + ebx] ; exchange dl with right element
        mov [edi + eax], dl ; store updated left element

        ;increment and decrement pointers
        inc eax
        dec ebx
        jmp reverse_elements_loop

    done:

    write_output:
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
    push dword [output_size]
    push result_buf
    push dword [stdHandle]
    call _WriteConsoleA@20

    ; write newline after result
    push -11
    call _GetStdHandle@4
    mov [stdHandle], eax

    push 0
    push newline_len
    push newline
    push dword [stdHandle]
    call _WriteConsoleA@20

jmp loop_start ; restart the process until the user quits



;exiting
exit_process:
push 0
call _ExitProcess@4