clear all
clc
load('Subject04.mat')
%% Demographics
% Gender = male
s4_h = 168;
s4_w = 68.03;
s4_a = 25;

%% 1D Gaussian lowpass filter
%https://www.mathworks.com/matlabcentral/fileexchange/12606-1d-gaussian-lowpass-filter
%https://www.mathworks.com/matlabcentral/answers/75987-gaussian-smoothing-of-time-series

%% Walking
% APDM_Accel - waist, chest, ankles and foot
s4_walk_waist_accX = Subject04.Walking.APDM_Accel.Data(:,3);
s4_walk_waist_accY = Subject04.Walking.APDM_Accel.Data(:,4);
s4_walk_waist_accZ = Subject04.Walking.APDM_Accel.Data(:,5);
s4_walk_waist_mag = sqrt(s4_walk_waist_accX.^2 + s4_walk_waist_accY.^2 + s4_walk_waist_accZ.^2);

s4_walk_chest_accX = Subject04.Walking.APDM_Accel.Data(:,12);
s4_walk_chest_accY = Subject04.Walking.APDM_Accel.Data(:,13);
s4_walk_chest_accZ = Subject04.Walking.APDM_Accel.Data(:,14);
s4_walk_chest_mag = sqrt(s4_walk_chest_accX.^2 + s4_walk_chest_accY.^2 + s4_walk_chest_accZ.^2);

s4_walk_leftAnk_accX = Subject04.Walking.APDM_Accel.Data(:,21);
s4_walk_leftAnk_accY = Subject04.Walking.APDM_Accel.Data(:,22);
s4_walk_leftAnk_accZ = Subject04.Walking.APDM_Accel.Data(:,23);
s4_walk_leftAnk_mag = sqrt(s4_walk_leftAnk_accX.^2 + s4_walk_leftAnk_accY.^2 + s4_walk_leftAnk_accZ.^2);

s4_walk_rightAnk_accX = Subject04.Walking.APDM_Accel.Data(:,30);
s4_walk_rightAnk_accY = Subject04.Walking.APDM_Accel.Data(:,31);
s4_walk_rightAnk_accZ = Subject04.Walking.APDM_Accel.Data(:,32);
s4_walk_rightAnk_mag = sqrt(s4_walk_rightAnk_accX.^2 + s4_walk_rightAnk_accY.^2 + s4_walk_rightAnk_accZ.^2);

s4_walk_leftFoot_accX = Subject04.Walking.APDM_Accel.Data(:,39);
s4_walk_leftFoot_accY = Subject04.Walking.APDM_Accel.Data(:,40);
s4_walk_leftFoot_accZ = Subject04.Walking.APDM_Accel.Data(:,41);
s4_walk_leftFoot_mag = sqrt(s4_walk_leftFoot_accX.^2 + s4_walk_leftFoot_accY.^2 + s4_walk_leftFoot_accZ.^2);

s4_walk_rightFoot_accX = Subject04.Walking.APDM_Accel.Data(:,48);
s4_walk_rightFoot_accY = Subject04.Walking.APDM_Accel.Data(:,49);
s4_walk_rightFoot_accZ = Subject04.Walking.APDM_Accel.Data(:,50);
s4_walk_rightFoot_mag = sqrt(s4_walk_rightFoot_accX.^2 + s4_walk_rightFoot_accY.^2 + s4_walk_rightFoot_accZ.^2);

% Empatica_Accel - Wrists
s4_walk_leftWrist_accX = Subject04.Walking.Empatica_Accel.Data(:,3);
s4_walk_leftWrist_accY = Subject04.Walking.Empatica_Accel.Data(:,4);
s4_walk_leftWrist_accZ = Subject04.Walking.Empatica_Accel.Data(:,5);
s4_walk_leftWrist_mag = sqrt(s4_walk_leftWrist_accX.^2 + s4_walk_leftWrist_accY.^2 + s4_walk_leftWrist_accZ.^2);

s4_walk_rightWrist_accX = Subject04.Walking.Empatica_Accel.Data(:,6);
s4_walk_rightWrist_accY = Subject04.Walking.Empatica_Accel.Data(:,7);
s4_walk_rightWrist_accZ = Subject04.Walking.Empatica_Accel.Data(:,8);
s4_walk_rightWrist_mag = sqrt(s4_walk_rightWrist_accX.^2 + s4_walk_rightWrist_accY.^2 + s4_walk_rightWrist_accZ.^2);

% Empatica_Physio - Wrists EDA and Skin Temperature
s4_walk_leftWrist_EDA = Subject04.Walking.Empatica_Physio.Data(:,3);
s4_walk_rightWrist_EDA = Subject04.Walking.Empatica_Physio.Data(:,5);

s4_walk_leftWrist_skinTemp = Subject04.Walking.Empatica_Physio.Data(:,4);
s4_walk_rightWrist_skinTemp = Subject04.Walking.Empatica_Physio.Data(:,6);

% Metabolic System - VO2, VC02, RER, BF, MV, OxS, HR
s4_walk_VO2 = Subject04.Walking.Metabolics_System.Data(:,3);
s4_walk_VCO2 = Subject04.Walking.Metabolics_System.Data(:,4);
s4_walk_gtEEcost = 16.58*s4_walk_VO2 + 4.84*s4_walk_VCO2;

%t = linspace(0,24,573)';
%hold on;
%subplot(3,1,1);
%plot(t,s4_walk_gtEEcost,'b');
%subplot(3,1,2);
%plot(t,s4_walk_VO2,'y');
%subplot(3,1,3);
%plot(t,s4_walk_VCO2,'g');

s4_walk_RER = Subject04.Walking.Metabolics_System.Data(:,5);
s4_walk_BreathFreq = Subject04.Walking.Metabolics_System.Data(:,6);
s4_walk_MinVent = Subject04.Walking.Metabolics_System.Data(:,7);
s4_walk_OxySat = Subject04.Walking.Metabolics_System.Data(:,8);
s4_walk_HR = Subject04.Walking.Metabolics_System.Data(:,9);

% EMG
s4_walk_left_EMG_1 = Subject04.Walking.EMG.Data(:,3);
s4_walk_left_EMG_2 = Subject04.Walking.EMG.Data(:,4);
s4_walk_left_EMG_3 = Subject04.Walking.EMG.Data(:,5);
s4_walk_left_EMG_4 = Subject04.Walking.EMG.Data(:,6);
s4_walk_left_EMG_5 = Subject04.Walking.EMG.Data(:,7);
s4_walk_left_EMG_6 = Subject04.Walking.EMG.Data(:,8);
s4_walk_left_EMG_7 = Subject04.Walking.EMG.Data(:,9);
s4_walk_left_EMG_8 = Subject04.Walking.EMG.Data(:,10);
s4_walk_left_EMG_mag = sqrt(s4_walk_left_EMG_1.^2 + s4_walk_left_EMG_2.^2 + s4_walk_left_EMG_3.^2 + s4_walk_left_EMG_4.^2 + s4_walk_left_EMG_5.^2 + s4_walk_left_EMG_6.^2 + s4_walk_left_EMG_7.^2 + s4_walk_left_EMG_8.^2);

