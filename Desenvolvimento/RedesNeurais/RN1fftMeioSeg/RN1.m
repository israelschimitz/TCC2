
%% RN1
% Pega a FFT de 0,5 segundos entre 3,5-4,0 // 4,0-4,5 // 4,5-5,0
% concatena os canais C3 e C4 e coloca na Entrada.
% Saída Esquerda [-1,1] e Direita  [1,-1]


clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

SampleRate = 128;
QuantColetas = 140;
CompEsp = 11;
QuantColetasTreino = .5*QuantColetas;
QuantColetasTeste = .5*QuantColetas;
%% Configurando a Saída
% Separação dos sinais entre direita e esquerda
for i=1:QuantColetas
    if (mod(y_train(i),2) == 1)
        Saida(1,i) = -1; %esquerda
        Saida(2,i) = 1;  %esquerda
    else
        Saida(1,i) = 1;  %direita
        Saida(2,i) = -1; %direita
    end
end

%% Configurando a Entrada

DadosC3(:,:) = x_train (:,1,:);
DadosC3x35(:,:) = DadosC3((4*SampleRate:4.5*SampleRate),:);
DadosC3x40(:,:) = DadosC3((4.5*SampleRate:5*SampleRate),:);
DadosC3x45(:,:) = DadosC3((5*SampleRate:5.5*SampleRate),:);

DadosC4(:,:) = x_train (:,3,:);
DadosC4x35(:,:) = DadosC4((4*SampleRate:4.5*SampleRate),:);
DadosC4x40(:,:) = DadosC4((4.5*SampleRate:5*SampleRate),:);
DadosC4x45(:,:) = DadosC4((5*SampleRate:5.5*SampleRate),:);

for k=1:QuantColetas
    FFTC3x35(:,k) = FFTCompEspFct(DadosC3x35(:,k),CompEsp,SampleRate);
    FFTC3x40(:,k) = FFTCompEspFct(DadosC3x40(:,k),CompEsp,SampleRate);
    FFTC3x45(:,k) = FFTCompEspFct(DadosC3x45(:,k),CompEsp,SampleRate);
    FFTC4x35(:,k) = FFTCompEspFct(DadosC4x35(:,k),CompEsp,SampleRate);
    FFTC4x40(:,k) = FFTCompEspFct(DadosC4x40(:,k),CompEsp,SampleRate);
    FFTC4x45(:,k) = FFTCompEspFct(DadosC4x45(:,k),CompEsp,SampleRate);
end

EntradaTreino(1,:) = FFTC3x35(:,1:QuantColetasTreino);
EntradaTreino(2,:) = FFTC3x40(:,1:QuantColetasTreino);
EntradaTreino(3,:) = FFTC3x45(:,1:QuantColetasTreino);
EntradaTreino(4,:) = FFTC4x35(:,1:QuantColetasTreino);
EntradaTreino(5,:) = FFTC4x40(:,1:QuantColetasTreino);
EntradaTreino(6,:) = FFTC4x45(:,1:QuantColetasTreino);

EntradaTeste(1,:) = FFTC3x35(:,(QuantColetasTreino+1):QuantColetas);
EntradaTeste(2,:) = FFTC3x40(:,(QuantColetasTreino+1):QuantColetas);
EntradaTeste(3,:) = FFTC3x45(:,(QuantColetasTreino+1):QuantColetas);
EntradaTeste(4,:) = FFTC4x35(:,(QuantColetasTreino+1):QuantColetas);
EntradaTeste(5,:) = FFTC4x40(:,(QuantColetasTreino+1):QuantColetas);
EntradaTeste(6,:) = FFTC4x45(:,(QuantColetasTreino+1):QuantColetas);

SaidaTreino(:,:)=Saida(:,1:QuantColetasTreino);
SaidaTeste(:,:)=Saida(:,(QuantColetasTreino+1):QuantColetas);


%Geracao da Rede neural
%150 neuronios na camada oculta
net = feedforwardnet(20, 'trainbr');
%Configuracao da rede neural
%Dados para treinamento 100%
net.divideParam.trainRatio=.75;
%Dados para validacao 0%
net.divideParam.valRatio=.25;
%Dados para teste 0%
net.divideParam.testRatio=0;

% --------------------------------
% %Numero de camadas
% net.NumLayers=3;
% %Conexao do Bias as camadas
% net.biasConnect=[1;1;1];
% net.outputConnect=[0 0 1];
% net.layerConnect=[0 0 0;1 0 0;0 1 0];
% %Camada oculta 2
% net.layers{2}.name='Hidden2';
% %Camada oculta 2 (75 neuronios)
% net.layers{2}.dimensions=40;
% net.layers{3}.name='Output';
% net.layers{2}.transferFcn='tansig';
% net.layers{3}.transferFcn='purelin';
%---------------------------------
clc;
tic;
%Minimo Gradiente
net.trainParam.min_grad=1e-9;
net.trainParam.epochs = 10000;
%Treinamento da rede neural
net = train(net,EntradaTreino,SaidaTreino);


for k=1:QuantColetasTeste
    Resultado(:,k)=net(EntradaTeste(:,k));
end

% Saída esquerda [-1,1] e direita  [1,-1]
for k=1:QuantColetasTeste
    if ((Resultado(1,k)<0)&(Resultado(2,k)>0))
        Direcao(k) = 1;
    else
        Direcao(k) = 2;
    end
end

Acertos = 0;
for k=1:QuantColetasTeste
    if (Direcao(k)==y_train(k))
        Acertos = Acertos+1;
    end
end


tf=toc;
ResultadoFinal = (Acertos/QuantColetasTeste)*100
% disp(sprintf('\n\nNumeros a serem jogados: [%d %d %d %d %d %d]',abs(round(Projecao_Resultado))));
disp(sprintf('\nTempo decorrido:%15.1f',tf));
%Salva a rede neural projetada
savefile = 'BCIRN1.mat';
save(savefile, 'net');



