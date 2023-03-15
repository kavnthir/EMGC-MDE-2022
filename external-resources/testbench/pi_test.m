Fs = 100; %sample frequency Hz

T_err = readtable('MACdata_err.csv');
T_out = readtable('MACdata_out.csv');
err_time = table2array(T_err(:,1));
err_vals = table2array(T_err(:,2));
out_time = table2array(T_out(:,1));
out_vals = table2array(T_out(:,2));

plot(err_time, err_vals);
hold on;
plot(out_time, out_vals);
hold of;