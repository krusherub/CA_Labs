ideal
model small 
stack 512

;-----------------------***************DATA***************------------------------------

dataseg
    ; Array to find a min number in
    matrix  DW 8, 8, 0, 1, 0, 0, 7, 5, 8, 4, 0, 5, 7, 0, 8, 6 

            DW 9, 3, 5, 5, 5, 9, 6, 5, 8, 1, 5, 1, 5, 6, 5, 9

            DW 4, 5, 7, 7, 5, 1, 3, 5, 5, 0, 6, 9, 3, 1, 3, 9

            DW 4, 9, 1, 2, 3, 8, 7, 1, 3, 9, 4, 0, 5, 8, 7, 8 

            DW 9, 6, 9, 3, 6, 8, 0, 3, 9, 7, 9, 5, 3, 4, 2, 4 

            DW 6, 6, 9, 6, 9, 2, 1, 8, 6, 6, 4, 8, 4, 7, 1, 7 

            DW 1, 2, 6, 5, 3, 8, 5, 5, 1, 0, 0, 3, 7, 4, 0, 0 

            DW 0, 4, 7, 9, 9, 0, 4, 8, 0, 3, 6, 8, 4, 6, 5, 8 

            DW 7, 7, 4, 7, 9, 8, 4, 9, 7, 5, 7, 8, 2, 8, 3, 8 

            DW 5, 4, 6, 2, 4, 3, 8, 9, 3, 4, 9, 4, 5, 5, 5, 6 

            DW 1, 9, 1, 2, 5, 0, 7, 1, 1, 1, 4, 4, 0, 1, 2, 4 

            DW 4, 6, 8, 1, 6, 6, 6, 0, 4, 9, 1, 2, 3, 5, 3, 8

            DW 2, 2, 5, 0, 7, 9, 5, 1, 4, 7, 0, 5, 4, 4, 0, 3 

            DW 4, 9, 3, 0, 9, 1, 4, 0, 2, 6, 0, 8, 3, 3, 0, 8 

            DW 9, 2, 2, 3, 8, 4, 9, 1, 1, 4, 6, 8, 0, 7, 7, 0

            DW 8, 9, 2, 1, 6, 5, 9, 8, 0, 3, 3, 9, 9, 6, 6, 1

    len dw 100h
    string db 254 ; var for string
    str_len db 0
    db 254 dup ('*') ; fill the buffer with *

    ; System messages
    system_message_1 db "Input command: " ,'$'
    system_message_2 db "The END" ,'$'
    ; UI messages
    message_0 db "program is running", 13, 10, '$'
    message_1 db "r - for count", 13, 10, '$'
    message_2 db "T - for beep", 13, 10, '$'
    message_3 db "y - for exit", 13, 10, '$' 
    message_3_0 db "m - for min value", 13, 10, '$' 
    
    message_4 db "program has stopped", 13, 10, '$'
    message_5 db "press any key", 13, 10, '$'
    message_6 db "Result -                         ", 13, 10, '$'
    message_7 db "min value: ", 13, 10, '$'
    ; setUP messages
    message db ?
        test_message db "This is a test", 13, 10, '$'
    ; vars for sound
    number_cycles equ 2000
    frequency equ 600
    port_b equ 61h
    command_reg equ 43h 
    channel_2 equ 42h
    symbol db ?

;-----------------------***************CODE***************------------------------------

codeseg

    start:                                  ;   typical initialization
        mov ax, @data 
        mov ds, ax      
        mov es, ax 

