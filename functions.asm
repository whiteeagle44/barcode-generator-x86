global _put_pixel, put_pixel
global _put_thin_bar, put_thin_bar
global _put_thick_bar, put_thick_bar
global _put_char, put_char

section .data
;used by put_char
    arr1 db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '-', '.',' ', '$', '/', '+', '%', '*'
    arr2 dw 0x34, 0x121, 0x61, 0x160, 0x31, 0x130, 0x70, 0x25,  0x124, 0x64, 0x109, 0x49, 0x148, 0x19, 0x118, 0x58, 0xD, 0x10C, 0x4C, 0x1C, 0x103, 0x43, 0x142, 0x13, 0x112, 0x52, 0x7, 0x106, 0x46, 0x16, 0x181, 0xC1, 0x1C0, 0x91, 0x190, 0xD0, 0x85, 0x184, 0xC4, 0xA8, 0xA2, 0x8A, 0x2A, 0x94

section	.text
; used by put_pixel
%define BYTES_PER_ROW 1800
%define BLACK 0x00000000 ;black color

; used by put_thin_bar
%define STARTING_Y 15 ; starting y coordinate of the bar

%macro call_put_pixel 0
    push edx
    push esi
    push ecx
    push ebx
    call put_pixel
    add esp, 4
    pop ecx
    add esp, 4
    pop edx
%endmacro

; used by put_thick_bar
%macro call_put_thin_bar 0
    push edx
    push ecx
    push ebx
    call put_thin_bar
    add esp, 4
    pop ecx
    pop edx
%endmacro


; int put_pixel(char* pixels, int x, int y);
; sets the color of specified pixel to black
; arguments:
;	char* pixels - address of pixel array
;   int x - x coordinate
;   int y - y coordinate - (0,0) - bottom left corner
; return value: 0
_put_pixel:
put_pixel:
	push ebp
	mov	ebp, esp
	push ebx

	mov eax, DWORD[ebp+8]  ; eax = char* pixels
	mov ebx, DWORD[ebp+12] ; ebx = int x
	mov ecx, DWORD[ebp+16] ; ecx = int y

    ; we need to find address: pixels + 3x + y * BYTES_PER_ROW
    imul ecx, ecx, BYTES_PER_ROW ; ecx = y * BYTES_PER_ROW
    mov edx, ebx           ; edx = x
    shl ebx, 1             ; ebx = 2x
    add ebx, edx           ; ebx = 3x
    add ebx, ecx           ; ebx = 3x + y * BYTES_PER_ROW
    add eax, ebx           ; eax = pixels + 3x + y * BYTES_PER_ROW

    ;now put black color into the address found (one pixel is 3 bytes)
    mov BYTE[eax], BLACK ; load byte BLACK at address in eax
    add eax, 1
    mov BYTE[eax], BLACK
    add eax, 1
    mov BYTE[eax], BLACK

    pop ebx
	xor eax, eax		; return value: 0
	pop	ebp
	ret


; int put_thin_bar(char* pixels, int x, int width);
; puts thin bar
; arguments:
;	char* pixels - address of pixel array
;   int x - x coordinate
;   int width - width in pixels of narrowest bar
; return value: x coordinate of the next character
_put_thin_bar:
put_thin_bar:
	push ebp
	mov	ebp, esp
	push ebx
	push esi

	mov ebx, DWORD[ebp+8]  ; ebx = char* pixels
	mov ecx, DWORD[ebp+12] ; ecx = int x
	mov edx, DWORD[ebp+16] ; edx = int width
	mov esi, STARTING_Y

put_bar:
    call_put_pixel ; put_pixel(ebx, ecx, esi)
    inc esi                 ; y++
    cmp esi, 35
    jle put_bar    ; while y <= 35, put pixel

    inc ecx
    dec edx
    cmp edx, 0
    mov esi, STARTING_Y
    jnz put_bar    ; while width left != 0, put bar

    pop esi
    pop ebx
	mov eax, ecx	    ; return value: x
	pop	ebp
	ret

