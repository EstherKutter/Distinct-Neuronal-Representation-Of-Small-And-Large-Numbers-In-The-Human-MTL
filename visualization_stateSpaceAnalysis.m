clear, clc

load('data_stateSpaceAnalysis.mat')

fig = figure('Units','centimeters', 'Position',[2 2 20 16.5], 'Color','w');

%%

nums = 0:9;
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

phaseNames = {'Fix.','Smpl.','Del.','Resp.'};
phaseIdx   = [ 1      16      41     71    81];

class = {'small','large'};
colors_class = [0  0  0; 1  1  1];

colors_two = [0      0.4470 0.7410;... % reddish
              0.8500 0.3250 0.0980];   % blueish
                    
%% --- 3D trajectories ---

axSpace3D = axes('Units','centimeters', 'Position',[1.5 6.5 8 8], 'Color',[.7 .7 .7]);
hold on

% trajectories + phaseBoundaries
for n=1:numel(nums)
    for p=1:numel(phaseNames)
        % phaseBoundary
        plot3(trajectories_3D(n).X(phaseIdx(p)),trajectories_3D(n).Y(phaseIdx(p)),trajectories_3D(n).Z(phaseIdx(p)),...
            'Marker','o', 'MarkerSize',5, 'Color','k', 'MarkerFaceColor',colors_num(n,:))
        % trajectory
        plot3(trajectories_3D(n).X(phaseIdx(p):phaseIdx(p+1)),trajectories_3D(n).Y(phaseIdx(p):phaseIdx(p+1)),trajectories_3D(n).Z(phaseIdx(p):phaseIdx(p+1)),...
            'LineStyle','-', 'LineWidth',1.5, 'Color',colors_num(n,:));
    end
end

% phase labels - nastily hard-coded
pos_phaseLabels = ...
    [-383.0410   66.7037  108.8607; ...
     -227.8519  173.1710    8.3104;...
     690.9376    1.0223  101.8008;...
     22.3252 -317.1838   17.8424];
for p=1:numel(phaseNames)
    text(pos_phaseLabels(p,1),pos_phaseLabels(p,2),pos_phaseLabels(p,3),...
        ['    ',phaseNames{p}],...
        'FontSize',10, 'FontAngle','Italic')
end

% axis properties
view(-96,17)
set(axSpace3D,...
    'xlim',[-480 880], 'ylim',[-430 300], 'zlim',[-330 160],...
    'xticklabel',[], 'yticklabel',[], 'zticklabel',[],...
    'ticklength',[.03 .01], 'FontSize',10)
grid on
xlabel('Dim. 2  ',    'FontSize',12, 'VerticalAlignment','bottom', 'HorizontalAlignment','right', 'Rotation',-65)
ylabel('Dimension 1', 'FontSize',12, 'VerticalAlignment','middle', 'Rotation',1.5)
zlabel('Dimension 3', 'FontSize',12)

%% --- legend: neural trajectories/states ---

axLegend = axes('Units','centimeters', 'Position',[.5 15 9 1]);
hold on

% prefNum
text(axLegend,...
    1,.3, 'Number:',...
    'HorizontalAlignment','right', 'VerticalAlignment','middle', 'FontSize',10)
