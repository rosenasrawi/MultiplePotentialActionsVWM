%% Description %%

% This scripts loads the .mat logfiles for each individual subject
% Then pastes these together (by row) to form one .csv file
% Returns .csv for the data; and .csv for its header

%% Clean workspace

clc; clear; close all

%% Settings

subjects = 1:25;

%% Loop over all participants

s = 0;

for this_subject = subjects
    
    s = s+1;
    
    [param, ~, ~] = rn2_gen_param(this_subject);                    % just need param once

    load ([param.path 'logfiles/' param.logfile]);
    
    sub_column = repmat(this_subject, size(datalog.data,1), 1);     % column with subject ID
    data2add = [sub_column datalog.data];                           % whole data with subject ID
    
    if this_subject == 1
        logfile_header = ['SubjectID', datalog.label];          % Create label field once
        logfiles_all = [sub_column datalog.data];              % Create logfiles_all.data once
    end

    if this_subject > 1        
        logfiles_all = [logfiles_all; data2add];          % Add subject data to matrix
    end
    
end

%% Add one row for R

row2add = zeros(1, size(logfiles_all,2));

logfiles_all = [row2add; logfiles_all];

%% Save

writematrix(logfiles_all, [param.path 'logfiles/logfiles_combined_rn2.csv'] )

writecell(logfile_header, [param.path 'logfiles/logfile_header_rn2.csv'] )
