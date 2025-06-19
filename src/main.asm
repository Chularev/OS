org 0x7C00
bits 16


_start:
    ; init
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    cli

    ; Install INT 1Ch handler
    mov word [0x1C*4], timer_isr    ; Offset
    mov [0x1C*4+2], cs              ; Segment (current code segment)
    sti                   ; Re-enable interrupts

    ; Main loop - wait for 18 ticks (~1 second)
    mov cx, 18
.wait_loop:
    cmp [tick_count], cx
    jb .wait_loop

    ; Print message after delay
    mov si, msg
    call print
    hlt

; INT 1Ch handler (called ~18.2 times/sec)
timer_isr:
    call print
    inc word [tick_count]
    iret                  ; No need to chain for INT 1Ch

; Simple print function
print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

; Data
tick_count dw 0
msg db "1 second passed!", 0

times 510-($-$$) db 0
dw 0AA55h