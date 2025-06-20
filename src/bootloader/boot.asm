org 0x7C00
bits 16

;
; FAT12 header
; 
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db 'SashaOS    '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

start:
    ; int
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; init stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

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