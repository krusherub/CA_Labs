IDEAL
MODEL small
STACK 256
;-----------------------------------------------------------------------------------------------------------
MACRO McROSS ; init macros
    mov ax, @data
    mov ds, ax
    mov es, ax
ENDM
;-----------------------------------------------------------------------------------------------------------
DATASEG
teamNumber db "team 2:", 10,13, '$' ; string for output
kryvonosiuk db "Kryvonosiuk Vitalii", 10,13, '$' ; string for output
brazhnik db "Brazhnyk Olexandr", 10,13, '$' ; string for output
devitskiy db "Devitskiy Ivan", 10,13, '$' ; string for output
;-----------------------------------------------------------------------------------------------------------
CODESEG
Start: 
McROSS

push ds
mov ah, 25h
mov al, 52h                         ; write the number of the interrution vector to al
lea dx, Interruption                ; writing the address of the interruption via "ефективне зміщення"
mov bx, seg Interruption                             
mov ds, bx
int 21h                             ; connecting the 52h to our procedure
pop ds

int 52h                              ; calling the interruption

mov ah, 4ch                          ; loading 4ch to ah
mov al, 0h                           ; getting the exit code
int 21h                              ; calling DOS 4ch to quit

proc Interruption far                ; procedure of the interruption (far is necessary)
    mov dx, offset teamNumber        ; writing the message to dx
    mov ah, 09h                      ; loading 09h to ah registry
    int 21h                          ; callling the interruption to output the message
    mov dx, offset kryvonosiuk
    int 21h
    mov dx, offset brazhnik
    int 21h                                                                                                         
    mov dx, offset devitskiy
    int 21h

IRET                                 ; returning from the interruption using IRET
endp Interruption
end Start
