%% Accelerometry Filtering
clear all;
close all;
clc;

%% Raw data from 6 stationary positions
Ar_P1 = dlmread('y1.csv');
Ar_P2 = dlmread('y2.csv');
Ar_P3 = dlmread('y3.csv');
Ar_P4 = dlmread('y4.csv');
Ar_P5 = dlmread('y5.csv');
Ar_P6 = dlmread('y6.csv');

n = 2240;    % number of raw acc samples
t = linspace(0,10,n)';
Ka = 2048;  % scale factor (sensitivity)

% for nx1 vectors of 1, 0 and -1 
one_vec = ones(n,1);
neg_one_vec = ones(n,1)*(-1);
zero_vec = ones(n,1)*0;

% Position 1
accX_H_p1 = Ar_P1(:,1)*2.^8;
accX_L_p1 = Ar_P1(:,2);
accY_H_p1 = Ar_P1(:,3)*2.^8;
accY_L_p1 = Ar_P1(:,4);
accZ_H_p1 = Ar_P1(:,5)*2.^8;
accZ_L_p1 = Ar_P1(:,6);

Ax_P1 = accX_H_p1 + accX_L_p1;
Ay_P1 = accY_H_p1 + accY_L_p1;
Az_P1 = accZ_H_p1 + accZ_L_p1;

w1 = [Ax_P1 Ay_P1 Az_P1 one_vec];

Y1 = [zero_vec zero_vec one_vec];       % y1 = [0 0 1]

% Position 2
accX_H_p2 = Ar_P2(:,1)*2.^8;
accX_L_p2 = Ar_P2(:,2);
accY_H_p2 = Ar_P2(:,3)*2.^8;
accY_L_p2 = Ar_P2(:,4);
accZ_H_p2 = Ar_P2(:,5)*2.^8;
accZ_L_p2 = Ar_P2(:,6);

Ax_P2 = accX_H_p2 + accX_L_p2;
Ay_P2 = accY_H_p2 + accY_L_p2;
Az_P2 = accZ_H_p2 + accZ_L_p2;

w2 = [Ax_P2 Ay_P2 Az_P2 one_vec];

Y2 = [zero_vec zero_vec neg_one_vec];      % y2 = [0 0 -1]

% Position 3
accX_H_p3 = Ar_P3(:,1)*2.^8;
accX_L_p3 = Ar_P3(:,2);
accY_H_p3 = Ar_P3(:,3)*2.^8;
accY_L_p3 = Ar_P3(:,4);
accZ_H_p3 = Ar_P3(:,5)*2.^8;
accZ_L_p3 = Ar_P3(:,6);

Ax_P3 = accX_H_p3 + accX_L_p3;
Ay_P3 = accY_H_p3 + accY_L_p3;
Az_P3 = accZ_H_p3 + accZ_L_p3;

w3 = [Ax_P3 Ay_P3 Az_P3 one_vec];    

Y3 = [zero_vec one_vec zero_vec];    % y3 = [0 1 0]

% Position 4
accX_H_p4 = Ar_P4(:,1)*2.^8;
accX_L_p4 = Ar_P4(:,2);
accY_H_p4 = Ar_P4(:,3)*2.^8;
accY_L_p4 = Ar_P4(:,4);
accZ_H_p4 = Ar_P4(:,5)*2.^8;
accZ_L_p4 = Ar_P4(:,6);

Ax_P4 = accX_H_p4 + accX_L_p4;
Ay_P4 = accY_H_p4 + accY_L_p4;
Az_P4 = accZ_H_p4 + accZ_L_p4;

w4 = [Ax_P4 Ay_P4 Az_P4 one_vec];

Y4 = [zero_vec neg_one_vec zero_vec];    % y4 = [0 -1 0]

% Position 5
accX_H_p5 = Ar_P5(:,1)*2.^8;
accX_L_p5 = Ar_P5(:,2);
accY_H_p5 = Ar_P5(:,3)*2.^8;
accY_L_p5 = Ar_P5(:,4);
accZ_H_p5 = Ar_P5(:,5)*2.^8;
accZ_L_p5 = Ar_P5(:,6);

Ax_P5 = accX_H_p5 + accX_L_p5;
Ay_P5 = accY_H_p5 + accY_L_p5;
Az_P5 = accZ_H_p5 + accZ_L_p5;

w5 = [Ax_P5 Ay_P5 Az_P5 one_vec];

Y5 = [one_vec zero_vec zero_vec];    % y5 = [1 0 0]

% Position 6
accX_H_p6 = Ar_P6(:,1)*2.^8;
accX_L_p6 = Ar_P6(:,2);
accY_H_p6 = Ar_P6(:,3)*2.^8;
accY_L_p6 = Ar_P6(:,4);
accZ_H_p6 = Ar_P6(:,5)*2.^8;
accZ_L_p6 = Ar_P6(:,6);

Ax_P6 = accX_H_p6 + accX_L_p6;
Ay_P6 = accY_H_p6 + accY_L_p6;
Az_P6 = accZ_H_p6 + accZ_L_p6;

w6 = [Ax_P6 Ay_P6 Az_P6 one_vec];

Y6 = [neg_one_vec zero_vec zero_vec];    % y6 = [-1 0 0]

%% Determination of matrix X
Y = [Y1; Y2; Y3; Y4; Y5; Y6];
w = [w1; w2; w3; w4; w5; w6];

X = inv(w'*w)*w'*Y;

%% Calculation of the calibrated values
Xa = X(1:3,1:3);
Xb = X(4,:)';

% An_Pk = Xa*[Ax_Pk,Ay_Pk,Az_Pk] + Xb;
% Position 1
for ii = 1:n
    An_P1(ii,:) = (Xa*[Ax_P1(ii),Ay_P1(ii),Az_P1(ii)]' + Xb)';
end

% Position 2
for ii = 1:n
    An_P2(ii,:) = (Xa*[Ax_P2(ii),Ay_P2(ii),Az_P2(ii)]' + Xb)';
end

% Position 3
for ii = 1:n
    An_P3(ii,:) = (Xa*[Ax_P3(ii),Ay_P3(ii),Az_P3(ii)]' + Xb)';
end

% Position 4
for ii = 1:n
    An_P4(ii,:) = (Xa*[Ax_P4(ii),Ay_P4(ii),Az_P4(ii)]' + Xb)';
end

% Position 5
for ii = 1:n
    An_P5(ii,:) = (Xa*[Ax_P5(ii),Ay_P5(ii),Az_P5(ii)]' + Xb)';
end

% Position 6
for ii = 1:n
    An_P6(ii,:) = (Xa*[Ax_P6(ii),Ay_P6(ii),Az_P6(ii)]' + Xb)';
end

%% Plot data with vs without calibration
% Position1
plot(t,Ax_P1/Ka,'b',t,An_P1(:,1),'r');
grid on;
xlabel('Time (s)');
ylabel('Acc (g)');
title('Acc: X axis');
legend('Raw data: Ka=2048','Calibrated data');