clear;
close all;
clc;

%% Subject 001
% Nota: apenas correu 5m a 10km/h
% Starting tstamp: 1595236435
age = 21;           % years
weight = 60.3;      % kg
height = 1.75;      % m
gender = 1;         % female = 0, male = 1
BMI = weight/(height^.2);

%% Rest Heart Rate
A = dlmread('HR_Calibration_Data.csv');
HR = A(:,2);                    
tstamp = A(:,1);
tstamp_test_conv = tstamp - tstamp(1);

% Plot
plot(tstamp_test_conv,HR);
xlabel('Time (s)');
ylabel('HR (bpm)');
title('Resting Heart Rate');
xlim([0 240])
ylim([0 100])

%% Heart Rate
% Freq 1Hz
A = dlmread('HR_Data.csv');
HR_test = A(38:697,2);
tstamp = A(:,1);
t = 1:length(HR_test);

% Plot
plot(t,HR_test);
xlabel('Time (s)');
ylabel('HR (bpm)');
title('Heart Rate');
xlim([0 660])
ylim([130 180])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

%% Muscle oxygenation
% Starting tstamp: 1595236435
% Freq: 4Hz
B = dlmread('Muscle_Oxy_Data.csv');
SmO2_test = B(157:2796,2);
t_test = B(157:2796,1);
t = (1:length(SmO2_test))/4;

% Plot
plot(t,SmO2_test);
hold on
for i = 1:length(SmO2_test)
    % Zona 2: azul
    if((t(i) <= 3/4) || ((t(i) >= 316/4) && (t(i) <= 371/4)) || ((t(i) > 371/4) && (t(i) <864/4)) || ((t(i) >= 1212/4) && (t(i) <= 1295/4)) || ((t(i) >= 1444/4) && (t(i) <= 1519/4)))
        line([t(i) t(i)],[0 SmO2_test(i)],'Color',[.0157 .49 0.74]);
    end
    % Zona 3: verde
    if((t(i) > 3/4) && (t(i) <192/4) || (t(i) > 279/4) && (t(i) <376/4) || (t(i) > 371/4) && (t(i) <864/4) || (t(i) > 1295/4) && (t(i) <1443/4) || (t(i) > 1514/4) && (t(i) <1976/4) || (t(i) > 2263/4))
        line([t(i) t(i)],[0 SmO2_test(i)],'Color',[0.1137 .6784 .38]);
    end
    % Zona 4: laranja
    if((t(i) >= 192/4) && (t(i) <= 279/4) || (t(i) >= 864/4) && (t(i) <= 943/4) || (t(i) >= 1036/4) && (t(i) <1211/4) || (t(i) >= 1976/4) && (t(i) <= 2263/4))
        line([t(i) t(i)],[0 SmO2_test(i)],'Color',[0.69 .43 .098]);
    end
    % Zona 5: vermelho
    if((t(i) >= 944/4) && (t(i) <= 1035/4)) 
        line([t(i) t(i)],[0 SmO2_test(i)],'Color',[.72 .0275 0.098]);
    end
end
xlabel('Time (s)');
ylabel('SmO2 (%)');
title('Muscle Oxygenation');
xlim([0 660]);
ylim([50 60])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

% 4th byte array
E3 = dlmread('byteArray4.csv');
b3 = E3(157:2796,2)/100;
t = (1:length(b3))/4;
t = 1:length(b3);

% Plot
plot(t,b3);
xlabel('Time (s)');
ylabel('Value');

figure
histogram(b3);
figure
u = unique(b3);
counts = histc(b3, u);
p = pie(counts, cellstr(num2str(u(:))));
pText = findobj(p,'Type','text');
percentValues = get(pText,'String'); 
txt = {'Recovery: 8,3%';'Steady-state: 64,28%';'Approaching limit: 23,94%';'Limit: 3,48%'}; 
combinedtxt = strcat(txt,percentValues);
pText(1).String = txt(1);   % 8,3%
pText(2).String = txt(2);   % 64,28%
pText(3).String = txt(3);   % 23,94%
pText(4).String = txt(4);   % 3,48%

% Resampling
SmO2_1Hz = resample(SmO2_test,1,4);

