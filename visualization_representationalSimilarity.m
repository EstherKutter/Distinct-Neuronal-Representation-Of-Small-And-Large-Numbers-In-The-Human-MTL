clear, clc

load('data_representationalSimilarity.mat')

fig = figure('Units','centimeters', 'Position',[2 2 10 16.5], 'Color','w');

%%

nums  = 0:9;
nNums = numel(nums);

for b=2:9
    boundLabel{b-1} = [num2str(b-1),'|',num2str(b)];
end
nBounds              = numel(boundLabel);
boundaries.value     = [3 4 5];
boundaries.lineWidth = [2 4 2];
boundaries.lineStyle = {':','-','--'};

colors_two = [0      0.4470 0.7410;... % reddish
              0.8500 0.3250 0.0980];   % blueish
                    
%% --- correlation matrix ---

axCorrMatrix = axes('Units','centimeters', 'Position',[1.5 6.5 8 8]);
hold on

% correlation matrix
colormap('jet')
imagesc(correlationMatrix,[0 1])

% boundaries
for b=1:numel(boundaries.value)
    plot([1.5 nNums+1], repmat(boundaries.value(b)+.5,1,2),...
        'Color','w', 'LineStyle',boundaries.lineStyle{b}, 'LineWidth',boundaries.lineWidth(b))
    plot(repmat(boundaries.value(b)+.5,1,2),[1.5 nNums+1],...
        'Color','w', 'LineStyle',boundaries.lineStyle{b}, 'LineWidth',boundaries.lineWidth(b))
end

% black rectangle around included range
rectangle('Position',[1.5 1.5 , 9 9],'EdgeColor','k', 'LineWidth',1.5)
% 'box on'
rectangle('Position',[.5 .5 , nNums nNums],'EdgeColor','k', 'LineWidth',.5)

% axis properties
set(axCorrMatrix,...
    'xlim',[.5 nNums+.5], 'xtick',1:nNums, 'xticklabel',nums,...
    'ylim',[.5 nNums+.5], 'ytick',1:nNums, 'yticklabel',nums,...
    'ydir','reverse', 'FontSize',10)
xlabel('Sample number', 'FontSize',12)
ylabel('Sample number', 'FontSize',12)
axCorrMatrix.XRuler.TickLabelGapOffset = -1.5;

%% --- legend: correlation matrix ---

axes(axCorrMatrix) % make corrMatrix current axis to get correct colormap
axCorr_Legend = colorbar;
set(axCorr_Legend, 'Units','centimeters', 'Position',[1.5 15.3 8 .5],...
    'Orientation','horizontal',...
    'xAxisLocation','bottom',...
    'Limits',[0 1], 'TickLength',.05,'Ticks',0:.1:1, 'TickLabels',{'0','','0.2','','0.4','','0.6','','0.8','','1'},...
    'FontSize',8)
title(axCorr_Legend,'Correlation coefficient', 'FontWeight','normal', 'FontSize',10)

%% --- boundary analysis ---

axCorrStats = axes('Units','centimeters', 'Position',[2 1.5 6.3 3.5]);

% ... difference between same/different elements ...

yyaxis left
hold on
axCorrStats.YAxis(1).Color = colors_two(2,:);

% difference
plot(1:nBounds, deltaCoefficient_withinAcross,...
    'Marker','.', 'MarkerSize',12, 'LineWidth',1.5, 'Color',colors_two(2,:))

% maximum value
[maxVal_diff,maxIdx_diff] = max(deltaCoefficient_withinAcross);
plot(maxIdx_diff,maxVal_diff,...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(2,:))

% axis properties
set(gca,...
    'xlim',[.5 nBounds+.5], 'xtick',1:nBounds, 'xticklabel',boundLabel, ...
    'ylim', [-.1 .301],...
    'FontSize',10)
ylabel({'\DeltaCorr.coeff.','(within - across)'}, 'FontSize',12)

% ... p-value ...

yyaxis right
hold on
axCorrStats.YAxis(2).Color = colors_two(1,:);

% p-values
plot(1:nBounds, p_withinAcross,...
    'Marker','.', 'MarkerSize',12, 'LineWidth',1.5, 'Color',colors_two(1,:));

% minimum of wilcoxon test
[minVal_W,minIdx_W] = min(p_withinAcross);
if minVal_W < .01/nBounds
    plot(minIdx_W,minVal_W,...
        'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(1,:));
end

% alpha-level
pa = plot([.5 nBounds+.5]',repmat(.01/nBounds,2,1)',...
    'LineWidth',1.5, 'Marker','none', 'Color',colors_two(1,:));

% axis properties
set(gca,...
    'xlim',[.5 nBounds+.5], 'xtick',1:nBounds, ...
    'ylim', [0 1], 'yscale','log', ...
    'ticklength',[.03 .01], 'FontSize',10)
ylabel('p-value', 'FontSize',12)
axCorrStats.XRuler.TickLabelGapOffset = -1;

xlabel('Category boundary', 'FontSize',12);
