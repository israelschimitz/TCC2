clear all;
clc;

%2303x5israels.mat Coletas2303x5israels Ordem2303x5israels
%% Carregando a coleta e a ordem
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2303x5israels.mat;

SampleRate = 1000;
QuantColetas = 12;

%% Separação dos sinais entre direita e esquerda
j=1;
k=1;
for i=1:QuantColetas
    if (mod(Ordem2303x5israels(i),2) == 1)
        IndiceEsq(j,:) = i;
        j=j+1;
    else
        IndiceDir(k,:) = i;
        k=k+1;
    end
end

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=4;
FminMu=10;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=4;
FminBeta=10;
FmaxBeta=11;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));


%% Análise para movimentos com a mão direita
% DadosDireita recebe somente as coletas com movimento da mão direita
for k=1:(QuantColetas/2)
    DadosDireita(:,:,k) = Coletas2303x5israels (:,:,IndiceDir(k));
end

%%
% Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC3(:,k) = DadosDireita(:,2,k); %canal 2 - C3
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC3FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirC3); %Aplica o filtro Mu
    DadosDirC3Potencia(k,:) = DadosDirC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC4(:,k) = DadosDireita(:,1,k); %canal 1 - C4
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC4FiltradosMu(k,:) = filter(NumBeta,DenBeta,RawDataDirC4); %Aplica o filtro Beta
    DadosDirC4Potencia(k,:) = DadosDirC4FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a média da potencia
for k=1:(SampleRate*9)
    DadosDirC3MediaPot(k) = sum(DadosDirC3Potencia(:,k))/(QuantColetas/2);
    DadosDirC4MediaPot(k) = sum(DadosDirC4Potencia(:,k))/(QuantColetas/2);
end

%% Análise para movimentos com a mão esquerda
% DadosEsquerda recebe somente as coletas com movimento da mão esquerda
for k=1:(QuantColetas/2)
    DadosEsquerda(:,:,k) = Coletas2303x5israels(:,:,IndiceEsq(k));
end

%%
% Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = DadosEsquerda(:,2,k); %canal 2 - C3
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC3FiltradosMu(k,:) = filter(NumBeta,DenBeta,RawDataEsqC3); %Aplica o filtro Beta
    DadosEsqC3Potencia(k,:) = DadosEsqC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC4(:,k) = DadosEsquerda(:,1,k); %canal 1 - C4
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC4FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqC4); %Aplica o filtro Beta
    DadosEsqC4Potencia(k,:) = DadosEsqC4FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a média da potencia
for k=1:(SampleRate*9)
    DadosEsqC3MediaPot(k) = sum(DadosEsqC3Potencia(:,k))/(QuantColetas/2);
    DadosEsqC4MediaPot(k) = sum(DadosEsqC4Potencia(:,k))/(QuantColetas/2);
end

%% Plota os gráficos passo a passo do Band Power Method
Time =0:(1/SampleRate):(9-(1/SampleRate));
Coleta=3;

%% Mão direita
% ERD 
figure;
subplot(4,2,1);
plot(Time,DadosDireitaC3(:,Coleta));
Titulo1=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
title(Titulo1);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,3);
plot(Time,DadosDirC3FiltradosMu(Coleta,:));
Titulo3=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo3);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,5);
plot(Time,DadosDirC3Potencia(Coleta,:));
Titulo5=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo5);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,2,7);
plot(Time,DadosDirC3MediaPot);
Titulo7=strcat('Sinal C3 Média das potências');
title(Titulo7);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');

%% 
% ERS
subplot(4,2,2);
plot(Time,DadosDireitaC4(:,Coleta));
Titulo2=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
title(Titulo2);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,4);
plot(Time,DadosDirC4FiltradosMu(Coleta,:));
Titulo4=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo4);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,6);
plot(Time,DadosDirC4Potencia(Coleta,:));
Titulo6=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo6);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,2,8);
plot(Time,DadosDirC4MediaPot);
Titulo8=strcat('Sinal C4 Média das potências');
title(Titulo8);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');

%% Mão esquerda
% ERD
figure;
subplot(4,2,1)
plot(Time,DadosEsquerdaC3(:,Coleta));
Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
title(Titulo10);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,3)
plot(Time,DadosEsqC3FiltradosMu(Coleta,:));
Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo30);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,5)
plot(Time,DadosEsqC3Potencia(Coleta,:));
Titulo50=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo50);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,2,7)
plot(Time,DadosEsqC3MediaPot);
Titulo70=strcat('Sinal C3 Média das potências');
title(Titulo70);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');

%%
% ERS
subplot(4,2,2);
plot(Time,DadosEsquerdaC4(:,Coleta));
Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
title(Titulo20);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,4);
plot(Time,DadosEsqC4FiltradosMu(Coleta,:));
Titulo40=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo40);
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');
subplot(4,2,6);
plot(Time,DadosEsqC4Potencia(Coleta,:));
Titulo60=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo60);
xlabel('Tempo [s]'); 
ylabel('Potência [V^2]');
subplot(4,2,8);
plot(Time,DadosEsqC4MediaPot);
Titulo80=strcat('Sinal C4 Média das potências');
title(Titulo80);
xlabel('Tempo [s]'); 
ylabel('Potência Média [V^2]');


