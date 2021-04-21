TITLE Lab-4

IDEAL
MODEL LARGE
STACK 1024
;-------------------------------II.МАКРОСИ-------------------------------------
                    ; Макрос для ініціалізації
MACRO M_Init    ; Початок макросу 
    mov     ax,@data
    mov     ds,ax   ; ds = data segment
    mov     es,ax   ; es = text VRAM segment for direct VRAM writes
ENDM M_Init      ; Кінець макросу

;----------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ------------------------------
DATASEG

matrix DW 8, 8, 0, 1, 0, 0, 7, 5 

       DW 9, 3, 5, 5, 5, 9, 6, 5

       DW 4, 5, 7, 7, 5, 1, 3, 5

       DW 4, 9, 1, 2, 3, 8, 7, 1 

       DW 9, 6, 9, 3, 6, 8, 0, 3 

       DW 6, 6, 9, 6, 9, 2, 1, 8 

       DW 1, 2, 6, 5, 3, 8, 5, 5 

       DW 0, 4, 7, 9, 9, 0, 4, 8
     
matrixLen = $-matrix
;-----------------------VI. ПОЧАТОК СЕГМЕНТУ КОДУ-------------------------------
CODESEG

Start:  
M_Init

lea si, [matrix]
mov ax,[matrixLen]
mov cx,ax
stack1: 
  mov ax, [si]
  add si,2
    push ax
  loop stack1
Exit:
mov ah,4ch

int 21h
end Start