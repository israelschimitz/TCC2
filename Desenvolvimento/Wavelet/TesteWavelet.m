clear all;
clc;
load C:\Israel\Engenharia_El�trica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
load C:\Israel\Engenharia_El�trica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\labels_data_set_iii.mat;

SampleRate = 128;
QuantColetas = 140;

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4� ordem 
OrdemMu=2;
FminMu=9;
FmaxMu=12;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

% %% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4� ordem 
% OrdemBeta=2;
% FminBeta=19;
% FmaxBeta=22;
% WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
% [NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
% HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

% %% Separa��o dos sinais entre direita e esquerda
% IndiceEsq=find(y_train==1); %encontra os sinais relacionados � m�o esquerda
% IndiceDir=find(y_train==2); %encontra os sinais relacionados � m�o direita


Dados = x_train;

%%
% An�lise C3 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:QuantColetas
    DadosC3(:,k) = Dados(:,1,k); %canal 1 - C3
    RawDataC3(k,:) = mapminmax(DadosC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosC3FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataC3(k,:)); %Aplica o filtro Mu
end
%%
% An�lise C4 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:QuantColetas
    DadosC4(:,k) = Dados(:,3,k);%canal 3 - C4
    RawDataC4(k,:) = mapminmax(DadosC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosC4FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataC4(k,:)); %Aplica o filtro Mu
end

Wname = 'coif3';
% dwtmode('per');
N=wmaxlev((SampleRate*9),Wname);% n�mero �timo de decomposi��es
for k=1:QuantColetas
    e1(k,:) = wentropy(DadosC3FiltradosMu(k,:),'shannon');%entropia do sinal
    [C1,L1] = wavedec(RawDataC3(k,:),N,Wname);%decomp�e em N n�veis
    [Ea1(k,:),Ed1(k,:)] = wenergy(C1,L1);%coeficientes de aproxima��o e coeficientes de detalhes
    
    e2(k,:) = wentropy(DadosC4FiltradosMu(k,:),'shannon');%entropia do sinal
    [C2,L2] = wavedec(RawDataC4(k,:),N,Wname);%decomp�e em N n�veis
    [Ea2(k,:),Ed2(k,:)] = wenergy(C2,L2);%coeficientes de aproxima��o e coeficientes de detalhes

end

for k=1:QuantColetas
    Ed1(k,(N+1)) = Ea1(k,1);
    Ed1(k,(N+2)) = e1(k,1);
    Ed2(k,(N+1)) = Ea2(k,1);
    Ed2(k,(N+2)) = e2(k,1);
end

for k=1:QuantColetas
    LDA(k,:) = [Ed1(k,:) Ed2(k,:)];
    LDAgr(k,:) = y_train(k,:);
end

