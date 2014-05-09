%Análise para movimentos com a mão direita
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
FminAlpha=16;
FmaxAlpha=17;
WnAlpha=[FminAlpha FmaxAlpha]*2/(SampleRate);
[NumAlpha,DenAlpha]=butter(OrdemAlpha,WnAlpha);
HAlpha=filt(NumAlpha,DenAlpha,(1/SampleRate));

IndiceEsq=find(y_train==1); %encontra os sinais relacionados à mão esquerda
IndiceDir=find(y_train==2); %encontra os sinais relacionados à mão direita

%%DadosDireita recebe somente as coletas com movimento da mão direita
for k=1:(QuantColetas/2)
    DadosDireita(:,:,k) = x_train (:,:,IndiceDir(k));
end
%%Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC3(:,k) = DadosDireita(:,1,k); %canal 1 - C3
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC3FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirC3); %Aplica o filtro Mu
    DadosDirC3Potencia(k,:) = DadosDirC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end
%%DadosDireitaCz recebe os dados do eletrodo Cz - canal 2 
for k=1:(QuantColetas/2)
    DadosDireitaCz(:,k) = DadosDireita(:,2,k);
    RawDataDirCz = mapminmax(DadosDireitaCz(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirCzFiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirCz); %Aplica o filtro Mu
    DadosDirCzPotencia(k,:) = DadosDirCzFiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end
%%Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC4(:,k) = DadosDireita(:,3,k);%canal 3 - C4
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC4FiltradosAlpha(k,:) = filter(NumAlpha,DenAlpha,RawDataDirC4); %Aplica o filtro Beta
    DadosDirC4Potencia(k,:) = DadosDirC4FiltradosAlpha(k,:).^2; %Calcula a potencia ao quadrado
end
%%Calcula a média da potencia 
for k=1:(SampleRate*9)
    DadosDirC3MediaPot(k) = sum(DadosDirC3Potencia(:,k))/(QuantColetas/2);
    DadosDirC4MediaPot(k) = sum(DadosDirC4Potencia(:,k))/(QuantColetas/2);
    DadosDirCzMediaPot(k) = sum(DadosDirCzPotencia(:,k))/(QuantColetas/2);
end

%%plota os gráficos
Time =0:(1/SampleRate):(9-(1/SampleRate));
Coleta=10;

%Mu - ERD
figure;
subplot(4,1,1)
plot(Time,DadosDireitaC3(:,IndiceDir(Coleta)));
Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
title(Titulo10);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,2)
plot(Time,DadosDirC3FiltradosMu(IndiceDir(Coleta),:));
Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo30);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,3)
plot(Time,DadosDirC3Potencia(IndiceDir(Coleta),:));
Titulo50=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo50);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,1,4)
plot(Time,DadosDirC3MediaPot);
Titulo70=strcat('Sinal C3 Média das potências');
title(Titulo70);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');
%Mu - ERS
figure;
subplot(4,1,1);
plot(Time,DadosDireitaC4(:,IndiceDir(Coleta)));
Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
title(Titulo20);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,2);
plot(Time,DadosDirC4FiltradosAlpha(IndiceDir(Coleta),:));
Titulo40=strcat('Sinal C4 Filtrado Alpha (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo40);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,1,3);
plot(Time,DadosDirC4Potencia(IndiceDir(Coleta),:));
Titulo60=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo60);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,1,4);
plot(Time,DadosDirC4MediaPot);
Titulo80=strcat('Sinal C4 Média das potências');
title(Titulo80);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');

%%Suavização das curvas
for k=1:(SampleRate*9)/8
    DadosDirC3Suavizados(k) = (DadosDirC3MediaPot(1,(1+8*(k-1)))+DadosDirC3MediaPot(1,(2+8*(k-1)))+DadosDirC3MediaPot(1,(3+8*(k-1)))+DadosDirC3MediaPot(1,(4+8*(k-1)))+DadosDirC3MediaPot(1,(5+8*(k-1)))+DadosDirC3MediaPot(1,(6+8*(k-1)))+DadosDirC3MediaPot(1,(7+8*(k-1)))+DadosDirC3MediaPot(1,(8+8*(k-1))))/8;
    DadosDirCzSuavizados(k) = (DadosDirCzMediaPot(1,(1+8*(k-1)))+DadosDirCzMediaPot(1,(2+8*(k-1)))+DadosDirCzMediaPot(1,(3+8*(k-1)))+DadosDirCzMediaPot(1,(4+8*(k-1)))+DadosDirCzMediaPot(1,(5+8*(k-1)))+DadosDirCzMediaPot(1,(6+8*(k-1)))+DadosDirCzMediaPot(1,(7+8*(k-1)))+DadosDirCzMediaPot(1,(8+8*(k-1))))/8;
    DadosDirC4Suavizados(k) = (DadosDirC4MediaPot(1,(1+8*(k-1)))+DadosDirC4MediaPot(1,(2+8*(k-1)))+DadosDirC4MediaPot(1,(3+8*(k-1)))+DadosDirC4MediaPot(1,(4+8*(k-1)))+DadosDirC4MediaPot(1,(5+8*(k-1)))+DadosDirC4MediaPot(1,(6+8*(k-1)))+DadosDirC4MediaPot(1,(7+8*(k-1)))+DadosDirC4MediaPot(1,(8+8*(k-1))))/8;
end

%Cálculo do ERD / ERS
RC3Dir = sum(DadosDirC3MediaPot(1,65:321))/(2*SampleRate);
RC4Dir = sum(DadosDirC4MediaPot(1,65:321))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Dir (k) = ((DadosDirC3Suavizados(k)-RC3Dir)/RC3Dir)*100;
    CzDir (k) = ((DadosDirCzSuavizados(k)-RC4Dir)/RC4Dir)*100;
    C4Dir (k) = ((DadosDirC4Suavizados(k)-RC4Dir)/RC4Dir)*100;
end

TimeSuavizado = 0:(1/SampleRate)*8:9-((1/SampleRate)*8);
Zeros = zeros (1,length(TimeSuavizado));

%plota ERD / ERS
figure;
subplot(3,1,1)
plot(TimeSuavizado,C3Dir,TimeSuavizado,Zeros);
title('C3 (Hemisfério Esquerdo) - Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(3,1,2)
plot(TimeSuavizado,CzDir,TimeSuavizado,Zeros);
title('Cz (Central) - Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(3,1,3)
plot(TimeSuavizado,C4Dir,TimeSuavizado,Zeros);
title('C4 (Hemisfério Direito) - Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
    
    
   
