clear;

T_err = readtable('MACdata_err.csv');
T_out = readtable('MACdata_out.csv');
err_time = table2array(T_err(:,1));
err_vals = table2array(T_err(:,2));
out_time = table2array(T_out(:,1));
out_vals = table2array(T_out(:,2));

Kp = 2.0;
Ki = 0.125;

C0 = int32(2^17) * (Kp);                    %2  < 62,914,560
C1 = int32(2^17) * (-Kp + (0.01 * Ki));     %-1.99875 * 2^17

% convert input to fixed point
x = int32(err_vals * 16);

tstart = 0;
y = int32(zeros(size(x)));
x(1) = 0;
%x(2:size(x,1)) = 16;
for i = (tstart + 2):(size(x, 1) + tstart)
    y(i) = (C0 * x(i)) + (C1 * x(i - 1)) + y(i - 1);
end 

% PI common denominator
y = y / int32(2^17);

% PI Gain:
y = (3 * y) / 16;

% DAC adjustments:
y = (255 * (y + 160)) / 320;    % convert to 1 byte
%y = (3.3 * double(y)) / 255;    % convert to analog

% AMP adjustment:
%y = 6 * (y - 1.65);             % shift down and amp by 6

% PLOT
tend = 2000;
figure();
x = double(x) / 16;
plot(err_time(1:tend), x(1:tend)); %test input

hold on;
plot(err_time(1:tend), y(1:tend));
hold off;

title('PI Response');
legend('PI Input (degrees)', 'PI Output (volts)');
xlabel('Time (s)');
ylabel('Amplitude');

steptime = 0:0.01:20;
stepin = zeros(size(steptime));
stepvolt = zeros(size(steptime));
stepout = zeros(size(steptime));

stepin(1:100) = 15;

stepvolt(1:101) = y(1);
stepvolt(102:2000) = y(2:1900);

stepout(1:101) = 15;
stepout(102:2000) = x(2:1900);

figure();
plot(steptime, stepout, 'LineWidth', 2);
hold on;
plot(steptime, stepvolt, 'LineWidth', 2);
hold off;
hold on;
plot(steptime, stepin, 'LineWidth', 2);
hold off;
title('PI Controller Response');
legend('Gimbal Angle Response', 'PI Voltage Output', 'Target Angle');
xlabel('Time (s)');
ylabel('Amplitude');

x_int16 = int16(floor(16 * x));
x_bin16 = dec2bin(typecast(x_int16, 'uint16'), 16);
fileID = fopen('pi_test_in.txt','w');
for i = 1:size(x_bin16, 1)
    fprintf(fileID, strcat(x_bin16(i,:), '\n'));
end
fclose(fileID);
