.intel_syntax noprefix
.section .data
    text: .string "My name is Ozymandias, king of kings 60"
    text_len: .int 39
    vowels: .int 97, 101, 105, 111, 117
    vowels_len: .int 5
    num_buffer: .space 16

    # mensagens 
    msg_spaces: .string "Spaces: "
    msg_consonants: .string "Consonants: "
    msg_vowels: .string "Vowels: "
    msg_numbers: .string "Numbers: "
    newline: .ascii "\n"
    newline_len: .int 1

.section .bss
    spaces_count: .int 0
    vowels_count: .int 0
    consonants_count: .int 0
    numbers_count: .int 0

.section .text
.globl _start

verify_is_number:
    movzx eax, byte ptr[rsi]
    test eax, eax 
    jz .end_verify_is_number

    # se nao for maior que 9 nem menor que 0, é um número
    cmp al, '0'
    jb .non_number

    cmp al, '9'
    ja .non_number

    # retorna 1 se positvo
    mov eax, 1
    jmp .end_verify_is_number

    # retorna 0 se negativo
    .non_number:
        mov eax, 0

    .end_verify_is_number:
        ret

verify_is_alphabetic:
    # verifica se há caracter
    movzx eax, byte ptr[rsi]
    test eax, eax 
    jz .end_verify_is_alphabetic

    # logica de verificação
    or al, 0x20
    sub al, 'a'
    cmp al, 'z'-'a'
    ja .non_aphabetic

    # 1 caso seja alfabético
    mov eax, 1
    jmp .end_verify_is_alphabetic

    # 0 caso não
    .non_aphabetic:
        mov eax, 0

    .end_verify_is_alphabetic: 
        ret

verify_is_vowel:
    xor edx, edx # iniciar registrador contador como zero
    movzx eax, byte ptr[rsi]
    test eax, eax
    jz .end_verify_is_vowel

    .loop_verify_vowel:
        # compara o valor do array de vogais com o caracter
        lea r8d, [vowels + edx*4]
        or eax, 0x20
        cmp eax, [r8d]
        jnz .non_vowel

        mov eax, 1
        jmp .end_verify_is_vowel

    .non_vowel:
        # verifica se ainda há vogais para comparar
        inc edx
        cmp edx, [vowels_len]
        jl .loop_verify_vowel

        # se nao, retornar 0
        mov eax, 0

    .end_verify_is_vowel:
        ret

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
    pop rsi           # Restaura o endereço da string para rsi (argumento 2 para sys_write)
    mov rdx, rax      # rdx = tamanho da string (argumento 3 para sys_write)
    mov rax, 1        # syscall sys_write
    mov rdi, 1        # stdout (file descriptor 1)
    syscall           # Chama o kernel (rax é modificado com o resultado da syscall)
    ret

_start:
    xor ecx, ecx # iniciar registrador contador como zero
    lea rbx, [text] # character holder

    .loop_verify_text:
        lea rsi, [rbx + rcx] # pega char do text

        mov r9b, byte ptr [rsi]
        cmp r9b, 0
        je .print_results

        jmp .is_space

    .is_space:
        # 0x20 representa o espaço
        cmp r9b, 0x20
        jnz .is_char
        add dword ptr [spaces_count], 1
        jmp .next_char

    .is_char:
        # caso a função retorne 1, pode continuar pois é um char, do contráro, verificar se é um number
        call verify_is_alphabetic
        cmp eax, 1
        jnz .is_number

        # caso a funcao retorne 1, é vowel
        call verify_is_vowel
        cmp eax, 1
        jnz .is_not_vowel

        add dword ptr [vowels_count], 1
        jmp .next_char

    .is_not_vowel:
        add dword ptr [consonants_count], 1
        jmp .next_char

    .is_number:
        # caso a funcao retorne 1, é number, se nao, apenas vai para o proximo caracter (pois especiais não estão sendo considerados)
        call verify_is_number 
        cmp eax, 1
        jnz .next_char 

        add dword ptr [numbers_count], 1
        jmp .next_char

    .next_char:
        inc ecx # i++
        jmp .loop_verify_text

    .print_results:
        # print spaces
        mov rdi, OFFSET msg_spaces
        call print_cstring
        mov eax, [spaces_count]
        call int_to_string
        call print_cstring
        mov edi, OFFSET newline
        call print_cstring

        # print consonants
        mov rdi, OFFSET msg_consonants
        call print_cstring
        mov eax, [consonants_count]
        call int_to_string
        call print_cstring
        mov edi, OFFSET newline
        call print_cstring

        # print vowels
        mov rdi, OFFSET msg_vowels
        call print_cstring
        mov eax, [vowels_count]
        call int_to_string
        call print_cstring
        mov edi, OFFSET newline
        call print_cstring

        # print numbers
        mov rdi, OFFSET msg_numbers
        call print_cstring
        mov eax, [numbers_count]
        call int_to_string
        call print_cstring
        mov edi, OFFSET newline
        call print_cstring
    
    .end:
        mov rax, 60
        xor rdi, rdi
        syscall

        pop rbx
        mov rsp, rbp
        ret
