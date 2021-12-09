%Pontificia Universidade Catolica do Rio de Janeiro
%Aula 1 - MATLAB - Disciplina: ICA
%Script para o exercicio do problema OU exclusivo

clear;
clc;
close all;

%%Dados do Perceptron
P = [0 1 0 1; 0 0 1 1]; %Pattern
T = [0 1 1 0];          %Target


%%Criacao de uma Perceptron 
net1 = perceptron;
net1.trainParam.showWindow = false; %Mostrar a tela de treinamento
net1.divideFcn = 'dividetrain';
net1 = train(net1,P,T);
%view(net)
y = net1(P);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Usando Multilayer perceptron
n_hidden = 2; %Quantidade de neurônios na camada escondida 

net = feedforwardnet(n_hidden); %Inicialização da Rede

%Divisao da base de dados, caso precise dividir entre treinamento,
%validação e teste. 

net.divideFcn = 'dividetrain';

%Para ver as funções de performance: help nnperformance
net.performFcn = 'mae'; 

%Pode ser usado para configurar previamente a rede baseado em In/Out
net = configure(net,P,T); 

%Treinamento da rede
[net, tr] = train(net,P,T);

%Simulação da rede
C = sim(net, P);
%Equivalente ao comando acima
O = net(P);

%Funcao criada para visualizacao do problema XOR
plotfigures(P,T,y,C,'Usando Perceptron','Usando MLP') 

function plotfigures(P,T,y,C,name,name2)
figure
subplot(1,3,1)
hold on
for i = 1:4
   if (T(i) > 0.5)
      plot(P(1,i), P(2,i), 'bx')
   else
      plot(P(1,i), P(2,i), 'rx')
   end
end
xlim([-0.1 1.1])
ylim([-0.1 1.1])
axis square
set(gca, 'xtick', [0 1])
set(gca, 'ytick', [0 1])
box on
grid on;
title('Desejado')

subplot(1,3,2)
hold on
for i = 1:4
   if (y(i) > 0.501)
      plot(P(1,i), P(2,i), 'bx')
   else
      plot(P(1,i), P(2,i), 'rx')
   end
end
xlim([-0.1 1.1])
ylim([-0.1 1.1])
axis square
set(gca, 'xtick', [0 1])
set(gca, 'ytick', [0 1])
grid on;
box on
title(name)

subplot(1,3,3)
hold on
for i = 1:4
   if (C(i) > 0.501)
      plot(P(1,i), P(2,i), 'bx')
   else
      plot(P(1,i), P(2,i), 'rx')
   end
end
xlim([-0.1 1.1])
ylim([-0.1 1.1])
axis square
set(gca, 'xtick', [0 1])
set(gca, 'ytick', [0 1])
grid on;
box on
title(name2)
end
