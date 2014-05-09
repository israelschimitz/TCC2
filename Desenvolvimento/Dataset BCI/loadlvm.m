
A = xlsread('C:\Israel\Engenharia_El�trica\Disciplinas\TCC1\Coletas\Dados\eegbipolarfone\coletas14.11\israel14.11 segunda\user_15.xls');

C3 = A(:,1);
C4 = A(:,2);


SampleRate = 1000;
Coleta = 100; %de 1 at� 140
Eletrodo = 1;   %C3(esquerda) - 1
                %Cz(centro)   - 2
                %C4(direita)  - 3

%-----------C�lculo FFT--------------------------------
%armazena os dados que ser�o calculados em "dados"
dados = C3; % coleta 2 - eletrodo C4

%vetor de tempo
%time=0:(1/SampleRate):(9-(1/SampleRate));
time = 0:(length(dados)-1);


%armazena o tamanho do vetor
L = length(dados);
%frequencia de amostragem [Hz]
fs=SampleRate;
%procura qual � a pot�ncia de 2 (2^x) na qual 
%mais se aproxima do tamanho de L. Isso otimiza o 
%tempo de calculo do algoritmo em at� 100x.
p = 2^nextpow2(L);
%calcula a fft do conteudo de "dados" com a quantidade de pontos 2^p  
Y = fft(dados,p);
%descarta as amostras negativas - da metade pra frente.
indiceNyquist = p/2+1;
Y = Y (1:indiceNyquist);
%por ser a soma dos termos, a FFT deve ser dividido pela 
%quantidade de pontos.
Y = Y/p;
%quando a frequencia � espelhada no plano negativo,
%ela divide por 2 a amplitude. Agora que desprezamos 
%plano negativo, precisamos compensar e multiplicar por 2.
%a partir do segundo termo, pois o primeiro � o DC
%de frequencia = 0.
Y(2:end) = 2* Y(2:end);
%calcula a magnitude 
%abs retora a magnitude para numeros complexos
magnitude = abs(Y);
%resolu��o de frequencia
deltaf = fs/p;
%eixo x - range de frequencias
fx = [0:indiceNyquist-1]*deltaf;


%plota os graficos
figure;

%plota o gr�fico no tempo
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
ylabel('Tens�o [V]');

%plota o gr�fico da FFT
subplot(2,1,2);
plot(fx, magnitude); 
if(Eletrodo == 1)
    TituloFreq=strcat('Sinal C3 em frequ�ncia (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 2)
    TituloFreq=strcat('Sinal Cz em frequ�ncia (Coleta ',int2str(Coleta),')');
elseif(Eletrodo == 3)
    TituloFreq=strcat('Sinal C4 em frequ�ncia (Coleta ',int2str(Coleta),')');
end
title(TituloTempo);
grid on; 
xlabel('Frequ�ncia [Hz]'); 
ylabel('Magnitude [Unidade]'); 

