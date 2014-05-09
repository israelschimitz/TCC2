% ------------------------------------------------ %
% ---ROTINA PARCIAL PARA O PROJETO DE GRADUAÇÃO--- %
% ---Aluno: Alessandro Botti Benevides ----------- %
% ---Matr.: 2002102325 --------------------------- %
% ---Orientador: Teodiano Freire Bastos Filho----- %
% ------------------------------------------------ %

%ERD1
sample_rate=128;
num=140;
%load C:\MATLAB7\work\sandro\graz_data\y_train.mat
for w=1:num
    y_t(w,1)=y_train(w,1);
end
[i,j]=find(y_t==1);%encontra os sinais relacionados à mão direita
[numao jj]=size(i);

sinalmu1em=zeros(1,1152);
sinalmu2em=zeros(1,1152);
sinalmu3em=zeros(1,1152);
sinalbeta1em=zeros(1,1152);
sinalbeta2em=zeros(1,1152);
sinalbeta3em=zeros(1,1152);

%load C:\MATLAB7\work\sandro\graz_data\x_train.mat
for m = 1:numao
    for mm = 1:3
        for nn= 1:1152
            xn(mm,nn) = x_train(nn,mm,i(m));
        end
    end
    %xn = premnmx(xn);
    xn = mapminmax (xn);
    w = xn';
    t = 0:(1/sample_rate):9;
    for lp= 1:1152
        w1(lp,1)=w(lp,1);
        w2(lp,1)=w(lp,2);
        w3(lp,1)=w(lp,3);
    end
    %------------FILTRA OS SINAIS NO RITMO MU----------
    n=4;
    fmin=8;
    fmax=11;
    wn=[fmin fmax]/(sample_rate/2);
    [b,a]=butter(n,wn);
    h=filt(b,a,(1/sample_rate));
    h1=filter(b,a,w1);
    sinalmu1(m,:)=h1';
    h2=filter(b,a,w2);
    sinalmu2(m,:)=h2';
    h3=filter(b,a,w3);
    sinalmu3(m,:)=h3';
    %------SINAL É ELEVADO AO QUADRADO (ENERGIA)-------
    for mu=1:1152
        sinalmu1e(m,mu)=sinalmu1(m,mu)^2;
        sinalmu2e(m,mu)=sinalmu2(m,mu)^2;
        sinalmu3e(m,mu)=sinalmu3(m,mu)^2;
    end
end
%---------MÉDIA DA ENERGIA DE TODOS OS SINAIS----------
for m=1:numao
    for mu=1:1152
        sinalmu1em(1,mu)=sinalmu1em(1,mu)+sinalmu1e(m,mu);
        sinalmu2em(1,mu)=sinalmu2em(1,mu)+sinalmu2e(m,mu);
        sinalmu3em(1,mu)=sinalmu3em(1,mu)+sinalmu3e(m,mu);
%         sinalbeta1em(1,mu)=sinalbeta1em(1,mu)+sinalbeta1e(m,mu);
%         sinalbeta2em(1,mu)=sinalbeta2em(1,mu)+sinalbeta2e(m,mu);
%         sinalbeta3em(1,mu)=sinalbeta3em(1,mu)+sinalbeta3e(m,mu);
    end
end
sinalmu1em=sinalmu1em/70;
sinalmu2em=sinalmu2em/70;
sinalmu3em=sinalmu3em/70;
% sinalbeta1em=sinalbeta1em/140;
% sinalbeta2em=sinalbeta2em/140;
% sinalbeta3em=sinalbeta3em/140;
%----------SUAZIZAÇÃO DA CURVA DA MÉDIA DE ENERGIA-----
for mu=1:(1152/8)
    sinalmu1emm(1,mu)=(sinalmu1em(1,1+8*(mu-1))+sinalmu1em(1,2+8*(mu-1))+sinalmu1em(1,3+8*(mu-1))+sinalmu1em(1,4+8*(mu-1))+sinalmu1em(1,5+8*(mu-1))+sinalmu1em(1,6+8*(mu-1))+sinalmu1em(1,7+8*(mu-1))+sinalmu1em(1,8+8*(mu-1)))/8;
    sinalmu2emm(1,mu)=(sinalmu2em(1,1+8*(mu-1))+sinalmu2em(1,2+8*(mu-1))+sinalmu2em(1,3+8*(mu-1))+sinalmu2em(1,4+8*(mu-1))+sinalmu2em(1,5+8*(mu-1))+sinalmu2em(1,6+8*(mu-1))+sinalmu2em(1,7+8*(mu-1))+sinalmu2em(1,8+8*(mu-1)))/8;
    sinalmu3emm(1,mu)=(sinalmu3em(1,1+8*(mu-1))+sinalmu3em(1,2+8*(mu-1))+sinalmu3em(1,3+8*(mu-1))+sinalmu3em(1,4+8*(mu-1))+sinalmu3em(1,5+8*(mu-1))+sinalmu3em(1,6+8*(mu-1))+sinalmu3em(1,7+8*(mu-1))+sinalmu3em(1,8+8*(mu-1)))/8;
