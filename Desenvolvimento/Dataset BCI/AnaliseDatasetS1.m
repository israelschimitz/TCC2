clear all;
clc;
load C:\Israel\Engenharia_El�trica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

SampleRate = 128;
QuantColetas = 140;

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4� ordem 
OrdemMu=2;
FminMu=9;
FmaxMu=12;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4� ordem 
OrdemBeta=2;
FminBeta=19;
FmaxBeta=22;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

%% Separa��o dos sinais entre direita e esquerda
IndiceEsq=find(y_train==1); %encontra os sinais relacionados � m�o esquerda
IndiceDir=find(y_train==2); %encontra os sinais relacionados � m�o direita

%% An�lise para movimentos com a m�o direita
% DadosDireita recebe somente as coletas com movimento da m�o direita
for k=1:(QuantColetas/2)
    DadosDireita(:,:,k) = x_train (:,:,IndiceDir(k));
end

%%
% An�lise C3 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosDireitaC3(:,k) = DadosDireita(:,1,k); %canal 1 - C3
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC3FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirC3); %Aplica o filtro Mu
    DadosDirC3Potencia(k,:) = DadosDirC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% DadosDiretaCz recebe os dados do eletrodo Cz - canal 2
for k=1:(QuantColetas/2)
    DadosDireitaCz(:,k) = DadosDireita(:,2,k);
    RawDataDirCz = mapminmax(DadosDireitaCz(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirCzFiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirCz); %Aplica o filtro Mu
    DadosDirCzPotencia(k,:) = DadosDirCzFiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% An�lise C4 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosDireitaC4(:,k) = DadosDireita(:,3,k);%canal 3 - C4
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC4FiltradosBeta(k,:) = filter(NumBeta,DenBeta,RawDataDirC4); %Aplica o filtro Beta
    DadosDirC4Potencia(k,:) = DadosDirC4FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a m�dia da potencia
for k=1:(SampleRate*9)
    DadosDirC3MediaPot(k) = sum(DadosDirC3Potencia(:,k))/(QuantColetas/2);
    DadosDirC4MediaPot(k) = sum(DadosDirC4Potencia(:,k))/(QuantColetas/2);
    DadosDirCzMediaPot(k) = sum(DadosDirCzPotencia(:,k))/(QuantColetas/2);
end

%% An�lise para movimentos com a m�o esquerda
% DadosEsquerda recebe somente as coletas com movimento da m�o esquerda
for k=1:(QuantColetas/2)
    DadosEsquerda(:,:,k) = x_train (:,:,IndiceEsq(k));
end

%%
% An�lise C3 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = DadosEsquerda(:,1,k); %canal 1 - C3
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC3FiltradosBeta(k,:) = filter(NumBeta,DenBeta,RawDataEsqC3); %Aplica o filtro Beta
    DadosEsqC3Potencia(k,:) = DadosEsqC3FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% DadosEsquerdaCz recebe os dados do eletrodo Cz - canal 2
for k=1:(QuantColetas/2)
    DadosEsquerdaCz(:,k) = DadosEsquerda(:,2,k);
    RawDataEsqCz = mapminmax(DadosEsquerdaCz(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqCzFiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqCz); %Aplica o filtro Mu
    DadosEsqCzPotencia(k,:) = DadosEsqCzFiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% An�lise C4 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosEsquerdaC4(:,k) = DadosEsquerda(:,3,k);%canal 3 - C4
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC4FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqC4); %Aplica o filtro Beta
    DadosEsqC4Potencia(k,:) = DadosEsqC4FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a m�dia da potencia
for k=1:(SampleRate*9)
    DadosEsqC3MediaPot(k) = sum(DadosEsqC3Potencia(:,k))/(QuantColetas/2);
    DadosEsqC4MediaPot(k) = sum(DadosEsqC4Potencia(:,k))/(QuantColetas/2);
    DadosEsqCzMediaPot(k) = sum(DadosEsqCzPotencia(:,k))/(QuantColetas/2);
end

%% Plota os gr�ficos passo a passo do Band Power Method
Time =0:(1/SampleRate):(9-(1/SampleRate));
Coleta=10;

%% M�o direita
% ERD 
figure;
subplot(4,2,1);
plot(Time,DadosDireitaC3(:,IndiceDir(Coleta)));
Titulo1=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imagina��o do movimento M�o Direita');
title(Titulo1);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,3);
plot(Time,DadosDirC3FiltradosMu(IndiceDir(Coleta),:));
Titulo3=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo3);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,5);
plot(Time,DadosDirC3Potencia(IndiceDir(Coleta),:));
Titulo5=strcat('Sinal C3 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo5);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia [V^2]');
subplot(4,2,7);
plot(Time,DadosDirC3MediaPot);
Titulo7=strcat('Sinal C3 M�dia das pot�ncias');
title(Titulo7);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia M�dia [V^2]');

