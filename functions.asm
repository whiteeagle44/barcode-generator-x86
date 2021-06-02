global _put_pixel, put_pixel
global _put_thin_bar, put_thin_bar

section	.text

; used by put_pixel
%define BYTES_PER_ROW 1800
%define BLACK 0x00000000 ;black color

;used by put_thin_bar
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

    inc ecx
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
