function stat = rn2_ftclusterstat2D(statcfg, data_cond1, data_cond2)

    % needs:
    % statcfg.xax = xxx.time;
    % statcfg.yax = xxx.freq;
    % statcfg.npermutations = 1000; % usually use 10.000 (but less for testing)
    % statcfg.clusterStatEvalaluationAlpha = 0.05;
    % statcfg.statMethod = 'montecarlo';  / statcfg.statMethod = 'analytic';
    % data_cond1 % paticipants x freq x time
    % data_cond2 % paticipants x freq x time - if one condition against 0, enter as: data_cond2 = zeros(size(data_cond1));
    % % assumes depsamples
    
    nsub  = size(data_cond1,1);
    
    % put into fieldtrip format
    dummy = []; x = []; y = [];
    dummy.time = statcfg.xax;
    dummy.freq = statcfg.yax;
    dummy.label = {'contrastofinterest'};
    dummy.dimord = 'chan_freq_time';
    
    for s = 1:nsub
        x{s} = dummy; x{s}.powspctrm(1,:,:) = squeeze(data_cond1(s,:,:)); % 1 structure per participant.
        y{s} = dummy; y{s}.powspctrm(1,:,:) = squeeze(data_cond2(s,:,:));
    end
    
    % run cluster stat
    cfg = [];
    cfg.method = statcfg.statMethod;
    cfg.numrandomization = statcfg.npermutations;
    
    if strcmp(cfg.method, 'montecarlo'); cfg.correctm='cluster'; else cfg.correctm = 'no'; end
        cfg.clusteralpha     = 0.05;
        cfg.alpha            = statcfg.clusterStatEvalaluationAlpha;
        cfg.tail             = 0;
        cfg.design           = [[ones(1,nsub), ones(1,nsub)*2];[1:nsub, 1:nsub]]; % specifies which dataset belongs to which participant and which condition (effect or zeros)
        cfg.ivar             = 1;
        cfg.uvar             = 2;
        cfg.statistic        = 'depsamplesT';
        cfg.neighbours       = [];
        stat = ft_freqstatistics(cfg, x{:},y{:});
    end
    
% % put "stat.mask" into "tfrdatastructure" to plot, and use:
% tfrdatastructure.mask = stat.mask;
% cfg.maskparameter = 'mask';
% cfg.maskstyle = 'outline';
% note: tfrdatastructure should only have a single TFR channel.
% Otherwise, make dummy with only this one channel (or repmat the mask field to duplicate the mask for the number of channels just for compatability).