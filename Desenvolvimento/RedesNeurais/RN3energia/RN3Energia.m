clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\labels_data_set_iii.mat;

SampleRate = 128;
QuantColetas = 140;
QuantColetasTreino = .5*QuantColetas;
QuantColetasTeste = .5*QuantColetas;

% Separação do segundo de interesse
TempoInicial=SampleRate*4.375;
Janela250ms = SampleRate*.25;

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

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=3;
FminMu=9;
FmaxMu=12;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=3;
FminBeta=17;
FmaxBeta=22;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

%% Aplicação do filtro e potência
% Extração da sessão
for k=1:QuantColetas
    Dados(:,:,k) = x_train (:,:,k);
end

% Separação dados C3 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC3(:,k) = Dados(:,1,k); %canal 1 - C3
%     RawDataC3 = mapminmax(DadosC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC3 = DadosC3(:,k)'; %normaliza os dados entre -1 e 1
    DadosC3FilterMu(k,:) = filter(NumMu,DenMu,RawDataC3); %Aplica o filtro Mu
    DadosC3PotenciaMu(k,:) = DadosC3FilterMu(k,:).^2; %Calcula a potencia ao quadrado 
    DadosC3FilterBeta(k,:) = filter(NumBeta,DenBeta,RawDataC3); %Aplica o filtro Mu
    DadosC3PotenciaBeta(k,:) = DadosC3FilterBeta(k,:).^2; %Calcula a potencia ao quadrado 
end

% Separação dados C4 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC4(:,k) = Dados(:,3,k);%canal 3 - C4
%     RawDataC4 = mapminmax(DadosC4(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC4 = DadosC4(:,k)'; %normaliza os dados entre -1 e 1
    DadosC4FilterMu(k,:) = filter(NumMu,DenMu,RawDataC4); %Aplica o filtro Beta
    DadosC4PotenciaMu(k,:) = DadosC4FilterMu(k,:).^2; %Calcula a potencia ao quadrado
    DadosC4FilterBeta(k,:) = filter(NumBeta,DenBeta,RawDataC4); %Aplica o filtro Beta
    DadosC4PotenciaBeta(k,:) = DadosC4FilterBeta(k,:).^2; %Calcula a potencia ao quadrado
end


for k=1:QuantColetas
    RNxMuC3(k,:) = DadosC3PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    RNxMuC4(k,:) = DadosC4PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    RNxBetaC3(k,:) = DadosC3PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));
    RNxBetaC4(k,:) = DadosC4PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));

end

% Média das amostras a cada 250 ms
for k=1:QuantColetas
    RNMuC3x1(k,:) = mean(RNxMuC3(k,1:Janela250ms));
    RNMuC3x2(k,:) = mean(RNxMuC3(k,1*Janela250ms:2*Janela250ms));
    RNMuC3x3(k,:) = mean(RNxMuC3(k,2*Janela250ms:3*Janela250ms));
    RNMuC3x4(k,:) = mean(RNxMuC3(k,3*Janela250ms:4*Janela250ms));
    
    RNMuC4x1(k,:) = mean(RNxMuC4(k,1:Janela250ms));
    RNMuC4x2(k,:) = mean(RNxMuC4(k,1*Janela250ms:2*Janela250ms));
    RNMuC4x3(k,:) = mean(RNxMuC4(k,2*Janela250ms:3*Janela250ms));
    RNMuC4x4(k,:) = mean(RNxMuC4(k,3*Janela250ms:4*Janela250ms));
        
    RNBetaC3x1(k,:) = mean(RNxBetaC3(k,1:Janela250ms));
    RNBetaC3x2(k,:) = mean(RNxBetaC3(k,1*Janela250ms:2*Janela250ms));
    RNBetaC3x3(k,:) = mean(RNxBetaC3(k,2*Janela250ms:3*Janela250ms));
    RNBetaC3x4(k,:) = mean(RNxBetaC3(k,3*Janela250ms:4*Janela250ms));
    
    RNBetaC4x1(k,:) = mean(RNxBetaC4(k,1:Janela250ms));
    RNBetaC4x2(k,:) = mean(RNxBetaC4(k,1*Janela250ms:2*Janela250ms));
    RNBetaC4x3(k,:) = mean(RNxBetaC4(k,2*Janela250ms:3*Janela250ms));
    RNBetaC4x4(k,:) = mean(RNxBetaC4(k,3*Janela250ms:4*Janela250ms));
    
    
end
for k=1:QuantColetas
    RN(:,k) = [RNMuC3x1(k) RNMuC3x2(k) RNMuC3x3(k) RNMuC3x4(k) RNMuC4x1(k) RNMuC4x2(k) RNMuC4x3(k) RNMuC4x4(k) RNBetaC3x1(k) RNBetaC3x2(k) RNBetaC3x3(k) RNBetaC3x4(k) RNBetaC4x1(k) RNBetaC4x2(k) RNBetaC4x3(k) RNBetaC4x4(k)];
end

i=1;
for k=1:QuantColetas
    if k<=QuantColetasTreino
        RNTreino(:,k) = RN(:,k);
        RNgrTreino(:,k) = Saida(:,k);
    else
        RNTeste(:,i) = RN(:,k);
        BCISide(:,i) = Saida(:,k);
        i=i+1;
    end
end


%Geracao da Rede neural
%150 neuronios na camada oculta
net = feedforwardnet(20);
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
net.trainParam.min_grad=1e-6;
net.trainParam.epochs = 5000;
%Treinamento da rede neural
net = train(net,RNTreino,RNgrTreino);


for k=1:QuantColetasTeste
    Resultado(:,k)=net(RNTeste(:,k));
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
savefile = 'BCIRN3.mat';
save(savefile, 'net');

