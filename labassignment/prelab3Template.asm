section .data
    upper dd 100
    result dd 0
    resultChar times 10 dd 0

section .bss
    stdHandle resd 1

section .text
    extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4
    global _start

_start:
    ; you need to to complete the if-control flow and the looping logic here.....
    ; store your calculation result to the variable label: 'result'
    ; your last instruction should be 'jmp done' --> jump to label 'done'



done:
    ; do not modify the following code.......
    ; this code will print the content of 'result'
    ; Convert the result to a string
    mov eax, [result]
    lea ecx, [resultChar + 9]  ; Point ecx to the end of the buffer
    mov dword [ecx], 0          ; Null-terminate the string

convert_loop:
    dec ecx                    ; Move back to the last character position
    xor edx, edx               ; Clear edx before division
    mov ebx, 10                ; We will divide by 10
    div ebx                    ; EDX:EAX / 10 -> EAX = quotient, EDX = remainder
    add edx, '0'               ; Convert remainder to ASCII
    mov [ecx], dl              ; Store the ASCII character
    test eax, eax              ; Check if quotient is zero
    jnz convert_loop           ; If not, continue the loop

    ; Get the standard output handle
    push -11                      ; STD_OUTPUT_HANDLE constant is -11
    call _GetStdHandle@4
    mov [stdHandle], eax          ; Save the handle

    ; Write the message to standard output
    push 0                        ; reserved
    push 10                      ; Length of the message
    push resultChar               ; Pointer to the message
    push dword [stdHandle]        ; Standard output handle
    call _WriteConsoleA@20

    ; Exit the process
    push 0                        ; Exit code
    call _ExitProcess@4
