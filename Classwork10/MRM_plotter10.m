clear all; close all; clc

%% Setup Parameters and Range Axis
Tbin = 32/(512*1.024);  % ns
T0 = 0;                 % ns
c = 0.29979;            % m/ns

% Read Data Files (Background and Target for PII = 6 through 15)
% PII = 6
[cfgb,reqb,scnb6,detb] = readMrmRetLog('background6new.csv');
[cfgt,reqt,scnt6,dett] = readMrmRetLog('target6new.csv');
rawscansIb6 = find([scnb6.Nfilt] == 1);
rawscansV_background6 = reshape([scnb6(rawscansIb6).scn],[],length(rawscansIb6))';
rawscansIt6 = find([scnt6.Nfilt] == 1);
rawscansV_target6 = reshape([scnt6(rawscansIt6).scn],[],length(rawscansIt6))';
scan_difference6 = abs(rawscansV_background6 - rawscansV_target6);

% PII = 7
[cfgb,reqb,scnb7,detb] = readMrmRetLog('background7new.csv');
[cfgt,reqt,scnt7,dett] = readMrmRetLog('target7new.csv');
rawscansIb7 = find([scnb7.Nfilt] == 1);
rawscansV_background7 = reshape([scnb7(rawscansIb7).scn],[],length(rawscansIb7))';
rawscansIt7 = find([scnt7.Nfilt] == 1);
rawscansV_target7 = reshape([scnt7(rawscansIt7).scn],[],length(rawscansIt7))';
scan_difference7 = abs(rawscansV_background7 - rawscansV_target7);

% PII = 8
[cfgb,reqb,scnb8,detb] = readMrmRetLog('background8.csv');
[cfgt,reqt,scnt8,dett] = readMrmRetLog('target8.csv');
rawscansIb8 = find([scnb8.Nfilt] == 1);
rawscansV_background8 = reshape([scnb8(rawscansIb8).scn],[],length(rawscansIb8))';
rawscansIt8 = find([scnt8.Nfilt] == 1);
rawscansV_target8 = reshape([scnt8(rawscansIt8).scn],[],length(rawscansIt8))';
scan_difference8 = abs(rawscansV_background8 - rawscansV_target8);

% PII = 9
[cfgb,reqb,scnb9,detb] = readMrmRetLog('background9.csv');
[cfgt,reqt,scnt9,dett] = readMrmRetLog('target9.csv');
rawscansIb9 = find([scnb9.Nfilt] == 1);
rawscansV_background9 = reshape([scnb9(rawscansIb9).scn],[],length(rawscansIb9))';
rawscansIt9 = find([scnt9.Nfilt] == 1);
rawscansV_target9 = reshape([scnt9(rawscansIt9).scn],[],length(rawscansIt9))';
scan_difference9 = abs(rawscansV_background9 - rawscansV_target9);

% PII = 10
[cfgb,reqb,scnb10,detb] = readMrmRetLog('background10.csv');
[cfgt,reqt,scnt10,dett] = readMrmRetLog('target10.csv');
rawscansIb10 = find([scnb10.Nfilt] == 1);
rawscansV_background10 = reshape([scnb10(rawscansIb10).scn],[],length(rawscansIb10))';
rawscansIt10 = find([scnt10.Nfilt] == 1);
rawscansV_target10 = reshape([scnt10(rawscansIt10).scn],[],length(rawscansIt10))';
scan_difference10 = abs(rawscansV_background10 - rawscansV_target10);

% PII = 11
[cfgb,reqb,scnb11,detb] = readMrmRetLog('background11.csv');
[cfgt,reqt,scnt11,dett] = readMrmRetLog('target11.csv');
rawscansIb11 = find([scnb11.Nfilt] == 1);
rawscansV_background11 = reshape([scnb11(rawscansIb11).scn],[],length(rawscansIb11))';
rawscansIt11 = find([scnt11.Nfilt] == 1);
rawscansV_target11 = reshape([scnt11(rawscansIt11).scn],[],length(rawscansIt11))';
scan_difference11 = abs(rawscansV_background11 - rawscansV_target11);

