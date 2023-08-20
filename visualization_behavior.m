clear, clc

load('data_behavior.mat')

fig = figure('Units','centimeters', 'Position',[2 2 20 8], 'Color','w');

%%

nums  = 0:9;
nNums = numel(nums);

colors_two = [0      0.4470 0.7410;... % reddish
          0.8500 0.3250 0.0980];   % blueish
      
stars = {'','*','*','*'};

plotRange = [0.5,9.5];
xline     = plotRange(1):.01:plotRange(end);

%% --- error rates ---

axErrorRates = axes('Units','centimeters', 'Position',[1.5 1.5 8 6]);
hold on

% original data
plot(nums,errorRates.mean,...
    'Marker','o', 'Color',colors_two(1,:), 'MarkerFaceColor',colors_two(1,:), 'LineStyle','none')
errorbar(nums,errorRates.mean,errorRates.sem,...
    'LineStyle','none', 'Color',colors_two(1,:))
% significance
for n=1:nNums-1
    xVals = nums([n,n+1]);
    yVals = repmat(max(errorRates.mean([n,n+1])+1.3*errorRates.sem([n,n+1])),1,2);
    if errorRates.pVals(n) < .05
        line(xVals,yVals, 'Color','k')
        text(xVals(1)+.5,1.02*yVals(1),...
            [stars{errorRates.pVals(n)<[Inf,.05,.01,.001]}],...
            'HorizontalAlignment','center', 'FontSize',16)
    end
end

% sigmoid fit
funSigmoid = @(x) errorRates.sigmoidFit.L + (errorRates.sigmoidFit.U-errorRates.sigmoidFit.L)./(1 + exp(-x-errorRates.sigmoidFit.xmid));
plSig = fplot(funSigmoid, plotRange,...
    'Color',colors_two(1,:), 'LineStyle',':', 'LineWidth',1.5);
% tangent function at inflection point
plInfl = plot(errorRates.inflectionPoint(1),errorRates.inflectionPoint(2),...
    'Color','k', 'Marker','*', 'MarkerSize',10, 'LineStyle',':', 'LineWidth',1.5);
plot(xline,errorRates.tangentLine,...
    'Color','k', 'LineStyle','--', 'LineWidth',1.5);
% subitizing function
plSub = plot(plotRange,repmat(errorRates.sigmoidFit.L,1,2),...
    'Color',colors_two(2,:), 'LineStyle','--', 'LineWidth',1.5);
% INTERSECTION POINT
plISR = plot(errorRates.intersectionPoint(1),errorRates.intersectionPoint(2),...
    'Color','g', 'Marker','x', 'MarkerSize',10, 'LineStyle','--', 'LineWidth',1.5);
plot(repmat(errorRates.intersectionPoint(1),1,2),[0 100], ...
    'Color','g', 'LineStyle','--', 'LineWidth',1.5);

% axis properties
set(axErrorRates,...
    'xlim',[-.5 9.5], 'xtick',0:10,...
    'ylim',[0 60],'ytick',0:20:100, 'FontSize',10)
ylabel('Error rate (%)', 'FontSize',12)
xlabel('Sample number',  'FontSize',12)

%% --- legend: curve fitting ---

legend(axErrorRates, [plSig,plInfl,plSub,plISR],{'sigmoid fit','tangent at inflection point','subitizing line','individual subitizing range'},...
    'Location','NorthWest', 'FontSize',8)

%% --- reaction times ---

axReactionTimes = axes('Units','centimeters', 'Position',[11.5 1.5 8 6]);
hold on

% original data
plot(nums,reactionTimes.median,...
    'Marker','o', 'Color',colors_two(1,:), 'MarkerFaceColor',colors_two(1,:), 'LineStyle','none')
errorbar(nums,reactionTimes.median,reactionTimes.sem,...
    'LineStyle','none', 'Color',colors_two(1,:))
% significance
for n=1:nNums-1
    xVals = nums([n,n+1]);
    yVals = repmat(max(reactionTimes.median([n,n+1])+1.3*reactionTimes.sem([n,n+1])),1,2);
    if reactionTimes.pVals(n) < .05
        line(xVals,yVals, 'Color','k')
        text(xVals(1)+.5,1.02*yVals(1),...
            [stars{reactionTimes.pVals(n)<[Inf,.05,.01,.001]}],...
            'HorizontalAlignment','center', 'FontSize',16)
    end
end

% sigmoid fit
funSigmoid = @(x) reactionTimes.sigmoidFit.L + (reactionTimes.sigmoidFit.U-reactionTimes.sigmoidFit.L)./(1 + exp(-x-reactionTimes.sigmoidFit.xmid));
fplot(funSigmoid, plotRange,...
    'Color',colors_two(1,:), 'LineStyle',':', 'LineWidth',1.5);
% tangent function at inflection point
plot(reactionTimes.inflectionPoint(1),reactionTimes.inflectionPoint(2),...
    'Color','k', 'Marker','*', 'MarkerSize',10, 'LineStyle',':', 'LineWidth',1.5);
plot(xline,reactionTimes.tangentLine,...
    'Color','k', 'LineStyle','--', 'LineWidth',1.5);
% subitizing function
plot(plotRange,repmat(reactionTimes.sigmoidFit.L,1,2),...
    'Color',colors_two(2,:), 'LineStyle','--', 'LineWidth',1.5);
% INTERSECTION POINT
plot(reactionTimes.intersectionPoint(1),reactionTimes.intersectionPoint(2),...
    'Color','g', 'Marker','x', 'MarkerSize',10, 'LineStyle','--', 'LineWidth',1.5);
plot(repmat(reactionTimes.intersectionPoint(1),1,2),[0 2000], ...
    'Color','g', 'LineStyle','--', 'LineWidth',1.5);

% axis properties
set(axReactionTimes,...
    'xlim',[-.5 9.5], 'xtick',0:10,...
    'ylim',[300 1500],'ytick',0:300:1800, 'FontSize',10)
ylabel('Reaction times (ms)', 'FontSize',12)
xlabel('Sample number',       'FontSize',12)

