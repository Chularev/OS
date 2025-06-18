org 0x7C00
bits 16

mov si, message   ; SI points to string
print_loop:
    lodsb         ; Load AL from [SI] and increment SI
    cmp al, 0     ; Check for null terminator
    je done
    mov ah, 0x0E
    int 0x10
    jmp print_loop
done:
    hlt

message db 'SashaOS srart!', 0

times 510-($-$$) db 0
dw 0AA55h