% sinal = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta.xls');
% sinal1 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta1.xls');
% sinal2 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta2.xls');
% sinal3 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta3.xls');
% sinal4 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta4.xls');
% sinal5 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\EEG_Michel\Roberta_03-10\roberta5.xls');
% 
% C3 = sinal (:,1);
% C3_1 = sinal1 (:,1);
% C3_2 = sinal2 (:,1);
% C3_3 = sinal3 (:,1);
% C3_4 = sinal4 (:,1);
% C3_5 = sinal5 (:,1);
% 
% C4 = sinal (:,3);
% C4_1 = sinal1 (:,3);
% C4_2 = sinal2 (:,3);
% C4_3 = sinal3 (:,3);
% C4_4 = sinal4 (:,3);
% C4_5 = sinal5 (:,3);
% 
% figure;
% subplot (2,2,1);
% plot(C3);
% title ('Coleta 1 - C3');
% subplot (2,2,2);
% plot(C4);
% title ('Coleta 1 - C4');
% subplot (2,2,3);
% plot(C3_1);
% title ('Coleta 2 - C3');
% subplot (2,2,4);
% plot(C4_1);
% title ('Coleta 2 - C4');
% 
% figure;
% subplot (2,2,1);
% plot(C3_2);
% title ('Coleta 3 - C3');
% subplot (2,2,2);
% plot(C4_2);
% title ('Coleta 3 - C4');
% subplot (2,2,3);
% plot(C3_3);
% title ('Coleta 4 - C3');
% subplot (2,2,4);
% plot(C4_3);
% title ('Coleta 4 - C4');
% 
% figure;
% subplot (2,2,1);
% plot(C3_4);
% title ('Coleta 5 - C3');
% subplot (2,2,2);
% plot(C4_4);
% title ('Coleta 5 - C4');
% subplot (2,2,3);
% plot(C3_5);
% title ('Coleta 6 - C3');
% subplot (2,2,4);
% plot(C4_5);
% title ('Coleta 6 - C4');

%Processamento dos dados

%-----------Cálculo FFT--------------------------------
%armazena os dados que serão calculados em "dados"
dados = C4_5';

%armazena o tamanho do vetor
L = length(dados);

%frequencia de amostragem [Hz]
fs=1000;

%procura qual é a potência de 2 (2^x) na qual 
%mais se aproxima do tamanho de L. Isso otimiza o 
%tempo de calculo do algoritmo em até 100x.
%Por exemplo, o algoritmo é mais rapido com a quantidade de 1024 (2^10)    
%pontos do que um com 1000 pontos.
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
deltaf = fs/p;

%eixo x - range de frequencias
fx = [0:indiceNyquist-1]*deltaf;

figure;
%plota o gráfico da FFT
plot(fx, magnitude); 
axis ([0 50 0 .3]);
title ('Coleta 6 - C4');
grid on; 
xlabel('Frequência [Hz]'); 
ylabel('Magnitude [Unidade]'); 