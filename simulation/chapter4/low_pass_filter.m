% LOW_PASS_FILTER  Low pass filtering of a noisy signal (ME 435, Chapter 4).
%
% A test signal made of a DC offset plus three sine waves (10, 20, 30 rad/s)
% is corrupted by high frequency noise (250 and 400 rad/s).  A Butterworth
% low pass filter with its cut-off placed between the two bands removes the
% noise while keeping the signal.  Each step is shown in both the time
% domain and the amplitude spectrum.
%
% HOW TO RUN: open this file in MATLAB and press Run (F5).
%
% REQUIRES: Signal Processing Toolbox (pspectrum, butter, filtfilt, freqz).

clc; clear; close all;

%% ---------------- 1. Input signal ----------------
t = 0:0.001:10;
w1 = 10; w2 = 20; w3 = 30;      % signal frequencies [rad/s]
dc_off = 0.8;                   % DC offset
x_in = dc_off + 0.5*sin(w1*t) + 0.7*sin(w2*t) + 0.9*sin(w3*t);
fs = 1000;                      % sampling frequency [Hz]

%% ---------------- 2. Amplitude spectrum of the input ----------------
% pspectrum returns POWER.  For a sine of amplitude A the peak is A^2/2,
% so the amplitude is sqrt(2*power).
[power, f] = pspectrum(x_in, fs);
w = 2*pi*f;                     % convert Hz -> rad/s
amp = sqrt(2*power);
amp(1) = amp(1)/2;        % DC didn't mirror + and - f

figure('Name', 'Input spectrum', 'Color', 'w');
plot(w, amp, 'LineWidth', 1.2)
xlabel('Frequency (rad/s)')
ylabel('Amplitude')
title('Amplitude Spectrum of x_{in}')
xlim([0 50])
grid on
xline(w1, '--r', '\omega_1: A = 0.5');
xline(w2, '--r', '\omega_2: A = 0.7');
xline(w3, '--r', '\omega_3: A = 0.9');
yline([0.5 0.7 0.9], ':');

%% ---------------- 3. Add high frequency noise ----------------
wn1 = 250; wn2 = 400;           % noise frequencies [rad/s]
x_noisy = x_in + 1.0*sin(wn1*t) + 1.0*sin(wn2*t);


%% ---------------- 4. Spectrum plot of Noisy signal ----------------

[power_noisy, f_noisy] = pspectrum(x_noisy, fs);

w_noisy = 2*pi*f_noisy;                     % convert Hz -> rad/s
amp_noisy = sqrt(2*power_noisy);
amp_noisy(1) = amp_noisy(1)/2;        % DC didn't mirror + and - f

figure('Name', 'Noisy Signal spectrum', 'Color', 'w');
plot(w_noisy, amp_noisy, 'LineWidth', 1.2)
xlabel('Frequency (rad/s)')
ylabel('Amplitude')
title('Amplitude Spectrum of x_{noisy}')
xlim([0 500])
grid on
xline(w1, '--r', '\omega_1: A = 0.5');
xline(w2, '--r', '\omega_2: A = 0.7');
xline(w3, '--r', '\omega_3: A = 0.9');
xline(wn1, '--r', '\omega_{n1}: A = 1.0');
xline(wn2, '--r', '\omega_{n2}: A = 1.0');

yline([0.5 0.7 0.9 1.0], ':');
%% ---------------- 5. Butterworth low pass filter ----------------
% The cut-off goes between the signal band (30 rad/s) and the noise (250 rad/s).
wc = 100;                       % cut-off frequency [rad/s]
fc = wc/(2*pi);                 % cut-off frequency [Hz]
n_order = 4;                    % filter order (steeper roll-off = higher order)

% butter() expects the cut-off normalized by the Nyquist frequency (fs/2)
[b, a] = butter(n_order, fc/(fs/2), 'low');

% filtfilt filters forward and backward -> zero phase distortion
x_filt = filtfilt(b, a, x_noisy);

%% ---------------- 6. Time domain result ----------------
figure('Name', 'Filtering result', 'Color', 'w');
plot(t, x_noisy, 'Color', [0.75 0.75 0.75]); hold on
plot(t, x_in,   'b--', 'LineWidth', 1.2)
plot(t, x_filt, 'r',   'LineWidth', 1.5)
xlabel('Time (s)'); ylabel('Amplitude')
title('Low Pass Filtering Result')
legend('Noisy input', 'Clean signal', 'Filtered output', 'Location', 'best')
xlim([0 2]); grid on

%% ---------------- 7. Spectrum plot of Filtered signal ----------------

[power_filt, f_filt] = pspectrum(x_filt, fs);

w_filt = 2*pi*f_filt;                   % convert Hz -> rad/s
amp_filt = sqrt(2*power_filt);
amp_filt(1) = amp_filt(1)/2;        % DC didn't mirror + and - f

figure('Name', 'Filtered Signal spectrum', 'Color', 'w');
plot(w_noisy, amp_noisy, 'Color', [0 0.45 0.74], 'LineWidth', 1.2); hold on
plot(w_filt, amp_filt, 'r', 'LineWidth', 1.4)
xlabel('Frequency (rad/s)')
ylabel('Amplitude')
title('Amplitude Spectrum of x_{filtered}')
xlim([0 500])
grid on
xline(w1, '--r', '\omega_1: A = 0.5');
xline(w2, '--r', '\omega_2: A = 0.7');
xline(w3, '--r', '\omega_3: A = 0.9');
xline(wn1, '--r', '\omega_{n1}: A = 1.0');
xline(wn2, '--r', '\omega_{n2}: A = 1.0');
xline(wc, '--k', '\omega_c');

yline([0.5 0.7 0.9 1.0], ':');
legend('Before', 'After', 'Location', 'best')
