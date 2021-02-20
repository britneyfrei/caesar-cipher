	.intel_syntax noprefix
	.data

	.text
	.global main

main:
	mov rdi, [rsi + 8]		# rdi = first argument
    	mov r15, [rsi + 16]		# r15 = second argument/rotation value
	movzx r13, BYTE PTR [r15]	# r13 = first char of rot value
	call neg_check			# call neg_check function
	mov r12, 0			# r12 = 0
	sub r13, 48			# r13 = actual decimal value rather than ascii char
	add r12, r13			# r12 = r13
	add r15, 1			# advance character pointer
	movzx r13, BYTE PTR [r15]	# r13 = next char of rot value
	cmp r13, 0			# check if r13 is 0/null
	je printstr			# if so, jump to printstr function
	jmp double_digits		# otherwise, jump to double_digits function
	ret

neg_check:
	cmp r13, '-'			# check if first char of rot value is a '-'
	je .neg_dash			# if so, jump to .neg_dash function
	ret

.neg_dash:
	mov r11, 0
	add r11, r13			# r11 = '-'
	add r15, 1			# advance character pointer
	movzx r13, BYTE PTR [r15]	# r13 = next char of rot value
	ret

double_digits:				# rot value is 2 digits
	mov rax, 10			# rax = 10
	mov rcx, 0			# rcx = 0
	add rcx, r12			# rcx = r12 = 1 or 2
	mul rcx				# rax = rax * rcx
	mov r12, rax			# r12 = rax = first digit * 10
	sub r13, 48			# r13 = decimal value/second digit
	add r12, r13			# r12 = (first digit * 10) + second digit
	jmp printstr			# jump to printstr function

rot:
	call neg_check2			# call neg_check2 function
	add rdi, r12			# rotate the value by the rot value
	call bound_check		# call bound_check function
	jmp printstr_loop		# jump to printstr_loop function

neg_check2:		
	cmp r11, '-'			# check if r11 = '-'
	je .neg_negate			# if so, jump to .neg_negate function
	ret

.neg_negate:
	neg r12				# r12 = -r12
	ret

bound_check:				
	cmp rdi, 'a'			# check if rdi is less than 'a'/97
	jl .add				# if so, jump to .add function
	cmp rdi, 'z'			# otherwise, check if rdi is greater than 'z'/122
	jg .sub				# if so, jump to .sub function
	ret

.add:
	add rdi, 26			# rdi = rdi + 26
	ret

.sub:
	sub rdi, 26			# rdi = rdi - 26
	ret

printstr:
	mov rbx, rdi			# rbx = rdi			
	jmp .printstr_check		# jump to .printstr_check function

printstr_loop:
	call putchar@PLT
	add rbx, 1

.printstr_check:
	movzx rdi, byte ptr [rbx]	# rdi = first char of rbx/first argument
	cmp rdi, 0			# check if rdi is null
	jne rot				# if not, jump to rot function
	mov rdi, '\n'			# otherwise, rdi = '\n'
	call putchar@PLT		# call putchar function to print newline
	mov rax, 0			# rax = 0
	ret