s4_walk_right_EMG_1 = Subject04.Walking.EMG.Data(:,11);
s4_walk_right_EMG_2 = Subject04.Walking.EMG.Data(:,12);
s4_walk_right_EMG_3 = Subject04.Walking.EMG.Data(:,13);
s4_walk_right_EMG_4 = Subject04.Walking.EMG.Data(:,14);
s4_walk_right_EMG_5 = Subject04.Walking.EMG.Data(:,15);
s4_walk_right_EMG_6 = Subject04.Walking.EMG.Data(:,16);
s4_walk_right_EMG_7 = Subject04.Walking.EMG.Data(:,17);
s4_walk_right_EMG_8 = Subject04.Walking.EMG.Data(:,18);
s4_walk_right_EMG_mag = sqrt(s4_walk_right_EMG_1.^2 + s4_walk_right_EMG_2.^2 + s4_walk_right_EMG_3.^2 + s4_walk_right_EMG_4.^2 + s4_walk_right_EMG_5.^2 + s4_walk_right_EMG_6.^2 + s4_walk_right_EMG_7.^2 + s4_walk_right_EMG_8.^2);

%% Incline
% APDM_Accel - waist, chest, ankles and foot
s4_incline_waist_accX = Subject04.Incline.APDM_Accel.Data(:,3);
s4_incline_waist_accY = Subject04.Incline.APDM_Accel.Data(:,4);
s4_incline_waist_accZ = Subject04.Incline.APDM_Accel.Data(:,5);
s4_incline_waist_mag = sqrt(s4_incline_waist_accX.^2 + s4_incline_waist_accY.^2 + s4_incline_waist_accZ.^2);

s4_incline_chest_accX = Subject04.Incline.APDM_Accel.Data(:,12);
s4_incline_chest_accY = Subject04.Incline.APDM_Accel.Data(:,13);
s4_incline_chest_accZ = Subject04.Incline.APDM_Accel.Data(:,14);
s4_incline_chest_mag = sqrt(s4_incline_chest_accX.^2 + s4_incline_chest_accY.^2 + s4_incline_chest_accZ.^2);

s4_incline_leftAnk_accX = Subject04.Incline.APDM_Accel.Data(:,21);
s4_incline_leftAnk_accY = Subject04.Incline.APDM_Accel.Data(:,22);
s4_incline_leftAnk_accZ = Subject04.Incline.APDM_Accel.Data(:,23);
s4_incline_leftAnk_mag = sqrt(s4_incline_leftAnk_accX.^2 + s4_incline_leftAnk_accY.^2 + s4_incline_leftAnk_accZ.^2);

s4_incline_rightAnk_accX = Subject04.Incline.APDM_Accel.Data(:,30);
s4_incline_rightAnk_accY = Subject04.Incline.APDM_Accel.Data(:,31);
s4_incline_rightAnk_accZ = Subject04.Incline.APDM_Accel.Data(:,32);
s4_incline_rightAnk_mag = sqrt(s4_incline_rightAnk_accX.^2 + s4_incline_rightAnk_accY.^2 + s4_incline_rightAnk_accZ.^2);

s4_incline_leftFoot_accX = Subject04.Incline.APDM_Accel.Data(:,39);
s4_incline_leftFoot_accY = Subject04.Incline.APDM_Accel.Data(:,40);
s4_incline_leftFoot_accZ = Subject04.Incline.APDM_Accel.Data(:,41);
s4_incline_leftFoot_mag = sqrt(s4_incline_leftFoot_accX.^2 + s4_incline_leftFoot_accY.^2 + s4_incline_leftFoot_accZ.^2);

s4_incline_rightFoot_accX = Subject04.Incline.APDM_Accel.Data(:,48);
s4_incline_rightFoot_accY = Subject04.Incline.APDM_Accel.Data(:,49);
s4_incline_rightFoot_accZ = Subject04.Incline.APDM_Accel.Data(:,50);
s4_incline_rightFoot_mag = sqrt(s4_incline_rightFoot_accX.^2 + s4_incline_rightFoot_accY.^2 + s4_incline_rightFoot_accZ.^2);

% Empatica_Accel - Wrists
s4_incline_leftWrist_accX = Subject04.Incline.Empatica_Accel.Data(:,3);
s4_incline_leftWrist_accY = Subject04.Incline.Empatica_Accel.Data(:,4);
s4_incline_leftWrist_accZ = Subject04.Incline.Empatica_Accel.Data(:,5);
s4_incline_leftWrist_mag = sqrt(s4_incline_leftWrist_accX.^2 + s4_incline_leftWrist_accY.^2 + s4_incline_leftWrist_accZ.^2);

s4_incline_rightWrist_accX = Subject04.Incline.Empatica_Accel.Data(:,6);
s4_incline_rightWrist_accY = Subject04.Incline.Empatica_Accel.Data(:,7);
s4_incline_rightWrist_accZ = Subject04.Incline.Empatica_Accel.Data(:,8);
s4_incline_rightWrist_mag = sqrt(s4_incline_rightWrist_accX.^2 + s4_incline_rightWrist_accY.^2 + s4_incline_rightWrist_accZ.^2);

% Empatica_Physio - Wrists EDA and Skin Temperature
s4_incline_leftWrist_EDA = Subject04.Incline.Empatica_Physio.Data(:,3);
s4_incline_rightWrist_EDA = Subject04.Incline.Empatica_Physio.Data(:,5);

s4_incline_leftWrist_skinTemp = Subject04.Incline.Empatica_Physio.Data(:,4);
s4_incline_rightWrist_skinTemp = Subject04.Incline.Empatica_Physio.Data(:,6);

% Metabolic System - VO2, VC02, RER, BF, MV, OxS, HR
s4_incline_VO2 = Subject04.Incline.Metabolics_System.Data(:,3);
s4_incline_VCO2 = Subject04.Incline.Metabolics_System.Data(:,4);
s4_incline_gtEEcost = 16.58*s4_incline_VO2 + 4.84*s4_incline_VCO2;

s4_incline_RER = Subject04.Incline.Metabolics_System.Data(:,5);
s4_incline_BreathFreq = Subject04.Incline.Metabolics_System.Data(:,6);
s4_incline_MinVent = Subject04.Incline.Metabolics_System.Data(:,7);
s4_incline_OxySat = Subject04.Incline.Metabolics_System.Data(:,8);
s4_incline_HR = Subject04.Incline.Metabolics_System.Data(:,9);

% EMG
s4_incline_left_EMG_1 = Subject04.Incline.EMG.Data(:,3);
s4_incline_left_EMG_2 = Subject04.Incline.EMG.Data(:,4);
s4_incline_left_EMG_3 = Subject04.Incline.EMG.Data(:,5);
s4_incline_left_EMG_4 = Subject04.Incline.EMG.Data(:,6);
s4_incline_left_EMG_5 = Subject04.Incline.EMG.Data(:,7);
s4_incline_left_EMG_6 = Subject04.Incline.EMG.Data(:,8);
s4_incline_left_EMG_7 = Subject04.Incline.EMG.Data(:,9);
s4_incline_left_EMG_8 = Subject04.Incline.EMG.Data(:,10);
s4_incline_left_EMG_mag = sqrt(s4_incline_left_EMG_1.^2 + s4_incline_left_EMG_2.^2 + s4_incline_left_EMG_3.^2 + s4_incline_left_EMG_4.^2 + s4_incline_left_EMG_5.^2 + s4_incline_left_EMG_6.^2 + s4_incline_left_EMG_7.^2 + s4_incline_left_EMG_8.^2);