% PII = 12
[cfgb,reqb,scnb12,detb] = readMrmRetLog('background12.csv');
[cfgt,reqt,scnt12,dett] = readMrmRetLog('target12.csv');
rawscansIb12 = find([scnb12.Nfilt] == 1);
rawscansV_background12 = reshape([scnb12(rawscansIb12).scn],[],length(rawscansIb12))';
rawscansIt12 = find([scnt12.Nfilt] == 1);
rawscansV_target12 = reshape([scnt12(rawscansIt12).scn],[],length(rawscansIt12))';
scan_difference12 = abs(rawscansV_background12 - rawscansV_target12);

% PII = 13
[cfgb,reqb,scnb13,detb] = readMrmRetLog('background13.csv');
[cfgt,reqt,scnt13,dett] = readMrmRetLog('target13.csv');
rawscansIb13 = find([scnb13.Nfilt] == 1);
rawscansV_background13 = reshape([scnb13(rawscansIb13).scn],[],length(rawscansIb13))';
rawscansIt13 = find([scnt13.Nfilt] == 1);
rawscansV_target13 = reshape([scnt13(rawscansIt13).scn],[],length(rawscansIt13))';
scan_difference13 = abs(rawscansV_background13 - rawscansV_target13);

% PII = 14
[cfgb,reqb,scnb14,detb] = readMrmRetLog('background14.csv');
[cfgt,reqt,scnt14,dett] = readMrmRetLog('target14.csv');
rawscansIb14 = find([scnb14.Nfilt] == 1);
rawscansV_background14 = reshape([scnb14(rawscansIb14).scn],[],length(rawscansIb14))';
rawscansIt14 = find([scnt14.Nfilt] == 1);
rawscansV_target14 = reshape([scnt14(rawscansIt14).scn],[],length(rawscansIt14))';
scan_difference14 = abs(rawscansV_background14 - rawscansV_target14);

% PII = 15
[cfgb,reqb,scnb15,detb] = readMrmRetLog('background15.csv');
[cfgt,reqt,scnt15,dett] = readMrmRetLog('target15.csv');
rawscansIb15 = find([scnb15.Nfilt] == 1);
rawscansV_background15 = reshape([scnb15(rawscansIb15).scn],[],length(rawscansIb15))';
rawscansIt15 = find([scnt15.Nfilt] == 1);
rawscansV_target15 = reshape([scnt15(rawscansIt15).scn],[],length(rawscansIt15))';
scan_difference15 = abs(rawscansV_background15 - rawscansV_target15);

% Range Vector Calculation
Rbin = c*(Tbin*(0:size(scan_difference6(1,:),2)-1) - T0)/2; % Range Bins in meters

% Plot All Difference Scans Together (Overlay)
figure('Name', 'Overlaid Difference Scans');
hold on;
plot(c*(Tbin*(0:size(scan_difference6,2)-1) - T0)/2, scan_difference6(10,:));
plot(c*(Tbin*(0:size(scan_difference7,2)-1) - T0)/2, scan_difference7(10,:));
plot(c*(Tbin*(0:size(scan_difference8,2)-1) - T0)/2, scan_difference8(10,:));
plot(c*(Tbin*(0:size(scan_difference9,2)-1) - T0)/2, scan_difference9(10,:));
plot(c*(Tbin*(0:size(scan_difference10,2)-1) - T0)/2, scan_difference10(10,:));
plot(c*(Tbin*(0:size(scan_difference11,2)-1) - T0)/2, scan_difference11(10,:));
plot(c*(Tbin*(0:size(scan_difference12,2)-1) - T0)/2, scan_difference12(10,:));
plot(c*(Tbin*(0:size(scan_difference13,2)-1) - T0)/2, scan_difference13(10,:));
plot(c*(Tbin*(0:size(scan_difference14,2)-1) - T0)/2, scan_difference14(10,:));
plot(c*(Tbin*(0:size(scan_difference15,2)-1) - T0)/2, scan_difference15(10,:));
hold off;

xlabel('Range (m)');
ylabel('Difference Amplitude');
title('Scan Differences Across Integration Values (Scan 10)');
legend('PII 6', 'PII 7', 'PII 8', 'PII 9', 'PII 10', ...
       'PII 11', 'PII 12', 'PII 13', 'PII 14', 'PII 15', 'Location', 'northeastoutside');
