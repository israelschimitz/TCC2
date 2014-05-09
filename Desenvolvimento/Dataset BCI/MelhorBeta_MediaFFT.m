%Verificando a melhor frequencia beta
SampleRate = 128;
Coleta = 3; %de 1 até 70
Eletrodo = 3;   %C3(esquerda) - 1
                %Cz(centro)   - 2
                %C4(direita)  - 3
for k=1:70
    %-----------Cálculo FFT--------------------------------
    %armazena os dados que serão calculados em "dados"
    dados = DadosEsquerdaC3(:,k); % coleta 2 - eletrodo C4
    %vetor de tempo
    time=0:(1/SampleRate):(9-(1/SampleRate));


    %armazena o tamanho do vetor
    L = length(dados);
    %frequencia de amostragem [Hz]
    fs=128;
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
    magnitude(:,k) = abs(Y);
    %resolução de frequencia
    deltaf = fs/p;
    %eixo x - range de frequencias
    fx = [0:indiceNyquist-1]*deltaf;
end

for m=1:length (fx)
    mediamagnitude(m) = sum(magnitude(m,:))/70;
end
plot(fx,mediamagnitude)