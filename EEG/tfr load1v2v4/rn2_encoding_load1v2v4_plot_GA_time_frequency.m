%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

laplacian_text = 'yes'; % laplacian_text = 'no';

%% Load structures for plotting

this_subject = 1; % just need the general info 

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'load1v2v4_all');
load ([param.path, '/tfr GA contrasts/' 'mean_load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_load1v2v4_all');

%% Load stats

% 1D
load ([param.path, '/tfr stats/' 'stat_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_beta_C3');

% 2D
load ([param.path, '/tfr stats/' 'stat_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_C3');

%% Color for time-courses

color_10 = [145, 145, 145] / 255;    % Grey

%% LOAD COMPARISONS - variables

% Loads comparisons
contrasts_loadcomp          = {'load1_load4','load1_load2','load2_load4'};
masks_loadcomp              = {'mask_load1_load4_C3','mask_load1_load2_C3','mask_load2_load4_C3'};
titles_loadcomp             = {'Load 1 versus 4', 'Load 1 versus 2', 'Load 2 versus 4'};

% Baseline corrected
contrasts_blc_loads         = {'blc_load1', 'blc_load2', 'blc_load4'};
titles_blc_loads            = {'Load 1 (baseline)', 'Load 2 (baseline)', 'Load 4 (baseline)'};

%% Plot contrasts - selected channels (C3, POz, Fz)

for channel = 1:length(mean_load1v2v4_all.label)
    mean_load1v2v4_all.mask_load1_load4_C3(channel,:,:) = squeeze(stat_load1_load4_C3.mask);
    mean_load1v2v4_all.mask_load1_load2_C3(channel,:,:) = squeeze(stat_load1_load2_C3.mask);
    mean_load1v2v4_all.mask_load2_load4_C3(channel,:,:) = squeeze(stat_load2_load4_C3.mask);
end

%% Plot TFR C3
select_channels = {'C3'}; 

zlims = {[-20 20], [-15 15], [-10 10]};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    %cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'no';

    for contrast = 1:length(contrasts_loadcomp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_loadcomp{contrast};
        cfg.maskparameter   = masks_loadcomp{contrast};
        cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg,mean_load1v2v4_all);
        colormap(flipud(brewermap(100,'RdBu')));

        title(titles_loadcomp{contrast}, 'FontSize', 14);
        xlabel('Time (s)', 'FontSize', 13);
        ylabel('Frequency (Hz)', 'FontSize', 13);

        hold on;

        plot([0,0], ylim, 'k');
        plot([2,2], ylim, 'k');

    end

end

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save
saveas(gcf, [param.figpath 'TFR-C3-load-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-12 12], [-7 7], [-6 6]};

for contrast = 1:length(contrasts_loadcomp)    
    cfg = [];

    cfg.layout    = 'easycapM1.mat';
    cfg.zlim      = zlims{contrast};
    cfg.ylim      = param.betaband;
    cfg.comment   = 'no';
    cfg.parameter = contrasts_loadcomp{contrast};
    cfg.style     = 'straight';
    cfg.colorbar  = 'no';    

    figure;
    sgtitle(['Topoplots: ' titles_loadcomp{contrast}], 'FontSize', 16, 'FontWeight', 'bold'); 

    for time = 1:length(title_timeselect)
        cfg.xlim      = param.timeselect{time};

        subplot(1,3,time);

        ft_topoplotTFR(cfg,mean_load1v2v4_all);
        colormap(flipud(brewermap(100,'RdBu')));
        title(title_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
    end
    
    %% Save

    set(gcf, "renderer", "Painters");
    set(gcf, "Position", [100 100 600 600]);
    saveas(gcf, [param.figpath 'topo-' titles_loadcomp{contrast} 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
    
end

%% Plot timecourses load comparisons betaband (side by side)

% To plot mask as vertal line

mask_load1_load4_beta_C3 = double(stat_load1_load4_beta_C3.mask); 
mask_load1_load4_beta_C3(mask_load1_load4_beta_C3==0) = nan; % nan data that is not part of mark

mask_load1_load2_beta_C3 = double(stat_load1_load2_beta_C3.mask); 
mask_load1_load2_beta_C3(mask_load1_load2_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2_load4_beta_C3 = double(stat_load2_load4_beta_C3.mask); 
mask_load2_load4_beta_C3(mask_load2_load4_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;

%% Load one versus four

subplot(1,3,1);

[m_plot1] = rn2_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load1_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot1, titles_loadcomp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-25 Hz)','FontSize', 13);

%% Load one versus two

subplot(1,3,2);

[m_plot2] = rn2_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load2_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load1_load2_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot2, titles_loadcomp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

%% Load two versus four

subplot(1,3,3);

[m_plot3] = rn2_errorbarplot(load1v2v4_all.time, load1v2v4_all.load2_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load2_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot3, titles_loadcomp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Load comparison in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-load-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