; int put_thick_bar(char* pixels, int x, int width);
; puts thick bar
; arguments:
;	char* pixels - address of pixel array
;   int x - x coordinate
;   int width - width in pixels of narrowest bar
; return value: x coordinate of the next character
_put_thick_bar:
put_thick_bar:
	push ebp
	mov	ebp, esp
	push ebx
	push esi

	mov ebx, DWORD[ebp+8]  ; ebx = char* pixels
	mov ecx, DWORD[ebp+12] ; ecx = int x
	mov edx, DWORD[ebp+16] ; edx = int width
	mov esi, STARTING_Y

    call_put_thin_bar ; put_thin_bar(ebx, ecx, edx)
    mov ecx, eax
    call_put_thin_bar

    pop esi
    pop ebx
	pop	ebp
	ret               ; return value: x

; int put_char(char* pixels, int x, int width, char character);
; puts bars and spaces unique to a given character
; arguments:
;	char* pixels - address of pixel array
;   int x - x coordinate
;   int width  - width in pixels of narrowest bar
;   char character - character to put
; return value: x coordinate of the next character
_put_char:
put_char:

	push ebp
	mov	ebp, esp
	push ebx
	push esi
	push edi

;	mov ebx, DWORD[ebp+8]  ; ebx = char* pixels
;	mov ecx, DWORD[ebp+12] ; ecx = int x
;	mov edx, DWORD[ebp+16] ; edx = int width
;	mov esi, DWORD[ebp+20] ; esi = character
    mov al,  BYTE[ebp+20] ; al = character

    mov esi, arr1
    mov edi, arr2

ch_look:
    mov bl, [esi]     ; load character from array
    cmp bl, al
    je ch_found

    cmp bl, '*'
    je  ch_not_found

    inc esi           ; didn't find the character in the array yet, keep looking
    add edi, 2        ; increase the other pointer's address as well
    jmp ch_look

ch_not_found:
    ; not found, incorrect character
    mov eax, -1       ; return -1 - character not supported
    jmp return

ch_found:
    ; character found, pointers esi and edi set to the character and sequence of bits respectively
    mov bx, 0x100     ; binary 100000000 (9-bit)
    mov cx, [edi]

ch_found2:
    mov dx, cx        ; we need cx later, so we'll work on a copy
    and dx, bx        ; dx = bx AND cx
    cmp dx, bx
    je  draw_thick_bar

    push ecx
    push edx
    push DWORD[ebp+16] ;   int width - width in pixels of narrowest bar
    push DWORD[ebp+12] ;   int x - x coordinate
    push DWORD[ebp+8]  ;   char* pixels - address of pixel array
    call put_thin_bar  ;   put_thin_bar(pixels, x, width)
    add  esp, 12
    pop  edx
    pop  ecx
    mov DWORD[ebp+12], eax

    jmp  space

draw_thick_bar:
    push ecx
    push edx
    push DWORD[ebp+16] ;   int width - width in pixels of narrowest bar
    push DWORD[ebp+12] ;   int x - x coordinate
    push DWORD[ebp+8]  ;   char* pixels - address of pixel array
    call put_thick_bar ;   put_thick_bar(pixels, x, width)
    add  esp, 12
    pop edx
    pop ecx
    mov DWORD[ebp+12], eax

space:
    shr bx, 1
    cmp bx, 0
    je  return_value

    mov dx, cx        ; we need cx later, so we'll work on a copy
    and dx, bx        ; dx = bx AND cx
    cmp dx, bx
    je  draw_thick_space
    ; draw thin space:
    shr bx, 1
    mov esi, DWORD[ebp+16] ; width
    add DWORD[ebp+12], esi ; x = x + width
    jmp ch_found2

draw_thick_space:
    shr bx, 1
    mov esi, DWORD[ebp+16] ; width
    imul esi, esi, 2             ; 2 * width
    add DWORD[ebp+12], esi ; x = x + 2 * width
    jmp ch_found2

return_value:
    ; set the proper return value
    mov eax, 0
    add eax, DWORD[ebp+12]
    add eax, DWORD[ebp+16]

return:
    pop edi
    pop esi
    pop ebx
	pop	ebp
	ret