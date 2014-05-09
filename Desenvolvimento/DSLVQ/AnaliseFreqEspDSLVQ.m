% Análise das frequências específicas com DSLVQ
clear all;
clc;

load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\labels_data_set_iii.mat;

SampleRate = 128;
QuantColetas = 140;

Dados = x_test;

DadosC3(:,:) = Dados(:,1,:); %canal 1 - C3
DadosC4(:,:) = Dados(:,3,:); %canal 3 - C4

for k=1:QuantColetas
    DadosC3(:,k) = mapminmax(DadosC3(:,k));
    DadosC4(:,k) = mapminmax(DadosC4(:,k));
end

% Segundo de análise
TempoInicial=SampleRate*4;
DadosC3seg(:,:) = DadosC3(TempoInicial:(TempoInicial+SampleRate-1),:); 
DadosC4seg(:,:) = DadosC4(TempoInicial:(TempoInicial+SampleRate-1),:); 

for k=1:QuantColetas
    DSLVQC3(:,k) = FFTDSLVQ (DadosC3seg(:,k),SampleRate);
    DSLVQC4(:,k) = FFTDSLVQ (DadosC4seg(:,k),SampleRate);
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
    ResultadosDSLVQ1(k,:,:)=DSLVQ(EntradaDSLVQ1,TrainTargets,length(TrainTargets));
    
    VetorRandon = randperm(QuantColetas);
    for k=1:length(VetorRandon)
        if (mod(VetorRandon(k),2) == 1)
            TrainTargets(k) = 1;
        else
            TrainTargets(k) = 0;
        end
    end
end
QuantIteracoes=200;
for k=1:QuantIteracoes
    ResultadosDSLVQ2(k,:,:)=DSLVQ(EntradaDSLVQ2,TrainTargets,length(TrainTargets));
    
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
