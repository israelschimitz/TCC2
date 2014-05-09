% Análise das frequências específicas com DSLVQ
clear all;
clc;

%% Carregando a coleta e a ordem
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2304x1000luciano3.mat;
% load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Desenvolvimento\ERDColetas\2404x1000giordano5.mat;

Dados(:,:,1:20) = Touca2304x1000luciano1;
Dados(:,:,21:40) = Touca2304x1000luciano3;
% Dados(:,:,41:60) = Touca2404x1000giordano5;

SampleRate = 1000;
QuantColetas = length(Dados(1,1,:));

DadosC3(:,:) = Dados(:,1,:); %canal 1 - C3
DadosC4(:,:) = Dados(:,2,:); %canal 2 - C4

for k=1:QuantColetas
    DadosC3(:,k) = mapminmax(DadosC3(:,k));
    DadosC4(:,k) = mapminmax(DadosC4(:,k));
end

% Segundo de análise
TempoInicial=SampleRate*4;
DadosC3seg(:,:) = DadosC3(TempoInicial:(TempoInicial+SampleRate-1),:); 
DadosC4seg(:,:) = DadosC4(TempoInicial:(TempoInicial+SampleRate-1),:); 

for k=1:QuantColetas
    DSLVQC3(:,k) = FFTDSLVQcoletas (DadosC3seg(:,k), SampleRate);
    DSLVQC4(:,k) = FFTDSLVQcoletas (DadosC4seg(:,k), SampleRate);
end

% EntradaDSLVQ = [DSLVQC3 DSLVQC4];
EntradaDSLVQ1 = DSLVQC3;
EntradaDSLVQ2 = DSLVQC4;

% Amostras de treinamento
% Identifica quais amostras serão para treinamento (50% 1)
VetorRandon = randperm(QuantColetas);

for k=1:length(VetorRandon)
    if (mod(VetorRandon(k),2) == 1)
        TrainTargets(k) = 1;
    else
        TrainTargets(k) = 0;
    end
end

QuantIteracoes=200;
for k=1:QuantIteracoes
    ResultadosDSLVQ1(k,:,:)=DSLVQcoletas(EntradaDSLVQ1,TrainTargets,length(TrainTargets));
    
    VetorRandon = randperm(QuantColetas);
    for k=1:length(VetorRandon)
        if (mod(VetorRandon(k),2) == 1)
            TrainTargets(k) = 1;
        else
            TrainTargets(k) = 0;
        end
    end
end
for k=1:QuantIteracoes
    ResultadosDSLVQ2(k,:,:)=DSLVQcoletas(EntradaDSLVQ2,TrainTargets,length(TrainTargets));
    
    VetorRandon = randperm(QuantColetas);
    for k=1:length(VetorRandon)
        if (mod(VetorRandon(k),2) == 1)
            TrainTargets(k) = 1;
        else
            TrainTargets(k) = 0;
        end
    end
end


DSLVQSaida1(:,:) = ResultadosDSLVQ1(:,:,15);
DSLVQSaida2(:,:) = ResultadosDSLVQ2(:,:,15);
for k=1:length(DSLVQSaida1(1,:))
    TotalDSLVQSaida1(:,k) = median(DSLVQSaida1(:,k));
    TotalDSLVQSaida2(:,k) = median(DSLVQSaida2(:,k));
end
for k=1:length(TotalDSLVQSaida1(1,:))
    MediaC3C4(k)= (TotalDSLVQSaida1(1,k)+TotalDSLVQSaida2(1,k))/2;
end
Time = linspace (8,30,23);
figure;
plot(Time,TotalDSLVQSaida1,Time,TotalDSLVQSaida2);
legend('C3','C4');
axis([8 30 0 .12]);
title('Frequências Específicas por DSLVQ');
xlabel('Frequência [Hz]'); 
ylabel('Relevância [Adimensional]');
figure;
plot(Time,MediaC3C4);
title('Frequências Específicas por DSLVQ - Média');
xlabel('Frequência [Hz]'); 
ylabel('Relevância [Adimensional]');
axis([8 30 0 .12]);
