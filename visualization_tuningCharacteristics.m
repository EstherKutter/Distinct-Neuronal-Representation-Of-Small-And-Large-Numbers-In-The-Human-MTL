clear, clc

load('data_tuningCharacteristics.mat')

fig = figure('Units','centimeters', 'Position',[2 2 20 16.5], 'Color','w');

%%

nums  = 0:9;
nNums = numel(nums);
colors_num = [0.8  0    0;...
              1.0  0.2  0;...
              1.0  0.6  0;...
              0.9  0.9  0;...
              0.5  0.8  0.3;...
              0.6  0.8  0.9;...
              0    0.8  1.0;...
              0    0.4  1.0;...
              0    0    1.0;...
              0    0    0.6];

% blue-red colormap for z-scored matrix
prBlue = 5; prRed = 10; % how fine-grained steps are
colors_mapBlueRed = ...
    [[linspace(0,255*prBlue/(prBlue+1),prBlue); linspace(0,255*prBlue/(prBlue+1),prBlue); repmat(255,1,prBlue)]';...
    [255 255 255];...
    flip([repmat(255,1,prRed); linspace(0,255*prRed/(prRed+1),prRed); linspace(0,255*prRed/(prRed+1),prRed)]')] / 255;

stars = {'','*','*','*'};
ns    = 'n.s.';

%% --- tuning curves ---

axTunCurves = axes('Units','centimeters', 'Position',[1.5 12.5 8 3.5]);
hold on

% baseline (= zero)
plot([nums(1)-1 nums(end)+1],[0 0], 'Color','k', 'LineStyle',':', 'LineWidth',1.5)
% data
for n=flip(1:nNums)
    errorbar(nums, tuningCurves.mean(n,:),tuningCurves.sem(n,:),...
        'LineWidth',1.5, 'Color',colors_num(n,:), 'Marker','o', 'MarkerSize',4, 'MarkerFaceColor','w')
end % n nums

% axis properties
set(axTunCurves,...
    'xlim',[nums(1)-.25 nums(end)+.25], 'xTick',nums, ...
    'ylim',[-.75 2.25],                 'yTick',-2:.5:3,...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel('Sample number',         'FontSize',12)
ylabel('Firing rate (z-score)', 'FontSize',12)
axTunCurves.XRuler.TickLabelGapOffset = -1;

%% --- z-score matrix ---

axZScoreMatrix = axes('Units','centimeters', 'Position',[1.5 1.5 8 8]);
hold on

% data
colormap(axZScoreMatrix, colors_mapBlueRed)
imagesc(tuningCurves.mean,[-1 2])
% 'box on'
rectangle('Position',[.5 .5 nNums nNums], 'EdgeColor','k', 'LineWidth',.1)

% axis properties
set(axZScoreMatrix,...
    'xlim',[.5 nNums+.5], 'xtick',1:nNums, 'xticklabel',nums,...
    'ylim',[.5 nNums+.5], 'ytick',1:nNums, 'yticklabel',nums, 'ydir','reverse',...
    'FontSize',10)
xlabel('Sample number',    'FontSize',12)
ylabel('Preferred number', 'FontSize',12)
axZScoreMatrix.XRuler.TickLabelGapOffset = -1.5;
axis square

%% --- legend z-score matrix ---

axes(axZScoreMatrix) % make axZScoreMatrix current axis to get correct colormap
axZScoreMatrix_Legend = axes('Units','centimeters', 'Position',[1.5 10.2 8 .5]);
colormap(axZScoreMatrix_Legend, colors_mapBlueRed)
cbData = linspace(-1,2,size(colors_mapBlueRed,1));
imagesc(axZScoreMatrix_Legend, cbData)

% axis properties
set(axZScoreMatrix_Legend,...
    'Xlim', [1 numel(cbData)], 'XTick',1:5:numel(cbData), 'XTickLabel',[-1:1:2],...
    'yTick',[],...
    'fontSize',8, 'tickLength',[.05 .01])
title(axZScoreMatrix_Legend, 'Z-score', 'FontWeight','normal', 'FontSize',10);

%% --- amplitudes ---

axAmplitudes = axes('Units','centimeters', 'Position',[11.5 9.5 8 6.3]);
hold on
box off

% data
for n=1:nNums
    errorbar(nums(n), amplitudes.mean(n), amplitudes.sem(n),...
        'Marker','o', 'LineStyle','none', 'LineWidth',1.5, 'Color',colors_num(n,:))
end
% significance
plot([0 3], repmat(max(amplitudes.mean(1:4)+amplitudes.sem(1:4)),1,2)+.05,...
    'Color','k', 'LineWidth',1.5)
text(1.5,max(amplitudes.mean(1:4)+amplitudes.sem(1:4))+.1, ns,...
    'HorizontalAlignment','center', 'FontSize',10)
plot([4 9], repmat(max(amplitudes.mean(5:end)+amplitudes.sem(5:end)),1,2)+.05,...
    'Color','k', 'LineWidth',1.5)
text(6.5,max(amplitudes.mean(5:end)+amplitudes.sem(5:end))+.1, ns,...
    'HorizontalAlignment','center', 'FontSize',10)
plot([1.5 6.5], repmat(2.2,1,2),...
    'Color','k', 'LineWidth',1.5)
text(4,2.225, [stars{[100 .05 .01 .001] >= amplitudes.pVals.smallLarge}],...
    'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',12);

% axis properties
set(axAmplitudes,...
    'xlim',[nums(1)-.5 nums(end)+.5] ,'xtick',nums,...
    'ylim',[0.5 2.2], 'ytick',0:.5:2,...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel('Sample number',          'FontSize',12)
ylabel('Amplitude of Gauss fit', 'FontSize',12)
axAmplitudes.XRuler.TickLabelGapOffset = -2;

%% --- sigmas ---

axSigmas = axes('Units','centimeters', 'Position',[11.5 1.5 8 6.3]);
hold on
box off

% data
for n=1:nNums
    errorbar(nums(n), sigmas.mean(n), sigmas.sem(n),...
        'Marker','o', 'LineStyle','none', 'LineWidth',1.5, 'Color',colors_num(n,:))
end
% significance
plot([0 3], repmat(max(sigmas.mean(1:4)+sigmas.sem(1:4)),1,2)+.05,...
    'Color','k', 'LineWidth',1.5)
text(1.5,max(sigmas.mean(1:4)+sigmas.sem(1:4))+.2, ns,...
    'HorizontalAlignment','center', 'FontSize',10)
plot([4 9], repmat(max(sigmas.mean(5:end)+sigmas.sem(5:end)),1,2)+.05,...
    'Color','k', 'LineWidth',1.5)
plot([1.5 6.5], repmat(4.27,1,2),...
    'Color','k', 'LineWidth',1.5)
text(4,4.33, [stars{[100 .05 .01 .001] >= sigmas.pVals.smallLarge}],...
    'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',12);

% axis properties
set(axSigmas,...
    'xlim',[nums(1)-.5 nums(end)+.5] ,'xtick',nums,...
    'ylim',[0.4 4.35], 'ytick',0:1:4,...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel('Sample number',          'FontSize',12)
ylabel('Sigma of Gauss fit', 'FontSize',12)
axSigmas.XRuler.TickLabelGapOffset = -2;
