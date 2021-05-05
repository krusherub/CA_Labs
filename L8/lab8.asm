.model small
.stack 512
;-----------------------***************DATA***************------------------------------
.data
    ; matrix to find a min number in
    matrix   DW 8, 8, 0, 1, 0, 0, 7, 5, 8, 4, 0, 5, 7, 0, 8, 6 

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
    string db 254       ;var for string

    port_b equ 61h
    command_reg equ 43h ;command registry address
    channel_2 equ 42h   ;channel 2's address
    top equ 08          ;uper row of menu
    bottom equ 15       ;lower row of menu
    lefcol equ 26       ;left column of menu
    attrib db ?         ;screen attributes
    row db 00           ;row of a screen

    ;main menu rows
    shadow db 20 dup(0dbh);
    menu db 0c9h, 17 dup(0cdh), 0bbh
    db 0bah, '   Team number   ',0bah
    db 0bah, '   Team members  ',0bah
    db 0bah, '      Count      ',0bah
    db 0bah, '      Sound      ',0bah
    db 0bah, '    Min value    ',0bah
    db 0bah, '      Exit       ',0bah
    db 0c8h, 17 dup(0cdh), 0bch

    ;assist messages
    prompt db 'To select an item use arrows'
    db ' and press enter'
    db 13, 10, 'Press esc to exit                         '
    .386
    message_3 db "RESULT:                               ", 13, 10, '$'   
    message_4 db "MIN VALUE:", 13, 10, '$'
    message_1 db "END", 13, 10, '$'
    message_2 db "BEEP", 13, 10, '$'
    empty_message db " ", 13, 10, '$'
    
    ;Team info
    teamNUmber db "Team 2",10,13,'$'
    sanya db "Brazhnik Olexandr",10,13,'$'
    vanya db "Devitskiy Ivan",10,13,'$'
    vitalya db "Kryvonosiuk Vitalii",10,13,'$'

