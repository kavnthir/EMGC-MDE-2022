Fs = 100; %sample frequency Hz

T_err = readtable('MACdata_err.csv');
T_out = readtable('MACdata_out.csv');
err_time = table2array(T_err(:,1));
x = table2array(T_err(:,2));
out_time = table2array(T_out(:,1));
out_vals = table2array(T_out(:,2));

Kp = 1.0;
Ki = 2.0;

C0 = Kp;
C1 = -Kp + (1 * Ki);

tstart = 1;
u = ones(size(x) + [tstart, 0]);
u(1:tstart) = 0;
for i = 1:15
    u(tstart + i) = 15 - i + 1;
end

y = zeros(size(x));
u(1) = 15; %initial value
for i = (tstart + 1):(size(x, 1) + tstart)
    y(i) = (C0 * u(i)) + (C1 * u(i - 1)) +  y(i - 1);
end 

% integral = 0.0;
% PI_reg = zeros(size(err_vals));
% for i = 1:size(err_vals, 1)
%     integral = integral + err_vals(i, 1);
%     PI_reg(i, 1) = (Kp * err_vals(i, 1)) + (Ki * integral);
% end

tend = 50;
%plot(err_time(1:tend), x(1:tend)); %test input

% hold on;
% plot(out_time(1:tend), out_vals(1:tend)); %test output
% hold off;

hold on;
stem(err_time(1:tend), y(1:tend));
hold off;

hold on;
stem(err_time(1:tend), u(1:tend));
hold off;


