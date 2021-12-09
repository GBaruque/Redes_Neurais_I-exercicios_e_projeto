%Pontificia Universidade Catolica do Rio de Janeiro
%Aula 1 - MATLAB - Disciplina: ICA
%Script para o exercicio do problema de Análise de Crédito

clear;
clc;
close all;

%Leitura dos dados
AnaliseCred = importdata('Classificacao/treino01.txt');
%Dados estao em forma de struct, entao obtemos os dados
dados = AnaliseCred.data;

%Classe é a ultima coluna, entao dividimos os Patterns do Target
P = dados(1:end,1:11)'; %Pattern
T = dados(1:end,12)';   %Target

n_hidden = [6,2]; %Quantidade de neurônios na camada escondida 

net = feedforwardnet(n_hidden); %Inicialização da Rede

%Funcao de ativacao dos neuronios
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';

%Opcoes para função de treinamento da rede
net.trainFcn = 'traingd'; 

%Alguns parametros para modificar o modelo
%Para ver todos os parâmetros que permitem em uma função de treinamento:
%help traingd (ou qualquer função de treinamento que queira)
net.trainParam.epochs = 1000; %Épocas para o treinamento do modelo
net.trainParam.goal = 0; %Erro objetivo do modelo
net.trainParam.lr = 0.1; %Taxa de aprendizado (default: 0.01)
net.trainParam.mc = 0.9; %Constante de momento (default: 0.9)
net.trainParam.show = 25; %Parametro de épocas para mostrar o resultado.
net.trainParam.showWindow = true; %Mostrar a tela de treinamento

%Divisao da base de dados, caso precise dividir entre treinamento,
%validação e teste. 

%Possiveis divisoes: dividerand, divideind, divideblock
net.divideFcn = 'dividerand';   
net.divideParam.trainRatio = 0.85;   %Proporcao para conjunto de treinamento
net.divideParam.valRatio = 0.15;    %Proporcao para conjunto de validacao
net.divideParam.testRatio = 0.15;   %Porporcao para conjunto de teste

%Para ver as funções de performance: help nnperformance
net.performFcn = 'mse'; 

%Pode ser usado para configurar previamente a rede baseado em In/Out
net = configure(net,P,T); 

%Para visualizacao da arquitetura da rede, podemos usar este comando
view(net)

%Treinamento da rede
[net, tr] = train(net,P,T);

%Simulação da rede
C = sim(net, P);
%Equivalente ao comando acima. Para visualizar se o comando é o mesmo,
%observar no Workspace se C = O.
O = net(P);

%Geraccao dos graficos de desempenho.
figure
plotperform(tr) %Curva de treinamento em funcao das epocas
figure
plotconfusion(T,O)  %Grafico da matriz de confusao

