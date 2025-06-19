org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A


_start:
    ; init
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    cli

    mov word [ds:0x1C*4], print    ; Set handler OFFSET
    mov [ds:0x1C*4+2], cs          ; Set handler SEGMENT (CS)
    sti                   ; Re-enable interrupts

; INT 1Ch handler (called ~18.2 times/sec)


print:
    push ax
    push si
    push bx

    mov si, msg

    .loop:
        lodsb
        test al, al
        jz .done
        mov ah, 0x0E
        mov bh, 0 
        int 0x10
        jmp .loop

    .done:
        pop ax
        pop si
        pop bx
        ret

msg db "1 second passed!", ENDL, 0

tick_count dw 0
times 510-($-$$) db 0
dw 0AA55h