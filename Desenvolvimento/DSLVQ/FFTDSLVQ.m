%% FFT para aplicação no DSLVQ
% Função extrair as componente entre 8 a 30 Hz.

function [Return] = FFTDSLVQ(Data,SR)

%FFT
SampleRate = SR;

%-----------Cálculo FFT--------------------------------
%armazena os dados que serão calculados em "dados"
dados = Data;

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
m=1;
for k=1:length(fx)
    if (8<=(fx(k)))&(fx(k)<=30)
        Return(m,:) = magnitude(k);
        m=m+1;
    end
end