;-----------------------***************CODE***************------------------------------
.code
    
    a10main proc far
            mov ax,@data 
            mov ds,ax 
            mov es,ax 
            call cleaner                ; clean the screen
            mov row,bottom+4 
        a20:
            call menuOutput             ;output menu
            mov row,top+1               ;choosing upper point of menu as a start value
                                        
            mov attrib,16h
            call d10disply
            call c10input

        jmp a20 
        a10main endp

        ; Output UI
        menuOutput proc near
            pusha
            mov ax,1301h
            mov bx,0060h
            lea bp,shadow
            mov cx,19
            mov dh,top+1
            mov dl,lefcol+1

        b20: int 10h
            inc dh ;next row
            cmp dh,bottom+2
            jne b20
            mov attrib,35h
            mov ax,1300h
            movzx bx,attrib
            lea bp,menu
            mov cx,19 
            mov dh,top
            mov dl,lefcol
        b30:
            int 10h
            add bp,19
            inc dh
            cmp dh,bottom+1
            jne b30
            mov ax,1301h
            movzx bx,attrib
            lea bp,prompt
            mov cx,79
            mov dh,bottom+4
            mov dl,00
            int 10h
            popa
            ret
        menuOutput endp

        ; arrow keys, enter and escape to choose and quit menus
        c10input proc near
        pusha
        main_cycle: 
            mov ah,10h ;request 1 symbol from keyboard
            int 16h
            cmp ah,50h ;arrow down
            je down_arrow_pressed
            cmp ah,48h ;arrow up
            je up_arrow_pressed
            cmp al,0dh ;press enter
            je enter_pressed ; enter_pressed
            cmp al,1bh ;escape pressed
            je ecs_pressed ; exit
        jmp main_cycle ;repeat if nothing is pressed

        ; arrow down
        down_arrow_pressed:
            mov attrib,35h
            call d10disply
            inc row
            cmp row,bottom-1
            jbe c50
            mov row,top+1
            jmp c50

        ; arrow up
        up_arrow_pressed:
            mov attrib,25h
            call d10disply
            dec row
            cmp row,top+1
            jae c50
            mov row,bottom-1
        ; fill selected
        c50:
            mov attrib,17h
            call d10disply
            jmp main_cycle
        ;esc pressed
        ecs_pressed:
            jmp exit
        ; enter pressed
        enter_pressed:
            popa 
            lea si,row
            mov ax,[ds:si]
            xor ah,ah
            mov bx, 8
            sub ax, bx
            ; selecting action depending on the option
            cmp ax, 01h
            je  print_team_number
            cmp ax, 02h
            je print_team
            cmp ax, 03h
            je count
            cmp ax, 04h
            je beep
            cmp ax, 05h
            je min
            cmp ax, 06h
            je exit
            ret
        c10input endp
        ; output team number
        print_team_number:
            mov dx, offset empty_message
            call display_information
            mov dx, offset teamNUmber
            call display_information
            call pause1
            call mrProper
            jmp main_cycle
        ; output team members
        print_team:
            mov dx, offset empty_message
            call display_information
            push ds
            mov ah, 25h
            mov al, 58h
            lea dx, print
            mov bx, seg print
            mov ds, bx
            int 21h
            pop ds
            int 58h
            jmp main_cycle
        ; expression calculation
        count:
            mov dx, offset empty_message
            call display_information
            mov dx, offset message_3
            call display_information
            call math
            jmp main_cycle
        ; beep
        beep:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_2 
            call display_information
            call beeper; call the needed function
            jmp main_cycle
        ;finding the minimal value
        min:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_4
            call display_information
            call findMin 
            mov ax, [ds:0000h]
            call output 
            jmp main_cycle
        ; quuitting the program
        exit:
            mov dx, offset empty_message 
            call display_information
            mov dx, offset message_1 
            call display_information
            mov ax,4c00h
            int 21h
        ; display the message
        display_information proc
            mov ah,9
            int 21h
            xor dx, dx
            ret
        display_information  endp
        ; Outputting a number
        output proc 
            mov [es:0475h],' '
            mov [es:0474h],' '
            mov [es:0473h],' '
            mov [es:0472h],' '
            mov [es:0471h],' '
            mov di,0470h

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

                mov [es:0475h],'$'
                mov dx, 0470h
                mov ah,09h
                int 21h
                
            call pause1
            call mrProper
            ret 
        output endp
        ; beeping stuff
        beeper proc
            lab8: 
                                ;встановлення частоти 440 гц
                                ;дозвіл каналу 2 встановлення порту в мікросхеми 8255
            in al,port_b        ;читання
            or al,3             ;встановлення двох молодших бітів
            out port_b,al       ;пересилка байта в порт b мікросхеми 8255
                                ;встановлення регістрів порту вводу-виводу
            mov al,10110110b    ;біти для каналу 2
            out command_reg,al  ;байт в порт командний регістр
                                ;встановлення лічильника 
            mov ax,2705         ;лічильник = 1190000/440
            out channel_2,al    ;відправка al
            mov al,ah           ;відправка старшого байту в al
            out channel_2,al    ;відправка старшого байту 
            ; пауза 1 секундy
            call pause1
            ; вимкнення звуку 
            in al,port_b        ;отримуємо байт з порту в
            and al,11111100b    ;скидання двох молодших бітів
            out port_b,al       ;пересилка байтів в зворотному напрямку
            ret
        beeper endp
        ;Calculating an algebraic expression
        math proc
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
        math endp
        ; array sorting procedure
        findMin proc
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
        findMin  endp
        ; painting the selected row
        d10disply proc near
            pusha 
            movzx ax,row 
            sub ax,top
            imul ax,19 
            lea si,menu+1 
            add si,ax
            mov ax,1300h 
            movzx bx,attrib 
            mov bp,si 
            mov cx,17 
            mov dh,row 
            mov dl,lefcol+1 
            int 10h
            popa 
            ret
        d10disply endp
        ; cleaning the screen
        cleaner proc near
            pusha 
            mov ax,0600h
            mov bh,35h ;setting the color of a screen 
            mov cx,00 
            mov dx,184fh
            int 10h
            popa 
            ret
        cleaner endp
        ; outputting team members
        print proc far
            mov ah,09h
            mov dx, offset sanya
            int 21h	
            mov dx, offset vanya
            int 21h	
            mov dx, offset vitalya
            int 21h
            call pause1
            call mrProper
            iret
        print endp
        ; clean the screen
        mrProper proc
            call cleaner ; clean screen
            call menuOutput ;menu output
            mov attrib,16h
            call d10disply
            ret
        mrProper endp
        ; pause for 1 second
        pause1 proc
            mov cx, 80 
            classic_loop:
                mov bx, cx
                mov  ah,86h
                xor cx, cx
                mov  dx,25000
                int  15h
                mov cx, bx 
            loop classic_loop
            ret
        pause1 endp
    end a10main