s4_incline_right_EMG_1 = Subject04.Incline.EMG.Data(:,11);
s4_incline_right_EMG_2 = Subject04.Incline.EMG.Data(:,12);
s4_incline_right_EMG_3 = Subject04.Incline.EMG.Data(:,13);
s4_incline_right_EMG_4 = Subject04.Incline.EMG.Data(:,14);
s4_incline_right_EMG_5 = Subject04.Incline.EMG.Data(:,15);
s4_incline_right_EMG_6 = Subject04.Incline.EMG.Data(:,16);
s4_incline_right_EMG_7 = Subject04.Incline.EMG.Data(:,17);
s4_incline_right_EMG_8 = Subject04.Incline.EMG.Data(:,18);
s4_incline_right_EMG_mag = sqrt(s4_incline_right_EMG_1.^2 + s4_incline_right_EMG_2.^2 + s4_incline_right_EMG_3.^2 + s4_incline_right_EMG_4.^2 + s4_incline_right_EMG_5.^2 + s4_incline_right_EMG_6.^2 + s4_incline_right_EMG_7.^2 + s4_incline_right_EMG_8.^2);

%% Backwards
% APDM_Accel - waist, chest, ankles and foot
s4_back_waist_accX = Subject04.Backwards.APDM_Accel.Data(:,3);
s4_back_waist_accY = Subject04.Backwards.APDM_Accel.Data(:,4);
s4_back_waist_accZ = Subject04.Backwards.APDM_Accel.Data(:,5);
s4_back_waist_mag = sqrt(s4_back_waist_accX.^2 + s4_back_waist_accY.^2 + s4_back_waist_accZ.^2);

s4_back_chest_accX = Subject04.Backwards.APDM_Accel.Data(:,12);
s4_back_chest_accY = Subject04.Backwards.APDM_Accel.Data(:,13);
s4_back_chest_accZ = Subject04.Backwards.APDM_Accel.Data(:,14);
s4_back_chest_mag = sqrt(s4_back_chest_accX.^2 + s4_back_chest_accY.^2 + s4_back_chest_accZ.^2);

s4_back_leftAnk_accX = Subject04.Backwards.APDM_Accel.Data(:,21);
s4_back_leftAnk_accY = Subject04.Backwards.APDM_Accel.Data(:,22);
s4_back_leftAnk_accZ = Subject04.Backwards.APDM_Accel.Data(:,23);
s4_back_leftAnk_mag = sqrt(s4_back_leftAnk_accX.^2 + s4_back_leftAnk_accY.^2 + s4_back_leftAnk_accZ.^2);

s4_back_rightAnk_accX = Subject04.Backwards.APDM_Accel.Data(:,30);
s4_back_rightAnk_accY = Subject04.Backwards.APDM_Accel.Data(:,31);
s4_back_rightAnk_accZ = Subject04.Backwards.APDM_Accel.Data(:,32);
s4_back_rightAnk_mag = sqrt(s4_back_rightAnk_accX.^2 + s4_back_rightAnk_accY.^2 + s4_back_rightAnk_accZ.^2);

s4_back_leftFoot_accX = Subject04.Backwards.APDM_Accel.Data(:,39);
s4_back_leftFoot_accY = Subject04.Backwards.APDM_Accel.Data(:,40);
s4_back_leftFoot_accZ = Subject04.Backwards.APDM_Accel.Data(:,41);
s4_back_leftFoot_mag = sqrt(s4_back_leftFoot_accX.^2 + s4_back_leftFoot_accY.^2 + s4_back_leftFoot_accZ.^2);

s4_back_rightFoot_accX = Subject04.Backwards.APDM_Accel.Data(:,48);
s4_back_rightFoot_accY = Subject04.Backwards.APDM_Accel.Data(:,49);
s4_back_rightFoot_accZ = Subject04.Backwards.APDM_Accel.Data(:,50);
s4_back_rightFoot_mag = sqrt(s4_back_rightFoot_accX.^2 + s4_back_rightFoot_accY.^2 + s4_back_rightFoot_accZ.^2);

% Empatica_Accel - Wrists
s4_back_leftWrist_accX = Subject04.Backwards.Empatica_Accel.Data(:,3);
s4_back_leftWrist_accY = Subject04.Backwards.Empatica_Accel.Data(:,4);
s4_back_leftWrist_accZ = Subject04.Backwards.Empatica_Accel.Data(:,5);
s4_back_leftWrist_mag = sqrt(s4_back_leftWrist_accX.^2 + s4_back_leftWrist_accY.^2 + s4_back_leftWrist_accZ.^2);

s4_back_rightWrist_accX = Subject04.Backwards.Empatica_Accel.Data(:,6);
s4_back_rightWrist_accY = Subject04.Backwards.Empatica_Accel.Data(:,7);
s4_back_rightWrist_accZ = Subject04.Backwards.Empatica_Accel.Data(:,8);
s4_back_rightWrist_mag = sqrt(s4_back_rightWrist_accX.^2 + s4_back_rightWrist_accY.^2 + s4_back_rightWrist_accZ.^2);

% Empatica_Physio - Wrists EDA and Skin Temperature
s4_back_leftWrist_EDA = Subject04.Backwards.Empatica_Physio.Data(:,3);
s4_back_rightWrist_EDA = Subject04.Backwards.Empatica_Physio.Data(:,5);

s4_back_leftWrist_skinTemp = Subject04.Backwards.Empatica_Physio.Data(:,4);
s4_back_rightWrist_skinTemp = Subject04.Backwards.Empatica_Physio.Data(:,6);

% Metabolic System - VO2, VC02, RER, BF, MV, OxS, HR
s4_back_VO2 = Subject04.Backwards.Metabolics_System.Data(:,3);
s4_back_VCO2 = Subject04.Backwards.Metabolics_System.Data(:,4);
s4_back_gtEEcost = 16.58*s4_back_VO2 + 4.84*s4_back_VCO2;

s4_back_RER = Subject04.Backwards.Metabolics_System.Data(:,5);
s4_back_BreathFreq = Subject04.Backwards.Metabolics_System.Data(:,6);
s4_back_MinVent = Subject04.Backwards.Metabolics_System.Data(:,7);
s4_back_OxySat = Subject04.Backwards.Metabolics_System.Data(:,8);
s4_back_HR = Subject04.Backwards.Metabolics_System.Data(:,9);