%% Suavização das curvas - Análise dos movimentos mão DIREITA
for k=1:(SampleRate*9)/8
    DadosDirC3Suavizados(k) = (DadosDirC3MediaPot(1,(1+8*(k-1)))+DadosDirC3MediaPot(1,(2+8*(k-1)))+DadosDirC3MediaPot(1,(3+8*(k-1)))+DadosDirC3MediaPot(1,(4+8*(k-1)))+DadosDirC3MediaPot(1,(5+8*(k-1)))+DadosDirC3MediaPot(1,(6+8*(k-1)))+DadosDirC3MediaPot(1,(7+8*(k-1)))+DadosDirC3MediaPot(1,(8+8*(k-1))))/8;
    DadosDirC4Suavizados(k) = (DadosDirC4MediaPot(1,(1+8*(k-1)))+DadosDirC4MediaPot(1,(2+8*(k-1)))+DadosDirC4MediaPot(1,(3+8*(k-1)))+DadosDirC4MediaPot(1,(4+8*(k-1)))+DadosDirC4MediaPot(1,(5+8*(k-1)))+DadosDirC4MediaPot(1,(6+8*(k-1)))+DadosDirC4MediaPot(1,(7+8*(k-1)))+DadosDirC4MediaPot(1,(8+8*(k-1))))/8;
end

%% Cálculo do ERD / ERS - Análise dos movimentos mão DIREITA
RC3Dir = sum(DadosDirC3MediaPot(1,500:2000))/(2*SampleRate);
RC4Dir = sum(DadosDirC4MediaPot(1,500:2000))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Dir (k) = ((DadosDirC3Suavizados(k)-RC3Dir)/RC3Dir)*100;
    C4Dir (k) = ((DadosDirC4Suavizados(k)-RC4Dir)/RC4Dir)*100;
end

%% Suavização das curvas - Análise dos movimentos mão ESQUERDA
for k=1:(SampleRate*9)/8
    DadosEsqC3Suavizados(k) = (DadosEsqC3MediaPot(1,(1+8*(k-1)))+DadosEsqC3MediaPot(1,(2+8*(k-1)))+DadosEsqC3MediaPot(1,(3+8*(k-1)))+DadosEsqC3MediaPot(1,(4+8*(k-1)))+DadosEsqC3MediaPot(1,(5+8*(k-1)))+DadosEsqC3MediaPot(1,(6+8*(k-1)))+DadosEsqC3MediaPot(1,(7+8*(k-1)))+DadosEsqC3MediaPot(1,(8+8*(k-1))))/8;
    DadosEsqC4Suavizados(k) = (DadosEsqC4MediaPot(1,(1+8*(k-1)))+DadosEsqC4MediaPot(1,(2+8*(k-1)))+DadosEsqC4MediaPot(1,(3+8*(k-1)))+DadosEsqC4MediaPot(1,(4+8*(k-1)))+DadosEsqC4MediaPot(1,(5+8*(k-1)))+DadosEsqC4MediaPot(1,(6+8*(k-1)))+DadosEsqC4MediaPot(1,(7+8*(k-1)))+DadosEsqC4MediaPot(1,(8+8*(k-1))))/8;
end

%% Cálculo do ERD / ERS - Análise dos movimentos mão ESQUERDA
RC3Esq = sum(DadosEsqC3MediaPot(1,500:2000))/(2*SampleRate);
RC4Esq = sum(DadosEsqC4MediaPot(1,500:2000))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Esq (k) = ((DadosEsqC3Suavizados(k)-RC3Esq)/RC3Esq)*100;
    C4Esq (k) = ((DadosEsqC4Suavizados(k)-RC4Esq)/RC4Esq)*100;
end


%% Plota ERD / ERS
TimeSuavizado = 0:(1/SampleRate)*8:9-((1/SampleRate)*8);
Zeros = zeros (1,length(TimeSuavizado));

%%
% Mão DIREITA
figure;
subplot(2,1,1)
plot(TimeSuavizado,C3Dir,TimeSuavizado,Zeros);
title('C3 (Hemisfério Esquerdo) - Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(2,1,2)
plot(TimeSuavizado,C4Dir,TimeSuavizado,Zeros);
title('C4 (Hemisfério Direito) - Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');

%% 
% Mão ESQUERDA
figure;
subplot(2,1,1)
plot(TimeSuavizado,C3Esq,TimeSuavizado,Zeros);
title('C3 (Hemisfério Esquerdo) - Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
subplot(2,1,2)
plot(TimeSuavizado,C4Esq,TimeSuavizado,Zeros);
title('C4 (Hemisfério Direito) - Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');



