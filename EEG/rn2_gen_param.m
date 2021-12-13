%% Parameters

% Function to specify general parameters of study rn2 (1vs2vs4 EEG).
% Input: subject ID as a number
% Output: param and filenames for subjects

function [param, eegfiles, logfiles] = rn2_gen_param(this_subject)

    param.path          = '/Users/rosenasrawi/Documents/VU PhD/Projects/rn2 - Load 1vs2vs4/Data/';
    param.figpath       = '/Users/rosenasrawi/Documents/VU PhD/Projects/rn2 - Load 1vs2vs4/Plots/';
    
    subjectIDs          = {'s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's20', 's21', 's22', 's23', 's24', 's25'}; % subject ID's
    eegfiles            = strcat(subjectIDs,'.mat');
    logfiles            = strcat(subjectIDs,'_logfiledata.mat');
    
    param.eegfile       = eegfiles{this_subject};
    param.logfile       = logfiles{this_subject};
    param.sID           = subjectIDs{this_subject};
    
    param.path_eegfile  = [param.path, 'epoched encoding/', param.eegfile]; % session 1
    param.path_logfile  = [param.path, 'logfiles/', param.logfile];
    
    param.betaband      = [15 25];
    param.alphaband     = [8 12];
        
    param.C3            = 'C3';
    param.AFz           = 'AFz';
    param.POz           = 'POz';
    
    param.T_window      = [-0.25 2.5];
    
    param.T_imprinting  = [0.5 1];
    param.T_between     = [1 1.5];
    param.T_preparing   = [1.5 2];
    
    param.timeselect    = {[0.5 1], [1 1.5], [1.5 2]};
    
end