% EMG
s4_back_left_EMG_1 = Subject04.Backwards.EMG.Data(:,3);
s4_back_left_EMG_2 = Subject04.Backwards.EMG.Data(:,4);
s4_back_left_EMG_3 = Subject04.Backwards.EMG.Data(:,5);
s4_back_left_EMG_4 = Subject04.Backwards.EMG.Data(:,6);
s4_back_left_EMG_5 = Subject04.Backwards.EMG.Data(:,7);
s4_back_left_EMG_6 = Subject04.Backwards.EMG.Data(:,8);
s4_back_left_EMG_7 = Subject04.Backwards.EMG.Data(:,9);
s4_back_left_EMG_8 = Subject04.Backwards.EMG.Data(:,10);
s4_back_left_EMG_mag = sqrt(s4_back_left_EMG_1.^2 + s4_back_left_EMG_2.^2 + s4_back_left_EMG_3.^2 + s4_back_left_EMG_4.^2 + s4_back_left_EMG_5.^2 + s4_back_left_EMG_6.^2 + s4_back_left_EMG_7.^2 + s4_back_left_EMG_8.^2);

s4_back_right_EMG_1 = Subject04.Backwards.EMG.Data(:,11);
s4_back_right_EMG_2 = Subject04.Backwards.EMG.Data(:,12);
s4_back_right_EMG_3 = Subject04.Backwards.EMG.Data(:,13);
s4_back_right_EMG_4 = Subject04.Backwards.EMG.Data(:,14);
s4_back_right_EMG_5 = Subject04.Backwards.EMG.Data(:,15);
s4_back_right_EMG_6 = Subject04.Backwards.EMG.Data(:,16);
s4_back_right_EMG_7 = Subject04.Backwards.EMG.Data(:,17);
s4_back_right_EMG_8 = Subject04.Backwards.EMG.Data(:,18);
s4_back_right_EMG_mag = sqrt(s4_back_right_EMG_1.^2 + s4_back_right_EMG_2.^2 + s4_back_right_EMG_3.^2 + s4_back_right_EMG_4.^2 + s4_back_right_EMG_5.^2 + s4_back_right_EMG_6.^2 + s4_back_right_EMG_7.^2 + s4_back_right_EMG_8.^2);


%% Running
% APDM_Accel - waist, chest, ankles and foot
s4_run_waist_accX = Subject04.Running.APDM_Accel.Data(:,3);
s4_run_waist_accY = Subject04.Running.APDM_Accel.Data(:,4);
s4_run_waist_accZ = Subject04.Running.APDM_Accel.Data(:,5);
s4_run_waist_mag = sqrt(s4_run_waist_accX.^2 + s4_run_waist_accY.^2 + s4_run_waist_accZ.^2);

s4_run_chest_accX = Subject04.Running.APDM_Accel.Data(:,12);
s4_run_chest_accY = Subject04.Running.APDM_Accel.Data(:,13);
s4_run_chest_accZ = Subject04.Running.APDM_Accel.Data(:,14);
s4_run_chest_mag = sqrt(s4_run_chest_accX.^2 + s4_run_chest_accY.^2 + s4_run_chest_accZ.^2);

s4_run_leftAnk_accX = Subject04.Running.APDM_Accel.Data(:,21);
s4_run_leftAnk_accY = Subject04.Running.APDM_Accel.Data(:,22);
s4_run_leftAnk_accZ = Subject04.Running.APDM_Accel.Data(:,23);
s4_run_leftAnk_mag = sqrt(s4_run_leftAnk_accX.^2 + s4_run_leftAnk_accY.^2 + s4_run_leftAnk_accZ.^2);

s4_run_rightAnk_accX = Subject04.Running.APDM_Accel.Data(:,30);
s4_run_rightAnk_accY = Subject04.Running.APDM_Accel.Data(:,31);
s4_run_rightAnk_accZ = Subject04.Running.APDM_Accel.Data(:,32);
s4_run_rightAnk_mag = sqrt(s4_run_rightAnk_accX.^2 + s4_run_rightAnk_accY.^2 + s4_run_rightAnk_accZ.^2);

s4_run_leftFoot_accX = Subject04.Running.APDM_Accel.Data(:,39);
s4_run_leftFoot_accY = Subject04.Running.APDM_Accel.Data(:,40);
s4_run_leftFoot_accZ = Subject04.Running.APDM_Accel.Data(:,41);
s4_run_leftFoot_mag = sqrt(s4_run_leftFoot_accX.^2 + s4_run_leftFoot_accY.^2 + s4_run_leftFoot_accZ.^2);

s4_run_rightFoot_accX = Subject04.Running.APDM_Accel.Data(:,48);
s4_run_rightFoot_accY = Subject04.Running.APDM_Accel.Data(:,49);
s4_run_rightFoot_accZ = Subject04.Running.APDM_Accel.Data(:,50);
s4_run_rightFoot_mag = sqrt(s4_run_rightFoot_accX.^2 + s4_run_rightFoot_accY.^2 + s4_run_rightFoot_accZ.^2);

% Empatica_Accel - Wrists
s4_run_leftWrist_accX = Subject04.Running.Empatica_Accel.Data(:,3);
s4_run_leftWrist_accY = Subject04.Running.Empatica_Accel.Data(:,4);
s4_run_leftWrist_accZ = Subject04.Running.Empatica_Accel.Data(:,5);
s4_run_leftWrist_mag = sqrt(s4_run_leftWrist_accX.^2 + s4_run_leftWrist_accY.^2 + s4_run_leftWrist_accZ.^2);

s4_run_rightWrist_accX = Subject04.Running.Empatica_Accel.Data(:,6);
s4_run_rightWrist_accY = Subject04.Running.Empatica_Accel.Data(:,7);
s4_run_rightWrist_accZ = Subject04.Running.Empatica_Accel.Data(:,8);
s4_run_rightWrist_mag = sqrt(s4_run_rightWrist_accX.^2 + s4_run_rightWrist_accY.^2 + s4_run_rightWrist_accZ.^2);

% Empatica_Physio - Wrists EDA and Skin Temperature
s4_run_leftWrist_EDA = Subject04.Running.Empatica_Physio.Data(:,3);
s4_run_rightWrist_EDA = Subject04.Running.Empatica_Physio.Data(:,5);

s4_run_leftWrist_skinTemp = Subject04.Running.Empatica_Physio.Data(:,4);
s4_run_rightWrist_skinTemp = Subject04.Running.Empatica_Physio.Data(:,6);

% Metabolic System - VO2, VC02, RER, BF, MV, OxS, HR
s4_run_VO2 = Subject04.Running.Metabolics_System.Data(:,3);
s4_run_VCO2 = Subject04.Running.Metabolics_System.Data(:,4);
s4_run_gtEEcost = 16.58*s4_run_VO2 + 4.84*s4_run_VCO2;

s4_run_RER = Subject04.Running.Metabolics_System.Data(:,5);
s4_run_BreathFreq = Subject04.Running.Metabolics_System.Data(:,6);
s4_run_MinVent = Subject04.Running.Metabolics_System.Data(:,7);
s4_run_OxySat = Subject04.Running.Metabolics_System.Data(:,8);
s4_run_HR = Subject04.Running.Metabolics_System.Data(:,9);

