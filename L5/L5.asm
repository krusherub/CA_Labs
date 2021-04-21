TITLE ЛР_5

;------------------------------------------------------------------------------
; Комп'ютерна архітектура
; ВУЗ:          НТУУ "КПІ"
; Факультет:    ФІОТ
; Курс:          1
; Група:       ІТ-01
;------------------------------------------------------------------------------

IDEAL			 
MODEL small		
STACK 2048		
;------------------------------------------------------------------------------

DATASEG
matrixArray db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            db 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
            
LEN DW 256

birthdate1 db "12122002"            
birthdate2 db "0512002"
birthdate3 db "22072003"
birthdate0 db "11111111"
;------------------------------------------------------------------------------
CODESEG
Start:
    mov ax, @data ; data segment init
    mov ds, ax
    mov es, ax

    mov cx, [LEN]   ;Cx is counter for OUTERLOOP CX=5    
    dec cx          ; CX = 4 
    call sort

    mov cx, 256                 ; repeats amount
    call copyArray
    
    mov cx, 8
    mov bp, 0162h
    call set_bdatesd

    mov cx, 8
    mov bp, 0172h
    call set_bdatesd

    mov cx, 8
    mov bp, 0182h
    call set_bdates1

    mov cx, 8
    mov bp, 0192h
    call set_bdates2

    mov cx, 8
    mov bp, 01A2h
    call set_bdates3



    mov cx, 8
    mov bp, 01B2h
    call set_bdatesd

    mov cx, 8
    mov bp, 01C2h
    call set_bdatesd

    mov cx, 8
    mov bp, 01D2h
    call set_bdatesd


; the end :)
    mov ah, 4ch
    int 21h

;--------------------------------------------Copy array -------------------------------------------         
; Input: cx - initial size of the array ,
;----------------------------------------------------------------------------------------------------------- 
    PROC copyArray       
        xor si, si                       ; si to 0
        array_coping_loop:
            mov bx, [ds:si]              ; get number from matrixArray & set it to bx as a temp variable
            mov [ds:[si+270h]], bx       ; copy number from bx to ds with offset 
            add si, 2                    ; si+= 2
            loop array_coping_loop

        ret
    ENDP   

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input: cx - birthday date,
;               bp - offset
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates1       
        xor si,si                                 ; set si to 0
        birthdate1_label:
            mov ah, [birthdate1+si]               ; put value of birthdate1 to ah with offset si
            mov [bp], ah                          ; add value from ah to stack
            inc si                                ; si++
            inc bp                                ; bp++
            loop birthdate1_label

        ret
    ENDP

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input: cx - birthday date,
;               bp - offset
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates2       
        xor si,si                                 ; set si to 0
        birthdate2_label:
            mov ah, [birthdate2+si]               ; put value of birthdate2 to ah with offset si
            mov [bp], ah                          ; add value from ah to stack
            inc si                                ; si++
            inc bp                                ; bp++
            loop birthdate2_label

        ret
    ENDP


;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input: cx - birthday date,
;               bp - offset
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdates3      
        xor si,si                                 ; set si to 0
        birthdate3_label:
            mov ah, [birthdate3+si]               ; put value of birthdate3 to ah with offset si
            mov [bp], ah                          ; add value from ah to stack
            inc si                                ; si++
            inc bp                                ; bp++
            loop birthdate3_label

        ret
    ENDP

;--------------------------------------------Add birthdate to stack-------------------------------------------         
; Input: cx - birthday date,
;               bp - offset
;----------------------------------------------------------------------------------------------------------- 
    PROC set_bdatesd    
        xor si,si                                 ; set si to 0
        birthdated_label:
            mov ah, [birthdate0+si]               ; put value of birthdate0 to ah with offset si
            mov [bp], ah                          ; add value from ah to stack
            inc si                                ; si++
            inc bp                                ; bp++
            loop birthdated_label

        ret
    ENDP

    PROC sort
        nextscan:                
            mov bx,cx
            mov si,0 

        nextcomp:

            mov al,[matrixArray+si]
            mov dl,[matrixArray+si+1]
            cmp al,dl

            jnc noswap 

            mov [matrixArray+si], dl
            mov [matrixArray+si+1], al

        noswap: 
            inc si
            dec bx
            jnz nextcomp

            loop nextscan

        ret
    ENDP

end Start