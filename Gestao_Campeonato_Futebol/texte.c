Esse projecto de como objectivo, simular a gestão de um campeonato de futebol e pôr em prática os 
conceitos aprendidos (OOP + Collections + Stream + Optional)
1- Crie a classe Jogador descrita abaixo:
a) Atributos: id, nome, apelido, dataNascimento, numero, posição, qualidade, cartões, suspenso, 
b) Criar um método cadastrar, que permite criar uma equipa com 11 jogadores. 
c) Criar um método que verifica a condição de jogo, ou seja, um método booleano que retornará true 
se o jogador está apto a jogar e false se o jogador está suspenso. Note que um jogador está 
suspenso pelo 3 cartão amarelo ou quando recebe uma punição cartão vermelho ou em uma 
decisão do tribunal. 
d) Criar um método que permite imprimir o “plantel” juntamente com a informação de quem está apto
a jogar, conforme a figura abaixo. Projecto de Frequência
Objectivo:
Esse projecto de como objectivo, simular a gestão de um campeonato de futebol e pôr em prática os 
conceitos aprendidos (OOP + Collections + Stream + Optional)
1- Crie a classe Jogador descrita abaixo:
a) Atributos: id, nome, apelido, dataNascimento, numero, posição, qualidade, cartões, suspenso, 
b) Criar um método cadastrar, que permite criar uma equipa com 11 jogadores. 
c) Criar um método que verifica a condição de jogo, ou seja, um método booleano que retornará true 
se o jogador está apto a jogar e false se o jogador está suspenso. Note que um jogador está 
suspenso pelo 3 cartão amarelo ou quando recebe uma punição cartão vermelho ou em uma 
decisão do tribunal. 
d) Criar um método que permite imprimir o “plantel” juntamente com a informação de quem está apto
a jogar, conforme a figura abaixo. Projecto de Frequência
Objectivo:
Esse projecto de como objectivo, simular a gestão de um campeonato de futebol e pôr em prática os 
conceitos aprendidos (OOP + Collections + Stream + Optional)
1- Crie a classe Jogador descrita abaixo:
a) Atributos: id, nome, apelido, dataNascimento, numero, posição, qualidade, cartões, suspenso, 
b) Criar um método cadastrar, que permite criar uma equipa com 11 jogadores. 
c) Criar um método que verifica a condição de jogo, ou seja, um método booleano que retornará true 
se o jogador está apto a jogar e false se o jogador está suspenso. Note que um jogador está 
suspenso pelo 3 cartão amarelo ou quando recebe uma punição cartão vermelho ou em uma 
decisão do tribunal. 
d) Criar um método que permite imprimir o “plantel” juntamente com a informação de quem está apto
a jogar, conforme a figura abaixo. Projecto de Frequência
Objectivo:
Esse projecto de como objectivo, simular a gestão de um campeonato de futebol e pôr em prática os 
conceitos aprendidos (OOP + Collections + Stream + Optional)
1- Crie a classe Jogador descrita abaixo:
a) Atributos: id, nome, apelido, dataNascimento, numero, posição, qualidade, cartões, suspenso, 
b) Criar um método cadastrar, que permite criar uma equipa com 11 jogadores. 
c) Criar um método que verifica a condição de jogo, ou seja, um método booleano que retornará true 
se o jogador está apto a jogar e false se o jogador está suspenso. Note que um jogador está 
suspenso pelo 3 cartão amarelo ou quando recebe uma punição cartão vermelho ou em uma 
decisão do tribunal. 
d) Criar um método que permite imprimir o “plantel” juntamente com a informação de quem está apto
a jogar, conforme a figura abaixo.  Jogadores Cadastrados: Goleiro 1- Marcelo (Tricolor) - 13/Janeiro/1987 -Condicao suspenso;  Lateral direito 2- Hermes (Hermes) - 01/Fevereiro/1995 -Condicao: ta pra jogo. e) Crie novos métodos na classe Jogador: 
 aplicarCartao(int quantidade): void - Aplica a quantidade de cartões informada ao 
jogador, adicionalmente pode tornar um jogador suspenso. 
 cumprirSuspencao(): void – Esse método vai zerar a quantidade de cartões e tornar o 
jogador apto a jogar 
 sofrerLesao(): void – Este método vai gerar aleatoriamente uma lesão no jogador.
