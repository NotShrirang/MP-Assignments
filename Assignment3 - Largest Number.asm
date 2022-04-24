section .data
    array db 11h, 55h, 33h, 22h, 44h
    msg1 db 10, 13h, 'Largest no in an array is '
    len1 equ $-msg1

section .bss
    cnt resb 1
    result resb 16

    dispbuff resb 2
    %macro print 2
        mov eax, 4
        mov ebx, 1
        mov ecx, %1
        mov edx, %2
        int 80h
    %endmacro

section .text
    global _start

_start:
    mov byte[cnt], 5          ; display
    mov rsi, array
    mov al, 0
  LP:
    cmp al, [rsi]
    jg skip
    xchg al, [rsi]
    skip: 
      inc rsi
      dec byte [cnt]
      jnz LP
    
    mov rax, 1      ; Store string
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall
        
    call display
    
    display:
        mov rbx, rax
        mov rdi, result
        mov cx, 16
        up1:
            rol rbx, 04
            mov al, bl

            and al, 0fh
            cmp al, 09h
            jg add_37
            add al, 30h
            jmp skip
    
    add_37:
        add al, 37h
        skip2:
            mov [rdi], al
            inc rdi
            dec cx
            jnz up1
        print result, 16
        ret
            
    mov rax, 60      ; exit system call
    mov rdi, 0
    syscall