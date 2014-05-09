clear all;
clc;

%% Carregando a coleta e a ordem
load C:\Israel\Engenharia_El�trica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\1104x256patrick2.mat;

Ordem = Ordem1104x256patrick2;
Dados = Touca1104x256patrick2;

% Ordem = Ordem2303x128israels;
% Dados = Coletas2303x128israels;


SampleRate = 256;
QuantColetas = length(Ordem);

%% Separa��o dos sinais entre direita e esquerda
j=1;
k=1;
for i=1:QuantColetas
    if (mod(Ordem(i),2) == 1)
        IndiceEsq(j,:) = i;
        j=j+1;
    else
        IndiceDir(k,:) = i;
        k=k+1;
    end
end

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4� ordem 
OrdemMu=2;
FminMu=10;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4� ordem 
OrdemBeta=2;
FminBeta=25;
FmaxBeta=26;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));


%% An�lise para movimentos com a m�o direita
% DadosDireita recebe somente as coletas com movimento da m�o direita
for k=1:(QuantColetas/2)
    DadosDireita(:,:,k) = Dados(:,:,IndiceDir(k));
end

%%
% An�lise C3 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosDireitaC3(:,k) = DadosDireita(:,2,k); %canal 2 - C3
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC3FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataDirC3); %Aplica o filtro Mu
    DadosDirC3Potencia(k,:) = DadosDirC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% An�lise C4 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosDireitaC4(:,k) = DadosDireita(:,1,k); %canal 1 - C4
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosDirC4FiltradosBeta(k,:) = filter(NumBeta,DenBeta,RawDataDirC4); %Aplica o filtro Beta
    DadosDirC4Potencia(k,:) = DadosDirC4FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a m�dia da potencia
for k=1:(SampleRate*9)
    DadosDirC3MediaPot(k) = sum(DadosDirC3Potencia(:,k))/(QuantColetas/2);
    DadosDirC4MediaPot(k) = sum(DadosDirC4Potencia(:,k))/(QuantColetas/2);
end

%% An�lise para movimentos com a m�o esquerda
% DadosEsquerda recebe somente as coletas com movimento da m�o esquerda
for k=1:(QuantColetas/2)
    DadosEsquerda(:,:,k) = Dados(:,:,IndiceEsq(k));
end

%%
% An�lise C3 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = DadosEsquerda(:,2,k); %canal 2 - C3
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC3FiltradosBeta(k,:) = filter(NumBeta,DenBeta,RawDataEsqC3); %Aplica o filtro Beta
    DadosEsqC3Potencia(k,:) = DadosEsqC3FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% An�lise C4 - Filtra (Banda Mu) e aplica a pot�ncia
for k=1:(QuantColetas/2)
    DadosEsquerdaC4(:,k) = DadosEsquerda(:,1,k); %canal 1 - C4
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    DadosEsqC4FiltradosMu(k,:) = filter(NumMu,DenMu,RawDataEsqC4); %Aplica o filtro Beta
    DadosEsqC4Potencia(k,:) = DadosEsqC4FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado
end

%%
% Calcula a m�dia da potencia
for k=1:(SampleRate*9)
    DadosEsqC3MediaPot(k) = sum(DadosEsqC3Potencia(:,k))/(QuantColetas/2);
    DadosEsqC4MediaPot(k) = sum(DadosEsqC4Potencia(:,k))/(QuantColetas/2);
end

%% Plota os gr�ficos passo a passo do Band Power Method
Time =0:(1/SampleRate):(9-(1/SampleRate));
Coleta=7;

