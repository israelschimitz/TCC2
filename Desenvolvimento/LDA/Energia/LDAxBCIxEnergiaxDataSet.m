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
    Dados(:,:,k) = x_test (:,:,k);
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
    LDAxMuC3(k,:) = DadosC3PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    LDAxMuC4(k,:) = DadosC4PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    LDAxBetaC3(k,:) = DadosC3PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));
    LDAxBetaC4(k,:) = DadosC4PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));

end

% Média das amostras a cada 250 ms
for k=1:QuantColetas
    LDAMuC3x1(k,:) = mean(LDAxMuC3(k,1:Janela250ms));
    LDAMuC3x2(k,:) = mean(LDAxMuC3(k,1*Janela250ms:2*Janela250ms));
    LDAMuC3x3(k,:) = mean(LDAxMuC3(k,2*Janela250ms:3*Janela250ms));
    LDAMuC3x4(k,:) = mean(LDAxMuC3(k,3*Janela250ms:4*Janela250ms));
    
    LDAMuC4x1(k,:) = mean(LDAxMuC4(k,1:Janela250ms));
    LDAMuC4x2(k,:) = mean(LDAxMuC4(k,1*Janela250ms:2*Janela250ms));
    LDAMuC4x3(k,:) = mean(LDAxMuC4(k,2*Janela250ms:3*Janela250ms));
    LDAMuC4x4(k,:) = mean(LDAxMuC4(k,3*Janela250ms:4*Janela250ms));
        
    LDABetaC3x1(k,:) = mean(LDAxBetaC3(k,1:Janela250ms));
    LDABetaC3x2(k,:) = mean(LDAxBetaC3(k,1*Janela250ms:2*Janela250ms));
    LDABetaC3x3(k,:) = mean(LDAxBetaC3(k,2*Janela250ms:3*Janela250ms));
    LDABetaC3x4(k,:) = mean(LDAxBetaC3(k,3*Janela250ms:4*Janela250ms));
    
    LDABetaC4x1(k,:) = mean(LDAxBetaC4(k,1:Janela250ms));
    LDABetaC4x2(k,:) = mean(LDAxBetaC4(k,1*Janela250ms:2*Janela250ms));
    LDABetaC4x3(k,:) = mean(LDAxBetaC4(k,2*Janela250ms:3*Janela250ms));
    LDABetaC4x4(k,:) = mean(LDAxBetaC4(k,3*Janela250ms:4*Janela250ms));
    
    
end
for k=1:QuantColetas
    LDA(k,:) = [LDAMuC3x1(k) LDAMuC3x2(k) LDAMuC3x3(k) LDAMuC3x4(k) LDAMuC4x1(k) LDAMuC4x2(k) LDAMuC4x3(k) LDAMuC4x4(k) LDABetaC3x1(k) LDABetaC3x2(k) LDABetaC3x3(k) LDABetaC3x4(k) LDABetaC4x1(k) LDABetaC4x2(k) LDABetaC4x3(k) LDABetaC4x4(k)];
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

