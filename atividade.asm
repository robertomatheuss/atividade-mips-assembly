.data
   quebraLinha: .asciiz "\n"
   
   #Mensagem para alternativas 
      escolhaFahrenheit: .asciiz "1 - Fahrenheit => Celsius\n"
      escolhaFibonnacci: .asciiz "2 - Fibonnacci\n"
      escolhaEnesimoPar: .asciiz "3 - Enesimo par\n"
      escolhaSaida: .asciiz "4 - Saida\n"
      escolha: .asciiz "Escolha sua atividade: "  
   
   #Constantes para atividade de Fahrenheit
      inicioFahrenheit: .asciiz "Digite um valor em Celsius: "
      apresentaResultadoFahrenheit: .asciiz "O valor em Fahrenheit é: "
      #Constante para usar no calculo de Fahrenheit 
      umPontoOito: .float 1.8
      trintaEDois: .float 32.0
      
   #Constantes para atividade de Fibonnacci
      inicioFibonnacci: .asciiz "Informe um N para o enésimo termo: "
      apresentaResultadoFibonnacci: .asciiz "O enesimo termo da sequencia de Fibonacci é: "
   
   #Constantes para enesimo par
      inicioPar: .asciiz "Informe um N para o enesimo par: "
      apresentaResultadoPar: .asciiz "O enesimo termo par de N é: "

.text 
   main:
      while:
	 jal printAlternativa       # Chama função para aprensentar alternativas
	 continua:                  # Eu fiz esse label pq usando o retorno de função estava dando erro
	 
	 la $a0, escolha            # Apresenta constante "escolha"
	 jal printString
	 
	 la $v0,5                   # Pega valor da escolha e armazena em $v0
	 syscall 
         
         beq $v0, 1 , fahrenheit    # Compara o $v0 com o valor 1 se é igual ele executa a função fahrenheit
	 beq $v0, 2 , fibonnacci    # Compara o $v0 com o valor 2 se é igual ele executa a função fibonnacci
	 beq $v0, 3 enesimoPar      # Compara o $v0 com o valor 3 se é igual ele executa a função enesimoPar
	 beq $v0, 4 saida	    # Compara o $v0 com o valor 4 se é igual ele executa a função saida
         j while
         
   printAlternativa:                # Função para apresentar alternativas 
      la $a0,escolhaFahrenheit
      jal printString
      
      la $a0,escolhaFibonnacci
      jal printString
      
      la $a0,escolhaEnesimoPar
      jal printString
      
      la $a0,escolhaSaida
      jal printString

      j continua                    # Usando o retorno ele não retornava para a função ele ficava parado
   
   quebraLinhaFunction:             # Função para quebrar linha 
      la $a0,quebraLinha
      li $v0, 4
      syscall
      jr $ra
   
   printString:                     # Apresenta a escolha do registrador $a0
      li $v0, 4
      syscall
      jr $ra   
      
   fahrenheit:                      # Função para executar a questão do fahrenheit
      la $a0,inicioFahrenheit
      jal printString
      
      li $v0,6                      # Input para float valor vai para $f0
      syscall
      
      lwc1 $f1, umPontoOito         # Pega o numero da memoria "1.8"
      lwc1 $f2 trintaEDois          # Pega o numero da memoria "32.0"
      
      mul.s $f3, $f1, $f0           # Multiplica o input com 1.8
      add.s $f12, $f2 ,$f3          # O resultado da multiplicação soma com 32
     
      la $a0,apresentaResultadoFahrenheit
      jal printString  
      li $v0,2                      # Print o resultado do argumento $f12
      syscall
      jal quebraLinhaFunction
      j while
      
   fibonnacci:                      # Função para executar a questão da fibonnacci
      la $a0, inicioFibonnacci      # Solicitar o valor de N ao usuário
      jal printString               # Função para print o argumento $a0
      
      li $v0, 5                     # Ler um inteiro que armazena o retorno em $v0
      syscall
      move $t0, $v0                 # Copia o valor de N em $t0
         
      la $a0,apresentaResultadoFibonnacci
      jal printString
         
      beq $t0, 1, printResultEqual1 # Se N for 1, exibir diretamente o resultado
      
      li $t1, 0                     # Para começar o looping a parti do segundo elemento pois os dois primeiros foram eliminados 
      li $t2, 1                     # E o segundo começa com essa conta "0+1"

      li $t3, 2                     # Contador começa em 2
      whileFibonnacci:              # Para fazer a fibonnacci eu usei a sequencia começando do 1: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55...

         add $t4, $t1, $t2          # F(i) = F(i-1) + F(i-2)
         beq $t3, $t0, FinalFibonnacci   # Se i == N, termine o loop
         move $t1, $t2              # F(i-2) = F(i-1)    
         move $t2, $t4              # F(i-1) = F(i)
         addi $t3, $t3, 1           # Incrementar contador
         j whileFibonnacci          # Repetir o loop
      FinalFibonnacci:    
      	 move $a0, $t4              # Resultado final em $t4
      	 li $v0, 1                  # Syscall para imprimir inteiro
         syscall
         jal quebraLinhaFunction
         j while
        
   printResultEqual1:
      li $a0, 1                     # Carrega o $a0 com valor 1
      li $v0, 1                     # Chama a função print_int
      syscall
      jal quebraLinhaFunction
      j while
   
   enesimoPar:                      # Função para executar a questão da fibonnacci
      la $a0, inicioPar             # Carrega constante
      jal printString               # Função para print o argumento $a0
     
       li $v0, 5                    # Ler um inteiro que armazena o retorno em $v0
      syscall
      move $t0, $v0                 # Armazenar o valor de N em $t0
      
      mul $t2,$t0,2                 # Multiplica o N por 2
      
      la $a0,apresentaResultadoPar
      jal printString
      	 
       move $a0, $t2                # Resultado final em $t2
      li $v0, 1                     # Syscall para imprimir inteiro
      syscall
      jal quebraLinhaFunction
      j while
      
   saida:
      li $v0,10
      syscall
      jr $ra