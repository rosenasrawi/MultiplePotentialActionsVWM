%% Clean workspace

clc; clear; close all

%% Load structures for plotting

laplacian = true; % laplacian = false;

laplacian_text = 'yes'; % laplacian_text = 'no';
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'performance_all');
load ([param.path, '/tfr GA contrasts/' 'mean_performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_performance_all');

%% Load stats

% 1D
load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load1precise_load1unprecise_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1precise_load1unprecise_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2precise_load2unprecise_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2precise_load2unprecise_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4precise_load4unprecise_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4precise_load4unprecise_beta_C3');

% 2D

load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load1precise_load1unprecise_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1precise_load1unprecise_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2precise_load2unprecise_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2precise_load2unprecise_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4precise_load4unprecise_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4precise_load4unprecise_C3');

%% Nice colors for plotting

color_1 = [204,35,49] / 255;    % Red (light) (80%)
color_2 = [128,22,30] / 255;    % Red (dark)  (50%)

color_3 = [29,119,204] / 255;   % Blue (light) 
color_4 = [18,75,128] / 255;    % Blue (dark)

color_5 = [255,238,46] / 255;   % Yellow (light) 
color_6 = [191,178,34] / 255;   % Yellow (dark)

color_7 = [179, 31, 44] / 255;      % Red       % 1
color_8 = [23, 94, 162] / 255;      % Blue      % 2
color_9 = [211, 189, 32] / 255;     % Yellow    % 4

color_10 = [145, 145, 145] / 255;    % Grey

color_11 = [100, 100, 100] / 255;    % Light grey
color_12 = [190, 190, 190] / 255;    % Dark grey

%% Performance RT's - Fast vs slow

%% RT variables

contrasts_rt_comp           = {'load1fast_load1slow','load2fast_load2slow','load4fast_load4slow'};
masks_rt_com                = {'mask_load1fast_load1slow_C3','mask_load2fast_load2slow_C3', 'mask_load2fast_load4slow_C3'};
titles_rt_comp              = {'Load 1: fast vs slow','Load 2: fast vs slow','Load 4: fast vs slow'};

contrasts_rt_blc            = {'blc_load1_fast_beta_C3', 'blc_load1_slow_beta_C3', 'blc_load2_fast_beta_C3', 'blc_load2_slow_beta_C3', 'blc_load4_fast_beta_C3', 'blc_load4_slow_beta_C3'};
titles_rt_blc               = {'Load 1 (fast)', 'Load 1 (slow)', 'Load 2 (fast)', 'Load 2 (slow)', 'Load 4 (fast)', 'Load 4 (slow)'};

%% Change mask for 2D

for channel = 1:length(mean_performance_all.label)
    mean_performance_all.mask_load1fast_load1slow_C3(channel,:,:)           = squeeze(stat_load1fast_load1slow_C3.mask);
    mean_performance_all.mask_load2fast_load2slow_C3(channel,:,:)           = squeeze(stat_load2fast_load2slow_C3.mask);
    mean_performance_all.mask_load2fast_load4slow_C3(channel,:,:)           = squeeze(stat_load4fast_load4slow_C3.mask);
    mean_performance_all.mask_load1precise_load1unprecise_C3(channel,:,:)   = squeeze(stat_load1precise_load1unprecise_C3.mask);
    mean_performance_all.mask_load2precise_load2unprecise_C3(channel,:,:)   = squeeze(stat_load2precise_load2unprecise_C3.mask);
    mean_performance_all.mask_load4precise_load4unprecise_C3(channel,:,:)   = squeeze(stat_load4precise_load4unprecise_C3.mask);
end

%% Multiplot (RT)

cfg = [];

for contrast = 1:length(contrasts_rt_comp)
    cfg.zlim            = 'maxabs';
    cfg.parameter       = contrasts_rt_comp{contrast};
    cfg.layout          = 'easycapM1.lay';

    ft_multiplotTFR_2(cfg, mean_performance_all);
    title(titles_rt_comp{contrast});
    colormap(flipud(brewermap(100,'RdBu')));

end

%% Plot TFR (RT)
%select_channels = {'C3','POz','Fz'};
select_channels = {'C3'}; 

zlims = {[-12 12], [-12 12], [-12 12]};
%zlims = {'maxabs'};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'no';

    for contrast = 1:length(contrasts_rt_comp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_rt_comp{contrast};
        cfg.maskparameter   = masks_rt_com{contrast};
        cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));

        title(titles_rt_comp{contrast}, 'FontSize', 14);
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

