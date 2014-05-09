clear all;
clc;

load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\1104x1000patrick1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\1104x1000patrick3.mat;
% load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2404x1000giordano5.mat;

Ordem(1:20,:) = Ordem1104x1000patrick1;
Ordem(21:40,:) = Ordem1104x1000patrick3;
% Ordem(41:60,:) = Ordem2404x1000giordano5;

Dados(:,:,1:20) = Touca1104x1000patrick1;
Dados(:,:,21:40) = Touca1104x1000patrick3;
% Dados(:,:,41:60) = Touca2404x1000giordano5;

SampleRate = 1000;
QuantColetas = length(Dados(1,1,:));

QuantColetasTreino = .5*QuantColetas;
QuantColetasTeste = .5*QuantColetas;

% Separação do segundo de interesse
TempoInicial=SampleRate*3.7;
Janela250ms = SampleRate*.25;

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
FminMu=10;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=3;
FminBeta=14;
FmaxBeta=15;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

%% Aplicação do filtro e potência
% Extração da sessão
% for k=1:QuantColetas
%     Dados(:,:,k) = x_train (:,:,k);
% end

% Separação dados C3 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC3(:,k) = Dados(:,2,k); %canal 2 - C3
%     RawDataC3 = mapminmax(DadosC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC3 = DadosC3(:,k)'; %normaliza os dados entre -1 e 1
    DadosC3FilterMu(k,:) = filter(NumMu,DenMu,RawDataC3); %Aplica o filtro Mu
    DadosC3PotenciaMu(k,:) = DadosC3FilterMu(k,:).^2; %Calcula a potencia ao quadrado 
    DadosC3FilterBeta(k,:) = filter(NumBeta,DenBeta,RawDataC3); %Aplica o filtro Mu
    DadosC3PotenciaBeta(k,:) = DadosC3FilterBeta(k,:).^2; %Calcula a potencia ao quadrado 
end

% Separação dados C4 - Filtra (Banda Mu e Beta) e aplica a potência
for k=1:QuantColetas
    DadosC4(:,k) = Dados(:,1,k);%canal 1 - C4
%     RawDataC4 = mapminmax(DadosC4(:,k)'); %normaliza os dados entre -1 e 1
    RawDataC4 = DadosC4(:,k)'; %normaliza os dados entre -1 e 1
    DadosC4FilterMu(k,:) = filter(NumMu,DenMu,RawDataC4); %Aplica o filtro Beta
    DadosC4PotenciaMu(k,:) = DadosC4FilterMu(k,:).^2; %Calcula a potencia ao quadrado
    DadosC4FilterBeta(k,:) = filter(NumBeta,DenBeta,RawDataC4); %Aplica o filtro Beta
    DadosC4PotenciaBeta(k,:) = DadosC4FilterBeta(k,:).^2; %Calcula a potencia ao quadrado
end


for k=1:QuantColetas
    SVMxMuC3(k,:) = DadosC3PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    SVMxMuC4(k,:) = DadosC4PotenciaMu(k,TempoInicial:(TempoInicial+SampleRate-1));
    SVMxBetaC3(k,:) = DadosC3PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));
    SVMxBetaC4(k,:) = DadosC4PotenciaBeta(k,TempoInicial:(TempoInicial+SampleRate-1));

end

% Média das amostras a cada 250 ms
for k=1:QuantColetas
    SVMMuC3x1(k,:) = mean(SVMxMuC3(k,1:Janela250ms));
    SVMMuC3x2(k,:) = mean(SVMxMuC3(k,1*Janela250ms:2*Janela250ms));
    SVMMuC3x3(k,:) = mean(SVMxMuC3(k,2*Janela250ms:3*Janela250ms));
    SVMMuC3x4(k,:) = mean(SVMxMuC3(k,3*Janela250ms:4*Janela250ms));
    
    SVMMuC4x1(k,:) = mean(SVMxMuC4(k,1:Janela250ms));
    SVMMuC4x2(k,:) = mean(SVMxMuC4(k,1*Janela250ms:2*Janela250ms));
    SVMMuC4x3(k,:) = mean(SVMxMuC4(k,2*Janela250ms:3*Janela250ms));
    SVMMuC4x4(k,:) = mean(SVMxMuC4(k,3*Janela250ms:4*Janela250ms));
        
    SVMBetaC3x1(k,:) = mean(SVMxBetaC3(k,1:Janela250ms));
    SVMBetaC3x2(k,:) = mean(SVMxBetaC3(k,1*Janela250ms:2*Janela250ms));
    SVMBetaC3x3(k,:) = mean(SVMxBetaC3(k,2*Janela250ms:3*Janela250ms));
    SVMBetaC3x4(k,:) = mean(SVMxBetaC3(k,3*Janela250ms:4*Janela250ms));
    
    SVMBetaC4x1(k,:) = mean(SVMxBetaC4(k,1:Janela250ms));
    SVMBetaC4x2(k,:) = mean(SVMxBetaC4(k,1*Janela250ms:2*Janela250ms));
    SVMBetaC4x3(k,:) = mean(SVMxBetaC4(k,2*Janela250ms:3*Janela250ms));
    SVMBetaC4x4(k,:) = mean(SVMxBetaC4(k,3*Janela250ms:4*Janela250ms));
    
    
end
for k=1:QuantColetas
    SVM(k,:) = [SVMMuC3x1(k) SVMMuC3x2(k) SVMMuC3x3(k) SVMMuC3x4(k) SVMMuC4x1(k) SVMMuC4x2(k) SVMMuC4x3(k) SVMMuC4x4(k) SVMBetaC3x1(k) SVMBetaC3x2(k) SVMBetaC3x3(k) SVMBetaC3x4(k) SVMBetaC4x1(k) SVMBetaC4x2(k) SVMBetaC4x3(k) SVMBetaC4x4(k)];
    SVMgr(k,:) = Saida(k,:);
end

i=1;
for k=1:QuantColetas
    if k<=QuantColetasTreino
        SVMTreino(k,:) = SVM(k,:);
        SVMgrTreino(k,:) = SVMgr(k,:);
    else
        SVMTeste(i,:) = SVM(k,:);
        BCISide(i,:) = SVMgr(k,:);
        i=i+1;
    end
end

%% Classificação por SVM
TreinoSVM = svmtrain(SVMTreino,SVMgrTreino);
SaidaSVM = svmclassify(TreinoSVM,SVMTeste);

%% Cálculo da porcentagem de acerto
Acertos = 0;
for k=1:QuantColetasTeste
    if SaidaSVM(k,:) == BCISide(k,:)
        Acertos = Acertos + 1;
    end
end
z(:,1) = BCISide(:,1);
z(:,2) = SaidaSVM(:,1);
Resultado = (Acertos/QuantColetasTeste)*100
%Resultado = (Acertos/(QuantColetasTeste-(length(SVMTreino(1,:)))-2))*100

