% plotMrmRetLog.m
% This script prompts the user for a MRM-RET logfile, reads, parses, and
% produces a "waterfall plot" of the motion filtered scans and detection lists 
% in the logfile

clear all; close all; clc

%% Query user for logfile

%dnm = '.'; fnm = 'MRM_002.csv';
[fnmb,dnmb] = uigetfile('*.csv');
fprintf('Reading logfile %s\n',fullfile(dnmb,fnmb));
[cfgb,reqb,scnb,det] = readMrmRetLog(fullfile(dnmb,fnmb));

[fnmt,dnmt] = uigetfile('*.csv');
fprintf('Reading logfile %s\n',fullfile(dnmt,fnmt));
[cfgt,reqt,scnt,dett] = readMrmRetLog(fullfile(dnmt,fnmt));

[fnmt,dnmt] = uigetfile('*.csv');
fprintf('Reading logfile %s\n',fullfile(dnmt,fnmt));
[cfgt2,reqt2,scnt2,dett2] = readMrmRetLog(fullfile(dnmt,fnmt));

[fnmt,dnmt] = uigetfile('*.csv');
fprintf('Reading logfile %s\n',fullfile(dnmt,fnmt));
[cfgt3,reqt3,scnt3,dett3] = readMrmRetLog(fullfile(dnmt,fnmt));

%% Separate raw, bandpassed, and motion filtered data from scn structure
% (only motion filtered is used)

%% Pull out the raw scans (if saved)

rawscansIb = find([scnb.Nfilt] == 1);
rawscansV_background = reshape([scnb(rawscansIb).scn],[],length(rawscansIb))';

rawscansIt = find([scnt.Nfilt] == 1);
rawscansV_Target05m = reshape([scnt(rawscansIt).scn],[],length(rawscansIt))';

rawscansIt = find([scnt.Nfilt] == 1);
rawscansV_Target1m = reshape([scnt2(rawscansIt).scn],[],length(rawscansIt))';

rawscansIt = find([scnt3.Nfilt] == 1);
rawscansV_Target15m = reshape([scnt3(rawscansIt).scn],[],length(rawscansIt))';

scan_difference05 = abs(rawscansV_background - rawscansV_Target05m);
scan_difference10 = abs(rawscansV_background - rawscansV_Target1m);
scan_difference15 = abs(rawscansV_background - rawscansV_Target15m);

%% Create the waterfall horizontal and vertical axes

Tbin = 32/(512*1.024);  % ns
T0 = 0; % ns
c = 0.29979;  % m/ns
Rbin = c*(Tbin*(0:size(rawscansV_background,2)-1) - T0)/2;

% Determine distance of object
[a05,i]=max(scan_difference05(5,:));
distance = Rbin(i)

[a10,i]=max(scan_difference10(5,:));
distance = Rbin(i)

[a15,i]=max(scan_difference15(5,:));
distance = Rbin(i)

%% Power Calculation

% 0.5m
% Real Power Calculation
pow05=a05^2;
scan_difference05_avg = zeros(1,length(scan_difference05(1,:)));
for i = 1:10
scan_difference05_avg = scan_difference05_avg+scan_difference05(i,:);
end
% Average Power Calculation
scan_difference05_avg = scan_difference05_avg/10;
[c05,i]=max(scan_difference05_avg);
distance05 = Rbin(i);

% 1m
% Real Power Calculation
pow10=a10^2;
scan_difference10_avg = zeros(1,length(scan_difference10(1,:)));
for i = 1:10
scan_difference10_avg = scan_difference10_avg+scan_difference10(i,:);
end
% Average Power Calculation
scan_difference10_avg = scan_difference10_avg/10;
[c10,i]=max(scan_difference10_avg);
distance10 = Rbin(i);

% 1.5m
% Real Power Calculation
pow15=a15^2;
scan_difference15_avg = zeros(1,length(scan_difference15(1,:)));
for i = 1:10
scan_difference15_avg = scan_difference15_avg+scan_difference15(i,:);
end
% Average Power Calculation
scan_difference15_avg = scan_difference15_avg/10;
[c15,i]=max(scan_difference15_avg);
distance15 = Rbin(i);

%% Organizing Powers and Distances

power=[pow05 pow10 pow15];
avgpower=[c05^2 c10^2 c15^2];
avgdistance=[distance05 distance10 distance15];

%% Plots

% Q: 7.b
%Background plot
figure(1)
hold on
plot(Rbin,rawscansV_background(10,:), 'r')
%Taget plot
plot(Rbin,rawscansV_Target05m(10,:), 'g')
plot(Rbin,rawscansV_Target1m(10,:), 'b')
plot(Rbin,rawscansV_Target15m(10,:), 'k')
legend("Background", "0.5m", "1m", "1.5m")
title('Overlay of Background and Three Target Scans')
hold off

% Q: 7.c
figure(2)
plot(Rbin, scan_difference05(5,:), '-r'), title('Scan Difference at 1.5m')
figure(3)
plot(Rbin, scan_difference10(5,:), '-g'), title('Scan Difference at 2.0m')
figure(4)
plot(Rbin, scan_difference15(5,:), '-k'), title('Scan Difference at 1.0m')

% Q: 8 & 9
figure(5)
plot(avgdistance,power,'*b')
hold on
plot(avgdistance,avgpower,'o'),
xlabel('Distance'),
title('Power'),
legend('Real Power','Average Power')
hold off

figure(6)
plot(Rbin, rawscansV_Target05m.^2)
hold on;
plot(Rbin, rawscansV_Target1m.^2)
hold on;
plot(Rbin, rawscansV_Target15m.^2)
hold off;
title('Power Graphs')