for n=1:nNums
    rectangle(axLegend,...
        'Position',[1.5*n 0 .6 .5], 'FaceColor',colors_num(n,:))
    text(axLegend,...
        1.5*n+.7,.3, num2str(nums(n)),...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end % f factors

% class labels
text(axLegend,...
    1,-.4, 'Label:',...
    'HorizontalAlignment','right', 'VerticalAlignment','middle', 'FontSize',10)
for c=1:2
    rectangle(axLegend,...
        'Position',[1.5*(5*c-4) -.7 .6 .5], 'FaceColor',colors_class(c,:))
    text(axLegend,...
        1.5*(5*c-4)+.7,-.4, [class{c},' number'],...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end

% axis properties
set(axLegend, 'xtick',[], 'ytick',[])
box on
axis(axLegend, [-2 1.5*(nNums+.9) , -.85 .65]) % with class

%% --- 2D neural states ---

axSpace2D = axes('Units','centimeters', 'Position',[11 7.5 8.5 8.5], 'Color',[.7 .7 .7]);
hold on

% average
for n=1:nNums
    % cluster mean
     plot(neuralStates_2D.clusterMean(n).X,neuralStates_2D.clusterMean(n).Y,...
        'LineStyle', 'none', 'Marker', 's', ...
        'MarkerFaceColor', colors_num(n,:), 'MarkerEdgeColor', [.5 .5 .5], ...
        'MarkerSize', 8);
    % ellipse
    plot(neuralStates_2D.ellipse(n).X,neuralStates_2D.ellipse(n).Y,...
        'Color', colors_num(n,:));    
end % n nums

% per trial
for n=1:nNums
    for t=1:16
        plot(neuralStates_2D.trials(n).X(t),neuralStates_2D.trials(n).Y(t),...
            'LineStyle','none',...
            'Marker','o', 'MarkerSize',4, ...
            'MarkerFaceColor',colors_num(n,:), 'MarkerEdgeColor',colors_class(neuralStates_2D.trials(n).labels(t),:))
    end
end
% centroids
for c=1:2
    plot(neuralStates_2D.classCentroids(c).X,neuralStates_2D.classCentroids(c).Y,...
        'LineWidth',3, 'LineStyle','none', 'Marker','x', 'MarkerSize',10, 'MarkerEdgeColor',colors_class(c,:), 'MarkerFaceColor','k')
end
% axis properties
set(axSpace2D, 'xlim',[-31 21], 'ylim',[-21 31], 'xtick',[], 'ytick',[])
xlabel('Dimension 1', 'FontSize',12);
ylabel('Dimension 2', 'FontSize',12)
view(-90,90)

%% --- evaluation criterion ---

axClusEval = axes('Units','centimeters', 'Position',[2 1.5 6.3 4]);

% ... calinskiHarabasz criterion ...

yyaxis left
hold on
axClusEval.YAxis(1).Color = colors_two(1,:);

% data
errorbar(1:nNums, clusterEvaluation.calinskiHarabasz.mean, clusterEvaluation.calinskiHarabasz.sem,...
    'LineWidth',1.5, 'Color',colors_two(1,:))
plot(clusterEvaluation.calinskiHarabasz.bestClass,clusterEvaluation.calinskiHarabasz.mean(clusterEvaluation.calinskiHarabasz.bestClass),...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(1,:))

% axis properties
set(axClusEval,...
    'ylim',[floor(min(clusterEvaluation.calinskiHarabasz.mean)) , ceil(max(clusterEvaluation.calinskiHarabasz.mean))],...
    'ticklength',[.03 .01], 'FontSize',10)
ylabel({'Calinski-Harabasz','index'}, 'FontSize',12)

% ... gap criterion ...

yyaxis right
hold on
axClusEval.YAxis(2).Color = colors_two(2,:);

% data
errorbar(1:nNums, clusterEvaluation.gap.mean,clusterEvaluation.gap.sem,...
    'LineWidth',1.5, 'Color',colors_two(2,:))
plot(clusterEvaluation.gap.bestClass,clusterEvaluation.gap.mean(clusterEvaluation.gap.bestClass),...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(2,:))

% axis properties
set(axClusEval,...
    'xlim',[.5 nNums+.5], 'xtick',1:nNums, ...
    'ylim',[.6 .8],...
    'ticklength',[.03 .01], 'FontSize',10);
ylabel('Gap value',       'FontSize',12)
axClusEval.XRuler.TickLabelGapOffset = -1;

xlabel('No. of clusters', 'FontSize',12)

%% --- clustering ---

axClass = axes('Units','centimeters', 'Position',[12 1.5 7.5 4]);
hold on

% class 
b = bar(axClass, nums, proportionClassA.mean,'stacked');
for c=1:2
    set(b(c), 'FaceColor',colors_class(c,:), 'BarWidth',.6);
end
% error bar from cross-validation
errorbar(axClass, nums, proportionClassA.mean(:,1),proportionClassA.std(:,2),zeros(nNums,1),...
    'LineStyle','none', 'LineWidth',1.5, 'Color',colors_class(2,:));
errorbar(axClass, nums, proportionClassA.mean(:,1),zeros(nNums,1),proportionClassA.std(:,1),...
    'LineStyle','none', 'LineWidth',1.5, 'Color',colors_class(1,:));
% boundary in num-color
for n=1:nNums
    bar(axClass, nums(n), 1, 'EdgeColor',colors_num(n,:), 'FaceColor','none', 'Linewidth',1.5, 'BarWidth',.65);
end

% axis properties
set(axClass,...
    'xlim',[nums(1)-.75 nums(end)+.75], 'xtick',0:10,...
    'ylim',[0 1], 'ytick',0:.25:1, 'yticklabel',0:25:100,...
    'ticklength',[.03 .01], 'FontSize',10)
ylabel({'Trials (%)','assigned to class'}, 'FontSize',12)
xlabel('Sample number',                    'FontSize',12)
axClass.XRuler.TickLabelGapOffset = -2;
