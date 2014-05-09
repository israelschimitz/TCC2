%FFT
% clear all;
% clc;
%load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

SampleRate = 1000;
Coleta = 3; %de 1 até 140
Eletrodo = 1;   %C3(esquerda) - 1
                %Cz(centro)   - 2
                %C4(direita)  - 3

%-----------Cálculo FFT--------------------------------
%armazena os dados que serão calculados em "dados"
%dados = Touca1104x256patrick2(3.5*SampleRate:4.5*SampleRate,2,Coleta); % coleta 2 - eletrodo C4
dados = DadosC4FilterMu(1:1000,1);
% dados = Fc100RawDataDirC4;
%vetor de tempo
%time=0:(1/SampleRate):(9-(1/SampleRate));
time = 0:(length(dados)-1);


%armazena o tamanho do vetor
L = length(dados);
%frequencia de amostragem [Hz]
% SampleRate=1000;
%procura qual é a potência de 2 (2^x) na qual 
%mais se aproxima do tamanho de L. Isso otimiza o 
%tempo de calculo do algoritmo em até 100x.
p = 2^nextpow2(L);
%calcula a fft do conteudo de "dados" com a quantidade de pontos 2^p  
Y = fft(dados,p);
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
deltaf = SampleRate/p;
%eixo x - range de frequencias
fx = [0:indiceNyquist-1]*deltaf;


%plota os graficos
figure;

%plota o gráfico no tempo
subplot(2,1,1);
plot(time,dados);
if(Eletrodo == 1)
    TituloTempo=strcat('Sinal C3 no tempo (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 2)
    TituloTempo=strcat('Sinal Cz no tempo (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 3)
    TituloTempo=strcat('Sinal C4 no tempo (Coleta ',int2str(Coleta),')');
end
title(TituloTempo);
grid on; 
xlabel('Tempo [s]'); 
ylabel('Tensão [V]');

%plota o gráfico da FFT
subplot(2,1,2);
plot(fx, magnitude); 
if(Eletrodo == 1)
    TituloFreq=strcat('Sinal C3 em frequência (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 2)
    TituloFreq=strcat('Sinal Cz em frequência (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 3)
    TituloFreq=strcat('Sinal C4 em frequência (Coleta ',int2str(Coleta),')');
end
title(TituloTempo);
grid on; 
xlabel('Frequência [Hz]'); 
ylabel('Magnitude [Unidade]'); 

