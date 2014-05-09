%Visualização do ERD
clear all;
clc;
load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

%--->> x_test
TaxaAmostragem=128;
QuantAmostras=140;
Amostra=140; %entre 1 até 140

%Filtro passa-faixas 8-11 Hz - Butterworth 4ª ordem - sinal MU
Ordem=4;
Fmin=8;
Fmax=12;
WnRads=[Fmin Fmax]*2/(TaxaAmostragem);
[Num,Den]=butter(Ordem,WnRads);
H=filt(Num,Den,(1/TaxaAmostragem));

for k = 1:3
    for kk = 1:1152
        s(k,kk) = x_train(kk,k,Amostra);
    end
end
s = mapminmax (s);
s = s';

%Aplicação do filtro
for m = 1:1152
    C3(m,1)=s(m,1);
    CZ(m,1)=s(m,2);
    C4(m,1)=s(m,3);
end
C3filtrado = filter(Num,Den,C3)';
CZfiltrado = filter(Num,Den,CZ)';
C4filtrado = filter(Num,Den,C4)';

%Aplicando a quadratura
for n = 1:1152
    C3quad(1,n) = C3filtrado(1,n)^2;
    CZquad(1,n) = CZfiltrado(1,n)^2;
    C4quad(1,n) = C4filtrado(1,n)^2;
end

         
            

% 
% for k = 1:QuantAmostras
%     for kk = 1:3
%         s = x_test (:,kk,Amostra);
%         s = s';
%         s = mapminmax (s);
%         %filtra entre a faixa Mu
%         wisrael=filter(Num,Den,s);
%         sMuC3 (:,kk,k) = filter(Num,Den,s);
%         
%     end 
% end
%     