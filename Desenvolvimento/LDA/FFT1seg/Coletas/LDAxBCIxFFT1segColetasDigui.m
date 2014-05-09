clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2404x1000giordano4.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2404x1000giordano2.mat;
% load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2404x1000giordano5.mat;

Ordem(1:20,:) = Ordem2404x1000giordano4;
Ordem(21:40,:) = Ordem2404x1000giordano2;
% Ordem(41:60,:) = Ordem2404x1000giordano5;

Dados(:,:,1:20) = Touca2404x1000giordano4;
Dados(:,:,21:40) = Touca2404x1000giordano2;
% Dados(:,:,41:60) = Touca2404x1000giordano5;

SampleRate = 1000;
QuantColetas = length(Dados(1,1,:));
QuantColetasTreino = .5*QuantColetas;
QuantColetasTeste = .5*QuantColetas;
CompFreqMu = 8;
CompFreqBeta = 17;

%% Separação dos sinais entre direita e esquerda
for k=1:QuantColetas
    if (mod(Ordem(k),2) == 1)
        Saida(k,:) = 1;
    else
        Saida(k,:) = 2;
    end
end

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=3;
FminMu=8;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=3;
FminBeta=15;
FmaxBeta=20;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

%% Aplicação do filtro e potência

% Separação dados C3 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC3(:,k) = Dados(:,2,k); %canal 2 - C3
%     RawDataC3 = mapminmax(DadosC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC3 = DadosC3(:,k)'; %normaliza os dados entre -1 e 1
    DadosC3FilterMu(:,k) = filter(NumMu,DenMu,RawDataC3); %Aplica o filtro Mu
    DadosC3FilterBeta(:,k) = filter(NumBeta,DenBeta,RawDataC3); %Aplica o filtro Mu
end

% Separação dados C4 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC4(:,k) = Dados(:,1,k);%canal 1 - C4
%     RawDataC4 = mapminmax(DadosC4(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC4 = DadosC4(:,k)'; %normaliza os dados entre -1 e 1
    DadosC4FilterMu(:,k) = filter(NumMu,DenMu,RawDataC4); %Aplica o filtro Beta
    DadosC4FilterBeta(:,k) = filter(NumBeta,DenBeta,RawDataC4); %Aplica o filtro Beta
end

% FFTC3x35(:,k) = FFTCompEspFct(DadosC3x35(:,k),CompEsp,SampleRate);

for k=1:QuantColetas
    for m=1:9
        LDAxMuC3(k,m) = FFTCompEspFct(DadosC3FilterMu(((((m-1)*SampleRate)+1):m*SampleRate),k),CompFreqMu,SampleRate);
        LDAxMuC4(k,m) = FFTCompEspFct(DadosC4FilterMu(((((m-1)*SampleRate)+1):m*SampleRate),k),CompFreqMu,SampleRate);
        LDAxBetaC3(k,m) = FFTCompEspFct(DadosC3FilterBeta(((((m-1)*SampleRate)+1):m*SampleRate),k),CompFreqBeta,SampleRate);
        LDAxBetaC4(k,m) = FFTCompEspFct(DadosC4FilterBeta(((((m-1)*SampleRate)+1):m*SampleRate),k),CompFreqBeta,SampleRate);
    end
end

%         LDA(k,:) = [LDAxMuC3(k,:) LDAxBetaC3(k,:) LDAxMuC4(k,:) LDAxBetaC4(k,:)];
for k=1:QuantColetas
    LDA(k,:) = [LDAxMuC3(k,:) LDAxMuC4(k,:)];
    LDAgr(k,:) = Saida(k,:);
end

i=1;
for k=1:QuantColetas
    if k<=QuantColetasTreino
        LDATreino(k,:) = LDA(k,:);
        LDAgrTreino(k,:) = LDAgr(k,:);
    else
        LDATeste(i,:) = LDA(k,:);
        BCISide(i,:) = LDAgr(k,:);
        i=i+1;
    end
end

%% Classificação por LDA
for k=1:QuantColetasTeste
    SaidaLDA(k,:) = classify(LDATeste(k,:),LDATreino,LDAgrTreino);
end

%% Cálculo da porcentagem de acerto
Acertos = 0;
for k=1:QuantColetasTeste
    if SaidaLDA(k,:) == BCISide(k,:)
        Acertos = Acertos + 1;
    end
end
z(:,1) = BCISide(:,1);
z(:,2) = SaidaLDA(:,1);
Resultado = (Acertos/QuantColetasTeste)*100
%Resultado = (Acertos/(QuantColetasTeste-(length(LDATreino(1,:)))-2))*100