% EMG
s4_run_left_EMG_1 = Subject04.Running.EMG.Data(:,3);
s4_run_left_EMG_2 = Subject04.Running.EMG.Data(:,4);
s4_run_left_EMG_3 = Subject04.Running.EMG.Data(:,5);
s4_run_left_EMG_4 = Subject04.Running.EMG.Data(:,6);
s4_run_left_EMG_5 = Subject04.Running.EMG.Data(:,7);
s4_run_left_EMG_6 = Subject04.Running.EMG.Data(:,8);
s4_run_left_EMG_7 = Subject04.Running.EMG.Data(:,9);
s4_run_left_EMG_8 = Subject04.Running.EMG.Data(:,10);
s4_run_left_EMG_mag = sqrt(s4_run_left_EMG_1.^2 + s4_run_left_EMG_2.^2 + s4_run_left_EMG_3.^2 + s4_run_left_EMG_4.^2 + s4_run_left_EMG_5.^2 + s4_run_left_EMG_6.^2 + s4_run_left_EMG_7.^2 + s4_run_left_EMG_8.^2);

s4_run_right_EMG_1 = Subject04.Running.EMG.Data(:,11);
s4_run_right_EMG_2 = Subject04.Running.EMG.Data(:,12);
s4_run_right_EMG_3 = Subject04.Running.EMG.Data(:,13);
s4_run_right_EMG_4 = Subject04.Running.EMG.Data(:,14);
s4_run_right_EMG_5 = Subject04.Running.EMG.Data(:,15);
s4_run_right_EMG_6 = Subject04.Running.EMG.Data(:,16);
s4_run_right_EMG_7 = Subject04.Running.EMG.Data(:,17);
s4_run_right_EMG_8 = Subject04.Running.EMG.Data(:,18);
s4_run_right_EMG_mag = sqrt(s4_run_right_EMG_1.^2 + s4_run_right_EMG_2.^2 + s4_run_right_EMG_3.^2 + s4_run_right_EMG_4.^2 + s4_run_right_EMG_5.^2 + s4_run_right_EMG_6.^2 + s4_run_right_EMG_7.^2 + s4_run_right_EMG_8.^2);


%% Cycling
% APDM_Accel - waist, chest, ankles and foot
s4_cyc_waist_accX = Subject04.Cycling.APDM_Accel.Data(:,3);
s4_cyc_waist_accY = Subject04.Cycling.APDM_Accel.Data(:,4);
s4_cyc_waist_accZ = Subject04.Cycling.APDM_Accel.Data(:,5);
s4_cyc_waist_mag = sqrt(s4_cyc_waist_accX.^2 + s4_cyc_waist_accY.^2 + s4_cyc_waist_accZ.^2);

s4_cyc_chest_accX = Subject04.Cycling.APDM_Accel.Data(:,12);
s4_cyc_chest_accY = Subject04.Cycling.APDM_Accel.Data(:,13);
s4_cyc_chest_accZ = Subject04.Cycling.APDM_Accel.Data(:,14);
s4_cyc_chest_mag = sqrt(s4_cyc_chest_accX.^2 + s4_cyc_chest_accY.^2 + s4_cyc_chest_accZ.^2);

s4_cyc_leftAnk_accX = Subject04.Cycling.APDM_Accel.Data(:,21);
s4_cyc_leftAnk_accY = Subject04.Cycling.APDM_Accel.Data(:,22);
s4_cyc_leftAnk_accZ = Subject04.Cycling.APDM_Accel.Data(:,23);
s4_cyc_leftAnk_mag = sqrt(s4_cyc_leftAnk_accX.^2 + s4_cyc_leftAnk_accY.^2 + s4_cyc_leftAnk_accZ.^2);

s4_cyc_rightAnk_accX = Subject04.Cycling.APDM_Accel.Data(:,30);
s4_cyc_rightAnk_accY = Subject04.Cycling.APDM_Accel.Data(:,31);
s4_cyc_rightAnk_accZ = Subject04.Cycling.APDM_Accel.Data(:,32);
s4_cyc_rightAnk_mag = sqrt(s4_cyc_rightAnk_accX.^2 + s4_cyc_rightAnk_accY.^2 + s4_cyc_rightAnk_accZ.^2);

s4_cyc_leftFoot_accX = Subject04.Cycling.APDM_Accel.Data(:,39);
s4_cyc_leftFoot_accY = Subject04.Cycling.APDM_Accel.Data(:,40);
s4_cyc_leftFoot_accZ = Subject04.Cycling.APDM_Accel.Data(:,41);
s4_cyc_leftFoot_mag = sqrt(s4_cyc_leftFoot_accX.^2 + s4_cyc_leftFoot_accY.^2 + s4_cyc_leftFoot_accZ.^2);

s4_cyc_rightFoot_accX = Subject04.Cycling.APDM_Accel.Data(:,48);
s4_cyc_rightFoot_accY = Subject04.Cycling.APDM_Accel.Data(:,49);
s4_cyc_rightFoot_accZ = Subject04.Cycling.APDM_Accel.Data(:,50);
s4_cyc_rightFoot_mag = sqrt(s4_cyc_rightFoot_accX.^2 + s4_cyc_rightFoot_accY.^2 + s4_cyc_rightFoot_accZ.^2);

% Empatica_Accel - Wrists
s4_cyc_leftWrist_accX = Subject04.Cycling.Empatica_Accel.Data(:,3);
s4_cyc_leftWrist_accY = Subject04.Cycling.Empatica_Accel.Data(:,4);
s4_cyc_leftWrist_accZ = Subject04.Cycling.Empatica_Accel.Data(:,5);
s4_cyc_leftWrist_mag = sqrt(s4_cyc_leftWrist_accX.^2 + s4_cyc_leftWrist_accY.^2 + s4_cyc_leftWrist_accZ.^2);

s4_cyc_rightWrist_accX = Subject04.Cycling.Empatica_Accel.Data(:,6);
s4_cyc_rightWrist_accY = Subject04.Cycling.Empatica_Accel.Data(:,7);
s4_cyc_rightWrist_accZ = Subject04.Cycling.Empatica_Accel.Data(:,8);
s4_cyc_rightWrist_mag = sqrt(s4_cyc_rightWrist_accX.^2 + s4_cyc_rightWrist_accY.^2 + s4_cyc_rightWrist_accZ.^2);

% Empatica_Physio - Wrists EDA and Skin Temperature
s4_cyc_leftWrist_EDA = Subject04.Cycling.Empatica_Physio.Data(:,3);
s4_cyc_rightWrist_EDA = Subject04.Cycling.Empatica_Physio.Data(:,5);

s4_cyc_leftWrist_skinTemp = Subject04.Cycling.Empatica_Physio.Data(:,4);
s4_cyc_rightWrist_skinTemp = Subject04.Cycling.Empatica_Physio.Data(:,6);

% Metabolic System - VO2, VC02, RER, BF, MV, OxS, HR
s4_cyc_VO2 = Subject04.Cycling.Metabolics_System.Data(:,3);
s4_cyc_VCO2 = Subject04.Cycling.Metabolics_System.Data(:,4);
s4_cyc_gtEEcost = 16.58*s4_cyc_VO2 + 4.84*s4_cyc_VCO2;

s4_cyc_RER = Subject04.Cycling.Metabolics_System.Data(:,5);
s4_cyc_BreathFreq = Subject04.Cycling.Metabolics_System.Data(:,6);
s4_cyc_MinVent = Subject04.Cycling.Metabolics_System.Data(:,7);
s4_cyc_OxySat = Subject04.Cycling.Metabolics_System.Data(:,8);
s4_cyc_HR = Subject04.Cycling.Metabolics_System.Data(:,9);