grid on;

% Subplot View for Each Integration Value
figure('Name', 'Individual Difference Scans');

subplot(5,2,1); plot(c*(Tbin*(0:size(scan_difference6,2)-1) - T0)/2, scan_difference6(10,:)); title('PII = 6'); grid on;
subplot(5,2,2); plot(c*(Tbin*(0:size(scan_difference7,2)-1) - T0)/2, scan_difference7(10,:)); title('PII = 7'); grid on;
subplot(5,2,3); plot(c*(Tbin*(0:size(scan_difference8,2)-1) - T0)/2, scan_difference8(10,:)); title('PII = 8'); grid on;
subplot(5,2,4); plot(c*(Tbin*(0:size(scan_difference9,2)-1) - T0)/2, scan_difference9(10,:)); title('PII = 9'); grid on;
subplot(5,2,5); plot(c*(Tbin*(0:size(scan_difference10,2)-1) - T0)/2, scan_difference10(10,:)); title('PII = 10'); grid on;
subplot(5,2,6); plot(c*(Tbin*(0:size(scan_difference11,2)-1) - T0)/2, scan_difference11(10,:)); title('PII = 11'); grid on;
subplot(5,2,7); plot(c*(Tbin*(0:size(scan_difference12,2)-1) - T0)/2, scan_difference12(10,:)); title('PII = 12'); grid on;
subplot(5,2,8); plot(c*(Tbin*(0:size(scan_difference13,2)-1) - T0)/2, scan_difference13(10,:)); title('PII = 13'); grid on;
subplot(5,2,9); plot(c*(Tbin*(0:size(scan_difference14,2)-1) - T0)/2, scan_difference14(10,:)); title('PII = 14'); grid on;
subplot(5,2,10); plot(c*(Tbin*(0:size(scan_difference15,2)-1) - T0)/2, scan_difference15(10,:)); title('PII = 15'); grid on;

% SNR Calculations Across Integration Levels
[a6, i] = max(scan_difference6(10,:));
noise_var6 = var(scan_difference6(10,125:175));
SNR6 = 10*log10(a6^2/noise_var6);

[a7, i] = max(scan_difference7(10,:));
noise_var7 = var(scan_difference7(10,125:175));
SNR7 = 10*log10(a7^2/noise_var7);

[a8, i] = max(scan_difference8(10,:));
noise_var8 = var(scan_difference8(10,125:175));
SNR8 = 10*log10(a8^2/noise_var8);

[a9, i] = max(scan_difference9(10,:));
noise_var9 = var(scan_difference9(10,125:175));
SNR9 = 10*log10(a9^2/noise_var9);

[a10, i] = max(scan_difference10(10,:));
noise_var10 = var(scan_difference10(10,125:175));
SNR10 = 10*log10(a10^2/noise_var10);

[a11, i] = max(scan_difference11(10,:));
noise_var11 = var(scan_difference11(10,125:175));
SNR11 = 10*log10(a11^2/noise_var11);

[a12, i] = max(scan_difference12(10,:));
noise_var12 = var(scan_difference12(10,125:175));
SNR12 = 10*log10(a12^2/noise_var12);

[a13, i] = max(scan_difference13(10,:));
noise_var13 = var(scan_difference13(10,125:175));
SNR13 = 10*log10(a13^2/noise_var13);

[a14, i] = max(scan_difference14(10,:));
noise_var14 = var(scan_difference14(10,125:175));
SNR14 = 10*log10(a14^2/noise_var14);

[a15, i] = max(scan_difference15(10,:));
noise_var15 = var(scan_difference15(10,125:175));
SNR15 = 10*log10(a15^2/noise_var15);

% Plot SNR vs PII
figure('Name', 'SNR Comparison');
PII_list = 6:15;
SNR_list = [SNR6, SNR7, SNR8, SNR9, SNR10, SNR11, SNR12, SNR13, SNR14, SNR15];
plot(PII_list, SNR_list, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
xlabel('Pulse Integration Index');
ylabel('Signal-to-Noise Ratio (dB)');
title('SNR vs Pulse Integration Index');
grid on;