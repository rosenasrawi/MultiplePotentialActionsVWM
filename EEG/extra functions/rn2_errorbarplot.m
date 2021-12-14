%% Description 

% Function to plot error around EEG time-course
% Input – xax: time axis, values: 2D data (subjects x time), rgb: color as RGB values, shading: for only se 'se', for only ci 'ci', for se & ci 'both'
% Output – m_plot, add to existing figure to show error as shading around timecourse

%% Errorbar plot

function [m_plot] = rn2_errorbarplot(xax, values, rgb, shading) 

    % Input arguments 
    % xax: time axis, 
    % values: 2D data (subjects x time), 
    % rgb: color as RGB values
    % shading: for only se 'se', for only ci 'ci', for se & ci 'both'

    % get mean and SE
    m = squeeze(mean(values)); % MEAN
    se = squeeze(std(values)) ./ sqrt(size(values,1)); % SE = std / sqrt(n)
    
    % also get 95% CI
    [~,~,ci,~] = ttest(values);
    
    % flip vectors if columns instead of rows
    if size(xax,1) > size(xax,2) 
        xax = xax'; 
    end
    
    if size(m,1) > size(m,2) 
        m = m'; 
    end
    
    if size(se,1) > size(se,2) 
        se = se'; 
    end
    
    % plot mean 
    m_plot = plot(xax, m, 'color', rgb, 'LineWidth', 1.5); hold on
    
    % plot SE using 'patch'
    if ismember(shading, 'se') | ismember(shading, 'both') % If you want only se's
        patch([xax, fliplr(xax)],[m-se, fliplr(m+se)], rgb, 'edgecolor', 'none', 'FaceAlpha', .3);   % +/- 1 SEM
    end    
    
    if ismember(shading, 'ci') | ismember(shading, 'both') % If you want only CI's
        patch([xax, fliplr(xax)],[ci(1,:), fliplr(ci(2,:))], rgb, 'edgecolor', 'none', 'FaceAlpha', .1); % +/- 95% CI
    end
    
end