% %% M�o direita
% % ERD 
% figure;
% subplot(4,2,1);
% plot(Time,DadosDireitaC3(:,Coleta));
% Titulo1=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imagina��o do movimento M�o Direita');
% title(Titulo1);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,3);
% plot(Time,DadosDirC3FiltradosMu(Coleta,:));
% Titulo3=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo3);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,5);
% plot(Time,DadosDirC3Potencia(Coleta,:));
% Titulo5=strcat('Sinal C3 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo5);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia [V^2]');
% subplot(4,2,7);
% plot(Time,DadosDirC3MediaPot);
% Titulo7=strcat('Sinal C3 M�dia das pot�ncias');
% title(Titulo7);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia M�dia [V^2]');
% 
% %% 
% % ERS
% subplot(4,2,2);
% plot(Time,DadosDireitaC4(:,Coleta));
% Titulo2=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imagina��o do movimento M�o Direita');
% title(Titulo2);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,4);
% plot(Time,DadosDirC4FiltradosMu(Coleta,:));
% Titulo4=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo4);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,6);
% plot(Time,DadosDirC4Potencia(Coleta,:));
% Titulo6=strcat('Sinal C4 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo6);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia [V^2]');
% subplot(4,2,8);
% plot(Time,DadosDirC4MediaPot);
% Titulo8=strcat('Sinal C4 M�dia das pot�ncias');
% title(Titulo8);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia M�dia [V^2]');
% 
% %% M�o esquerda
% % ERD
% figure;
% subplot(4,2,1)
% plot(Time,DadosEsquerdaC3(:,Coleta));
% Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imagina��o do movimento M�o Esquerda');
% title(Titulo10);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,3)
% plot(Time,DadosEsqC3FiltradosMu(Coleta,:));
% Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo30);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,5)
% plot(Time,DadosEsqC3Potencia(Coleta,:));
% Titulo50=strcat('Sinal C3 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo50);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia [V^2]');
% subplot(4,2,7)
% plot(Time,DadosEsqC3MediaPot);
% Titulo70=strcat('Sinal C3 M�dia das pot�ncias');
% title(Titulo70);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia M�dia [V^2]');
% 
% %%
% % ERS
% subplot(4,2,2);
% plot(Time,DadosEsquerdaC4(:,Coleta));
% Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imagina��o do movimento M�o Esquerda');
% title(Titulo20);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,4);
% plot(Time,DadosEsqC4FiltradosMu(Coleta,:));
% Titulo40=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo40);
% xlabel('Tempo [s]'); 
% ylabel('Tens�o [V]');
% subplot(4,2,6);
% plot(Time,DadosEsqC4Potencia(Coleta,:));
% Titulo60=strcat('Sinal C4 elevado ao quadrado - Pot�ncia (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo60);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia [V^2]');
% subplot(4,2,8);
% plot(Time,DadosEsqC4MediaPot);
% Titulo80=strcat('Sinal C4 M�dia das pot�ncias');
% title(Titulo80);
% xlabel('Tempo [s]'); 
% ylabel('Pot�ncia M�dia [V^2]');


%% Suaviza��o das curvas - An�lise dos movimentos m�o DIREITA
TaxaSuavizacao = 32;
for k=1:(SampleRate*9)/TaxaSuavizacao
    DadosDirC3Suavizados(k) = (DadosDirC3MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(32+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
    DadosDirC4Suavizados(k) = (DadosDirC4MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(32+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
end

%% C�lculo do ERD / ERS - An�lise dos movimentos m�o DIREITA
RC3Dir = mean(DadosDirC3MediaPot(1,1.5*SampleRate:2.5*SampleRate));
RC4Dir = mean(DadosDirC4MediaPot(1,1.5*SampleRate:2.5*SampleRate));

for k=1:(SampleRate*9)/TaxaSuavizacao
    C3Dir (k) = ((DadosDirC3Suavizados(k)-RC3Dir)/RC3Dir)*100;
    C4Dir (k) = ((DadosDirC4Suavizados(k)-RC4Dir)/RC4Dir)*100;
end

%% Suaviza��o das curvas - An�lise dos movimentos m�o ESQUERDA
for k=1:(SampleRate*9)/TaxaSuavizacao
    DadosEsqC3Suavizados(k) = (DadosEsqC3MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(32+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
    DadosEsqC4Suavizados(k) = (DadosEsqC4MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(32+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
end

%% C�lculo do ERD / ERS - An�lise dos movimentos m�o ESQUERDA
RC3Esq = mean(DadosEsqC3MediaPot(1,1.5*SampleRate:2.5*SampleRate));
RC4Esq = mean(DadosEsqC4MediaPot(1,1.5*SampleRate:2.5*SampleRate));

for k=1:(SampleRate*9)/TaxaSuavizacao
    C3Esq (k) = ((DadosEsqC3Suavizados(k)-RC3Esq)/RC3Esq)*100;
    C4Esq (k) = ((DadosEsqC4Suavizados(k)-RC4Esq)/RC4Esq)*100;
end

%% IL
for k=1:(SampleRate*9)/TaxaSuavizacao
    IL(k) = ((DadosEsqC3Suavizados(k)-DadosEsqC4Suavizados(k))+(DadosDirC4Suavizados(k)-DadosDirC4Suavizados(k)))/2;
end

%% Plota ERD / ERS
TimeSuavizado = 0:(1/SampleRate)*TaxaSuavizacao:9-((1/SampleRate)*TaxaSuavizacao);
Zeros = zeros (1,length(TimeSuavizado));

%%
% M�o DIREITA
figure;
subplot(2,1,1)
plot(TimeSuavizado,C3Dir,TimeSuavizado,C4Dir,TimeSuavizado,Zeros);
legend ('C3 (Hemisf�rio Esquerdo)','C4 (Hemisf�rio Direito)');
title('Imagina��o do movimento M�o Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');

%% 
% M�o ESQUERDA
subplot(2,1,2)
plot(TimeSuavizado,C3Esq,TimeSuavizado,C4Esq,TimeSuavizado,Zeros);
legend ('C3 (Hemisf�rio Esquerdo)','C4 (Hemisf�rio Direito)');
title('Imagina��o do movimento M�o Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');

% %% 
% % IL
% figure;
% plot(TimeSuavizado,IL);

