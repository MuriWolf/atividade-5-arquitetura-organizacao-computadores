.intel_syntax noprefix
.section .data
    rows: .int 3
    cols: .int 3
    num_buffer: .space 16
    nl: .asciz "\n"
    space: .asciz " "
    msg_matrix_one: .string "Matrix A: "
    msg_matrix_two: .string "Matrix B: "
    msg_matrix_sum: .string "Sum of matrix A and B: "

    matrix_one: 
        .int 1, 2, 3
        .int 4, 5, 6
        .int 7, 8, 9

    matrix_two: 
        .int 9, 8, 7 
        .int 6, 5, 4
        .int 3, 2, 1 

.section .bss 
    matrix_sum: 
        .int 0, 0, 0 
        .int 0, 0, 0 
        .int 0, 0, 0 

.section .text
.globl _start

strlen:
    xor rax, rax      # Inicializa contador de comprimento
.strlen_loop:
    cmp BYTE PTR [rdi + rax], 0 # Compara o byte atual com NULL
    je .strlen_done             # Se for NULL, fim da string
    inc rax                     # Incrementa o comprimento
    jmp .strlen_loop            # Próximo caractere
.strlen_done:
    ret

int_to_string:
    mov rdi, OFFSET num_buffer # rdi aponta para o início do buffer
    add rdi, 15           # Move rdi para o final do buffer (para preencher de trás para frente)
    mov BYTE PTR [rdi], 0 # Coloca o terminador NULL no final

    mov r8d, 10           # Divisor para conversão decimal

    test eax, eax         # Verifica se eax é 0
    jnz .convert_loop_entry # Se não for zero, inicia o loop de conversão
    dec rdi               # Se for zero, move rdi para trás uma posição
    mov BYTE PTR [rdi], '0' # Coloca '0' no buffer
    ret                   # Retorna, rdi aponta para "0"

.convert_loop_entry:
.convert_loop:
    test eax, eax         # Verifica se o quociente (eax) é zero
    jz .convert_done      # Se for zero, a conversão terminou
    xor edx, edx          # Limpa edx para a divisão (rdx:rax / r8d)
    div r8d               # Divide eax por r8d (10). Quociente em eax, resto em edx.
    add dl, '0'           # Converte o resto (dígito) para caractere ASCII
    dec rdi               # Move o ponteiro do buffer para a esquerda
    mov BYTE PTR [rdi], dl # Armazena o dígito no buffer
    jmp .convert_loop     # Repete com o novo quociente em eax

.convert_done:
    ret                   # rdi aponta para o início da string numérica

print_cstring:
    push rdi          # Salva o endereço da string (rdi)
    call strlen       # Chama strlen, rax = tamanho da string
    pop rsi
    mov rdx, rax      # rdx = tamanho da string (argumento 3 para sys_write)
    mov rax, 1        # syscall sys_write
    mov rdi, 1        # stdout (file descriptor 1)
    syscall           # Chama o kernel (rax é modificado com o resultado da syscall)
    ret

print_matrix:
    push r13
    mov r13, rdi

    xor ebx, ebx

    # SEGMENTATION FAULT ESTA NESSAS CHAMADAS AO PRINT_CSTRING, PROVAVELMENTE RELACIONADO COM O EDI/RDI

    mov edi, OFFSET nl
    call print_cstring
    
.print_matrix_loop_rows:
    cmp ebx, [rows]
    je .end_print_matrix_loop_rows
    xor r14d, r14d

.print_matrix_loop_cols:
    cmp r14d, [cols]
    je .end_print_matrix_loop_cols

    # mov r8d, dword ptr [matrix_one + (ebx*[cols] + r14d) * 4]
    # chega até o endereço atual na matrix
    mov r12, rbx # r12 = row
    imul r12, [cols] # r12 = row * cols
    add r12, r14 # r12 = row * cols + col
    shl r12, 2 # r12 = (row * cols + col) * 4

    # chama a função de print preservando a (matriz)
    mov eax, dword ptr [r13 + r12] # pega o valor da matriz escolhida
    call int_to_string
    call print_cstring
    mov edi, OFFSET space
    call print_cstring

    inc r14d
    jmp .print_matrix_loop_cols

.end_print_matrix_loop_cols:
    mov edi, OFFSET nl
    call print_cstring

    inc ebx
    jmp .print_matrix_loop_rows

.end_print_matrix_loop_rows:
    pop r13
    ret

_start:
    xor ecx, ecx

.loop_rows:
    cmp ecx, [rows]
    je .end_loop_rows
    xor ebx, ebx

.loop_cols:
    cmp ebx, [cols]
    je .end_loop_cols

    # mov r8d, dword ptr [matrix_one + (ecx*[cols] + ebx) * 4]
    # chega até o endereço atual na matrix
    mov edx, ecx # edx = row
    imul edx, [cols] # edx = row * cols
    add edx, ebx # edx = row * cols + col
    shl edx, 2 # edx = (row * cols + col) * 4

    # pega os valores da matriz 1 e matriz 2
    mov r8d, dword ptr [matrix_one + rdx] 
    mov r9d, dword ptr [matrix_two + rdx] 

    # soma o valor da matriz 1 com a matriz 2
    mov eax, r8d
    add eax, r9d

    # poem a soma na matrix_sum
    mov dword ptr [matrix_sum + rdx], eax

    inc ebx
    jmp .loop_cols

.end_loop_cols:
    inc ecx
    jmp .loop_rows

.end_loop_rows:

    mov edi, OFFSET nl
    call print_cstring
    mov rdi, OFFSET msg_matrix_one
    call print_cstring
    lea rdi, [matrix_one]
    call print_matrix

    mov edi, OFFSET nl
    call print_cstring
    mov rdi, OFFSET msg_matrix_two
    call print_cstring
    lea rdi, [matrix_two]
    call print_matrix

    mov edi, OFFSET nl
    call print_cstring
    mov rdi, OFFSET msg_matrix_sum
    call print_cstring
    lea rdi, [matrix_sum]
    call print_matrix

    jmp .end

.end:
    mov rax, 60
    xor rdi, rdi
    syscall
