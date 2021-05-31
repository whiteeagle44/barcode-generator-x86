section	.text
global _func, func

_func:
func:
	push ebp
	mov	ebp, esp
	push ebx
	mov	eax, DWORD [ebp+8]	;address of *a to eax

replace_loop:
	mov bl, [eax]
	cmp bl, 0
	je exit_loop
	cmp bl, 'a'
	jne increment_loop
	mov	BYTE [eax], '*'

increment_loop:
   inc eax
  jmp replace_loop

exit_loop:
	xor	eax, eax		; eax = 0
	pop ebx
	pop	ebp
	ret