section .data
    menumsg db 10, '*** Menu ***'
    db 10, '1. Addition'
    db 10, '2. Subtraction'
    db 10, '3. Division'
    db 10, '4. Multiplication'
    db 10, 10, 'Enter your choice : '

    menumsg_len : equ $ -menumsg

    addmsg db 10, 'Welcome to addition : ', 10
    addmsg_len equ $-addmsg

    submsg db 10, 'Welcome to subtraction : ', 10
    submsg_len equ $-submsg

    mulmsg db 10, 'Welcome to multiplication : ', 10
    mulmsg_len equ $-mulmsg

    divmsg db 10, 'Welcome to division : ', 10
    divmsg_len equ $-divmsg

    wrchmsg db 10, 10, 'You entered wrong choice!'
    wrchmsg_len equ $-wrchmsg

    no1 dq 08h
    no2 dq 02h

    nummsg db 10
    result dq 0

    resmsg db 10, 'Result is : '
    resmsg_len equ $-resmsg

    qmsg db 10, 'Quotient : '
    qmsg_len equ $-qmsg

    rmsg db 10, 'Remainder :'
    remg_len equ $-rmsg

    nwmsg db 10
    resh dq 0
    resl dq 0

section .bss
    choice resb 2
    dispbuff resb 16

%macro scall 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdi, %4
    syscall
%endmacro

section .text
    global _start
_start:
    up:
        scall 1, 1, menumsg, menumsg_len
        scall 0, 0, choice, 2
        cmp byte[choice], '1'
        jne case2
        call add_proc
        jmp up
    
        case2:
            cmp byte[choice], '2'
            jne case3
            call sub_proc
            jmp up
        case3:
            cmp byte[choice], '3'
            jne case4
            call mul_proc
            jmp up
        case4:
            cmp byte[choice], '4'
            jne caseinv
            call sub_proc
            jmp up
        caseinv:
            scall 1, 1, wrchmsg, wrchmsg_len
            exit:
                mov eax, 01
                mov ebx, 0
                int 80h
    add_proc:
        scall 1, 1, addmsg, addmsg_len
        mov rax, [no1]
        add rax, [no2]
        mov [result], rax
        scall 1, 1, resmsg, resmsg_len
        mov rbx, [result]
        call disp64num
        scall 1, 1, nummsg, 1
        ret
    sub_proc:
        scall 1, 1, submsg, submsg_len
        mov rax, [no1]
        sub rax, [no2]
        mov [result], rax
        scall 1, 1, resmsg, resmsg_len
        mov rbx, [result]
        call disp64num
        scall 1, 1, nummsg, 1
        ret

    mul_proc:
        scall 1, 1, mulmsg, mulmsg_len
        mov rax, [no1]
        mov rbx, [no2]
        mul rbx
        mov [resh], rdx
        mov [resl], rax
        scall 1, 1, resmsg, resmsg_len
        mov rbx, [resh]
        call disp64num
        scall 1, 1, nummsg, 1
        ret

    div_proc:
        scall 1, 1, divmsg, divmsg_len
        mov rax, [no1]
        mov rdx, 0
        add rbx, [no2]
        div rbx
        mov [resh], rdx
        mov [resl], rax
        scall 1, 1, resmsg, resmsg_len
        mov rbx, [resh]
        call disp64num
        scall 1, 1, nummsg, 1
        ret

    disp64num:
        mov rbx, rax
        mov rdx, result
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
        skip:
            mov [rdi], al
            inc rdi
            dec rcx
            jnz up1
            disp64num result, 16
            ret