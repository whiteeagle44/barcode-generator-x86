section	.text
global _put_pixel, put_pixel

%define BYTES_PER_ROW 1800
%define BLACK 0x00000000 ;black color

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
	push edi
	push esi

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

return:
    pop esi
    pop edi
    pop ebx

	xor eax, eax		; return 0
	pop	ebp
	ret