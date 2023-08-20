clear, clc

load('data_svmClassification.mat')

fig = figure('Units','centimeters', 'Position',[2 2 20 16.5], 'Color','w');

%%

nums  = 0:9;
nNums = numel(nums);
colors_nums = [1    1    1;...   % white > necessary for unitProps
               0.8  0    0;...   % dark red = 0
               1.0  0.2  0;...
               1.0  0.6  0;...
               0.9  0.9  0;...   % yellowish
               0.5  0.8  0.3;...
               0.6  0.8  0.9;... % greenish
               0    0.8  1.0;...
               0    0.4  1.0;...
               0    0    1.0;...
               0    0    0.6];   % blue = 9

phaseNames            = {'Fix.','Sample','Delay'};
phaseIntervals        = [0 300 800 1400];
phaseIntervalLabels   = phaseIntervals - 300;
phaseNamePositions    = phaseIntervals(1:end-1)+diff(phaseIntervals)/2;
color_phaseBoundaries = repmat(.75,1,3);

for b=2:9
    boundLabel{b-1} = [num2str(b-1),'|',num2str(b)];
end
nBounds              = numel(boundLabel);
boundaries.value     = [4 5 6];
boundaries.lineWidth = [2 4 2];
boundaries.lineStyle = {':','-','--'};

colors_two = [0      0.4470 0.7410;... % reddish
              0.8500 0.3250 0.0980];   % blueish

ylimit = [0 55];

%% --- selectivity across time ---

axSelUnits = axes('Units','centimeters', 'Position',[1.5 9.5 8 6]);
hold on

% data
unitProps = bar(axSelUnits,...
    steps(idx_stepsWithSelUnits+1),flip(count_selUnitsPerStep(:,idx_stepsWithSelUnits),1)',...
    'stacked', 'barWidth',1);
for bc=1:numel(unitProps)
    unitProps(bc).FaceColor = colors_nums(12-bc,:);
    unitProps(bc).EdgeColor = 'none';
end
blackBoundary  = bar(axSelUnits, steps(idx_stepsWithSelUnits+1), sum(count_selUnitsPerStep(2:end,idx_stepsWithSelUnits)),...
    'barWidth',1, 'FaceColor','none');

% phase boundaries % labels
plot(axSelUnits,...
    repmat(phaseIntervals(2:end),2,1), repmat([0 75],numel(phaseIntervals)-1,1)',...
    'LineStyle',':', 'LineWidth',1.5, 'Color',color_phaseBoundaries)
for lp=1:3
    text(axSelUnits,...
        phaseNamePositions(lp),-.02, phaseNames{lp},...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',10, 'FontAngle','Italic');
end

% axis properties
set(axSelUnits,...
    'xlim',[0 1460], 'xtick',phaseIntervals, 'xticklabel',phaseIntervalLabels, 'xminortick','on', ...
    'ylim',[0 75], 'ytick',0:20:80, 'yminortick','on', ...
    'ticklength',[.03 .01], 'FontSize',10)
axSelUnits.XRuler.MinorTickValues    = 0:100:1400;
axSelUnits.XRuler.TickLabelGapOffset = -2;
axSelUnits.YRuler.MinorTickValues    = 0:10:80;
axSelUnits.YRuler.TickLabelGapOffset = 0;
xlabel(axSelUnits,'Time (ms)',           'FontSize',12);
ylabel(axSelUnits,'Selective units (#)', 'FontSize',12);

%% --- accuracy across time ---

axSliWin = axes('Units','centimeters', 'Position',[1.5 1.5 8 6]);
hold on

% phase boundaries % labels
plot(axSliWin,...
    repmat(phaseIntervals(2:end),2,1), repmat(ylimit,numel(phaseIntervals)-1,1)',...
    'LineStyle',':', 'LineWidth',1.5, 'Color',color_phaseBoundaries)
for lp=1:3
    text(axSliWin,...
        phaseNamePositions(lp),ylimit(1)-.02, phaseNames{lp},...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',10, 'FontAngle','Italic');
end

% chance level
plot(axSliWin,...
    steps, repmat(100/numel(nums),1,numel(steps)),...
    'LineStyle',':', 'LineWidth',1.5, 'Color','k');

% data
plot(axSliWin,...
    steps, accuracyCurve,...
    'LineStyle','-', 'LineWidth',2.5, 'Color',colors_two(1,:));

% significance
line(clusters,repmat(.99*ylimit(2),1,2), 'LineWidth',3, 'Color','k')

% axis properties
set(axSliWin,...
    'xlim',[0 1460], 'xtick',phaseIntervals, 'xticklabel',phaseIntervalLabels, 'xminortick','on', ...
    'ylim',ylimit, 'ytick',ylimit(1):10:ylimit(2), 'yminortick','on', ...
    'ticklength',[.03 .01], 'FontSize',10)
axSliWin.XRuler.MinorTickValues    = 0:100:1400;
axSliWin.XRuler.TickLabelGapOffset = -2;
axSliWin.YRuler.MinorTickValues    = 0:10:ylimit(2);
axSliWin.YRuler.TickLabelGapOffset = 0;
xlabel(axSliWin,'Time (ms)',    'FontSize',12);
ylabel(axSliWin,'Accuracy (%)', 'FontSize',12);

%% --- confusion matrix ---

axConfMatrix = axes('Units','centimeters', 'Position',[11.5 6.5 8 8]);
hold on

% correlation matrix
colormap('jet')
imagesc(confusionMatrix,[0 1])

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
set(axConfMatrix,...
    'xlim',[.5 nNums+.5], 'xtick',1:nNums, 'xticklabel',nums,...
    'ylim',[.5 nNums+.5], 'ytick',1:nNums, 'yticklabel',nums,...
    'ydir','reverse', 'FontSize',10)
xlabel('Predicted class', 'FontSize',12)
ylabel('True class',      'FontSize',12)
axConfMatrix.XRuler.TickLabelGapOffset = -1.5;

%% --- legend: correlation matrix ---

axes(axConfMatrix) % make corrMatrix current axis to get correct colormap
axConf_Legend = colorbar;
set(axConf_Legend, 'Units','centimeters', 'Position',[11.5 15.3 8 .5],...
    'Orientation','horizontal',...
    'xAxisLocation','bottom',...
    'Limits',[0 1], 'TickLength',.05,'Ticks',0:.1:1, 'TickLabels',{'0','','20','','40','','60','','80','','100'},...
    'FontSize',8)
title(axConf_Legend,'Classification probability (%)', 'FontWeight','normal', 'FontSize',10)

%% --- boundary analysis ---

axCorrStats = axes('Units','centimeters', 'Position',[12 1.5 6.3 3.5]);

% ... difference between same/different elements ...

yyaxis left
hold on
axCorrStats.YAxis(1).Color = colors_two(2,:);

% difference
plot(1:nBounds, deltaClassProb,...
    'Marker','.', 'MarkerSize',12, 'LineWidth',1.5, 'Color',colors_two(2,:))
% maximum value
[maxVal_diff,maxIdx_diff] = max(deltaClassProb);
plot(maxIdx_diff,maxVal_diff,...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(2,:))
% axis properties
set(gca,...
    'xlim',[.5 nBounds+.5], 'xtick',1:nBounds, 'xticklabel',boundLabel, ...
    'ylim', [0 .151], 'ytick',0:.05:015, 'yticklabel',0:5:15, ... 
    'FontSize',10)
ylabel({'\DeltaClass.prob.(%)','(within - across)'}, 'FontSize',12)

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
