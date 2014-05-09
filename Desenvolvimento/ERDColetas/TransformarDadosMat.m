clear all;
clc;

QuantColetas = 20;
Ordem2404x1000giordano5 = xlsread('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\Dados\eegbipolarfone\240414giordano\2403x1000giordano5\Ordem2403x1000giordano5.xls');

User = '2404x1000giordano5x';
Numero = 0;

for m=1:QuantColetas
    Path1 = strcat('C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\Coletas\Dados\eegbipolarfone\240414giordano\2403x1000giordano5\',User,int2str(Numero),'.xls');
    Touca2404x1000giordano5 (:,:,m) = xlsread(Path1);
    Numero = Numero + 1;
end

save 2404x1000giordano5.mat Touca2404x1000giordano5 Ordem2404x1000giordano5
