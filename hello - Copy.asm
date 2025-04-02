section .data
    message db 'Hello, World!', 0DH, 0AH, 0  ; Message to print with CR LF and null terminator
    messageLen equ $ - message               ; Calculate the length of the message
    charsWritten db 1                      ; space for the pointer to the length of the written message  


section .bss
    stdHandle resd 1                         ; space for the standard output handle
    

section .text
    extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ; Get the standard output handle
    push -11                      ; STD_OUTPUT_HANDLE constant is -11
    call _GetStdHandle@4
    mov [stdHandle], eax          ; Save the handle

    ; Write the message to standard output
    push 0                        ; Placeholder for number of bytes written
    push charsWritten
    push messageLen               ; Length of the message
    push message                  ; Pointer to the message
    push dword [stdHandle]           ; Standard output handle
    call _WriteConsoleA@20

    ; Exit the process
    push 0                        ; Exit code
    call _ExitProcess@4