; kinda talks for itself (it's infinite)
    main_cycle:                             

        call show_menu                      ; kinda talks for itself as well
   
        mov ah, 0ah                         ; ah <- 0ah 
        mov dx, offset string               ; Sending the start of the buffer to dx
        int 21h 

        xor ax, ax 
        mov bx, offset string               ; Sending the start of the buffer to dx (раелізація адресації зі зміщенням)
        mov ax, [bx+1]                      ; Put input to ax
        shr ax, 8                           ; Shifting (зсування) ax

        ; Input logic is here
        cmp ax, 72h                         ; ascii for r is 72h
        je count
        cmp ax, 54h                         ; ascii for T is 54h
        je beep
        cmp ax, 6dh                         ; ascii for m is 72h
        je find_min
        cmp ax, 79h                         ; ascii for y is 79h
        je exit
        jmp main_cycle                      ; unconditional return to our cycle (that's why it's infinite)

    ; Calculating the given expression
    count:
        mov dx, offset message_6
        call show_string
        call math
        jmp main_cycle    

    ; Beeping
    beep:
        mov dx, offset message_5 
        call show_string
        call beeper
        jmp main_cycle
    ; finding 
    find_min:
        mov dx, offset message_5 
        call show_string
        call FindMin 
        jmp main_cycle
    ; Вихід з програми
    exit:
        mov dx, offset message_4 
        call show_string
        mov ah,04ch
        int 21h

    ;-----***************ASSISTING PROCEDURES***************-----------
    ;   Pretty self explanatory
    proc show_menu
        mov ah, 0
        mov al, 3
        int 10h
        mov dx, offset message_0
        call show_string
        mov dx, offset message_1
        call show_string
        mov dx, offset message_2
        call show_string
        mov dx, offset message_3
        call show_string
        mov dx, offset message_3_0
        call show_string
        mov dx, offset system_message_1
        call show_string
        ret
    endp show_menu
    ;Outputting a string form dx
    proc show_string
        mov ah,9
        int 21h
        xor dx, dx
        ret
    endp show_string 
    ;Playing a sound
    proc beeper
        lab7:
        int 16h             ; interruption for saving the input value 
        mov [symbol], al
        cmp [symbol], 'y'   ;Chacking for correspondence and setting the flag to 0
        jz exit             ;if true goes to exit
                            
        in al,port_b        ;reading
        or al,3             ;setting the two younger bits
        out port_b,al       ;sending a byte to port b of microscheme 8255
                            ;setting IO registries
        mov al,10110110b    ;bits for the second channel
        out command_reg,al  ;byte to command registry
                            ;setting a counter
        mov ax,2705         ;counter is equal to 1190000/440
        out channel_2,al    ;sending al
        mov al,ah           ;sending ah al
        out channel_2,al    ;sending ah

        ;pause for 2 seconds
        mov cx, 80          ; 40 is for 1 second
        looop:
            mov bx,cx
            mov ah,86h
            xor cx,cx
            mov dx,20000
            int 15h
            mov cx,bx 
        loop looop

                            ;switch off
        in al,port_b        ;getting a byte from port_b
        and al,11111100b    ;dropping the younger bits
        out port_b,al       ;sending bytes in reverse
        ret
    endp beeper

    ;Calculating an algebraic expression
    proc math
        mov ax, -7
        mov bx, 3
        add ax, bx
        mov cl, 2h
        imul cl
        mov bl, 4
        idiv bl
        mov bl, 2
        add al, bl

        call output
        ret
    endp math

    ;Outputting a number
    proc output

        mov [es:0105h],' '
        mov [es:0104h],' '
        mov [es:0103h],' '
        mov [es:010h],' '
        mov [es:0101h],' '
        mov di,0100h  

        push cx
        push dx
        push bx
        mov bx,10
        xor cx,cx
        
    point1:   
        xor dx,dx
        div bx
        push dx
        inc cx
        test ax,ax
        jnz point1
    point2:   
        pop ax
        add al,'0'
        stosb
        loop point2

        pop bx
        pop dx
        pop cx 

        mov [es:0105h],'$'
        mov dx, 100h
        mov ah,09h 
        int 21h

        ;pause for output
        mov cx, 50
        loooop:
            mov bx, cx
            mov  ah,86h
            xor cx, cx
            mov  dx,20000
            int  15h
            mov cx, bx 
        loop loooop

        ret 
    endp output

    ;array sorting procedure
    proc FindMin 
        lea si, matrix
        mov cx, len    
            push    bx
            push    cx
            push    dx
            push    si
            push    di

            mov     bx,     si
            mov     dx,     cx
            dec     dx
            shl     dx,     1               
            dec     cx                      
            mov     si,     0
        forI:
            mov     di,     dx             
        forJ:                                 
            mov     ax,     [bx+di-2]       
            cmp     ax,     [bx+di]
            jbe     nextJ                
            xchg    ax,     [bx+di]         
            xchg    ax,     [bx+di-2]       
            xchg    ax,     [bx+di]         
        nextJ:
            sub     di,     2              
            cmp     di,     si             
            ja      forJ
            add     si,     2              
            loop    forI
        mov ax, [ds:0000h]
        call output       

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        ret

    endp FindMin  

end start