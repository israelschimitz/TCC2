%Análise para movimentos com a mão esquerda
clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

SampleRate = 128;
QuantColetas = 140;

%Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=4;
FminMu=8;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%Filtro ALPHA passa-faixas  Butterworth 4ª ordem 
OrdemAlpha=4;
FminAlpha=20;
FmaxAlpha=21;
WnAlpha=[FminAlpha FmaxAlpha]*2/(SampleRate);
[NumAlpha,DenAlpha]=butter(OrdemAlpha,WnAlpha);
HAlpha=filt(NumAlpha,DenAlpha,(1/SampleRate));

IndiceEsq=find(y_train==1); %encontra os sinais relacionados à mão esquerda
IndiceDir=find(y_train==2); %encontra os sinais relacionados à mão direita

%%DadosEsquerda recebe somente as coletas com movimento da mão esquerda
for k=1:(QuantColetas/2)
    DadosEsquerda(:,:,k) = x_train (:,:,IndiceEsq(k));
end
%%Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = DadosEsquerda(:,1,k); %canal 1 - C3
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC3FiltradosAlpha(k,:) = filter(NumAlpha,DenAlpha,RawDataEsqC3); %Aplica o filtro Mu
    DadosEsqC3Potencia(k,:) = DadosEsqC3FiltradosAlpha(k,:).^2; %Calcula a potencia ao quadrado 
end
%%DadosEsquerdaCz recebe os dados do eletrodo Cz - canal 2 
for k=1:(QuantColetas/2)
    DadosEsquerdaCz(:,k) = DadosEsquerda(:,2,k);
    RawDataEsqCz = mapminmax(DadosEsquerdaCz(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqCzFiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqCz); %Aplica o filtro Mu
    DadosEsqCzPotencia(k,:) = DadosEsqCzFiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end
%%Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC4(:,k) = DadosEsquerda(:,3,k);%canal 3 - C4
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC4FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqC4); %Aplica o filtro Beta
    DadosEsqC4Potencia(k,:) = DadosEsqC4FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end
%%Calcula a média da potencia 
for k=1:(SampleRate*9)
    DadosEsqC3MediaPot(k) = sum(DadosEsqC3Potencia(:,k))/(QuantColetas/2);
    DadosEsqC4MediaPot(k) = sum(DadosEsqC4Potencia(:,k))/(QuantColetas/2);
    DadosEsqCzMediaPot(k) = sum(DadosEsqCzPotencia(:,k))/(QuantColetas/2);
end

%%plota os gráficos
Time =0:(1/SampleRate):(9-(1/SampleRate));
Coleta=10;

%Mu - ERD
figure;
subplot(4,1,1)
plot(Time,DadosEsquerdaC3(:,IndiceEsq(Coleta)));
Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
title(Titulo10);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,2)
plot(Time,DadosEsqC3FiltradosAlpha(IndiceEsq(Coleta),:));
Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo30);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,3)
plot(Time,DadosEsqC3Potencia(IndiceEsq(Coleta),:));
Titulo50=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo50);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,1,4)
plot(Time,DadosEsqC3MediaPot);
Titulo70=strcat('Sinal C3 Média das potências');
title(Titulo70);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');
%Mu - ERS
figure;
subplot(4,1,1);
plot(Time,DadosEsquerdaC4(:,IndiceEsq(Coleta)));
Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
title(Titulo20);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,2);
plot(Time,DadosEsqC4FiltradosMu(IndiceEsq(Coleta),:));
Titulo40=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo40);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,3);
plot(Time,DadosEsqC4Potencia(IndiceEsq(Coleta),:));
Titulo60=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo60);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,1,4);
plot(Time,DadosEsqC4MediaPot);
Titulo80=strcat('Sinal C4 Média das potências');
title(Titulo80);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');

%%Suavização das curvas
for k=1:(SampleRate*9)/8
    DadosEsqC3Suavizados(k) = (DadosEsqC3MediaPot(1,(1+8*(k-1)))+DadosEsqC3MediaPot(1,(2+8*(k-1)))+DadosEsqC3MediaPot(1,(3+8*(k-1)))+DadosEsqC3MediaPot(1,(4+8*(k-1)))+DadosEsqC3MediaPot(1,(5+8*(k-1)))+DadosEsqC3MediaPot(1,(6+8*(k-1)))+DadosEsqC3MediaPot(1,(7+8*(k-1)))+DadosEsqC3MediaPot(1,(8+8*(k-1))))/8;
    DadosEsqCzSuavizados(k) = (DadosEsqCzMediaPot(1,(1+8*(k-1)))+DadosEsqCzMediaPot(1,(2+8*(k-1)))+DadosEsqCzMediaPot(1,(3+8*(k-1)))+DadosEsqCzMediaPot(1,(4+8*(k-1)))+DadosEsqCzMediaPot(1,(5+8*(k-1)))+DadosEsqCzMediaPot(1,(6+8*(k-1)))+DadosEsqCzMediaPot(1,(7+8*(k-1)))+DadosEsqCzMediaPot(1,(8+8*(k-1))))/8;
    DadosEsqC4Suavizados(k) = (DadosEsqC4MediaPot(1,(1+8*(k-1)))+DadosEsqC4MediaPot(1,(2+8*(k-1)))+DadosEsqC4MediaPot(1,(3+8*(k-1)))+DadosEsqC4MediaPot(1,(4+8*(k-1)))+DadosEsqC4MediaPot(1,(5+8*(k-1)))+DadosEsqC4MediaPot(1,(6+8*(k-1)))+DadosEsqC4MediaPot(1,(7+8*(k-1)))+DadosEsqC4MediaPot(1,(8+8*(k-1))))/8;
end

%Cálculo do ERD / ERS
RC3Esq = sum(DadosEsqC3MediaPot(1,65:321))/(2*SampleRate);
RC4Esq = sum(DadosEsqC4MediaPot(1,65:321))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Esq (k) = ((DadosEsqC3Suavizados(k)-RC3Esq)/RC3Esq)*100;
    CzEsq (k) = ((DadosEsqCzSuavizados(k)-RC4Esq)/RC4Esq)*100;
    C4Esq (k) = ((DadosEsqC4Suavizados(k)-RC4Esq)/RC4Esq)*100;
end

TimeSuavizado = 0:(1/SampleRate)*8:9-((1/SampleRate)*8);
Zeros = zeros (1,length(TimeSuavizado));

%plota ERD / ERS
figure;
subplot(3,1,1)
plot(TimeSuavizado,C3Esq,TimeSuavizado,Zeros);
title('C3 (Hemisfério Esquerdo) - Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(3,1,2)
plot(TimeSuavizado,CzEsq,TimeSuavizado,Zeros);
title('Cz (Central) - Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(3,1,3)
plot(TimeSuavizado,C4Esq,TimeSuavizado,Zeros);
title('C4 (Hemisfério Direito) - Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
    
    
   
