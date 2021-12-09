close all;
clear;
clc;

%% Setting Path for SOM-Toolbox
addpath(genpath('SOM-Toolbox'))

%% Leitura dos dados
sD = som_read_data('new-thyroid.data');

%% Normalização dos dados - 'var' (variancia normalizada para 1), 'range' (entre 0 e 1), 'log', 'logistic', 'histD' or 'histC'
sD_norm = som_normalize(sD, 'histD');

%% Treinamento

% Inicialização do Mapa - lattice: 'hexa' or 'rect'
sM = som_randinit(sD_norm, 'msize', [13 13], 'lattice', 'hexa');

% Ordering Phase
trainOrdering = 1100;
alphaOrdering = 0.97;

sM = som_seqtrain(sM, sD_norm, 'radius', [10 1], 'alpha', alphaOrdering,... 
    'alpha_type', 'linear', 'trainlen', trainOrdering);%,'tracking', 3);    #alpha_type (learning rate finction ->'inv', 'linear' or 'power'

% Finetunning
trainFineTuning = 84500;
alphaFineTuning = 0.01;

sM = som_seqtrain(sM, sD_norm, 'radius', 1, 'alpha', alphaFineTuning,...
    'alpha_type', 'linear', 'trainlen', trainFineTuning);%, 'tracking', 3); #alpha_type ->'inv', 'linear' or 'power'


%% Visualização do Mapa
som_show(sM, 'umat', 'all', 'comp', 1:5, 'norm', 'd');

figure;
%Gera a figura vazia com nomes 'Label' e 'Hits'
som_show(sM, 'Empty', 'Label', 'Empty', 'Hits');

%Mapa com o label respectivo
sM_label = som_autolabel(sM, sD_norm, 'vote');

%Adicionar na nossa figura
som_show_add('label', sM_label, 'subplot', 1); %gerando os labels
som_show_add('hit', som_hits(sM, sD_norm), 'subplot', 2); %gerando os hits


%%Métricas possíveis - kmeans e erros de quantização e topográfico
figure;
[c,p,err,ind] = kmeans_clusters(sM, 3, 1000);
[dummy, i] = min(ind);
som_show(sM, 'color', {p{i}, sprintf('%d clusters',i)});


[mqe, tge] = som_quality(sM, sD_norm);
fprintf('Final quantization error: %5.3f\n', mqe)
fprintf('Final topographic error: %5.3f\n', tge)




