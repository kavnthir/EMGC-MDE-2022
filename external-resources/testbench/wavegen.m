% generate decreasing discrete exponential
Tf = 5; %total seconds
Fs = 100; %sample frequency Hz
t = 0:(Tf*Fs); %time domain
A0 = 10; %initial angle value

% base function
At = A0 .* exp(-t / Fs);

% vanishing periodic noise
At = At + (0.6 .* exp(-t / 90) .* sin(pi .* t.^2 / 500));

% convert to fixed point
At_int16 = int16(floor(16 * At));
At_bin16 = dec2bin(At_int16, 16);

% inject random bit errors
for i = 1:(Tf*Fs+1)
    if randi(100) <= 1 
        rnum = randi([9, 16]);
        if At_bin16(i,rnum) == '0'
            At_bin16(i,rnum) = '1';
        else
            At_bin16(i,rnum) = '0';
        end
    end
end

% convert back to dec to plot
At_rint16 = bin2dec(At_bin16)/16;
figure;
plot(t, At_rint16);

% print the waveform to fixed point binary
fileID = fopen('testwave.txt','w');
for i = 1:(Tf*Fs+1)
    fprintf(fileID, strcat(At_bin16(i,:), '\n'));
end
fclose(fileID);