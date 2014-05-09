clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\labels_data_set_iii.mat;

SampleRate = 128;
QuantColetas = 40;
QuantColetasTreino = .5*QuantColetas;
QuantColetasTeste = .5*QuantColetas;
CompFreqMu = 10;
CompFreqBeta = 20;


%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=3;
FminMu=10;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=3;
FminBeta=20;
FmaxBeta=21;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

%% Aplicação do filtro e potência
% Extração da sessão
for k=1:QuantColetas
    Dados(:,:,k) = x_test (:,:,k);
end

% Separação dados C3 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC3(:,k) = Dados(:,1,k); %canal 1 - C3
%     RawDataC3 = mapminmax(DadosC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC3 = DadosC3(:,k)'; %normaliza os dados entre -1 e 1
    DadosC3FilterMu(:,k) = filter(NumMu,DenMu,RawDataC3); %Aplica o filtro Mu
    DadosC3FilterBeta(:,k) = filter(NumBeta,DenBeta,RawDataC3); %Aplica o filtro Mu
end

% Separação dados C4 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC4(:,k) = Dados(:,3,k);%canal 3 - C4
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
    LDAgr(k,:) = y_test(k,:);
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