% Check frequency during the acquisition
format long
[a,b] = histc(t_test,unique(t_test));
y = a(b);
x = 1:length(t_test);
x1 = x + t_test';
x2 = x1';
%figure
%hist(y)
%figure
%hist(y.', unique(y(:)))
figure
plot(x1,y);
xlabel('Timestamp (s)');
ylabel('Frequency (Hz)');
title('SmO2 frequency');
%xlim([-5000 70000])
ylim([0 7])

%% Other byte arrays
% 1st byte array
E1 = dlmread('byteArray1.csv');
b1 = E1(157:2796,2);
t = (1:length(b1))/4;

% Plot
plot(t,b1);
xlabel('Time (s)');
ylabel('Value');
%title('Muscle Oxygenation');
xlim([0 640])
%ylim([50 60])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

% 2nd byte array
E2 = dlmread('byteArray2.csv');
b2 = E2(157:2796,2);
t = (1:length(b2))/4;

% Plot
plot(t,b2);
xlabel('Time (s)');
ylabel('Value');
%title('Muscle Oxygenation');
xlim([0 640])
%ylim([50 60])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

% 4th byte array
E3 = dlmread('byteArray4.csv');
b3 = E3(157:2796,2)/100;
t = (1:length(b3))/4;
t = 1:length(b3);

% Plot
plot(t,b3);
xlabel('Time (s)');
ylabel('Value');
%title('Muscle Oxygenation');
xlim([0 640])
%ylim([50 60])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

plot(t,SmO2_test,'-b',t,b3,'-r');

%% EDA
% Starting tstamp: 1595236435
C = dlmread('EDA_Data.csv');
EDA_test = C(3701:69700,3);
EDA_raw = 1./EDA_test;
ADC = EDA_raw./(2^10);
EDA_top = (ADC*3.3)./0.132;
EDA = EDA_top * (10^(-6));

% Low-pass 4th order Butterworth;  fc = 1Hz
fc = 0.1;     % cut-off freq 0.1Hz
fs = 100;     % sample rate 100Hz
n = 4;
[b,a] = butter(n,fc/(fs/2));
EDA_fil = filtfilt(b, a, EDA);

plot([EDA_fil]);

%
fid = fopen('data_eda.csv', 'wt');

tstamp = C(3701:69700,1);

A = [tstamp,EDA];

for ii = 1:size(A,1)
    fprintf(fid,'%f,',A(ii,:));
    fprintf(fid,'\n');
end

fclose(fid);

% FFT
Fs = 100;
EDA_fft = fft(detrend(EDA_test));
f = 0:Fs/length(EDA_test):Fs/2;
EDA_fft = EDA_fft(1:length(EDA_test)/2+1);
figure
plot(f,abs(EDA_fft)); xlabel('Frequency (Hz)'); ylabel('Magnitude');

% FFT
L = size(C,1);                                              % Vector Length
Ts = mean(diff(t_test));                                    % Sampling Interval (Assume ‘seconds’)
Fs = 1/Ts;                                                  % Sampling Frequency (Assume ‘Hz’)
Fn = Fs/2;                                                  % Nyquist Frequency (Assume ‘Hz’)
EDA_test = EDA_test - mean(EDA_test);                       % Remove D-C (Constant) Offset
Y = fft(EDA_test)/L;                                        % Scaled Two-Sided Discrete Fourier Transform
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                         % Frequency Vector
Iv = 1:length(Fv);                                          % Index Vector For Plot
figure
plot(Fv, 2*abs(Y(Iv)))
xlabel('Frequency')
ylabel('Magnitude')

EDA_lp = designfilt('lowpassfir','FilterOrder',100,'CutoffFrequency',0.1,'SampleRate',100);
y = filtfilt(EDA_lp,EDA);
% Plot
t = (1:length(EDA))/100;
plot(t,EDA);
hold on
plot(t,EDA_fil);
plot(t,y);
%lowpass(EDA,0.001,100)
xlabel('Time (s)');
ylabel('EDA (Siemens)');
title('Skin electrodermal activity');
xlim([0 660])
%ylim([0.00095 0.0015])
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

% Resampling
EDA_1Hz = resample(EDA_fil,1,100);
t = 1:length(EDA_1Hz);

% Plot resample
plot(t,EDA_1Hz);
xlabel('Time (s)');
ylabel('EDA (ys)');
title('Skin electrodermal activity');
xlim([0 660])
%ylim([0.00095 0.0015])
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

%% Energy Expenditure
% Keytel et. al 2005
EE = (-55.0969 + (0.6309*HR_test) + (0.1988*weight) + (0.2017*age))/4.184; %kcal/min

ee_fil = lowpass(EE,0.1,100);

sgf = sgolayfilt(EE,3,11);

% Plot
%plot(tstamp_test_conv,EE,'-b',tstamp_test_conv,sgf,'-r');
%plot(tstamp_test_conv,sgf,'-b');
plot(t,EE);
xlabel('Time (s)');
ylabel('EE (kcal/min)');
title('Energy Expenditure');
%legend('Normal','Filtered');
xlim([0 660])
ylim([10 18])
xline(180,'--r');
xline(360,'--r');
xl = xline(1,'--r','8km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(180,'--r','9km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';
xl = xline(360,'--r','10km/h');
xl.LabelVerticalAlignment = 'top';
xl.LabelHorizontalAlignment = 'right';
xl.LabelOrientation = 'horizontal';

cal_m = sum(sgf/60);

plot([HR_test EE]);

yyaxis left
plot(t,HR_test);
xlabel('Time (s)');
ylabel('Heart rate (BPM)');
ylim([150 180]);
yyaxis right
plot(t,EE);
%xlabel('Time (s)');
ylabel('EE (kcal/min)');
ylim([13 18]);
%% Accelerations
% Starting tstamp: 1595236435-1595237095
D = dlmread('Acc_Data.csv');
t_test = D(21969:90358,1);
t_test_conv = t_test - t_test(1);

% Check frequency during the acquisition
format long
[a,b] = histc(t_test,unique(t_test));
y = a(b);
x = 1:68390;
x1 = x + t_test';
x2 = x1';
%figure
%hist(y)
%figure
%hist(y.', unique(y(:)))
figure
plot(x1,y);
xlabel('Timestamp (s)');
ylabel('Frequency (Hz)');
title('Acc frequency');
%xlim([-5000 70000])
ylim([0 130])

%% Accelerations
clear;
close all;
clc;
D = dlmread('Acc_Data.csv');

%% Raw data
% Body locations
% Pelvis
x_pelvis = D(21969:90358,2);
y_pelvis = D(21969:90358,3);
z_pelvis = D(21969:90358,4);
m_pelvis = sqrt(x_pelvis.^2+y_pelvis.^2+z_pelvis.^2);

% L5(lower back - lombares)
x_l5 = D(21969:90358,5);
y_l5 = D(21969:90358,6);
z_l5 = D(21969:90358,7);
m_l5 = sqrt(x_l5.^2+y_l5.^2+z_l5.^2);

% L3(lower toraxic back - zona inferior vertebras toraxicas)
x_l3 = D(21969:90358,8);
y_l3 = D(21969:90358,9);
z_l3 = D(21969:90358,10);
m_l3 = sqrt(x_l3.^2+y_l3.^2+z_l3.^2);

% T12(medium toraxic back - zona intermedia vertebras toraxicas)
x_t12 = D(21969:90358,11);
y_t12 = D(21969:90358,12);
z_t12 = D(21969:90358,13);
m_t12 = sqrt(x_t12.^2+y_t12.^2+z_t12.^2);

% T8(upper toraxic back - zona superior vertebras toraxicas)
x_t8 = D(21969:90358,14);
y_t8 = D(21969:90358,15);
z_t8 = D(21969:90358,16);
m_t8 = sqrt(x_t8.^2+y_t8.^2+z_t8.^2);

% Neck
x_neck = D(21969:90358,17);
y_neck = D(21969:90358,18);
z_neck = D(21969:90358,19);
m_neck = sqrt(x_neck.^2+y_neck.^2+z_neck.^2);

% Head
x_head = D(21969:90358,20);
y_head = D(21969:90358,21);
z_head = D(21969:90358,22);
m_head = sqrt(x_head.^2+y_head.^2+z_head.^2);

% Right soulder
x_rs = D(21969:90358,23);
y_rs = D(21969:90358,24);
z_rs = D(21969:90358,25);
m_rs = sqrt(x_rs.^2+y_rs.^2+z_rs.^2);

% Right upper arm
x_rua = D(21969:90358,26);
y_rua = D(21969:90358,27);
z_rua = D(21969:90358,28);
m_rua = sqrt(x_rua.^2+y_rua.^2+z_rua.^2);

% Right forearm
x_rfa = D(21969:90358,29);
y_rfa = D(21969:90358,30);
z_rfa = D(21969:90358,31);
m_rfa = sqrt(x_rfa.^2+y_rfa.^2+z_rfa.^2);

% Right hand
x_rh = D(21969:90358,32);
y_rh = D(21969:90358,33);
z_rh = D(21969:90358,34);
m_rh = sqrt(x_rh.^2+y_rh.^2+z_rh.^2);

% Left shouler
x_ls = D(21969:90358,35);
y_ls = D(21969:90358,36);
z_ls = D(21969:90358,37);
m_ls = sqrt(x_ls.^2+y_ls.^2+z_ls.^2);

% Left upper-arm
x_lua = D(21969:90358,38);
y_lua = D(21969:90358,39);
z_lua = D(21969:90358,40);
m_lua = sqrt(x_lua.^2+y_lua.^2+z_lua.^2);

% Left forearm
x_lfa = D(21969:90358,41);
y_lfa = D(21969:90358,42);
z_lfa = D(21969:90358,43);
m_lfa = sqrt(x_lfa.^2+y_lfa.^2+z_lfa.^2);

% Left hand
x_lh = D(21969:90358,44);
y_lh = D(21969:90358,45);
z_lh = D(21969:90358,46);
m_lh = sqrt(x_lh.^2+y_lh.^2+z_lh.^2);

% Right upper leg
x_rul = D(21969:90358,47);
y_rul = D(21969:90358,48);
z_rul = D(21969:90358,49);
m_rul = sqrt(x_rul.^2+y_rul.^2+z_rul.^2);

% Right lower leg
x_rll = D(21969:90358,50);
y_rll = D(21969:90358,51);
z_rll = D(21969:90358,52);
m_rll = sqrt(x_rll.^2+y_rll.^2+z_rll.^2);

% Right foot
x_rf = D(21969:90358,53);
y_rf = D(21969:90358,54);
z_rf = D(21969:90358,55);
m_rf = sqrt(x_rf.^2+y_rf.^2+z_rf.^2);

% Right toe
x_rt = D(21969:90358,56);
y_rt = D(21969:90358,57);
z_rt = D(21969:90358,58);
m_rt = sqrt(x_rt.^2+y_rt.^2+z_rt.^2);

% Left upper leg
x_lul = D(21969:90358,59);
y_lul = D(21969:90358,60);
z_lul = D(21969:90358,61);
m_lul = sqrt(x_lul.^2+y_lul.^2+z_lul.^2);

% Left lower leg
x_lll = D(21969:90358,62);
y_lll = D(21969:90358,63);
z_lll = D(21969:90358,64);
m_lll = sqrt(x_lll.^2+y_lll.^2+z_lll.^2);

% Left foot
x_lf = D(21969:90358,65);
y_lf = D(21969:90358,66);
z_lf = D(21969:90358,67);
m_lf = sqrt(x_lf.^2+y_lf.^2+z_lf.^2);

% Left toe
x_lt = D(21969:90358,68);
y_lt = D(21969:90358,69);
z_lt = D(21969:90358,70);
m_lt = sqrt(x_lt.^2+y_lt.^2+z_lt.^2);


%% Filtering and resampling data example
% Low-pass 4th order Butterworth;  fc = 20Hz
fc = 20;    % cut-off freq 20Hz
fs = 120;   % sample rate 120Hz
n = 4;      % 4th order
[b,a] = butter(n,fc/(fs/2));

x_pelvis_fill = filtfilt(b, a, x_pelvis);
y_pelvis_fill = filtfilt(b, a, y_pelvis);
z_pelvis_fill = filtfilt(b, a, z_pelvis);
m_pelvis_fill = sqrt(x_pelvis_fill.^2+y_pelvis_fill.^2+z_pelvis_fill.^2);

x_pelvis_fill_lp = lowpass(x_pelvis, 20, 120);
y_pelvis_fill_lp = lowpass(y_pelvis, 20, 120);
z_pelvis_fill_lp = lowpass(z_pelvis, 20, 120);
m_pelvis_fill_lp = sqrt(x_pelvis_fill_lp.^2+y_pelvis_fill_lp.^2+z_pelvis_fill_lp.^2);

%% Filtering MVN acc data
%% Remove DC component and apply low-pass filter, fc = 20Hz. Then resample to 1Hz
%% Pelvis
% Remove DC component
f_x = fft(x_pelvis);
f_y = fft(y_pelvis);
f_z = fft(z_pelvis);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
lp_fil = designfilt('lowpassfir','FilterOrder',10,'CutoffFrequency',20,'SampleRate',120);   % Low pass filter, fc = 20Hz

y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_p_1hz = resample(y_mp,1,56);

%% L5(lower back - lombares)
% Remove DC component
f_x = fft(x_l5);
f_y = fft(y_l5);
f_z = fft(z_l5);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_l5_1hz = resample(y_mp,1,120);

%% L3(lower toraxic back - zona inferior vertebras toraxicas)
% Remove DC component
f_x = fft(x_l3);
f_y = fft(y_l3);
f_z = fft(z_l3);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_l3_1hz = resample(y_mp,1,120);

%% LT12(medium toraxic back - zona intermedia vertebras toraxicas)
% Remove DC component
f_x = fft(x_t12);
f_y = fft(y_t12);
f_z = fft(z_t12);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_t12_1hz = resample(y_mp,1,120);

%% LT8(medium toraxic back - zona intermedia vertebras toraxicas)
% Remove DC component
f_x = fft(x_t8);
f_y = fft(y_t8);
f_z = fft(z_t8);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_t8_1hz = resample(y_mp,1,120);

%% Neck
% Remove DC component
f_x = fft(x_neck);
f_y = fft(y_neck);
f_z = fft(z_neck);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_neck_1hz = resample(y_mp,1,120);

%% Head
% Remove DC component
f_x = fft(x_head);
f_y = fft(y_head);
f_z = fft(z_head);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_head_1hz = resample(y_mp,1,120);

%% Right shoulder
% Remove DC component
f_x = fft(x_rs);
f_y = fft(y_rs);
f_z = fft(z_rs);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rs_1hz = resample(y_mp,1,120);

%% Right upper arm
% Remove DC component
f_x = fft(x_rua);
f_y = fft(y_rua);
f_z = fft(z_rua);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rua_1hz = resample(y_mp,1,120);

%% Right forearm
% Remove DC component
f_x = fft(x_rfa);
f_y = fft(y_rfa);
f_z = fft(z_rfa);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rfa_1hz = resample(y_mp,1,120);

%% Right hand
% Remove DC component
f_x = fft(x_rh);
f_y = fft(y_rh);
f_z = fft(z_rh);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rh_1hz = resample(y_mp,1,120);

%% Left shoulder
% Remove DC component
f_x = fft(x_ls);
f_y = fft(y_ls);
f_z = fft(z_ls);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_ls_1hz = resample(y_mp,1,120);

%% Left upper arm
% Remove DC component
f_x = fft(x_lua);
f_y = fft(y_lua);
f_z = fft(z_lua);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lua_1hz = resample(y_mp,1,120);

%% Left forarm
% Remove DC component
f_x = fft(x_lfa);
f_y = fft(y_lfa);
f_z = fft(z_lfa);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lfa_1hz = resample(y_mp,1,120);

%% Left upper arm
% Remove DC component
f_x = fft(x_lh);
f_y = fft(y_lh);
f_z = fft(z_lh);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lh_1hz = resample(y_mp,1,120);

%% Right upper leg
% Remove DC component
f_x = fft(x_rul);
f_y = fft(y_rul);
f_z = fft(z_rul);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rul_1hz = resample(y_mp,1,120);

%% Right lower leg
% Remove DC component
f_x = fft(x_rll);
f_y = fft(y_rll);
f_z = fft(z_rll);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rll_1hz = resample(y_mp,1,120);

%% Right foot
% Remove DC component
f_x = fft(x_rf);
f_y = fft(y_rf);
f_z = fft(z_rf);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rf_1hz = resample(y_mp,1,120);

%% Right toe
% Remove DC component
f_x = fft(x_rt);
f_y = fft(y_rt);
f_z = fft(z_rt);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_rt_1hz = resample(y_mp,1,120);

%% Right upper leg
% Remove DC component
f_x = fft(x_lul);
f_y = fft(y_lul);
f_z = fft(z_lul);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lul_1hz = resample(y_mp,1,120);

%% Left lower leg
% Remove DC component
f_x = fft(x_lll);
f_y = fft(y_lll);
f_z = fft(z_lll);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lll_1hz = resample(y_mp,1,120);

%% Left foot
% Remove DC component
f_x = fft(x_lf);
f_y = fft(y_lf);
f_z = fft(z_lf);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lf_1hz = resample(y_mp,1,120);

%% Left toe
% Remove DC component
f_x = fft(x_lt);
f_y = fft(y_lt);
f_z = fft(z_lt);

f_x(1) = 0;
f_y(1) = 0;
f_z(1) = 0;

x_pelvis_nDC = real(ifft(f_x));
y_pelvis_nDC = real(ifft(f_y));
z_pelvis_nDC = real(ifft(f_z));

% Apply LP filter, fc = 20Hz
y_xp = filtfilt(lp_fil,x_pelvis_nDC);
y_yp = filtfilt(lp_fil,y_pelvis_nDC);
y_zp = filtfilt(lp_fil,z_pelvis_nDC);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

% Resample to 1 Hz
m_lt_1hz = resample(y_mp,1,120);


%% Raw data plots
% Pelvis magnitude vector
bp_fill = designfilt('bandpassfir','FilterOrder',20,'CutoffFrequency1',0.1,'CutoffFrequency2',10,'SampleRate',120);
[h,w] = freqz(bp_fill,120);
y = filtfilt(bp_fill,m_pelvis);
lp_fil = designfilt('lowpassfir','FilterOrder',10,'CutoffFrequency',20,'SampleRate',120);
y_xp = filtfilt(lp_fil,x_pelvis);
y_yp = filtfilt(lp_fil,y_pelvis);
y_zp = filtfilt(lp_fil,z_pelvis);
y_mp = sqrt((y_xp.^2)+(y_yp.^2)+(y_zp.^2));

plot([m_pelvis y_mp]);

t_raw = (1:length(m_rf))/120;
figure
plot(t_raw,x_pelvis);
hold on
plot(t_raw,y_xp);
%plot(t_raw,m_rf);
%plot(t_raw,m_pelvis,'g');
xlabel('Time');
ylabel('Acceleration (g)');
title('Acceleration VM (right foot)');

% Subplots
t_raw = (1:length(m_pelvis))/120;
figure
subplot(3,1,1);
plot(t_raw,m_pelvis);
xlim([500 510]);
xlabel('Time');
ylabel('Acceleration (g)');
title('Acceleration Magnitude (pelvis)');
subplot(3,1,2);
plot(t_raw,m_rf);
xlim([500 510]);
xlabel('Time');
ylabel('Acceleration (g)');
title('Acceleration Magnitude(right foot)');
subplot(3,1,3);
plot(t_raw,m_lf);
xlim([500 510]);
xlabel('Time');
ylabel('Acceleration (g)');
title('Acceleration Magnitude(left foot)');

% Resample pelvis magnitude vector
t_raw = 1:length(m_pelvis_1hz);
figure
plot(t_raw,m_pelvis_1hz);
xlabel('Time');
ylabel('Acceleration (g)');
title('Acceleration VM (pelvis)');
xlim([-1 721])


%% Import the data to csv_file
fid = fopen('Dataset_Sub011.csv', 'wt');

BMI = BMI+zeros(length(HR_test),1);
age = age+zeros(length(HR_test),1);
height = height+zeros(length(HR_test),1);
weight = weight+zeros(length(HR_test),1);
gender = gender+zeros(length(HR_test),1);

A = [age,weight,height,BMI,HR_test,SmO2_1Hz,EDA_1Hz,m_p_1hz(1:406),m_l5_1hz(1:406),m_l3_1hz(1:406), m_t12_1hz(1:406),m_t8_1hz(1:406),m_neck_1hz(1:406),m_head_1hz(1:406),m_rs_1hz(1:406),m_rua_1hz(1:406),m_rfa_1hz(1:406),m_rh_1hz(1:406),m_ls_1hz(1:406),m_lua_1hz(1:406),m_lfa_1hz(1:406),m_lh_1hz(1:406),m_rul_1hz(1:406),m_rll_1hz(1:406),m_rf_1hz(1:406),m_rt_1hz(1:406),m_lul_1hz(1:406),m_lll_1hz(1:406),m_lf_1hz(1:406),m_lt_1hz(1:406),gender];

for ii = 1:size(A,1)
    fprintf(fid,'%f,',A(ii,:));
    fprintf(fid,'\n');
end

fclose(fid);

%% Correlation
fid = fopen('EE_001.csv', 'wt');
A = [EE];
for ii = 1:size(A,1)
    fprintf(fid,'%f,',A(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);