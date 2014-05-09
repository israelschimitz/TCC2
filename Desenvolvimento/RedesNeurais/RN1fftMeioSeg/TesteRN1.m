
%% RN1
% Pega a FFT de 0,5 segundos entre 3,5-4,0 // 4,0-4,5 // 4,5-5,0
% concatena os canais C3 e C4 e coloca na Entrada. Saída esquerda [-1,1]
%                                                        direita  [1,-1]

%% Carregando a coleta e a ordem
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\Touca0704x128israels5.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\Touca0704x128israels5.mat;

% load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2303x128israels.mat;

Ordem = Ordem0704x128israels5;
Dados = Touca0704x128israels5;

SampleRate = 128;
QuantColetas = length(Ordem);
CompEsp = 11;

%% Configurando a Saída
% Separação dos sinais entre direita e esquerda
for i=1:QuantColetas
    if (mod(Ordem(i),2) == 1)
        SaidaColeta(1,i) = -1; %esquerda
        SaidaColeta(2,i) = 1;  %esquerda
    else
        SaidaColeta(1,i) = 1;  %direita
        SaidaColeta(2,i) = -1; %direita
    end
end

%% Configurando a Entrada
% 
DadosC3Coleta(:,:) = Dados (:,1,:);
DadosC3x35Coleta(:,:) = DadosC3Coleta((3.5*SampleRate:4.0*SampleRate),:);
DadosC3x40Coleta(:,:) = DadosC3Coleta((4.0*SampleRate:4.5*SampleRate),:);
DadosC3x45Coleta(:,:) = DadosC3Coleta((4.5*SampleRate:5.0*SampleRate),:);

DadosC4Coleta(:,:) = x_train (:,3,:);
DadosC4x35Coleta(:,:) = DadosC4Coleta((3.5*SampleRate:4.0*SampleRate),:);
DadosC4x40Coleta(:,:) = DadosC4Coleta((4.0*SampleRate:4.5*SampleRate),:);
DadosC4x45Coleta(:,:) = DadosC4Coleta((4.5*SampleRate:5.0*SampleRate),:);

for k=1:QuantColetas
    FFTC3x35Coleta(:,k) = FFTCompEspFct(DadosC3x35Coleta(:,k),CompEsp,SampleRate);
    FFTC3x40Coleta(:,k) = FFTCompEspFct(DadosC3x40Coleta(:,k),CompEsp,SampleRate);
    FFTC3x45Coleta(:,k) = FFTCompEspFct(DadosC3x45Coleta(:,k),CompEsp,SampleRate);
    FFTC4x35Coleta(:,k) = FFTCompEspFct(DadosC4x35Coleta(:,k),CompEsp,SampleRate);
    FFTC4x40Coleta(:,k) = FFTCompEspFct(DadosC4x40Coleta(:,k),CompEsp,SampleRate);
    FFTC4x45Coleta(:,k) = FFTCompEspFct(DadosC4x45Coleta(:,k),CompEsp,SampleRate);
end

EntradaColeta(1,:) = FFTC3x35Coleta(:,:);
EntradaColeta(2,:) = FFTC3x40Coleta(:,:);
EntradaColeta(3,:) = FFTC3x45Coleta(:,:);
EntradaColeta(4,:) = FFTC4x35Coleta(:,:);
EntradaColeta(5,:) = FFTC4x40Coleta(:,:);
EntradaColeta(6,:) = FFTC4x45Coleta(:,:);

% 
% %Geracao da Rede neural
% %150 neuronios na camada oculta
% net = feedforwardnet(75);
% %Configuracao da rede neural
% %Dados para treinamento 100%
% net.divideParam.trainRatio=.5;
% %Dados para validacao 0%
% net.divideParam.valRatio=.25;
% %Dados para teste 0%
% net.divideParam.testRatio=.25;
% 
% %--------------------------------
% %Numero de camadas
% net.NumLayers=3;
% %Conexao do Bias as camadas
% net.biasConnect=[1;1;1];
% net.outputConnect=[0 0 1];
% net.layerConnect=[0 0 0;1 0 0;0 1 0];
% %Camada oculta 2
% net.layers{2}.name='Hidden2';
% %Camada oculta 2 (75 neuronios)
% net.layers{2}.dimensions=100;
% net.layers{3}.name='Output';
% net.layers{2}.transferFcn='tansig';
% net.layers{3}.transferFcn='tansig';
% %---------------------------------
% clc;
% tic;
% %Minimo Gradiente
% net.trainParam.min_grad=1e-9;
% 
% %Treinamento da rede neural
% net = train(net,Entrada,Saida);

for k=1:QuantColetas
    ResultadoColeta(:,k)=net(EntradaColeta(:,k));
end

% 
% tf=toc;
% clc;
% % disp(sprintf('\n\nNumeros a serem jogados: [%d %d %d %d %d %d]',abs(round(Projecao_Resultado))));
% disp(sprintf('\nTempo decorrido:%15.1f',tf));
% %Salva a rede neural projetada
% savefile = 'BCIRN1.mat';
% save(savefile, 'net');



