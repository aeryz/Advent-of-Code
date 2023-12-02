

[bits 64]

file_load_va: equ 4096 * 40

db 0x7f, 'E', 'L', 'F'
db 2
db 1
db 1
db 0
dq 0
dw 2
dw 0x3e
dd 1
dq _start + file_load_va
dq program_headers_start
; Section header offset. We don't have any sections, so set it to 0 for now.
dq 0
dd 0
dw 64
dw 0x38
dw 1
; Size of a section header entry.
dw 0x40
; Number of section header entries. Now 0, since we don't have them.
dw 0
; The section containing section names. Not used anymore, so set to 0.
dw 0

program_headers_start:
dd 1
dd 5
dq 0
dq file_load_va
dq file_load_va
; We'll change our single program header to include the entire file.
dq file_end
dq file_end
dq 0x200000


_start:
	mov rdi, file_load_va + parsing
	mov rsi, parsing_len
	call print_str

	mov rdi, file_load_va + input_str
	xor rax, rax
	push rax
.loop:
	call parse_line
	; 1 2 in rax
	mov rdi, rax
	call calculate_value
	pop rcx
	add rcx, rax
	push rcx 
	mov rcx, 10 << 16
	mov rax, rdi
	add rax, rcx
	push rax
	mov rdi, rsp
	mov rsi, 3
        call print_str
	pop rax
	mov rdi, rbx
	inc rdi

	mov rax, file_load_va + input_str
	add rax, input_len
	cmp rax, rdi
	jg .loop
	pop rdi
	call print_int
	call exit

calculate_value:
	push rbx
	mov rbx, rdi
	xor rax, rax
	mov al, bh
	sub rax, 48
	xor rcx, rcx
	mov cl, bl
	sub cl, 48
	imul rcx, rcx, 10
	add rax, rcx
	pop rbx
	ret

parse_line:
	call forward_search
	push rax
.loop:
	cmp BYTE [rdi], 10
	je .newline	
	inc rdi
	jmp .loop
.newline:
	push rdi
	mov rax, rdi
	call backwards_search
	pop rbx

	shl rax, 8
	mov al, BYTE [rsp] 
	pop rcx
	ret

forward_search:
	xor rax, rax
	dec rdi
.loop:
	inc rdi
	mov al, BYTE [rdi]
	cmp al, 48 ; '0'
	jl .loop
	cmp al, 57
	jg .loop
	ret

backwards_search:
	xor rax, rax
	inc rdi
.loop:
	dec rdi
	mov al, BYTE [rdi]
	cmp al, 48 ; '0'
	jl .loop
	cmp al, 57
	jg .loop
	ret
	
print_str:
	mov rdx, rsi
	mov rsi, rdi
	mov rax, 1
	mov rdi, 1
	syscall
	ret

print_int:
	mov rbx, rdi
	mov rdi, 10
	mov rcx, 1
	push 10
.loop:
	cmp rbx, 0
	jne .cont
	jmp .done
.cont:
	inc rcx
	mov rax, rbx
	xor rdx, rdx
	div rdi
	mov rbx, rax
	add rdx, 48
	pop rax
	shl rax, 8
	mov al, dl
	push rax
	jmp .loop
.done:
	push rcx
	mov rdi, file_load_va + calibration
	mov rsi, calibration_len
	call print_str
	pop rcx
	mov rdi, rsp
	mov rsi, rcx
	call print_str
exit:
	mov rax, 60
	mov rdi, 1
	syscall
code_end:

input_str db "1abc2", 0xa, "pqr3stu8vw", 0xa , "a1b2c3d4e5f", 0xa, "treb7uchet", 0xa
input_len equ  $ - input_str
parsing db "Calculating values..", 0xa
parsing_len equ  $ - parsing
calibration db "Sum of the calibration values:", 0xa
calibration_len equ  $ - calibration


file_end:
