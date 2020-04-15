%% Accelerometry Filtering
clear all;
close all;
clc;

A = dlmread('Dataset.csv');
t = linspace(0,1157,1157000)';
accX = A(:,2);
accY = A(:,3);
accZ = A(:,4);
spo2 = A(:,5);
hr = A(:,6);
rri = A(:,7);

fs = 1000;
fpass = 0.7;    % cut-off frequency of the filter in Hz.

% Low pass filter
accXFill_low = lowpass(accX,fpass,fs);      %  accX is sampled at a rate of fs Hz.
accYFill_low = lowpass(accY,fpass,fs);      %  accY is sampled at a rate of fs Hz.
accZFill_low = lowpass(accZ,fpass,fs);      %  accZ is sampled at a rate of fs Hz.

% High pass filter
accXFill_high = highpass(accX,fpass,fs);    %  accX is sampled at a rate of fs Hz.
accYFill_high = highpass(accY,fpass,fs);    %  accY is sampled at a rate of fs Hz.
accZFill_high = highpass(accZ,fpass,fs);    %  accZ is sampled at a rate of fs Hz.

fnorm = 0.01;
df = designfilt('lowpassiir',...       
               'PassbandFrequency',fnorm,...
               'FilterOrder',7,...
               'PassbandRipple',1,...
               'StopbandAttenuation',60);
           
accXFill_Model = filtfilt(df,accXFill_high);
accYFill_Model = filtfilt(df,accYFill_high);
accZFill_Model = filtfilt(df,accZFill_high);
           
           
%% Plots
% X axis
subplot(3,1,1);
hold on;
plot(t,accX,'b'); 
%plot(t,accXFill_low,'g'); 
plot(t,accXFill_high,'r');
%plot(t,accXFill_Model,'g');
grid on;
xlabel('Time (s)');
ylabel('Acc (g)');
title('Acc: X axis');
legend('Original','Filtered Signal');
%legend('Original','Filtered: low pass','Filtered: high pass','Filtered: model');

% Y axis
subplot(3,1,2);
hold on;
plot(t,accY,'b');
%plot(t,accYFill_low,'g');
plot(t,accYFill_high,'r');
%plot(t,accYFill_Model,'r');
grid on;
xlabel('Time (s)');
ylabel('Acc (g)');
title('Acc: Y axis');
legend('Original','Filtered Signal');
%legend('Original','Filtered: low pass','Filtered: high pass','Filtered: model');

% Z axis
subplot(3,1,3);
hold on;
plot(t,accZ,'b');
%plot(t,accZFill_low,'g');
plot(t,accZFill_high,'r');
%plot(t,accZFill_Model,'r');
grid on;
xlabel('Time (s)');
ylabel('Acc (g)');
title('Acc: Z axis');
legend('Original','Filtered Signal');
%legend('Original','Filtered: low pass','Filtered: high pass','Filtered: model');

%% Energy Expenditure Calculation
age = 23;
weight = 58;
hr_max = 220 - age;         % Karvonen formula to calculate maximum heart rate
hr_rest = 52;               % Mean value of the average heart rate over a resting period of 7 min
hr_reserve_pct = ((hr - hr_rest)/(hr_max - hr_rest))*100;     % Percentage heart rate reserve

accFill_Norm = sqrt(accXFill_high.^2 + accYFill_high.^2 + accZFill_high.^2);    % Vector magnitude of the filtered acceleration

MET = 0.0024*accFill_Norm + 0.029*hr_reserve_pct + 5.3113;  % Metabolic equivalent estimation

EE = 0.0175*MET*weight;     % Energy Expenditure in kcal/min

% EE plot
subplot(3,1,1);
plot(t,EE,'b');
grid on;
xlabel('Time (s)');
ylabel('EE (kcal/min)');
title('Energy Expenditure during 20 minutes of running');

% HR plot
subplot(3,1,2);
plot(t,hr,'r');
grid on;
xlabel('Time (s)');
ylabel('HR (bmp)');
title('Heart Rate during 20 minutes of running');

% MET plot
subplot(3,1,3);
plot(t,MET,'y');
grid on;
xlabel('Time (s)');
ylabel('MET');
title('METs during 20 minutes of running');

%% Saving the data
data = [accXFill_Model,accYFill_Model,accZFill_Model,spo2,hr,rri,EE];
fid = fopen('Dataset_Filt.csv', 'wt');

for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end

fclose(fid);
%type('teste_AccFiltered_HP.csv');