## Desafio de Programação: Implementação Dual C++/Assembly
### Instruções Gerais
Nesta atividade, você deverá implementar dois algoritmos diferentes em ambas as linguagens: C++ e Assembly x86/x64. O objetivo é comparar diferentes abordagens de programação e compreender como operações de baixo nível funcionam em ambientes distintos.
Entregáveis

## Exercícios
### Exercício 1: Análise de String
Escreva um programa que analise uma string pré-definida. O programa deve contar e exibir o número de:

Vogais (maiúsculas ou minúsculas: a, e, i, o, u, A, E, I, O, U)
Consoantes (outras letras do alfabeto)
Dígitos (0-9)
Espaços em branco

### Exercício 2: Soma de Matrizes
Implemente um programa que realize a soma de duas matrizes 3x3 de números inteiros. O programa deve:

Inicializar duas matrizes 3x3 com valores pré-definidos
Calcular a matriz resultante somando os elementos correspondentes
Exibir as duas matrizes originais e a matriz resultante

## Debug com gdb

```
gdb ./arquivo

break _start     // adiciona breakpoint

run

layout asm      // adiciona visualização do assembly 

layout split   // divide os layouts da tela (para caber o regs)

layout regs    // adiciona visualização dos registradores

si            // avança no assembly, ENTER pode ser usado depois do primiero 'si'
```

## Algumas lições aprendidas

* Gdb é muito útil para debugar assembly;
* Syscalls podem modificar registradores voláteis (ex: rcx). O que pode resultar em segmentation fault e muita DOR DE CABEÇA. Ou seja, não confiar muito em registradores voláteis, podem estar sendo "implicitamente" modificados.

## Links úteis usados
* https://cs.brown.edu/courses/cs033/docs/guides/gdb.pdf
* https://en.wikipedia.org/wiki/X86_instruction_listings
* https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
* https://www.cs.uaf.edu/2017/fall/cs301/lecture/09_11_registers.html
* https://faydoc.tripod.com/cpu/je.htm
* https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
* https://gil0mendes.gitbooks.io/assembly/content/index.html
* https://stackoverflow.com/questions/54536362/what-is-the-idea-behind-32-that-converts-lowercase-letters-to-upper-and-vice
* https://stackoverflow.com/questions/15995696/how-to-create-nested-loops-in-x86-assembly-language
* https://stackoverflow.com/questions/4584089/what-is-the-function-of-the-push-pop-instructions-used-on-registers-in-x86-ass
* https://stackoverflow.com/questions/47783926/why-are-loops-always-compiled-into-do-while-style-tail-jump
* https://stackoverflow.com/questions/31824441/how-can-i-check-if-a-character-is-a-letter-in-assembly
