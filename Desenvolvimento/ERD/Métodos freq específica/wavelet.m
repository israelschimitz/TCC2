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
   
    DadosEsqC3Potencia(k,:) = RawDataEsqC3(2*128:8*128).^2; %Calcula a potencia ao quadrado 
    DadosEsqC4Potencia(k,:) = RawDataEsqC4(2*128:8*128).^2; %Calcula a potencia ao quadrado 
    DadosDirC3Potencia(k,:) = RawDataDirC3(2*128:8*128).^2; %Calcula a potencia ao quadrado 
    DadosDirC4Potencia(k,:) = RawDataDirC4(2*128:8*128).^2; %Calcula a potencia ao quadrado 

end

for k=1:(SampleRate*6)
    DadosEsqC3MediaPot(k) = sum(DadosEsqC3Potencia(:,k))/(QuantColetas/2);
    DadosEsqC4MediaPot(k) = sum(DadosEsqC4Potencia(:,k))/(QuantColetas/2);
    DadosDirC3MediaPot(k) = sum(DadosDirC3Potencia(:,k))/(QuantColetas/2);
    DadosDirC4MediaPot(k) = sum(DadosDirC4Potencia(:,k))/(QuantColetas/2);
end

Y = DadosDirC4MediaPot;

%Aplica a tranformada Wavelet
t = linspace(2,8,6*SampleRate);
dt = 1/(SampleRate-1);

figure;
%Beta
s0 = 3*dt; ds = 0.04; NbSc = 45;

%Total
%s0 = 3.5*dt; ds = 0.015; NbSc = 155;
wname = 'morl';
SCA = {s0,ds,NbSc};
cwtsig = cwtft({Y,dt},'scales',SCA,'wavelet',wname);
MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
Scales = cwtsig.scales.*MorletFourierFactor;
Freq = 1./Scales;
imagesc(t,[],abs(cwtsig.cfs));
indices = get(gca,'ytick');
set(gca,'yticklabel',Freq(indices));
xlabel('Time'); ylabel('Hz');
title('Time-Frequency Analysis with CWT');