saveas(gcf, [param.figpath 'TFR-C3-performance-RT-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-6 6], [-6 6], [-6 6]};

for contrast = 1:length(contrasts_rt_comp)    
    cfg = [];

    cfg.layout    = 'easycapM1.mat';
    cfg.zlim      = zlims{contrast};
    cfg.ylim      = param.betaband;
    cfg.comment   = 'no';
    cfg.parameter = contrasts_rt_comp{contrast};
    cfg.style     = 'straight';
    cfg.colorbar  = 'no';    

    figure;
    sgtitle(['Topoplots: ' titles_rt_comp{contrast}], 'FontSize', 16, 'FontWeight', 'bold'); 

    for time = 1:length(title_timeselect)
        cfg.xlim      = param.timeselect{time};

        subplot(1,3,time);

        ft_topoplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));
        title(title_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
    end
    
    %% Save

    set(gcf, "renderer", "Painters");
    set(gcf, "Position", [100 100 600 600]);
    saveas(gcf, [param.figpath 'topo-' titles_rt_comp{contrast} 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
    
end

% %% Plot timecourses loads betaband (side by side) (RT)
% 
% figure;
% subplot(1,3,1);
% 
% [m_plot1] = frevede_errorbarplot(performance_all.time, performance_all.blc_load1_fast_beta_C3, color_12, 'se');
% [m_plot2] = frevede_errorbarplot(performance_all.time, performance_all.blc_load1_slow_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot2], titles_rt_blc{[1 2]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-30 Hz) power','FontSize', 13);
% 
% subplot(1,3,2);
% 
% [m_plot3] = frevede_errorbarplot(performance_all.time, performance_all.blc_load2_fast_beta_C3, color_12, 'se');
% [m_plot4] = frevede_errorbarplot(performance_all.time, performance_all.blc_load2_slow_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot3, m_plot4], titles_rt_blc{[3 4]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% subplot(1,3,3);
% 
% [m_plot5] = frevede_errorbarplot(performance_all.time, performance_all.blc_load4_fast_beta_C3, color_12, 'se');
% [m_plot6] = frevede_errorbarplot(performance_all.time, performance_all.blc_load4_slow_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot5, m_plot6], titles_rt_blc{[5 6]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% sgtitle('Fast and slow in C3 (vs baseline)','FontSize', 14);
% 
% %% Save
% 
% saveas(gcf, [param.figpath 'beta-C3-subplot-performance-RT-baseline-corrected-' 'lapl-' laplacian_text '.png'])

%% Plot beta C3 difference (RT)

mask_load1fast_load1slow_beta_C3 = double(stat_load1fast_load1slow_beta_C3.mask); 
mask_load1fast_load1slow_beta_C3(mask_load1fast_load1slow_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2fast_load2slow_beta_C3 = double(stat_load2fast_load2slow_beta_C3.mask); 
mask_load2fast_load2slow_beta_C3(mask_load2fast_load2slow_beta_C3==0) = nan; % nan data that is not part of mark

mask_load4fast_load4slow_beta_C3 = double(stat_load4fast_load4slow_beta_C3.mask); 
mask_load4fast_load4slow_beta_C3(mask_load4fast_load4slow_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;
subplot(1,3,1);

[m_plot1] = frevede_errorbarplot(performance_all.time, performance_all.load1fast_load1slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load1fast_load1slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot1, titles_rt_comp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-25 Hz)','FontSize', 13);


subplot(1,3,2);

[m_plot2] = frevede_errorbarplot(performance_all.time, performance_all.load2fast_load2slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load2fast_load2slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);


legend(m_plot2, titles_rt_comp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

subplot(1,3,3);

[m_plot3] = frevede_errorbarplot(performance_all.time, performance_all.load4fast_load4slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load4fast_load4slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);


legend(m_plot3, titles_rt_comp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Fast versus slow in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-performance-RT-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Performance errors - Precise vs unprecise

%% Error variables

contrasts_err_comp          = {'load1precise_load1unprecise','load2precise_load2unprecise','load4precise_load4unprecise'};
titles_err_comp             = {'Load 1: precise vs imprecise','Load 2: precise vs imprecise','Load 4: precise vs imprecise'};

contrasts_err_blc           = {'blc_load1_precise_beta_C3', 'blc_load1_unprecise_beta_C3', 'blc_load2_precise_beta_C3', 'blc_load2_unprecise_beta_C3', 'blc_load4_precise_beta_C3', 'blc_load4_unprecise_beta_C3'};
titles_err_blc              = {'Load 1 (precise)', 'Load 1 (imprecise)', 'Load 2 (precise)', 'Load 2 (imprecise)', 'Load 4 (precise)', 'Load 4 (imprecise)'};

%% Multiplot (RT)

cfg = [];

for contrast = 1:length(contrasts_err_comp)
    cfg.zlim            = 'maxabs';
    cfg.parameter       = contrasts_err_comp{contrast};
    cfg.layout          = 'easycapM1.lay';

    ft_multiplotTFR_2(cfg, mean_performance_all);
    title(titles_err_comp{contrast});
    colormap(flipud(brewermap(100,'RdBu')));

end

%% Plot TFR (errors)
%select_channels = {'C3','POz','Fz'};
select_channels = {'C3'}; 

zlims = {[-8 8], [-8 8], [-8 8]};
%zlims = {'maxabs'};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'n';

    for contrast = 1:length(contrasts_err_comp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_err_comp{contrast};
        %cfg.maskparameter   = masks_loadcomp{contrast};
        %cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));

        title(titles_err_comp{contrast}, 'FontSize', 14);
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

saveas(gcf, [param.figpath 'TFR-C3-performance-err-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-6 6], [-6 6], [-6 6]};

for contrast = 1:length(contrasts_err_comp)    
    cfg = [];

    cfg.layout    = 'easycapM1.mat';
    cfg.zlim      = zlims{contrast};
    cfg.ylim      = param.betaband;
    cfg.comment   = 'no';
    cfg.parameter = contrasts_err_comp{contrast};
    cfg.style     = 'straight';
    cfg.colorbar  = 'no';    

    figure;
    sgtitle(['Topoplots: ' titles_err_comp{contrast}], 'FontSize', 16, 'FontWeight', 'bold'); 

    for time = 1:length(title_timeselect)
        cfg.xlim      = param.timeselect{time};

        subplot(1,3,time);

        ft_topoplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));
        title(title_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
    end
    %% Save

    set(gcf, "renderer", "Painters");
    set(gcf, "Position", [100 100 600 600]);
    saveas(gcf, [param.figpath 'topo-' titles_err_comp{contrast} 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
    
end

%% Plot beta C3 difference (errors)

mask_load1precise_load1unprecise_beta_C3 = double(stat_load1precise_load1unprecise_beta_C3.mask); 
mask_load1precise_load1unprecise_beta_C3(mask_load1precise_load1unprecise_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2precise_load2unprecise_beta_C3 = double(stat_load2precise_load2unprecise_beta_C3.mask); 
mask_load2precise_load2unprecise_beta_C3(mask_load2precise_load2unprecise_beta_C3==0) = nan; % nan data that is not part of mark

mask_load4precise_load4unprecise_beta_C3 = double(stat_load4precise_load4unprecise_beta_C3.mask); 
mask_load4precise_load4unprecise_beta_C3(mask_load4precise_load4unprecise_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;
subplot(1,3,1);

[m_plot1] = frevede_errorbarplot(performance_all.time, performance_all.load1precise_load1unprecise_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load1precise_load1unprecise_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot1, titles_err_comp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-30 Hz)','FontSize', 13);

subplot(1,3,2);

[m_plot2] = frevede_errorbarplot(performance_all.time, performance_all.load2precise_load2unprecise_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load2precise_load2unprecise_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot2, titles_err_comp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

subplot(1,3,3);

[m_plot3] = frevede_errorbarplot(performance_all.time, performance_all.load4precise_load4unprecise_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load4precise_load4unprecise_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot3, titles_err_comp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Precise versus imprecise in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-performance-err-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

% %% Plot timecourses loads betaband (side by side) (Errors)
% 
% figure;
% subplot(1,3,1);
% 
% [m_plot1] = frevede_errorbarplot(performance_all.time, performance_all.blc_load1_precise_beta_C3, color_12, 'se');
% [m_plot2] = frevede_errorbarplot(performance_all.time, performance_all.blc_load1_unprecise_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot2], titles_err_blc{[1 2]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-30 Hz) power','FontSize', 13);
% 
% subplot(1,3,2);
% 
% [m_plot3] = frevede_errorbarplot(performance_all.time, performance_all.blc_load2_precise_beta_C3, color_12, 'se');
% [m_plot4] = frevede_errorbarplot(performance_all.time, performance_all.blc_load2_unprecise_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot3, m_plot4], titles_err_blc{[3 4]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% subplot(1,3,3);
% 
% [m_plot5] = frevede_errorbarplot(performance_all.time, performance_all.blc_load4_precise_beta_C3, color_12, 'se');
% [m_plot6] = frevede_errorbarplot(performance_all.time, performance_all.blc_load4_unprecise_beta_C3, color_11, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot5, m_plot6], titles_err_blc{[5 6]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% sgtitle('Precise and imprecise in C3 (vs baseline)','FontSize', 14);
% 
