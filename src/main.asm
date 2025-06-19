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

    mov word [ds:0x1C*4], timer_isr    ; Set handler OFFSET
    mov [ds:0x1C*4+2], cs          ; Set handler SEGMENT (CS)
    sti                   ; Re-enable interrupts

    hlt

timer_isr:
    pusha                   ; Save all registers
    push ds                 ; Save DS (BIOS may modify it)
    
    inc word [tick_count]   ; Increment tick counter
    
    cmp word [tick_count], 18  ; About 1 second (18.2 ticks/sec)
    jb .end_isr
    
    ; Reset counter and print
    mov word [tick_count], 0
    call print
    
.end_isr:
    pop ds                  ; Restore DS
    popa                    ; Restore all registers
    iret                    ; Proper interrupt return


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
        pop bx
        pop si
        pop ax
        ret

msg db "1 second passed!", ENDL, 0

tick_count dw 0
times 510-($-$$) db 0
dw 0AA55h