%     sinalbeta1emm(1,mu)=(sinalbeta1em(1,1+8*(mu-1))+sinalbeta1em(1,2+8*(mu-1))+sinalbeta1em(1,3+8*(mu-1))+sinalbeta1em(1,4+8*(mu-1))+sinalbeta1em(1,5+8*(mu-1))+sinalbeta1em(1,6+8*(mu-1))+sinalbeta1em(1,7+8*(mu-1))+sinalbeta1em(1,8+8*(mu-1)))/8;
%     sinalbeta2emm(1,mu)=(sinalbeta2em(1,1+8*(mu-1))+sinalbeta2em(1,2+8*(mu-1))+sinalbeta2em(1,3+8*(mu-1))+sinalbeta2em(1,4+8*(mu-1))+sinalbeta2em(1,5+8*(mu-1))+sinalbeta2em(1,6+8*(mu-1))+sinalbeta2em(1,7+8*(mu-1))+sinalbeta2em(1,8+8*(mu-1)))/8;
%     sinalbeta3emm(1,mu)=(sinalbeta3em(1,1+8*(mu-1))+sinalbeta3em(1,2+8*(mu-1))+sinalbeta3em(1,3+8*(mu-1))+sinalbeta3em(1,4+8*(mu-1))+sinalbeta3em(1,5+8*(mu-1))+sinalbeta3em(1,6+8*(mu-1))+sinalbeta3em(1,7+8*(mu-1))+sinalbeta3em(1,8+8*(mu-1)))/8;
end
%---PEGA UM SINAL QUALQUER COMO EXEMPLO-----
%rn=randperm(numao);
%teste=rn(1);
teste = 70;
exemplo1(:,1)=x_train(:,1,i(teste));
exemplo2(:,1)=x_train(:,2,i(teste));
exemplo3(:,1)=x_train(:,3,i(teste));
teste0=int2str(i(teste));
t=0:(1/128):(1152/128-1/128);
t2=0:(1/16):(144/16-1/16);
%-----PLOTA OS GRÁFICOS DO CANAL C4--------
figure
subplot(4,1,1)
plot(t,exemplo1,'k')
aux1=strcat('Sinal C4 (teste ',teste0,')');
title(aux1);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,2)
plot(t,sinalmu1(teste,:),'k')
aux2=strcat('Sinal C4 (teste ',teste0,') filtrado (8-11)Hz');
title(aux2);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,3)
plot(t,sinalmu1e(teste,:),'k')
aux3=strcat('Energia do sinal C4 (teste ',teste0,')');
title(aux3);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,4)
plot(t,sinalmu1em,'k')
title('Média da energia de todos os sinais do canal C4');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
%-----PLOTA OS GRÁFICOS DO CANAL CZ--------
figure
subplot(4,1,1)
plot(t,exemplo2,'k')
aux1=strcat('Sinal Cz (teste ',teste0,')');
title(aux1);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,2)
plot(t,sinalmu2(teste,:),'k')
aux2=strcat('Sinal Cz (teste ',teste0,') filtrado (8-11)Hz');
title(aux2);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,3)
plot(t,sinalmu2e(teste,:),'k')
aux3=strcat('Energia do sinal Cz (teste ',teste0,')');
title(aux3);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,4)
plot(t,sinalmu2em,'k')
title('Média da energia de todos os sinais do canal Cz');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
%-----PLOTA OS GRÁFICOS DO CANAL C3--------
figure
subplot(4,1,1)
plot(t,exemplo3,'k')
aux1=strcat('Sinal C3 (teste ',teste0,')');
title(aux1);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,2)
plot(t,sinalmu3(teste,:),'k')
aux2=strcat('Sinal C3 (teste ',teste0,') filtrado (8-11)Hz');
title(aux2);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,3)
plot(t,sinalmu3e(teste,:),'k')
aux3=strcat('Energia do sinal C3 (teste ',teste0,')');
title(aux3);
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(4,1,4)
plot(t,sinalmu3em,'k')
title('Média da energia de todos os sinais do canal C3');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
%----PLOTA AS CURVAS DE ENERGIA SUAVIZADA DOS CANAIS---
figure
subplot(3,1,1)
plot(t2,sinalmu1emm','k')
title('Suavização da curva de energia dos sinais do canal C4');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(3,1,2)
plot(t2,sinalmu2emm','k')
title('Suavização da curva de energia dos sinais do canal Cz');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
subplot(3,1,3)
plot(t2,sinalmu3emm','k')
title('Suavização da curva de energia dos sinais do canal C3');
ylabel('Amplitude');
xlabel('Tempo(segundos)');
























  