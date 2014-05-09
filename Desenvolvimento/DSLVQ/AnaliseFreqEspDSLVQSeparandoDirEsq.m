% Análise das frequências específicas com DSLVQ
clear all;
clc;

load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\labels_data_set_iii.mat;

SampleRate = 128;
QuantColetas = 140;

Dados = x_test;

%% Separação dos sinais entre direita e esquerda
IndiceEsq=find(y_test==1); %encontra os sinais relacionados à mão esquerda
IndiceDir=find(y_test==2); %encontra os sinais relacionados à mão direita

for k=1:(QuantColetas/2)
    DadosC3Dir(:,k) = Dados(:,1,IndiceDir(k));%canal 1 - C3
    DadosC4Dir(:,k) = Dados(:,3,IndiceDir(k));%canal 3 - C4
    DadosC3Esq(:,k) = Dados(:,1,IndiceEsq(k));
    DadosC4Esq(:,k) = Dados(:,3,IndiceEsq(k));
end

for k=1:(QuantColetas/2)
    DadosC3Dir(:,k) = mapminmax(DadosC3Dir(:,k));
    DadosC4Dir(:,k) = mapminmax(DadosC4Dir(:,k));
    DadosC3Esq(:,k) = mapminmax(DadosC3Esq(:,k));
    DadosC4Esq(:,k) = mapminmax(DadosC4Esq(:,k));
end

% Segundo de análise
TempoInicial=SampleRate*3.75;
DadosC3DirSeg(:,:) = DadosC3Dir(TempoInicial:(TempoInicial+SampleRate-1),:); 
DadosC4DirSeg(:,:) = DadosC4Dir(TempoInicial:(TempoInicial+SampleRate-1),:); 
DadosC3EsqSeg(:,:) = DadosC3Esq(TempoInicial:(TempoInicial+SampleRate-1),:); 
DadosC4EsqSeg(:,:) = DadosC4Esq(TempoInicial:(TempoInicial+SampleRate-1),:); 

for k=1:(QuantColetas/2)
    DSLVQC3Dir(:,k) = FFTDSLVQ (DadosC3DirSeg(:,k),SampleRate);
    DSLVQC4Dir(:,k) = FFTDSLVQ (DadosC4DirSeg(:,k),SampleRate);
    DSLVQC3Esq(:,k) = FFTDSLVQ (DadosC3EsqSeg(:,k),SampleRate);
    DSLVQC4Esq(:,k) = FFTDSLVQ (DadosC4EsqSeg(:,k),SampleRate);
end

% EntradaDSLVQ = [DSLVQC3 DSLVQC4];
EntradaDSLVQ = DSLVQC4Dir;

% Amostras de treinamento
% Identifica quais amostras serão para treinamento (50% 1)
VetorRandon = randperm((QuantColetas/2));

for k=1:length(VetorRandon)
    if (mod(VetorRandon(k),2) == 1)
        TrainTargets(k) = 1;
    else
        TrainTargets(k) = 0;
    end
end

QuantIteracoes=100;
for k=1:QuantIteracoes
    ResultadosDSLVQ(k,:,:)=DSLVQ(EntradaDSLVQ,TrainTargets,length(TrainTargets));
    
    VetorRandon = randperm(QuantColetas/2);
    for k=1:length(VetorRandon)
        if (mod(VetorRandon(k),2) == 1)
            TrainTargets(k) = 1;
        else
            TrainTargets(k) = 0;
        end
    end
end
DSLVQSaida(:,:) = ResultadosDSLVQ(:,:,15);
for k=1:length(DSLVQSaida(1,:))
    TotalDSLVQSaida(:,k) = median(DSLVQSaida(:,k));
end
Time = linspace (8,30,23);
plot(Time,TotalDSLVQSaida);
