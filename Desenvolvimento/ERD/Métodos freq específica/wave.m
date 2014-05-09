% wavelet = x_train (:,1,2);
% c = cwtft(wavelet,'plot');
% 
% figure;
% s0 = 6*dt; 
% ds = 0.15; 
% NbSc = 50;
% wname = 'morl';
% SCA = {s0,ds,NbSc};
% cwtsig = cwtft({Y,dt},'scales',SCA,'wavelet',wname);
% MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
% Scales = cwtsig.scales.*MorletFourierFactor;
% Freq = 1./Scales;
% imagesc(t,[],abs(cwtsig.cfs));
% indices = get(gca,'ytick');
% set(gca,'yticklabel',Freq(indices));
% xlabel('Time'); ylabel('Hz');
% title('Time-Frequency Analysis with CWT');

clear all;
clc;

load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;

SampleRate = 128;
Time = linspace(0,9,9*SampleRate);
dt = 1/(SampleRate-1);
%Y = x_train (:,1,40);
Y = sin(8*pi*Time).*(Time<=4.5) + sin(16*pi*Time).*(Time>4.5);
Sinal = {Y,dt};
%cwtS1 = cwtft(Sinal,'plot');

% % smallest scale, spacing between scales, number of scales
% dt = 1/1023;
% s0 = 2*dt; ds = 0.5; NbSc = 20;
% % scale vector is
% % scales = s0*2.^((0:NbSc-1)*ds);
% wname = 'paul';
% SIG = {Y,dt};
% % Create SCA input as cell array
% SCA = {s0,ds,NbSc};
% % Specify wavelet and parameters
% WAV = {wname,8};
% %cwtS2 = cwtft(SIG,'scales',SCA,'wavelet',WAV,'plot');

% figure;
% s0 = 3*dt; ds = 0.15; NbSc = 50;
% wname = 'morl';
% SCA = {s0,ds,NbSc};
% cwtsig = cwtft({Y,dt},'scales',SCA,'wavelet',wname);
% MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
% Scales = cwtsig.scales.*MorletFourierFactor;
% Freq = 1./Scales;
% imagesc(Time,[],abs(cwtsig.cfs));
% indices = get(gca,'ytick');
% set(gca,'yticklabel',Freq(indices));
% xlabel('Time'); ylabel('Hz');
% title('Time-Frequency Analysis with CWT');

% figure;
% s0 = 6*dt; ds = 0.15; NbSc = 50;
% m = 8;
% % scale vector is
% % scales = s0*2.^((0:NbSc-1)*ds);
% wname = 'morl';
% SIG = {Y,dt};
% % Create SCA input as cell array
% SCA = {s0,ds,NbSc};
% % Specify wavelet and parameters
% WAV = {wname,m};
% cwtMorl = cwtft(SIG,'scales',SCA,'wavelet',WAV);
% scales = cwtMorl.scales;
% MorlFourierFactor = 4*pi/(6+sqrt(2+6^2));
% Freq = 1./(MorlFourierFactor.*scales);
% contour(Time,Freq,real(cwtMorl.cfs));
% xlabel('Time'); ylabel('Hz'); colorbar;
% title('Real Part of CWT using Paul Wavelet (m=8)');
% grid on;
% 
% load C:\Israel\Engenharia_Elétrica\Disciplinas\TCC1\BCIchallenge\BCI_II\graz_data\dataset_BCIcomp1.mat;
% 
% fs = 128;
%  t = linspace(0,9,9*fs);
%  x = x_test (:,3,90);
%  dt = 1/fs;
%  minscale = centfrq('morl')/(40*dt);
%  maxscale = centfrq('morl')/(5*dt);
%  scales = minscale:maxscale;
%  cfs = cwt(x,scales,'morl','plot');
% %Now for cwtft (using an analytic Morlet wavelet)

MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
s0 = (0.02*MorletFourierFactor);
smax = (1/10*MorletFourierFactor);
ds =0.2;
nb = ceil(log2(smax/s0)/ds+1);
scales = struct('s0',s0,'ds',0.5,'nb',nb,'type','pow','pow',2);
cwtS1 = cwtft({Y,dt},'scales',scales,'wavelet','morl');
sc = cwtS1.scales;
freq = 1./(sc*MorletFourierFactor);
contour(Time,freq,abs(cwtS1.cfs));
colormap('jet');
xlabel('Time'); ylabel('Pseudo-Frequency');