% EMG
s4_cyc_left_EMG_1 = Subject04.Cycling.EMG.Data(:,3);
s4_cyc_left_EMG_2 = Subject04.Cycling.EMG.Data(:,4);
s4_cyc_left_EMG_3 = Subject04.Cycling.EMG.Data(:,5);
s4_cyc_left_EMG_4 = Subject04.Cycling.EMG.Data(:,6);
s4_cyc_left_EMG_5 = Subject04.Cycling.EMG.Data(:,7);
s4_cyc_left_EMG_6 = Subject04.Cycling.EMG.Data(:,8);
s4_cyc_left_EMG_7 = Subject04.Cycling.EMG.Data(:,9);
s4_cyc_left_EMG_8 = Subject04.Cycling.EMG.Data(:,10);
s4_cyc_left_EMG_mag = sqrt(s4_cyc_left_EMG_1.^2 + s4_cyc_left_EMG_2.^2 + s4_cyc_left_EMG_3.^2 + s4_cyc_left_EMG_4.^2 + s4_cyc_left_EMG_5.^2 + s4_cyc_left_EMG_6.^2 + s4_cyc_left_EMG_7.^2 + s4_cyc_left_EMG_8.^2);

s4_cyc_right_EMG_1 = Subject04.Cycling.EMG.Data(:,11);
s4_cyc_right_EMG_2 = Subject04.Cycling.EMG.Data(:,12);
s4_cyc_right_EMG_3 = Subject04.Cycling.EMG.Data(:,13);
s4_cyc_right_EMG_4 = Subject04.Cycling.EMG.Data(:,14);
s4_cyc_right_EMG_5 = Subject04.Cycling.EMG.Data(:,15);
s4_cyc_right_EMG_6 = Subject04.Cycling.EMG.Data(:,16);
s4_cyc_right_EMG_7 = Subject04.Cycling.EMG.Data(:,17);
s4_cyc_right_EMG_8 = Subject04.Cycling.EMG.Data(:,18);
s4_cyc_right_EMG_mag = sqrt(s4_cyc_right_EMG_1.^2 + s4_cyc_right_EMG_2.^2 + s4_cyc_right_EMG_3.^2 + s4_cyc_right_EMG_4.^2 + s4_cyc_right_EMG_5.^2 + s4_cyc_right_EMG_6.^2 + s4_cyc_right_EMG_7.^2 + s4_cyc_right_EMG_8.^2);


%% Filters
% Local Signals: lowpass fc = 0.1   Acc => wrists = 32Hz  rest = 128Hz
%                                   EMG => 1000Hz
df_local_32 = designfilt('lowpassfir','CutoffFrequency',0.1,'FilterOrder',7,'SampleRate',32);
df_local_128 = designfilt('lowpassfir','CutoffFrequency',0.1,'FilterOrder',7,'SampleRate',128);
df_local_1000 = designfilt('lowpassfir','CutoffFrequency',0.1,'FilterOrder',7,'SampleRate',1000);

% Global Signals: lowpass fc = 0.01  EDA and Skin Temp = 4Hz
df_global = designfilt('lowpassfir','CutoffFrequency',0.01,'FilterOrder',7,'SampleRate',4);
df_global_noSR = designfilt('lowpassfir','CutoffFrequency',0.01,'FilterOrder',7);

%% Filtered Data
%% Walking
% Local
% APDM_Accel - waist, chest, ankles and foot
s4_walk_waist_mag_fil = filtfilt(df_local_128,s4_walk_waist_mag);
s4_walk_chest_mag_fil = filtfilt(df_local_128,s4_walk_chest_mag);
s4_walk_leftAnk_mag_fil = filtfilt(df_local_128,s4_walk_leftAnk_mag);
s4_walk_rightAnk_mag_fil = filtfilt(df_local_128,s4_walk_rightAnk_mag);
s4_walk_leftFoot_mag_fil = filtfilt(df_local_128,s4_walk_leftFoot_mag);
s4_walk_rightFoot_mag_fil = filtfilt(df_local_128,s4_walk_rightFoot_mag);

data = [s4_walk_waist_mag_fil,s4_walk_chest_mag_fil,...
        s4_walk_leftAnk_mag_fil,s4_walk_rightAnk_mag_fil,...
        s4_walk_leftFoot_mag_fil,s4_walk_rightFoot_mag_fil];
