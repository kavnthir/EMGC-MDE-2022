%This file writes a sine wave as a csv of signed integers
%use csv_to_fxp.py to change csv into a list of fxp numbers that can be
%read in to vhdl tb as lines

fs = 10000;
f = 100;
t = 0:1/fs:.03;
% t = 0:1/200:.1;
noiseAmplitude = 2;

snr = 5;
wave = sin(2*pi*100*t) * 5;
wave2 = sin(2*pi*10000*t)*4;
% plot(t, wave, 'linewidth', 2);

%noisyWave = wave + noiseAmplitude * rand(1, length(wave));

%noisyWave = awgn(wave, snr, 'measured');

noisyWave = wave + wave2;

plot(t, noisyWave, 'linewidth', 1);

% output = linspace(0,t.length(), 100);



writematrix(noisyWave, "noisy_sine_wave.txt", "Delimiter", ",");









