% Created by Luke Schofield
% Purpose: Loads all nessary data for gimbal and controller and 
% analyzes response of system.
% NOTE: the simulink model ('GIMBALBOTTOM') must be open for script to run.
clc
clear
close all

% setup intial simulink values from data files
GIMBALBOTTOM_DataFile1;
GIMBALBOTTOM_DataFile;
vsat_motor_params;

FP = []; %Feedback Parameters
SetRollError = 10; %inital offset to set point (0)
SetPitchError = 10; %inital offset to set point (0)
% initial PID parameters
FP.Px_roll = 2; %shift binary bits left by 2
FP.Ix_roll = 0.5; %shift binary bits right 2 times
FP.Dx_roll = 0;
FP.Px_pitch = 2; %shift binary bits left by 2
FP.Ix_pitch = 0.5; %shift binary bits right 2 times
FP.Dx_pitch = 0;

% use "getConfigSet('GIMBALBOTTOM','Configuration');" to open
% configurations
set_param('GIMBALBOTTOM','StopTime','20');
set_param('GIMBALBOTTOM','PacingRate','1000');
simData = sim("GIMBALBOTTOM.slx", 'SimulationMode', 'accelerator');
%set_param(bdroot,'SimulationCommand','AccelBuild'),

Response = GetResponse(simData);

Results = AnalizeResponse(FP, Response);

PlotResponse(FP, Response, Results, 'Response');

% write Excel files of scope data
filename = 'MACdata_input_log.xlsx';
data = [Response.time, Response.y_roll];
writematrix(data,filename);
data = readtable(filename);    % read your file as table
data.Properties.VariableNames = {'Time', 'Data'}; % add header names
writetable(data, filename); % write again
filename = 'MACdata_output_log.xlsx';
data = [Response.time, Response.MAC_out_roll];
writematrix(data,filename);
data = readtable(filename);    % read your file as table
data.Properties.VariableNames = {'Time', 'Data'};
writetable(data, filename);

% FUNCTIONS %
% Get the response of the system from the scope data in simulink model
function Response = GetResponse(simData)
    Response = [];
    ref = simData.RollError{1}.Values; % reference to scope data
    Response.y_roll = squeeze(ref.Data);
    ref = simData.PitchError{1}.Values;
    Response.y_pitch = squeeze(ref.Data);
    Response.time = ref.Time;
    ref = simData.MAC_out_roll{1}.Values;
    Response.MAC_out_roll = squeeze(ref.Data);
end
% analizes the response of the system and calculates steady state error.
function results = AnalizeResponse(FP, Response)
    %endIndex = length(y1);
    results = [];
    results.SSE_roll = 0;
    results.maxValue_roll = 0;
    results.maxValueIndex_roll = -1;
    results.maxValueTime_roll = 0;
    results.SSE_pitch = 0;
    results.maxValue_pitch = 0;
    results.maxValueIndex_pitch = -1;
    results.maxValueTime_pitch = 0;

    %calculate max value
    %SSE = abs(10-values(endIndex));
    [results.maxValue_roll, results.maxValueIndex_roll] = max(Response.y_roll);
    results.maxValueTime_roll = Response.time(results.maxValueIndex_roll);
    % calculate cross corilation with set point
    startIndex = 1001;
    for i = startIndex : 1 : length(Response.y_roll) % start comparing at t = 5 seconds
        err = 0 - Response.y_roll(i); % setpoint - value
        results.SSE_roll = results.SSE_roll + abs(err);
    end
    results.SSE_roll = results.SSE_roll/(length(Response.y_roll)-startIndex);
    for i = startIndex : 1 : length(Response.y_pitch) % start comparing at t = 5 seconds
        err = 0 - Response.y_pitch(i); % setpoint - value
        results.SSE_pitch = results.SSE_pitch + abs(err);
    end
    results.SSE_pitch = results.SSE_pitch/(length(Response.y_pitch)-startIndex);
end
% plots the reponse of the system (pitch and roll angle error)
function PlotResponse(FP, Response, Results, strName)
    %figure
    clf
    hold on
    plot(Response.time, Response.y_roll);
    plot(Response.time, Response.y_pitch);
    yline(0,'k--')
    annotation('textbox', [0.5, 0.18, 0.1, 0.1], 'String', "Roll Steady State Error: " +Results.SSE_roll);
    annotation('textbox', [0.5, 0.1, 0.1, 0.1], 'String', "Pitch Steady State Error: " +Results.SSE_pitch);
    title(strcat(strName+" - Px: "+FP.Px_roll,", Ix: "+FP.Ix_roll, ", Dx: "+FP.Dx_roll));
    xlabel('t (Time)');
    ylabel('\theta (Angle) Error');
end