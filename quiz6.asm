section .data
    ; reserve 128 bytes for input
    inputBuffer times 128 db 0    

    ;store how many characters are read in successfully
    charsRead dd 0

    ;promot user for input
    message db "Hello", 0dh, 0ah, 0
    messageLen equ $ - message
    charsWrite dd 0

    ;print information about the calculation results
    message1 db "Please Type in 11", 0dh, 0ah, 0
    messageLen1 equ $ - message1
    charsWrite1 dd 0

section .bss
    ;uninitizalized data if you need
    stdHandle resd 1
    stdReadHandle resd 1
    

section .text
    ;write your code here
    extern _ReadConsoleA@20, _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ;main function here

    ; Get the standard input handle
    push -10                     ; STD_INPUT_HANDLE constant is -10
    call _GetStdHandle@4
    mov [stdReadHandle], eax          ; Save the handle

    ; Write the message to standard input
    push 0                                 ; Reserved
    push charsRead                         ; verifying
    push 128                               ; Length of the message
    push inputBuffer                       ; Pointer to the message
    push dword [stdReadHandle]             ; Standard input handle
    call _ReadConsoleA@20   

    ;currently, we have an input in inputBuffer, but it is a string
    ;we need to convert it to a number/integer
    movzx eax, byte [inputBuffer]  
    sub eax, '0'                   

    cmp eax, 11
    ;jump to if branch if eax == 11
    je if_branch
    ;unconditional jump to else branch
    jmp else_branch

if_branch:
    push -11                      ; STD_OUTPUT_HANDLE constant is -11
    call _GetStdHandle@4
    mov [stdHandle], eax          ; Save the handle
    ; Write the message to standard output
    push 0                        ; Placeholder for number of bytes written
    push charsWrite               ; verifying
    push messageLen                        ; Length of the message
    push message               ; Pointer to the message
    push dword [stdHandle]        ; Standard output handle
    call _WriteConsoleA@20
    jmp end_if_else

else_branch:
    push -11                      ; STD_OUTPUT_HANDLE constant is -11
    call _GetStdHandle@4
    mov [stdHandle], eax          ; Save the handle
    ; Write the message to standard output
    push 0                        ; Placeholder for number of bytes written
    push charsWrite1               ; verifying
    push messageLen1                        ; Length of the message
    push message1               ; Pointer to the message
    push dword [stdHandle]        ; Standard output handle
    call _WriteConsoleA@20
    jmp end_if_else

end_if_else:
    ;code continues here after if-else

    ; Exit the process
    push 0                        ; Exit code
    call _ExitProcess@4