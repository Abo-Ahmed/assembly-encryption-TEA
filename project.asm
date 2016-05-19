   
name "string"



org     100h

jmp start  ; skip over the declarations and data

;intialize all varialbes


buffer db "empty buffer --- empty buffer"
buffer2 db "empty buffer --- empty buffer"

size = $ - offset buffer  ; declare constant
size2 = $ - offset buffer2  ; declare constant


start:

;to print any string we but its pointer in si
print "you shouldn't enter any message more than 4 characters" 
call newLine
print "Enter first number: "
    
    

; get the first message
lea     di, buffer      ; buffer offset.
mov     dx, size        ; buffer size.
call    get_string

call newLine


; print "Enter second number"
print "Enter second number: "

;get the second message
lea     di, buffer2      ; buffer offset.
mov     dx, size2        ; buffer size.
call    get_string
            
            
call newLine           
           
           
call encrypt


; print using macro:
print "first encrypted number: "

; print string in ds:si using procedure:
lea     si, buffer
call    print_string


call newLine
print "second encrypted number: "

; print string in ds:si using procedure:
lea     si, buffer2
call    print_string

call decrypt


call newLine
print "first decrypted number: "

; print string in ds:si using procedure:
lea     si, buffer
call    print_string

call newLine
print "second decrypted number: "

; print string in ds:si using procedure:
lea     si, buffer2
call    print_string


call newLine


; wait for any key...
mov     ax, 0
int     16h

ret

;End main program 


;next all procedure definations




;prints any string sent to it as an argument
print   macro   sdat
local   next_char, s_dcl, printed, skip_dcl
push    ax      ; store registers...
push    si      ;
jmp     skip_dcl        ; skip declaration.
        s_dcl db sdat, 0
skip_dcl:
        lea     si, s_dcl
next_char:      
        mov     al, cs:[si]
        cmp     al, 0
        jz      printed
        inc     si
        mov     ah, 0eh ; teletype function.
        int     10h
        jmp     next_char
printed:
pop     si      ; re-store registers...
pop     ax      ;
print   endm






;prints any character sent to it
; we use it in to bread line '\n'
putc    macro   char
        push    ax
        mov     al, char
        mov     ah, 0eh
        int     10h     
        pop     ax
putc    endm



newLine proc near

;print break line
putc    0Dh
putc    10 ; next line.

ret
newLine endp











; get a null terminated string from keyboard,
; write it to buffer at ds:di, maximum buffer size is set in dx.
; 'enter' stops the input.
get_string      proc    near
push    ax
push    cx
push    di
push    dx

mov     cx, 0                   ; char counter.

cmp     dx, 1                   ; buffer too small?
jbe     empty_buffer            ;

dec     dx                      ; reserve space for last zero.


;============================
; eternal loop to get
; and processes key presses:

wait_for_key:

mov     ah, 0                   ; get pressed key.
int     16h

cmp     al, 0Dh                  ; 'return' pressed?
jz      exit


cmp     al, 8                   ; 'backspace' pressed?
jne     add_to_buffer
jcxz    wait_for_key            ; nothing to remove!
dec     cx
dec     di
putc    8                       ; backspace.
putc    ' '                     ; clear position.
putc    8                       ; backspace again.
jmp     wait_for_key

add_to_buffer:

        cmp     cx, dx          ; buffer is full?
        jae     wait_for_key    ; if so wait for 'backspace' or 'return'...

        mov     [di], al
        inc     di
        inc     cx
        
        ; print the key:
        mov     ah, 0eh
        int     10h

jmp     wait_for_key
;============================

exit:

; terminate by null:
mov     [di], 0

empty_buffer:

pop     dx
pop     di
pop     cx
pop     ax
ret
get_string      endp



; print null terminated string at current cursor position,
; raddress of string in ds:si
print_string proc near
push    ax      ; store registers...
push    si      ;

next_char:      
        mov     al, [si]
        cmp     al, 0
        jz      printed
        inc     si
        mov     ah, 0eh ; teletype function.
        int     10h
        jmp     next_char
printed:

pop     si      ; re-store registers...
pop     ax      ;

ret
print_string endp















encrypt proc near

;TODO
;write the encryption code here
;use the processor registers to do operation
;notice that this process has only 16-bit registers
;so long operation should be divided into sub opearations

ret
encrypt endp

decrypt proc near

;TODO
;write the decryption code here
;use the processor registers to do operation
;notice that this process has only 16-bit registers
;so long operation should be divided into sub opearations

ret
decrypt endp