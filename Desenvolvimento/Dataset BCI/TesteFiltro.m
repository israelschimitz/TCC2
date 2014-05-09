SampleRate = 128;
QuantColetas = 140;


%Filtro MU passa-faixas 8-11 Hz - Butterworth 4ª ordem 
OrdemMu=4;
FminMu=8;
FmaxMu=11;
WnMu=[FminMu FmaxMu]*2/(SampleRate);
[NumMu,DenMu]=butter(OrdemMu,WnMu);
HMu=filt(NumMu,DenMu,(1/SampleRate));

bode(HMu);
% 
% 
% %Filtro BETA passa-faixas 26-30 Hz - Butterworth 4ª ordem 
% OrdemBeta=4;
% FminBeta=26;
% FmaxBeta=30;
% WnBeta=[FminBeta FmaxBeta]*2/(SampleRate);
% [NumBeta,DenBeta]=butter(OrdemBeta,WnBeta);
% HBeta=filt(NumBeta,DenBeta,(1/SampleRate));

% %Suavização da curva da média de potência
% for k=1:1152
%     if ((k==1)||(k==2)||(k==3)||(k==4))
%         DadosDirC3Suav(k) = DadosDirC3MediaPot(k);
%         DadosDirC4Suav(k) = DadosDirC4MediaPot(k);
%     elseif ((k==1149)||(k==1150)||(k==1151)||(k==1152))
%         DadosDirC3Suav(k) = DadosDirC3MediaPot(k);
%         DadosDirC4Suav(k) = DadosDirC4MediaPot(k);
%     else
%         DadosDirC3Suav(k) = (DadosDirC3MediaPot(k-4)+DadosDirC3MediaPot(k-3)+DadosDirC3MediaPot(k-2)+DadosDirC3MediaPot(k-1)+DadosDirC3MediaPot(k)+DadosDirC3MediaPot(k+1)+DadosDirC3MediaPot(k+2)+DadosDirC3MediaPot(k+3)+DadosDirC3MediaPot(k+4))/9;
%         DadosDirC4Suav(k) = (DadosDirC4MediaPot(k-1)+DadosDirC4MediaPot(k)+DadosDirC4MediaPot(k+1))/3;
%     end
% end
% subplot(5,2,9)
% plot(Time,DadosDirC3Suav);
% Titulo9=strcat('Sinal C3 Média das potências suavizadas');
% title(Titulo9);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');
% subplot(5,2,10)
% plot(Time,DadosDirC4Suav);
% Titulo10=strcat('Sinal C4 Média das potências suavizadas');
% title(Titulo10);
% xlabel('Tempo [s]'); 
% ylabel('Potência Média [V^2]');
