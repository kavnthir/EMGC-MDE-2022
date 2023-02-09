% generate decreasing discrete exponential
Tf = 5; %total seconds
Fs = 100; %sample frequency Hz
t = 0:(Tf*Fs);
At = 10 .* exp(-t / Fs);

figure;
stem(t, At);

At_int16 = int16(floor(16 * At)); % convert to fixed point
At_bin16 = dec2bin(At_int16, 16); %show binary list

fileID = fopen('testwave.txt','w');
for i = 1:(Tf*Fs+1)
    fprintf(fileID, strcat(At_bin16(i,:), '\n'));
end
fclose(fileID);