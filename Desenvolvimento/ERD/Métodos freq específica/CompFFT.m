%FFT
clear all;
clc;

load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

QuantColetas = 140;
SampleRate = 128;

IndiceEsq=find(y_train==1); %encontra os sinais relacionados à mão esquerda
IndiceDir=find(y_train==2); %encontra os sinais relacionados à mão direita

%%DadosEsquerda recebe somente as coletas com movimento da mão esquerda
for k=1:(QuantColetas/2)
    DadosEsquerdaC3(:,k) = x_train (:,1,IndiceEsq(k));
    DadosEsquerdaC4(:,k) = x_train (:,3,IndiceEsq(k));
    DadosDireitaC3(:,k) = x_train (:,1,IndiceDir(k));
    DadosDireitaC4(:,k) = x_train (:,3,IndiceDir(k));
    
    RawDataEsqC3 = mapminmax(DadosEsquerdaC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataEsqC4 = mapminmax(DadosEsquerdaC4(:,k)'); %normaliza os dados entre -1 e 1
    RawDataDirC3 = mapminmax(DadosDireitaC3(:,k)'); %normaliza os dados entre -1 e 1
    RawDataDirC4 = mapminmax(DadosDireitaC4(:,k)'); %normaliza os dados entre -1 e 1
   
    DadosEsqC3Potencia(k,:) = RawDataEsqC3.^2; %Calcula a potencia ao quadrado 
    DadosEsqC4Potencia(k,:) = RawDataEsqC4.^2; %Calcula a potencia ao quadrado 
    DadosDirC3Potencia(k,:) = RawDataDirC3.^2; %Calcula a potencia ao quadrado 
    DadosDirC4Potencia(k,:) = RawDataDirC4.^2; %Calcula a potencia ao quadrado 

end

ToMu = 4;
TfMu = 5;

ToAlpha = 4;
TfAlpha = 5;


dados = DadosDirC4Potencia(15,:); 

%Atividade
%dadosATIVIDADE = dados(1,(ToMu*SampleRate):(TfMu*SampleRate));
dadosATIVIDADE = dados(1,(ToAlpha*SampleRate):(TfAlpha*SampleRate));

%vetor de tempo
%time=0:(1/SampleRate):(9-(1/SampleRate));
time = 0:(length(dadosATIVIDADE)-1);

%armazena o tamanho do vetor
L = length(dadosATIVIDADE);
%frequencia de amostragem [Hz]
fs=128;
%procura qual é a potência de 2 (2^x) na qual 
%mais se aproxima do tamanho de L. Isso otimiza o 
%tempo de calculo do algoritmo em até 100x.
p = 2^nextpow2(L);
%calcula a fft do conteudo de "dados" com a quantidade de pontos 2^p  
Y = fft(dadosATIVIDADE,p);
%descarta as amostras negativas - da metade pra frente.
indiceNyquist = p/2+1;
Y = Y (1:indiceNyquist);
%por ser a soma dos termos, a FFT deve ser dividido pela 
%quantidade de pontos.
Y = Y/p;
%quando a frequencia é espelhada no plano negativo,
%ela divide por 2 a amplitude. Agora que desprezamos 
%plano negativo, precisamos compensar e multiplicar por 2.
%a partir do segundo termo, pois o primeiro é o DC
%de frequencia = 0.
Y(2:end) = 2* Y(2:end);
%calcula a magnitude 
%abs retora a magnitude para numeros complexos
magnitude = abs(Y);
%resolução de frequencia
deltaf = fs/p;
%eixo x - range de frequencias
fx = [0:indiceNyquist-1]*deltaf;

%REFERENCIA
dadosREFERENCIA = dados(1,(0.5*SampleRate):(1.5*SampleRate));
%vetor de tempo
%time=0:(1/SampleRate):(9-(1/SampleRate));
timeREF = 0:(length(dadosREFERENCIA)-1);

%armazena o tamanho do vetor
LREF = length(dadosREFERENCIA);
%frequencia de amostragem [Hz]
fsREF=128;
%procura qual é a potência de 2 (2^x) na qual 
%mais se aproxima do tamanho de L. Isso otimiza o 
%tempo de calculo do algoritmo em até 100x.
pREF = 2^nextpow2(LREF);
%calcula a fft do conteudo de "dados" com a quantidade de pontos 2^p  
YREF = fft(dadosREFERENCIA,pREF);
%descarta as amostras negativas - da metade pra frente.
indiceNyquist2 = pREF/2+1;
YREF = YREF (1:indiceNyquist2);
%por ser a soma dos termos, a FFT deve ser dividido pela 
%quantidade de pontos.
YREF = YREF/pREF;
%quando a frequencia é espelhada no plano negativo,
%ela divide por 2 a amplitude. Agora que desprezamos 
%plano negativo, precisamos compensar e multiplicar por 2.
%a partir do segundo termo, pois o primeiro é o DC
%de frequencia = 0.
YREF(2:end) = 2* YREF(2:end);
%calcula a magnitude 
%abs retora a magnitude para numeros complexos
magnitudeREF = abs(YREF);
%resolução de frequencia
deltafREF = fsREF/pREF;
%eixo x - range de frequencias
fxREF = [0:indiceNyquist2-1]*deltafREF;

%plota os graficos
figure;

%plota o gráfico da FFT
plot(fx, magnitude,fxREF,magnitudeREF); 
legend('Atividade','Referência');
title('Comparação entre 1 seg de Atividade / Referencia');
grid on; 
xlabel('Frequência [Hz]'); 
ylabel('Magnitude [Unidade]'); 
%axis([8 30 0 .05])

