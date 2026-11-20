% EE384 Final Project
% Hannah Kelley
% November 29, 2026

clear;
clc;
close all;

rng(42); % fix random seed so results are repeatable

%% read .wav files
[xA_clean, FsA] = audioread('ordinario\ClBb-ord-A3-mf-N-N.wav');
[xEb_clean, FsEb] = audioread('ordinario\ClBb-ord-D#4-mf-N-N.wav'); % Eb and D# are enharmonic spellings
[xC_clean, FsC] = audioread('ordinario\ClBb-ord-C5-mf-N-N.wav');

% make them column vectors
xA_clean = xA_clean(:);
xEb_clean = xEb_clean(:);
xC_clean = xC_clean(:);

% time vectors
tA = (0:length(xA_clean)-1)' / FsA;
tEb = (0:length(xEb_clean)-1)' / FsEb;
tC = (0:length(xC_clean)-1)' / FsC;

% zoom window (20 ms slice)
zoom_start = 1.00; 
zoom_end   = 1.02;

%% plot original time domain signals
figure('Name', 'Original Signals');

% A3
subplot(3, 2, 1);
plot(tA(1:100:end), xA_clean(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 Original Clean');
xlim([0 max(tA)]); grid on;

subplot(3, 2, 2);
idxA = tA >= zoom_start & tA <= zoom_end;
plot(tA(idxA), xA_clean(idxA), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 Original Clean (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% Eb4
subplot(3, 2, 3);
plot(tEb(1:100:end), xEb_clean(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 Original Clean');
xlim([0 max(tEb)]); grid on;

subplot(3, 2, 4);
idxEb = tEb >= zoom_start & tEb <= zoom_end;
plot(tEb(idxEb), xEb_clean(idxEb), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 Original Clean (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% C5
subplot(3, 2, 5);
plot(tC(1:100:end), xC_clean(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 Original Clean');
xlim([0 max(tC)]); grid on;

subplot(3, 2, 6);
idxC = tC >= zoom_start & tC <= zoom_end;
plot(tC(idxC), xC_clean(idxC), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 Original Clean (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

%% add noise, interference, and detuning to original signals
noise_std = 0.04;          % white Gaussian noise
f_whine   = 4200;          % high-frequency electronic whine (Hz)
amp_whine = 0.05;          % amplitude of high-frequency whine
f_hum     = 60;            % 60 Hz AC hum
amp_hum   = 0.02;          % amplitude of 60 Hz hum

% add noise to A3
xA = xA_clean ...
     + noise_std * randn(size(xA_clean)) ...
     + amp_whine * sin(2*pi*f_whine*tA) ...
     + amp_hum * sin(2*pi*f_hum*tA);

% detune Eb4 slightly sharp (+18 cents), then add noise
detune_cents = 18; 
detune_ratio = 2^(detune_cents / 1200);
tEb_warped = (0:length(xEb_clean)-1)' * detune_ratio / FsEb;
xEb_detuned = interp1(tEb, xEb_clean, tEb_warped, 'linear', 0);

xEb = xEb_detuned ...
      + noise_std * randn(size(xEb_clean)) ...
      + amp_whine * sin(2*pi*f_whine*tEb) ...
      + amp_hum * sin(2*pi*f_hum*tEb);

% add noise to C5
xC = xC_clean ...
     + noise_std * randn(size(xC_clean)) ...
     + amp_whine * sin(2*pi*f_whine*tC) ...
     + amp_hum * sin(2*pi*f_hum*tC);

%% plot noisy time domain signals (unfiltered)
figure('Name', 'Noisy Signals (Unfiltered)');

% A3
subplot(3, 2, 1);
plot(tA(1:100:end), xA(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 With Noise Added');
xlim([0 max(tA)]); grid on;

subplot(3, 2, 2);
plot(tA(idxA), xA(idxA), 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 With Noise Added (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% Eb4
subplot(3, 2, 3);
plot(tEb(1:100:end), xEb(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 With Noise & Detuning');
xlim([0 max(tEb)]); grid on;

subplot(3, 2, 4);
plot(tEb(idxEb), xEb(idxEb), 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 With Noise & Detuning (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% C5
subplot(3, 2, 5);
plot(tC(1:100:end), xC(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 With Noise Added');
xlim([0 max(tC)]); grid on;

subplot(3, 2, 6);
plot(tC(idxC), xC(idxC), 'LineWidth', 1);
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 With Noise Added (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

%% filter via convolution
% M-point moving average low-pass filter
M = 15;                     % window length in samples
h = ones(M, 1) / M;         % impulse response

% plot filter frequency response
[H, f_resp] = get_freq_response(h, FsA, 8192);
figure('Name', 'Filter Frequency Response');
subplot(2, 1, 1);
plot(f_resp, 20*log10(abs(H) + eps), 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title(['Moving Average Filter Magnitude Response (M = ', num2str(M), ')']);
xlim([0 FsA/2]);
ylim([-50 5]);
grid on;

subplot(2, 1, 2);
plot(f_resp, angle(H)*(180/pi), 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Moving Average Filter Phase Response');
xlim([0 FsA/2]);
grid on;

% filter using custom convolution 
% y[n] = x[n] * h[n]
xA_filt = my_conv(xA, h);
xEb_filt = my_conv(xEb, h);
xC_filt = my_conv(xC, h);

%% plot filtered time domain signals
figure('Name', 'Filtered Signals');

% A3
subplot(3, 2, 1);
plot(tA(1:100:end), xA_filt(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 Filtered');
xlim([0 max(tA)]); grid on;

subplot(3, 2, 2);
plot(tA(idxA), xA_filt(idxA), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('A3 Filtered (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% Eb4
subplot(3, 2, 3);
plot(tEb(1:100:end), xEb_filt(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 Filtered');
xlim([0 max(tEb)]); grid on;

subplot(3, 2, 4);
plot(tEb(idxEb), xEb_filt(idxEb), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('Eb4 Filtered (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

% C5
subplot(3, 2, 5);
plot(tC(1:100:end), xC_filt(1:100:end));
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 Filtered');
xlim([0 max(tC)]); grid on;

subplot(3, 2, 6);
plot(tC(idxC), xC_filt(idxC), 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Amplitude');
title('C5 Filtered (20 ms Zoom)');
xlim([zoom_start zoom_end]); grid on;

%% FFT comparison: unfiltered (noisy) vs. filtered
NA = length(xA_filt);
NC = length(xC_filt);
NEb = length(xEb_filt);

XA_raw = fft(xA);
XEb_raw = fft(xEb);
XC_raw = fft(xC);

XA = fft(xA_filt);
XEb = fft(xEb_filt);
XC = fft(xC_filt);

fA = (0:NA-1)*(FsA/NA);
fEb = (0:NEb-1)*(FsEb/NEb);
fC = (0:NC-1)*(FsC/NC);

halfA = floor(NA/2);
halfEb = floor(NEb/2);
halfC = floor(NC/2);

%% plot FFT magnitude spectra
figure('Name', 'FFT Magnitude Spectra');

% A3
subplot(3, 2, 1);
plot(fA(1:halfA), abs(XA_raw(1:halfA)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('A3 FFT Spectrum (Before Filter)');
xlim([0 5000]); grid on;

subplot(3, 2, 2);
plot(fA(1:halfA), abs(XA(1:halfA)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('A3 FFT Spectrum (After Filter)');
xlim([0 5000]); grid on;

% Eb4
subplot(3, 2, 3);
plot(fEb(1:halfEb), abs(XEb_raw(1:halfEb)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Eb4 FFT Spectrum (Before Filter)');
xlim([0 5000]); grid on;

subplot(3, 2, 4);
plot(fEb(1:halfEb), abs(XEb(1:halfEb)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Eb4 FFT Spectrum (After Filter)');
xlim([0 5000]); grid on;

% C5
subplot(3, 2, 5);
plot(fC(1:halfC), abs(XC_raw(1:halfC)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('C5 FFT Spectrum (Before Filter)');
xlim([0 5000]); grid on;

subplot(3, 2, 6);
plot(fC(1:halfC), abs(XC(1:halfC)),'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('C5 FFT Spectrum (After Filter)');
xlim([0 5000]); grid on;

%% calculate SNR improvement
snr_A_before = 10 * log10(sum(xA_clean.^2) / sum((xA - xA_clean).^2));
snr_A_after  = 10 * log10(sum(xA_clean.^2) / sum((xA_filt - xA_clean).^2));

snr_C_before = 10 * log10(sum(xC_clean.^2) / sum((xC - xC_clean).^2));
snr_C_after  = 10 * log10(sum(xC_clean.^2) / sum((xC_filt - xC_clean).^2));

fprintf('--- Signal-to-Noise Ratio (SNR) Improvement ---\n');
fprintf('A3 SNR: %.2f dB (Before) -> %.2f dB (After) | Gain: +%.2f dB\n', ...
    snr_A_before, snr_A_after, snr_A_after - snr_A_before);
fprintf('C5 SNR: %.2f dB (Before) -> %.2f dB (After) | Gain: +%.2f dB\n\n', ...
    snr_C_before, snr_C_after, snr_C_after - snr_C_before);

%% get fundamental frequency & tuning analysis
expectedA  = 220.00;     % A3
expectedEb = 311.13;     % Eb4
expectedC  = 523.25;     % C5
range      = 0.20;       % +/- 20% search window

% compute FFTs of original clean signals for baseline comparison
XA_clean  = fft(xA_clean);
XEb_clean = fft(xEb_clean);
XC_clean  = fft(xC_clean);

% analyze all 3 stages for each note
[fA_clean,  errA_clean,  centsA_clean]  = analyze_pitch(XA_clean,  fA,  halfA,  expectedA,  range);
[fA_noisy,  errA_noisy,  centsA_noisy]  = analyze_pitch(XA_raw,    fA,  halfA,  expectedA,  range);
[fA_filt,   errA_filt,   centsA_filt]   = analyze_pitch(XA,        fA,  halfA,  expectedA,  range);

[fEb_clean, errEb_clean, centsEb_clean] = analyze_pitch(XEb_clean, fEb, halfEb, expectedEb, range);
[fEb_noisy, errEb_noisy, centsEb_noisy] = analyze_pitch(XEb_raw,   fEb, halfEb, expectedEb, range);
[fEb_filt,  errEb_filt,  centsEb_filt]  = analyze_pitch(XEb,       fEb, halfEb, expectedEb, range);

[fC_clean,  errC_clean,  centsC_clean]  = analyze_pitch(XC_clean,  fC,  halfC,  expectedC,  range);
[fC_noisy,  errC_noisy,  centsC_noisy]  = analyze_pitch(XC_raw,    fC,  halfC,  expectedC,  range);
[fC_filt,   errC_filt,   centsC_filt]   = analyze_pitch(XC,        fC,  halfC,  expectedC,  range);

% print comparison table
fprintf('====================================================================================\n');
fprintf('                       TUNING COMPARISON: CLEAN vs. NOISY vs. FILTERED              \n');
fprintf('====================================================================================\n');
fprintf('%-6s | %-12s | %-24s | %-24s | %-24s\n', ...
    'Note', 'Expected', 'Clean Original', 'Noisy (Unfiltered)', 'Filtered');
fprintf('------------------------------------------------------------------------------------\n');

fprintf('%-6s | %6.2f Hz    | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)\n', ...
    'A3',  expectedA,  fA_clean,  centsA_clean,  fA_noisy,  centsA_noisy,  fA_filt,  centsA_filt);
fprintf('%-6s | %6.2f Hz    | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)\n', ...
    'Eb4', expectedEb, fEb_clean, centsEb_clean, fEb_noisy, centsEb_noisy, fEb_filt, centsEb_filt);
fprintf('%-6s | %6.2f Hz    | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)   | %6.2f Hz (%+6.2f c)\n', ...
    'C5',  expectedC,  fC_clean,  centsC_clean,  fC_noisy,  centsC_noisy,  fC_filt,  centsC_filt);
fprintf('====================================================================================\n\n');

% detailed status breakdown for filtered signals
fprintf('--- Final Filtered Tuning Status ---\n');
fprintf('A3:  %.2f Hz | Error: %.2f%% | %+.2f cents (%s)\n', fA_filt,  errA_filt,  centsA_filt,  get_tuning_label(centsA_filt));
fprintf('Eb4: %.2f Hz | Error: %.2f%% | %+.2f cents (%s)\n', fEb_filt, errEb_filt, centsEb_filt, get_tuning_label(centsEb_filt));
fprintf('C5:  %.2f Hz | Error: %.2f%% | %+.2f cents (%s)\n', fC_filt,  errC_filt,  centsC_filt,  get_tuning_label(centsC_filt));

%% functions
function y = my_conv(x, h)
    N = length(x);
    L = length(h);
    c = zeros(N + L - 1, 1);
    
    for k = 1:L
        c(k : k + N - 1) = c(k : k + N - 1) + h(k) * x;
    end
    
    delay = floor((L - 1) / 2);
    y = c(delay + 1 : delay + N);
end

function [H, f] = get_freq_response(h, Fs, nfft)
    H_full = fft(h, nfft);
    half_n = floor(nfft/2) + 1;
    H = H_full(1:half_n);
    f = (0:half_n-1)' * (Fs / nfft);
end

function [pks, locs] = my_findpeaks(y, f, min_height)
    dy = diff(y);
    idx = find(dy(1:end-1) > 0 & dy(2:end) <= 0) + 1;
    valid = y(idx) >= min_height;
    idx = idx(valid);
    pks = y(idx);
    locs = f(idx);
end

function label = get_tuning_label(cents)
    if cents > 2
        label = 'sharp';
    elseif cents < -2
        label = 'flat';
    else
        label = 'in tune';
    end
end

function [fund_freq, pct_err, cents] = analyze_pitch(X, f, half_len, expected_freq, range)
    mag = abs(X(1:half_len));
    f_half = f(1:half_len);
    
    [pks, locs] = my_findpeaks(mag, f_half, max(mag) * 0.05);
    valid = locs >= expected_freq*(1-range) & locs <= expected_freq*(1+range);
    
    valid_pks = pks(valid);
    valid_locs = locs(valid);
    
    if isempty(valid_pks)
        fund_freq = NaN;
        pct_err = NaN;
        cents = NaN;
    else
        [~, maxIdx] = max(valid_pks);
        fund_freq = valid_locs(maxIdx);
        pct_err = abs(fund_freq - expected_freq) / expected_freq * 100;
        cents = 1200 * log2(fund_freq / expected_freq);
    end
end