fid = fopen('Local_128.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% APDM_Accel - wrists
s4_walk_leftWrist_mag_fil = filtfilt(df_local_32,s4_walk_leftWrist_mag);
s4_walk_rightWrist_mag_fil = filtfilt(df_local_32,s4_walk_rightWrist_mag);

data = [s4_walk_leftWrist_mag_fil,s4_walk_rightWrist_mag_fil];
fid = fopen('Local_32.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% EMGRightLeg
s4_walk_left_EMG_mag_fil = filtfilt(df_local_1000,s4_walk_left_EMG_mag);
s4_walk_right_EMG_mag_fil = filtfilt(df_local_1000,s4_walk_right_EMG_mag);

data = [s4_walk_left_EMG_mag_fil,s4_walk_right_EMG_mag_fil];
fid = fopen('Local_1000.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Global
% Empatica_Physio - Wrists EDA and Skin Temperature
s4_walk_leftWrist_EDA_fil = filtfilt(df_global,s4_walk_leftWrist_EDA);
s4_walk_rightWrist_EDA_fil = filtfilt(df_global,s4_walk_rightWrist_EDA);

s4_walk_leftWrist_skinTemp_fil = filtfilt(df_global,s4_walk_leftWrist_skinTemp);
s4_walk_rightWrist_skinTemp_fil = filtfilt(df_global,s4_walk_rightWrist_skinTemp);

data = [s4_walk_leftWrist_EDA_fil,s4_walk_rightWrist_EDA_fil,...
        s4_walk_leftWrist_skinTemp_fil,s4_walk_rightWrist_skinTemp_fil];
fid = fopen('Global_EDA_ST.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% BF MV OS HR
s4_walk_BreathFreq_fil = filtfilt(df_global_noSR,s4_walk_BreathFreq);
s4_walk_MinVent_fil = filtfilt(df_global_noSR,s4_walk_MinVent);
s4_walk_OxySat_fil = filtfilt(df_global_noSR,s4_walk_OxySat);
s4_walk_HR_fil = filtfilt(df_global_noSR,s4_walk_HR);

data = [s4_walk_BreathFreq,s4_walk_MinVent,...
        s4_walk_OxySat,s4_walk_HR,...
        s4_walk_VO2,s4_walk_VCO2];
fid = fopen('Global_BF_MV_OS_HR.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Incline
% Local
% APDM_Accel - waist, chest, ankles and foot
s4_incline_waist_mag_fil = filtfilt(df_local_128,s4_incline_waist_mag);
s4_incline_chest_mag_fil = filtfilt(df_local_128,s4_incline_chest_mag);
s4_incline_leftAnk_mag_fil = filtfilt(df_local_128,s4_incline_leftAnk_mag);
s4_incline_rightAnk_mag_fil = filtfilt(df_local_128,s4_incline_rightAnk_mag);
s4_incline_leftFoot_mag_fil = filtfilt(df_local_128,s4_incline_leftFoot_mag);
s4_incline_rightFoot_mag_fil = filtfilt(df_local_128,s4_incline_rightFoot_mag);

data = [s4_incline_waist_mag_fil,s4_incline_chest_mag_fil,...
        s4_incline_leftAnk_mag_fil,s4_incline_rightAnk_mag_fil,...
        s4_incline_leftFoot_mag_fil,s4_incline_rightFoot_mag_fil];
fid = fopen('Local_128.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% APDM_Accel - wrists
s4_incline_leftWrist_mag_fil = filtfilt(df_local_32,s4_incline_leftWrist_mag);
s4_incline_rightWrist_mag_fil = filtfilt(df_local_32,s4_incline_rightWrist_mag);

data = [s4_incline_leftWrist_mag_fil,s4_incline_rightWrist_mag_fil];
fid = fopen('Local_32.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% EMGRightLeg
s4_incline_left_EMG_mag_fil = filtfilt(df_local_1000,s4_incline_left_EMG_mag);
s4_incline_right_EMG_mag_fil = filtfilt(df_local_1000,s4_incline_right_EMG_mag);

data = [s4_incline_left_EMG_mag_fil,s4_incline_right_EMG_mag_fil];
fid = fopen('Local_1000.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Global
% Empatica_Physio - Wrists EDA and Skin Temperature
s4_incline_leftWrist_EDA_fil = filtfilt(df_global,s4_incline_leftWrist_EDA);
s4_incline_rightWrist_EDA_fil = filtfilt(df_global,s4_incline_rightWrist_EDA);

s4_incline_leftWrist_skinTemp_fil = filtfilt(df_global,s4_incline_leftWrist_skinTemp);
s4_incline_rightWrist_skinTemp_fil = filtfilt(df_global,s4_incline_rightWrist_skinTemp);

data = [s4_incline_leftWrist_EDA_fil,s4_incline_rightWrist_EDA_fil,...
        s4_incline_leftWrist_skinTemp_fil,s4_incline_rightWrist_skinTemp_fil];
fid = fopen('Global_EDA_ST.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% BF MV OS HR
s4_incline_BreathFreq_fil = filtfilt(df_global_noSR,s4_incline_BreathFreq);
s4_incline_MinVent_fil = filtfilt(df_global_noSR,s4_incline_MinVent);
s4_incline_OxySat_fil = filtfilt(df_global_noSR,s4_incline_OxySat);
s4_incline_HR_fil = filtfilt(df_global_noSR,s4_incline_HR);

data = [s4_incline_BreathFreq,s4_incline_MinVent,...
        s4_incline_OxySat,s4_incline_HR,...
        s4_incline_VO2,s4_incline_VCO2];
fid = fopen('Global_BF_MV_OS_HR.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Backwards
% Local
% APDM_Accel - waist, chest, ankles and foot
s4_back_waist_mag_fil = filtfilt(df_local_128,s4_back_waist_mag);
s4_back_chest_mag_fil = filtfilt(df_local_128,s4_back_chest_mag);
s4_back_leftAnk_mag_fil = filtfilt(df_local_128,s4_back_leftAnk_mag);
s4_back_rightAnk_mag_fil = filtfilt(df_local_128,s4_back_rightAnk_mag);
s4_back_leftFoot_mag_fil = filtfilt(df_local_128,s4_back_leftFoot_mag);
s4_back_rightFoot_mag_fil = filtfilt(df_local_128,s4_back_rightFoot_mag);

data = [s4_back_waist_mag_fil,s4_back_chest_mag_fil,...
        s4_back_leftAnk_mag_fil,s4_back_rightAnk_mag_fil,...
        s4_back_leftFoot_mag_fil,s4_back_rightFoot_mag_fil];
fid = fopen('Local_128.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% APDM_Accel - wrists
s4_back_leftWrist_mag_fil = filtfilt(df_local_32,s4_back_leftWrist_mag);
s4_back_rightWrist_mag_fil = filtfilt(df_local_32,s4_back_rightWrist_mag);

data = [s4_back_leftWrist_mag_fil,s4_back_rightWrist_mag_fil];
fid = fopen('Local_32.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% EMGRightLeg
s4_back_left_EMG_mag_fil = filtfilt(df_local_1000,s4_back_left_EMG_mag);
s4_back_right_EMG_mag_fil = filtfilt(df_local_1000,s4_back_right_EMG_mag);

data = [s4_back_left_EMG_mag_fil,s4_back_right_EMG_mag_fil];
fid = fopen('Local_1000.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Global
% Empatica_Physio - Wrists EDA and Skin Temperature
s4_back_leftWrist_EDA_fil = filtfilt(df_global,s4_back_leftWrist_EDA);
s4_back_rightWrist_EDA_fil = filtfilt(df_global,s4_back_rightWrist_EDA);

s4_back_leftWrist_skinTemp_fil = filtfilt(df_global,s4_back_leftWrist_skinTemp);
s4_back_rightWrist_skinTemp_fil = filtfilt(df_global,s4_back_rightWrist_skinTemp);

data = [s4_back_leftWrist_EDA_fil,s4_back_rightWrist_EDA_fil,...
        s4_back_leftWrist_skinTemp_fil,s4_back_rightWrist_skinTemp_fil];
fid = fopen('Global_EDA_ST.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% BF MV OS HR
s4_back_BreathFreq_fil = filtfilt(df_global_noSR,s4_back_BreathFreq);
s4_back_MinVent_fil = filtfilt(df_global_noSR,s4_back_MinVent);
s4_back_OxySat_fil = filtfilt(df_global_noSR,s4_back_OxySat);
s4_back_HR_fil = filtfilt(df_global_noSR,s4_back_HR);

data = [s4_back_BreathFreq,s4_back_MinVent,...
        s4_back_OxySat,s4_back_HR,...
        s4_back_VO2,s4_back_VCO2];
fid = fopen('Global_BF_MV_OS_HR.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Running
% Local
% APDM_Accel - waist, chest, ankles and foot
s4_run_waist_mag_fil = filtfilt(df_local_128,s4_run_waist_mag);
s4_run_chest_mag_fil = filtfilt(df_local_128,s4_run_chest_mag);
s4_run_leftAnk_mag_fil = filtfilt(df_local_128,s4_run_leftAnk_mag);
s4_run_rightAnk_mag_fil = filtfilt(df_local_128,s4_run_rightAnk_mag);
s4_run_leftFoot_mag_fil = filtfilt(df_local_128,s4_run_leftFoot_mag);
s4_run_rightFoot_mag_fil = filtfilt(df_local_128,s4_run_rightFoot_mag);

data = [s4_run_waist_mag_fil,s4_run_chest_mag_fil,...
        s4_run_leftAnk_mag_fil,s4_run_rightAnk_mag_fil,...
        s4_run_leftFoot_mag_fil,s4_run_rightFoot_mag_fil];
fid = fopen('Local_128.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% APDM_Accel - wrists
s4_run_leftWrist_mag_fil = filtfilt(df_local_32,s4_run_leftWrist_mag);
s4_run_rightWrist_mag_fil = filtfilt(df_local_32,s4_run_rightWrist_mag);

data = [s4_run_leftWrist_mag_fil,s4_run_rightWrist_mag_fil];
fid = fopen('Local_32.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% EMGRightLeg
s4_run_left_EMG_mag_fil = filtfilt(df_local_1000,s4_run_left_EMG_mag);
s4_run_right_EMG_mag_fil = filtfilt(df_local_1000,s4_run_right_EMG_mag);

data = [s4_run_left_EMG_mag_fil,s4_run_right_EMG_mag_fil];
fid = fopen('Local_1000.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Global
% Empatica_Physio - Wrists EDA and Skin Temperature
s4_run_leftWrist_EDA_fil = filtfilt(df_global,s4_run_leftWrist_EDA);
s4_run_rightWrist_EDA_fil = filtfilt(df_global,s4_run_rightWrist_EDA);

s4_run_leftWrist_skinTemp_fil = filtfilt(df_global,s4_run_leftWrist_skinTemp);
s4_run_rightWrist_skinTemp_fil = filtfilt(df_global,s4_run_rightWrist_skinTemp);

data = [s4_run_leftWrist_EDA_fil,s4_run_rightWrist_EDA_fil,...
        s4_run_leftWrist_skinTemp_fil,s4_run_rightWrist_skinTemp_fil];
fid = fopen('Global_EDA_ST.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% BF MV OS HR
s4_run_BreathFreq_fil = filtfilt(df_global_noSR,s4_run_BreathFreq);
s4_run_MinVent_fil = filtfilt(df_global_noSR,s4_run_MinVent);
s4_run_OxySat_fil = filtfilt(df_global_noSR,s4_run_OxySat);
s4_run_HR_fil = filtfilt(df_global_noSR,s4_run_HR);

data = [s4_run_BreathFreq,s4_run_MinVent,...
        s4_run_OxySat,s4_run_HR,...
        s4_run_VO2,s4_run_VCO2];
fid = fopen('Global_BF_MV_OS_HR.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Cycling
% Local
% APDM_Accel - waist, chest, ankles and foot
s4_cyc_waist_mag_fil = filtfilt(df_local_128,s4_cyc_waist_mag);
s4_cyc_chest_mag_fil = filtfilt(df_local_128,s4_cyc_chest_mag);
s4_cyc_leftAnk_mag_fil = filtfilt(df_local_128,s4_cyc_leftAnk_mag);
s4_cyc_rightAnk_mag_fil = filtfilt(df_local_128,s4_cyc_rightAnk_mag);
s4_cyc_leftFoot_mag_fil = filtfilt(df_local_128,s4_cyc_leftFoot_mag);
s4_cyc_rightFoot_mag_fil = filtfilt(df_local_128,s4_cyc_rightFoot_mag);

data = [s4_cyc_waist_mag_fil,s4_cyc_chest_mag_fil,...
        s4_cyc_leftAnk_mag_fil,s4_cyc_rightAnk_mag_fil,...
        s4_cyc_leftFoot_mag_fil,s4_cyc_rightFoot_mag_fil];
fid = fopen('Local_128.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% APDM_Accel - wrists
s4_cyc_leftWrist_mag_fil = filtfilt(df_local_32,s4_cyc_leftWrist_mag);
s4_cyc_rightWrist_mag_fil = filtfilt(df_local_32,s4_cyc_rightWrist_mag);

data = [s4_cyc_leftWrist_mag_fil,s4_cyc_rightWrist_mag_fil];
fid = fopen('Local_32.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% EMGRightLeg
s4_cyc_left_EMG_mag_fil = filtfilt(df_local_1000,s4_cyc_left_EMG_mag);
s4_cyc_right_EMG_mag_fil = filtfilt(df_local_1000,s4_cyc_right_EMG_mag);

data = [s4_cyc_left_EMG_mag_fil,s4_cyc_right_EMG_mag_fil];
fid = fopen('Local_1000.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Global
% Empatica_Physio - Wrists EDA and Skin Temperature
s4_cyc_leftWrist_EDA_fil = filtfilt(df_global,s4_cyc_leftWrist_EDA);
s4_cyc_rightWrist_EDA_fil = filtfilt(df_global,s4_cyc_rightWrist_EDA);

s4_cyc_leftWrist_skinTemp_fil = filtfilt(df_global,s4_cyc_leftWrist_skinTemp);
s4_cyc_rightWrist_skinTemp_fil = filtfilt(df_global,s4_cyc_rightWrist_skinTemp);

data = [s4_cyc_leftWrist_EDA_fil,s4_cyc_rightWrist_EDA_fil,...
        s4_cyc_leftWrist_skinTemp_fil,s4_cyc_rightWrist_skinTemp_fil];
fid = fopen('Global_EDA_ST.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% BF MV OS HR
s4_cyc_BreathFreq_fil = filtfilt(df_global_noSR,s4_cyc_BreathFreq);
s4_cyc_MinVent_fil = filtfilt(df_global_noSR,s4_cyc_MinVent);
s4_cyc_OxySat_fil = filtfilt(df_global_noSR,s4_cyc_OxySat);
s4_cyc_HR_fil = filtfilt(df_global_noSR,s4_cyc_HR);

data = [s4_cyc_BreathFreq,s4_cyc_MinVent,...
        s4_cyc_OxySat,s4_cyc_HR,...
        s4_cyc_VO2,s4_cyc_VCO2];
fid = fopen('Global_BF_MV_OS_HR.csv', 'wt');
for ii = 1:size(data,1)
    fprintf(fid,'%f,',data(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

% Metabolic System - VO2 and VC02
% Walking
% s4_walk_VO2 = Subject04.Walking.Metabolics_System.Data(:,3);
% s4_walk_VCO2 = Subject04.Walking.Metabolics_System.Data(:,4);
% s4_walk_gtEEcost = 16.58*s4_walk_VO2 + 4.84*s4_walk_VCO2;

% Incline
% s4_incline_VO2 = Subject04.Incline.Metabolics_System.Data(:,3);
% s4_incline_VCO2 = Subject04.Incline.Metabolics_System.Data(:,4);
% s4_incline_gtEEcost = 16.58*s4_incline_VO2 + 4.84*s4_incline_VCO2;

% Backwards
% s4_back_VO2 = Subject04.Backwards.Metabolics_System.Data(:,3);
% s4_back_VCO2 = Subject04.Backwards.Metabolics_System.Data(:,4);
% s4_back_gtEEcost = 16.58*s4_back_VO2 + 4.84*s4_back_VCO2;

% Running
% s4_run_VO2 = Subject04.Running.Metabolics_System.Data(:,3);
% s4_run_VCO2 = Subject04.Running.Metabolics_System.Data(:,4);
% s4_run_gtEEcost = 16.58*s4_run_VO2 + 4.84*s4_run_VCO2;

% Cycling
% s4_cyc_VO2 = Subject04.Cycling.Metabolics_System.Data(:,3);
% s4_cyc_VCO2 = Subject04.Cycling.Metabolics_System.Data(:,4);
% s4_cyc_gtEEcost = 16.58*s4_cyc_VO2 + 4.84*s4_cyc_VCO2;