%% 
% ERS
subplot(4,2,2);
plot(Time,DadosDireitaC4(:,IndiceDir(Coleta)));
Titulo2=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imagina��o do movimento M�o Direita');
title(Titulo2);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,4);
plot(Time,DadosDirC4FiltradosBeta(IndiceDir(Coleta),:));
Titulo4=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo4);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,6);
plot(Time,DadosDirC4Potencia(IndiceDir(Coleta),:));
Titulo6=strcat('Sinal C4 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceDir(Coleta)),')');
title(Titulo6);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia [V^2]');
subplot(4,2,8);
plot(Time,DadosDirC4MediaPot);
Titulo8=strcat('Sinal C4 M�dia das pot�ncias');
title(Titulo8);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia M�dia [V^2]');

%% M�o esquerda
% ERD
figure;
subplot(4,2,1)
plot(Time,DadosEsquerdaC3(:,IndiceEsq(Coleta)));
Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imagina��o do movimento M�o Esquerda');
title(Titulo10);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,3)
plot(Time,DadosEsqC3FiltradosBeta(IndiceEsq(Coleta),:));
Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo30);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,5)
plot(Time,DadosEsqC3Potencia(IndiceEsq(Coleta),:));
Titulo50=strcat('Sinal C3 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo50);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia [V^2]');
subplot(4,2,7)
plot(Time,DadosEsqC3MediaPot);
Titulo70=strcat('Sinal C3 M�dia das pot�ncias');
title(Titulo70);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia M�dia [V^2]');

%%
% ERS
subplot(4,2,2);
plot(Time,DadosEsquerdaC4(:,IndiceEsq(Coleta)));
Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imagina��o do movimento M�o Esquerda');
title(Titulo20);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,4);
plot(Time,DadosEsqC4FiltradosMu(IndiceEsq(Coleta),:));
Titulo40=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo40);
xlabel('Tempo [s]'); 
ylabel('Tens�o [V]');
subplot(4,2,6);
plot(Time,DadosEsqC4Potencia(IndiceEsq(Coleta),:));
Titulo60=strcat('Sinal C4 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceEsq(Coleta)),')');
title(Titulo60);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia [V^2]');
subplot(4,2,8);
plot(Time,DadosEsqC4MediaPot);
Titulo80=strcat('Sinal C4 M�dia das pot�ncias');
title(Titulo80);
xlabel('Tempo [s]'); 
ylabel('Pot�ncia M�dia [V^2]');


%% Suaviza��o das curvas - An�lise dos movimentos m�o DIREITA
for k=1:(SampleRate*9)/8
    DadosDirC3Suavizados(k) = (DadosDirC3MediaPot(1,(1+8*(k-1)))+DadosDirC3MediaPot(1,(2+8*(k-1)))+DadosDirC3MediaPot(1,(3+8*(k-1)))+DadosDirC3MediaPot(1,(4+8*(k-1)))+DadosDirC3MediaPot(1,(5+8*(k-1)))+DadosDirC3MediaPot(1,(6+8*(k-1)))+DadosDirC3MediaPot(1,(7+8*(k-1)))+DadosDirC3MediaPot(1,(8+8*(k-1))))/8;
    DadosDirCzSuavizados(k) = (DadosDirCzMediaPot(1,(1+8*(k-1)))+DadosDirCzMediaPot(1,(2+8*(k-1)))+DadosDirCzMediaPot(1,(3+8*(k-1)))+DadosDirCzMediaPot(1,(4+8*(k-1)))+DadosDirCzMediaPot(1,(5+8*(k-1)))+DadosDirCzMediaPot(1,(6+8*(k-1)))+DadosDirCzMediaPot(1,(7+8*(k-1)))+DadosDirCzMediaPot(1,(8+8*(k-1))))/8;
    DadosDirC4Suavizados(k) = (DadosDirC4MediaPot(1,(1+8*(k-1)))+DadosDirC4MediaPot(1,(2+8*(k-1)))+DadosDirC4MediaPot(1,(3+8*(k-1)))+DadosDirC4MediaPot(1,(4+8*(k-1)))+DadosDirC4MediaPot(1,(5+8*(k-1)))+DadosDirC4MediaPot(1,(6+8*(k-1)))+DadosDirC4MediaPot(1,(7+8*(k-1)))+DadosDirC4MediaPot(1,(8+8*(k-1))))/8;
end

%% C�lculo do ERD / ERS - An�lise dos movimentos m�o DIREITA
RC3Dir = sum(DadosDirC3MediaPot(1,65:321))/(2*SampleRate);
RC4Dir = sum(DadosDirC4MediaPot(1,65:321))/(2*SampleRate);
RCzDir = sum(DadosDirCzMediaPot(1,65:321))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Dir (k) = ((DadosDirC3Suavizados(k)-RC3Dir)/RC3Dir)*100;
    CzDir (k) = ((DadosDirCzSuavizados(k)-RCzDir)/RCzDir)*100;
    C4Dir (k) = ((DadosDirC4Suavizados(k)-RC4Dir)/RC4Dir)*100;
end

