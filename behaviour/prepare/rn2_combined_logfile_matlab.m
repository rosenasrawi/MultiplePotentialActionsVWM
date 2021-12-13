%% Clean workspace

clc; clear; close all

%% Get param

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

%% Open and change header

combined_logfile = readtable([param.path 'logfiles/logfiles_combined_header_rn2.csv']);

combined_logfile.Var1 = [];

new_names = {'SubjectID','SuperBlock','Block','BlockType','Trial','ITI','LocColor1','LocColor2','LocColor3','LocColor4','ColorLoc1','ColorLoc2','ColorLoc3','ColorLoc4','OriLoc1','OriLoc2','OriLoc3','OriLoc4','TargetColor','TargetLoc','TargetOri','OtherPTargetColor','OtherPTargetLoc','OtherPTargetOri','SameDif','ProbeOri','ReportOri','ReportVsTarget','ReportVsProbe','TargetVsProbe','ReportVsOtherPTarget','RT1','RT2','RT3','TargetVsPTarget','ItemSimilarity', 'cleanRT1', 'removeRT1','SlowVsFast', 'AbsReportVsTarget', 'PreciseVsUnprecise'};

combined_logfile.Properties.VariableNames = new_names;
head(combined_logfile)

%% Save as .mat for later

save ([param.path 'logfiles/logfiles_combined_header_rn2.mat'], 'combined_logfile');
