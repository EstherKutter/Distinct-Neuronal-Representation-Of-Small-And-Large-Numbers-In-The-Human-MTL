clear, clc

load('data_anova.mat')

fig = figure('Units','centimeters', 'Position',[2 2 20 8], 'Color','w');

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
          
colors_anova = [ 58  34 130;...      % dark blue
                 62 139 202;...      % light blue
                123 187  77;...      % green
                240 176   0] / 255;  % yellow
stars = {'','*','*','*'};

nAreas = numel(areas);
nFacs  = numel(factors);

%% --- anova table ---

axAnova = axes('Units','centimeters', 'Position',[1.5 2.2 11.5 5.3]);
hold on

% data
for a=1:nAreas
    % xlabel
    text(a,0,...
        {areas{a}{1},[areas{a}{2},' (',num2str(unitsPerArea(a)),')']},...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',10)
    % bars
    xs = linspace(a-.3,a+.3,nFacs);
    b  = bar(xs,diag(tablePercent(:,a)), 'stacked');
    for f=1:nFacs
        b(f).FaceColor = colors_anova(f,:);
        % significance
        text(xs(f),tablePercent(f,a)+.5,...
            [stars{[100 .05 .01 .001] >= tableSignificance(f,a)}],...
            'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',10);
    end % f factors
end % a areas

% axis properties
set(axAnova,...
    'xTick',1:nAreas, 'xTickLabel',[],... % tickLabels,...
    'yTick',0:5:axAnova.YLim(2), 'yGrid','on',...
    'FontSize',10)
ylabel('Significant units (%)', 'FontSize',12)
axAnova.XRuler.TickLabelGapOffset = -2;
axAnova.YRuler.TickLabelGapOffset = 0;
axis([[0 nAreas]+.5  ,  [0 27]]); % ceil((max(table_percs(:)+2)/5))*5]])

%% --- legend: anova table ---

axAnova_Legend = axes('Units','centimeters', 'Position',[6.5 .5 6.5 .5]);
hold on

xFacs = [0 0 .6 .65];
for f=1:nFacs
    rectangle('Position',[f+xFacs(f) 0 .2 .5], 'FaceColor',colors_anova(f,:))
    text(f+.35+xFacs(f),.25, factors{f},...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end % f factors

% axis properties
axis([0.9 nFacs+1.5 , -.15 .7])
set(axAnova_Legend, 'XTick','', 'YTick','', 'box','on')

%% --- preferred numbers ---

axPrefNums = axes('Units','centimeters', 'Position',[14.5 1.5 5 6]);

% data
b = bar(nums,diag(percent_prefNums), 'stacked');
for n=1:numel(nums)
    set(b(n), 'FaceColor',colors_num(n,:), 'FaceAlpha',1);
end % n nums

% axis properties
set(axPrefNums,...
    'xTick',nums, 'xTickLabel',nums,...
    'yTick',0:4:22, 'yGrid','on',...
    'FontSize',10)
xlabel('Preferred number',    'FontSize', 12)
ylabel('Selective units (%)', 'FontSize', 12)
axPrefNums.XRuler.TickLabelGapOffset = -2;
axPrefNums.YRuler.TickLabelGapOffset = 0;
axis([nums(1)-.75 nums(end)+.75 , 0 max(percent_prefNums)+1])
box off
