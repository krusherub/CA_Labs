TITLE Lab-4

IDEAL
MODEL LARGE
STACK 1024
;-------------------------------II.МАКРОСИ-------------------------------------
                    ; Макрос для ініціалізації
MACRO M_Init		; Початок макросу 
    mov     ax,@data
    mov     ds,ax   ; ds = data segment
    mov     es,ax   ; es = text VRAM segment for direct VRAM writes
ENDM M_Init			; Кінець макросу

;----------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ------------------------------
DATASEG
birthdates db "2003|22.07" 
db	"2002|5.11"
db	"2002|12.12 "
;-----------------------VI. ПОЧАТОК СЕГМЕНТУ КОДУ-------------------------------
CODESEG

Start:	
M_Init

	mov cx, 16
    mov bp, 0150h

	xor si,si                                 
        birthdate_label:
            mov ah, [birthdates+si]          
            mov [bp], ah                         
            inc si                                
            inc bp                                
            loop birthdate_label

        ret
		
end Start