%% Suaviza��o das curvas - An�lise dos movimentos m�o ESQUERDA
for k=1:(SampleRate*9)/8
    DadosEsqC3Suavizados(k) = (DadosEsqC3MediaPot(1,(1+8*(k-1)))+DadosEsqC3MediaPot(1,(2+8*(k-1)))+DadosEsqC3MediaPot(1,(3+8*(k-1)))+DadosEsqC3MediaPot(1,(4+8*(k-1)))+DadosEsqC3MediaPot(1,(5+8*(k-1)))+DadosEsqC3MediaPot(1,(6+8*(k-1)))+DadosEsqC3MediaPot(1,(7+8*(k-1)))+DadosEsqC3MediaPot(1,(8+8*(k-1))))/8;
    DadosEsqCzSuavizados(k) = (DadosEsqCzMediaPot(1,(1+8*(k-1)))+DadosEsqCzMediaPot(1,(2+8*(k-1)))+DadosEsqCzMediaPot(1,(3+8*(k-1)))+DadosEsqCzMediaPot(1,(4+8*(k-1)))+DadosEsqCzMediaPot(1,(5+8*(k-1)))+DadosEsqCzMediaPot(1,(6+8*(k-1)))+DadosEsqCzMediaPot(1,(7+8*(k-1)))+DadosEsqCzMediaPot(1,(8+8*(k-1))))/8;
    DadosEsqC4Suavizados(k) = (DadosEsqC4MediaPot(1,(1+8*(k-1)))+DadosEsqC4MediaPot(1,(2+8*(k-1)))+DadosEsqC4MediaPot(1,(3+8*(k-1)))+DadosEsqC4MediaPot(1,(4+8*(k-1)))+DadosEsqC4MediaPot(1,(5+8*(k-1)))+DadosEsqC4MediaPot(1,(6+8*(k-1)))+DadosEsqC4MediaPot(1,(7+8*(k-1)))+DadosEsqC4MediaPot(1,(8+8*(k-1))))/8;
end

%% C�lculo do ERD / ERS - An�lise dos movimentos m�o ESQUERDA
RC3Esq = sum(DadosEsqC3MediaPot(1,65:321))/(2*SampleRate);
RC4Esq = sum(DadosEsqC4MediaPot(1,65:321))/(2*SampleRate);
RCzEsq = sum(DadosEsqCzMediaPot(1,65:321))/(2*SampleRate);
for k=1:(SampleRate*9)/8
    C3Esq (k) = ((DadosEsqC3Suavizados(k)-RC3Esq)/RC3Esq)*100;
    CzEsq (k) = ((DadosEsqCzSuavizados(k)-RCzEsq)/RCzEsq)*100;
    C4Esq (k) = ((DadosEsqC4Suavizados(k)-RC4Esq)/RC4Esq)*100;
end


%% Plota ERD / ERS
TimeSuavizado = 0:(1/SampleRate)*8:9-((1/SampleRate)*8);
Zeros = zeros (1,length(TimeSuavizado));
Linha = linspace(-100,200,300);
% %%
% % M�o DIREITA
% figure;
% subplot(3,1,1)
% plot(TimeSuavizado,C3Dir,TimeSuavizado,Zeros);
% title('C3 (Hemisf�rio Esquerdo) - Imagina��o do movimento M�o Direita');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
% subplot(3,1,2)
% plot(TimeSuavizado,CzDir,TimeSuavizado,Zeros);
% title('Cz (Central) - Imagina��o do movimento M�o Direita');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
% subplot(3,1,3)
% plot(TimeSuavizado,C4Dir,TimeSuavizado,Zeros);
% title('C4 (Hemisf�rio Direito) - Imagina��o do movimento M�o Direita');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
% 
% %% 
% % M�o ESQUERDA
% figure;
% subplot(3,1,1)
% plot(TimeSuavizado,C3Esq,TimeSuavizado,Zeros);
% title('C3 (Hemisf�rio Esquerdo) - Imagina��o do movimento M�o Esquerda');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
% subplot(3,1,2)
% plot(TimeSuavizado,CzEsq,TimeSuavizado,Zeros);
% title('Cz (Central) - Imagina��o do movimento M�o Esquerda');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
% subplot(3,1,3)
% plot(TimeSuavizado,C4Esq,TimeSuavizado,Zeros);
% title('C4 (Hemisf�rio Direito) - Imagina��o do movimento M�o Esquerda');
% xlabel('Tempo [s]'); 
% ylabel('Potencia Relativa [%]');
  
%%
% M�o DIREITA
figure;
subplot(2,1,1)
plot(TimeSuavizado,C3Dir,TimeSuavizado,C4Dir,3,Linha);
legend ('C3/Esq','C4/Dir');
title('Imagina��o do movimento M�o Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
axis([0 9 -100 200]);

%% 
% M�o ESQUERDA
subplot(2,1,2)
plot(TimeSuavizado,C3Esq,TimeSuavizado,C4Esq,3,Linha);
legend ('C3/Esq','C4/Dir)');
title('Imagina��o do movimento M�o Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
axis([0 9 -100 200]);
