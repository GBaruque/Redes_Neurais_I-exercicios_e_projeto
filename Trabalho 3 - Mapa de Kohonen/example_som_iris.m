%Exemplo do SOM Toolbox usando o Dataset Iris.
close all;
clc;
clear;
%FASE 1 - Leitura de dados
sD = som_read_data('iris.data');
%FASE 2 - Normalização dos dados
%Lembrete - Podemos normalizar usando diferentes funcoes.
%'var','linear','histD,'histC'
sD_norm = som_normalize(sD,'var');
%%Criação do mapa e teste da rede
sM = som_randinit(sD_norm,'msize',[12 10],'lattice','hexa');
%FASE 3 - Treinamento da rede.
%Dividiremos em duas fases
%Ordering Training
trainOrdering = 80;
%Treinamento de fato do Mapa de Kohonen para a fase de Ordering.
sM = som_seqtrain(sM,sD_norm,'radius',[4 1],'alpha',0.9,'alpha_type',...
    'linear','trainlen',trainOrdering);
%Fine-tuning Training
trainFine = 100;
%Para declarar a taxa de aprendizado, podemos declarar manualmente, desde
%que o vetor possua dimensão igual a época de treinamento.
%alpha = 0.2*ones(trainFine,1); 
sM = som_seqtrain(sM,sD_norm,'radius',1,'alpha',0.1,'trainlen',trainFine);
%FASE 4 - VISUALIZAÇÃO DO MAPA
som_show(sM,'umat','all','comp',1:4,'norm','d');
figure;
sM_label = som_autolabel(sM, sD_norm,'vote');
som_show(sM,'Empty','Label','Empty','Hits');
som_show_add('label',sM_label,'subplot',1); %Geracao dos labels
som_show_add('hit',som_hits(sM, sD_norm),'subplot',2) %Geracao dos hits

%FASE 5 - ANALISE DOS RESULTADOS

[mqe,tge,cbe] = som_quality(sM,sD_norm);
fprintf('Final quantization error: %5.3f\n',mqe)
fprintf('Final topographic error:  %5.3f\n',tge)
fprintf('Final combined error:  %5.3f\n',cbe)

figure;
[c,p,err,ind] = kmeans_clusters(sM, 3, 1000);
som_show(sM,'color',{p{3},sprintf('%d clusters',3)});


