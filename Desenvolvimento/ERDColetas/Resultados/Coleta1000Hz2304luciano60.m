clear all;
clc;


%% Carregando a coleta e a ordem
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano2.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano3.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano4.mat;


Ordem(1:20,:) = Ordem2304x1000luciano1;
Ordem(21:40,:) = Ordem2304x1000luciano2;
Ordem(41:60,:) = Ordem2304x1000luciano4;


Dados(:,:,1:20) = Touca2304x1000luciano1;
Dados(:,:,21:40) = Touca2304x1000luciano2;
Dados(:,:,41:60) = Touca2304x1000luciano4;


SampleRate = 1000;
QuantColetas = length(Ordem);

%% Separação dos sinais entre direita e esquerda
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

%% Filtro passa-baixas 100 Hz - Butterworth 4ª ordem 
Ordem100=2;
Fc100=100;
Wn100=[Fc100]*2/(SampleRate);
[Num100,Den100]=butter(Ordem100,Wn100);
H100=filt(Num100,Den100,(1/SampleRate));

%% Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=2;
FminMu=12;
FmaxMu=13;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

%% Filtro BETA passa-faixas 12-30 Hz - Butterworth 4ª ordem 
OrdemBeta=2;
FminBeta=22;
FmaxBeta=24;
WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
[NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
HBeta=filt(NumBeta,DenBeta,(1/SampleRate));


%% Análise para movimentos com a mão direita
% DadosDireita recebe somente as coletas com movimento da mão direita
for k=1:(QuantColetas/2)
    DadosDireita(:,:,k) = Dados(:,:,IndiceDir(k));
end

%%
% Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC3(:,k) = DadosDireita(:,2,k); %canal 2 - C3
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    Fc100RawDataDirC3 = filter(Num100, Den100, RawDataDirC3);
    DadosDirC3FiltradosMu(k,:) = filter(NumMu,DenMu,Fc100RawDataDirC3); %Aplica o filtro Mu
    DadosDirC3Potencia(k,:) = DadosDirC3FiltradosMu(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosDireitaC4(:,k) = DadosDireita(:,1,k); %canal 1 - C4
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
    Fc100RawDataDirC4 = filter(Num100, Den100, RawDataDirC4);
    DadosDirC4FiltradosBeta(k,:) = filter(NumBeta,DenBeta,Fc100RawDataDirC4); %Aplica o filtro Beta
    DadosDirC4Potencia(k,:) = DadosDirC4FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado
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
    DadosEsquerda(:,:,k) = Dados(:,:,IndiceEsq(k));
end

%%
% Análise C3 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = DadosEsquerda(:,2,k); %canal 2 - C3
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    Fc100RawDataEsqC3 = filter(Num100, Den100, RawDataEsqC3);
    DadosEsqC3FiltradosBeta(k,:) = filter(NumBeta,DenBeta,Fc100RawDataEsqC3); %Aplica o filtro Beta
    DadosEsqC3Potencia(k,:) = DadosEsqC3FiltradosBeta(k,:).^2; %Calcula a potencia ao quadrado 
end

%%
% Análise C4 - Filtra (Banda Mu) e aplica a potência
for k=1:(QuantColetas/2)
    DadosEsquerdaC4(:,k) = DadosEsquerda(:,1,k); %canal 1 - C4
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    Fc100RawDataEsqC4 = filter(Num100, Den100, RawDataEsqC4);
    DadosEsqC4FiltradosMu(k,:) = filter(NumMu,DenMu,Fc100RawDataEsqC4); %Aplica o filtro Beta
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

% %% Mão direita
% % ERD 
% figure;
% subplot(4,2,1);
% plot(Time,DadosDireitaC3(:,Coleta));
% Titulo1=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
% title(Titulo1);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,3);
% plot(Time,DadosDirC3FiltradosMu(Coleta,:));
% Titulo3=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo3);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,5);
% plot(Time,DadosDirC3Potencia(Coleta,:));
% Titulo5=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo5);
% xlabel('Tempo [s]'); 
% ylabel('Potência [V^2]');
% subplot(4,2,7);
% plot(Time,DadosDirC3MediaPot);
% Titulo7=strcat('Sinal C3 Média das potências');
% title(Titulo7);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');
% 
% %% 
% % ERS
% subplot(4,2,2);
% plot(Time,DadosDireitaC4(:,Coleta));
% Titulo2=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceDir(Coleta)),') - Imaginação do movimento Mão Direita');
% title(Titulo2);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,4);
% plot(Time,DadosDirC4FiltradosMu(Coleta,:));
% Titulo4=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo4);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,6);
% plot(Time,DadosDirC4Potencia(Coleta,:));
% Titulo6=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceDir(Coleta)),')');
% title(Titulo6);
% xlabel('Tempo [s]'); 
% ylabel('Potência [V^2]');
% subplot(4,2,8);
% plot(Time,DadosDirC4MediaPot);
% Titulo8=strcat('Sinal C4 Média das potências');
% title(Titulo8);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');
% 
% %% Mão esquerda
% % ERD
% figure;
% subplot(4,2,1)
% plot(Time,DadosEsquerdaC3(:,Coleta));
% Titulo10=strcat('Sinal C3 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
% title(Titulo10);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,3)
% plot(Time,DadosEsqC3FiltradosMu(Coleta,:));
% Titulo30=strcat('Sinal C3 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo30);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,5)
% plot(Time,DadosEsqC3Potencia(Coleta,:));
% Titulo50=strcat('Sinal C3 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo50);
% xlabel('Tempo [s]'); 
% ylabel('Potência [V^2]');
% subplot(4,2,7)
% plot(Time,DadosEsqC3MediaPot);
% Titulo70=strcat('Sinal C3 Média das potências');
% title(Titulo70);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');
% 
% %%
% % ERS
% subplot(4,2,2);
% plot(Time,DadosEsquerdaC4(:,Coleta));
% Titulo20=strcat('Sinal C4 bruto (Coleta ',int2str(IndiceEsq(Coleta)),') - Imaginação do movimento Mão Esquerda');
% title(Titulo20);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,4);
% plot(Time,DadosEsqC4FiltradosMu(Coleta,:));
% Titulo40=strcat('Sinal C4 Filtrado Mu 8-11 Hz (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo40);
% xlabel('Tempo [s]'); 
% ylabel('Tensão [V]');
% subplot(4,2,6);
% plot(Time,DadosEsqC4Potencia(Coleta,:));
% Titulo60=strcat('Sinal C4 elevado ao quadrado - Potência (Coleta ',int2str(IndiceEsq(Coleta)),')');
% title(Titulo60);
% xlabel('Tempo [s]'); 
% ylabel('Potência [V^2]');
% subplot(4,2,8);
% plot(Time,DadosEsqC4MediaPot);
% Titulo80=strcat('Sinal C4 Média das potências');
% title(Titulo80);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');


%% Suavização das curvas - Análise dos movimentos mão DIREITA
TaxaSuavizacao = 90;
for k=1:(SampleRate*9)/TaxaSuavizacao 
    DadosDirC3Suavizados(k) = (DadosDirC3MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(32+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(33+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(34+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(35+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(36+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(37+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(38+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(39+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(40+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(41+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(42+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(43+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(44+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(45+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(46+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(47+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(48+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(49+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(50+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(51+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(52+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(53+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(54+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(55+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(56+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(57+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(58+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(59+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(60+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(61+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(62+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(63+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(64+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(65+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(66+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(67+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(68+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(69+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(70+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(71+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(72+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(73+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(74+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(75+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(76+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(77+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(78+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(79+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(80+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(81+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(82+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(83+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(84+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(85+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(86+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(87+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(88+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(89+TaxaSuavizacao*(k-1)))+DadosDirC3MediaPot(1,(90+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
    DadosDirC4Suavizados(k) = (DadosDirC4MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(32+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(33+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(34+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(35+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(36+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(37+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(38+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(39+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(40+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(41+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(42+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(43+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(44+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(45+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(46+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(47+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(48+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(49+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(50+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(51+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(52+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(53+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(54+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(55+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(56+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(57+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(58+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(59+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(60+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(61+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(62+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(63+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(64+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(65+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(66+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(67+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(68+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(69+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(70+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(71+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(72+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(73+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(74+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(75+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(76+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(77+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(78+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(79+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(80+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(81+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(82+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(83+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(84+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(85+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(86+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(87+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(88+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(89+TaxaSuavizacao*(k-1)))+DadosDirC4MediaPot(1,(90+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
end

%% Cálculo do ERD / ERS - Análise dos movimentos mão DIREITA
RC3Dir = mean(DadosDirC3MediaPot(1,1000:2000));
RC4Dir = mean(DadosDirC4MediaPot(1,1000:2000));
for k=1:(SampleRate*9)/TaxaSuavizacao 
    C3Dir (k) = ((DadosDirC3Suavizados(k)-RC3Dir)/RC3Dir)*100;
    C4Dir (k) = ((DadosDirC4Suavizados(k)-RC4Dir)/RC4Dir)*100;
end

%% Suavização das curvas - Análise dos movimentos mão ESQUERDA
for k=1:(SampleRate*9)/TaxaSuavizacao
    DadosEsqC3Suavizados(k) = (DadosEsqC3MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(32+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(33+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(34+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(35+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(36+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(37+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(38+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(39+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(40+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(41+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(42+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(43+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(44+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(45+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(46+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(47+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(48+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(49+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(50+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(51+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(52+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(53+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(54+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(55+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(56+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(57+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(58+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(59+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(60+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(61+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(62+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(63+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(64+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(65+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(66+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(67+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(68+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(69+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(70+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(71+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(72+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(73+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(74+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(75+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(76+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(77+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(78+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(79+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(80+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(81+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(82+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(83+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(84+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(85+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(86+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(87+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(88+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(89+TaxaSuavizacao*(k-1)))+DadosEsqC3MediaPot(1,(90+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
    DadosEsqC4Suavizados(k) = (DadosEsqC4MediaPot(1,(1+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(2+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(3+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(4+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(5+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(6+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(7+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(8+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(9+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(10+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(11+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(12+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(13+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(14+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(15+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(16+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(17+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(18+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(19+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(20+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(21+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(22+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(23+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(24+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(25+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(26+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(27+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(28+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(29+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(30+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(31+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(32+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(33+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(34+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(35+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(36+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(37+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(38+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(39+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(40+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(41+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(42+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(43+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(44+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(45+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(46+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(47+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(48+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(49+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(50+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(51+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(52+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(53+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(54+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(55+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(56+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(57+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(58+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(59+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(60+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(61+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(62+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(63+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(64+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(65+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(66+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(67+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(68+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(69+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(70+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(71+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(72+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(73+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(74+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(75+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(76+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(77+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(78+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(79+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(80+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(81+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(82+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(83+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(84+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(85+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(86+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(87+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(88+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(89+TaxaSuavizacao*(k-1)))+DadosEsqC4MediaPot(1,(90+TaxaSuavizacao*(k-1))))/TaxaSuavizacao;
end

%% Cálculo do ERD / ERS - Análise dos movimentos mão ESQUERDA
RC3Esq = mean(DadosEsqC3MediaPot(1,1000:2000));
RC4Esq = mean(DadosEsqC4MediaPot(1,1000:2000));
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
% Mão DIREITA
figure;
subplot(2,1,1)
plot(TimeSuavizado,C3Dir,TimeSuavizado,C4Dir,TimeSuavizado,Zeros);
legend ('C3/Esq','C4/Dir');
title('Imaginação do movimento Mão Direita');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
axis ([0 9 -100 200]);

%% 
% Mão ESQUERDA
subplot(2,1,2)
plot(TimeSuavizado,C3Esq,TimeSuavizado,C4Esq,TimeSuavizado,Zeros);
legend ('C3/Esq','C4/Dir');
title('Imaginação do movimento Mão Esquerda');
xlabel('Tempo [s]'); 
ylabel('Potencia Relativa [%]');
axis ([0 9 -100 200]);


%% 
% % IL
% figure;
% plot(TimeSuavizado,IL);