A gravidade da lesão irá se refletir em uma redução da qualidade do jogador, quanto 
mais grave maior a redução da qualidade. Crie uma escala de redução de no 
mínimo 1 ponto até o máximo de 15% da qualidade total do jogador. Note que a 
qualidade jamais pode ficar negativa. A tabela abaixo pode ser utilizada como 
referência:

Probabilidade       Qualidade decrementada            

5%                      15 % do toatal da qualidade
10%                     10 % do toatal da qualidade      
15%                     5 % do toatal da qualidade  
30%                     2 pontos    
40%                     1 ponto

executarTreinamento(): void – A exemplo do método anterior, este método 
aleatoriamente vai aumentar a qualidade do jogador. Note que só pode ser 
executado 1 treinamento antes de cada partida (você deve adicionar um 
atributo na classe para poder controlar essa informação). Além disso, deve 
existir uma maior probabilidade para pequenos incrementos na qualidade 
conforme a seguinte tabela:

Probabilidade       Qualidade icrementada            

5%                      5 pontos
10%                     4 pontos     
15%                     3 pontos  
30%                     2 pontos    
40%                     1 ponto

Observe que a qualidade nunca pode superar o máximo de 100 pontos. Além 
disso, você deverá adicionar mais um atributo na classe jogador para poder 
controlar os jogadores que já efetuaram o treinamento e que só poderão treinar 
após o próximo jogo. 
2 - Crie uma nova classe chamada Equipa conforme abaixo: 
a) Atributos: nome, apelido, fundacao, plantel: ArrayList<Jogador>, relacionados: 
ArrayList<Jogador> , Equipa() , Equipa (all attrs), relacionarJogadores(): ArrayList<Jogador>
b) Cadastrar/Instanciar pelo menos 2 equipas e em cada equipa pelo menos 23 jogadores. 
c) Cria o método relacionarJogadores. Este método irá selecionar os 18 jogadores, 11 
titulares(os 11 jogadores com a maior qualidade devem ser relacionados) e 7 reservas 
ordenados pela qualidade. Ou seja, os 11 titulares devem estar alocados nas primeiras 
posições do array e as 7 reservas nas últimas posições do array. Não devem apenas olhar 
para qualidade dos jogadores, mas também a sua posição, assim os 18 relacionados devem 
ser os melhores em sua posição, mas não necessariamente os jogadores com as maiores 
qualidades no elenco.
d) Cria o método relacionarJogadores. Este método irá selecionar os 11 melhores jogadores de 
acordo com a qualidade (os 11 jogadores com a maior qualidade devem ser relacionados). 
e) Crie um método que imprima as escalações de ambos os times/equipas e mostre também os 
jogadores titulares e os jogadores que compõem o banco de reservas.
3 - Crie a classe Jogo conforme o diagrama abaixo: 
Jogo 
a) Abributos: mandante: Time, visitante: Time, dataDoJogo: Date, estadio: String, cidade: String, 
placarMandante: Integer, placarVisitante: Integer, Jogo() , Jogo(all atribs), gerarResultado(): void , 
gerarLesoes(): void gerarCartoes(): void, permitirTreinamento(): void 
b) O método gerarResultado deve criar um resultado aleatório considerando o total da
qualidade dos titulares. Isso quer dizer que quanto maior o somatório da qualidade dos 
jogadores titulares maior será a probabilidade da equipa ganhar. Por exemplo, o somatório 
da qualidade dos jogadores titulares da equipe A é 584, enquanto que o somatório da 
qualidade dos jogadores titulares da equipe B é 723. Considere esses valores no momento 
de definir o resultado e o ganhador do confronto. Pode utilizar tanto uma clusterização, por 
exemplo, 50% de vitória para o time/equipa com maior qualidade, 30% de vitória para o 
time com menor qualidade e 20% para dar empate. 
c) O método gerarLesoes deve gerar aleatoriamente de 0 até duas lesões (independente do 
time) por jogo. O jogador que sofre a lesão também deve ser escolhido aleatoriamente. 
d) O método gerarCartoes deve gerar aleatoriamente de 0 até 10 cartões por jogo 
(independente do time). O jogador que recebe o cartão deve ser escolhido aleatoriamente.
Verifique se o mesmo jogador é escolhido duas vezes, neste caso, ele deve ser expulso do 
jogo alterando as probabilidades de vitória de cada time. Além disso, ele deve ficar 
suspenso da próxima partida
e) O método permitirTreinamento após a conclusão do jogo deve possibilitar que os 
jogadores possam realizar outro treinamento.