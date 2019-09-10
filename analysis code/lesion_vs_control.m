% ========================================================================
% this is a catch-all script for the lesion patients ran on artmusePatient
%
% first, enter the healthy controls and patients then specify the damage
% type for each patient
%
% second, this code will group the data 
%
% third, it will run t-tests. this code can be skipped if desired.
%
% fourth, plots will be made for valid control and relational trials
% (separately) for healthy participants vs patients. the patients will have
% different symbols depending on their damage type. this can be changed if 
% desired. the graphs will not have bars but lines at the mean instead and
% can also be skipped if desired. this code relies on the 'plotSpread'
% function
% 
% graph key:
% diamond = hypoxic patient
% circle = left lobectomy patients
% triangle = right lobectomy patients
%
% be sure to check line 40 to make sure you are doing what you want!!!
%
% for use, make sure to have this code in the same directory as the 'data'
% folder and the 'plotSpread' folder
% 
% nicholas ruiz
% june 2019
% ========================================================================

clear all

%% directories

    % finds current directory and adds 'data' folder
    cd ..
    currentPath = pwd;
    dataPath = [currentPath '/data']; % '/data' for Mac OS and '\data' for Windows
    psPath = [currentPath '/plotSpread']; % '/plotSpread' for Mac OS and '\plotSpread' for Windows
    addpath(dataPath)
    addpath(psPath)

%% what do you want to do?

    makePlots=1; % 1 for making graphs // 0 for not
    multiSymbols=1; % 1 for plotting different symbols depending on brain damage // 0 for plotting all the same symbols all patients
    groupData=1; % 1 to group datat // 0 to skip
    runTtests=1; % 1 for running and saving ttests // 0 for skipping that code

%% name the data

    groupFileName = 'lesion_vs_control.mat';
    ttestFileName = 'lesion_vs_control_ttests.mat';
    
%% specify subjects
      
    control_subjs = {'201','202','203','204','205','206','207','208','209','210','211','212','213','214'};
    patients = {'101','102','103','104','105','106','107'};
    hypoxic = {'101',};
    left_lobectomy = {'104','105','106','107'};
    right_lobectomy = {'102','103'};

    numControls = length(control_subjs);
    numPatients = length(patients);

    colToUse = {[1 0.42 0.42],[0.39 0.72 1]};

%% data titles

    measures = {'APrime', 'RT', 'InverseEfficiency'};
    conds = {'controlCond', 'exptCond'};
    states = {'Art', 'Room'};
    trialTypes = {'Valid', 'Invalid'};
    groups = {'controls', 'patients','hypoxic','left_lobectomy','right_lobectomy'};
    
%% group data

if groupData == 1
    for g = 1:length(groups) % for controls and patients
        
        if g == 1
            subjs = control_subjs;
            struct_label = 'controls';
        elseif g == 2
            subjs = patients;
            struct_label = 'patients';
        elseif g == 3
            subjs = hypoxic;
            struct_label = 'hypoxic';
        elseif g == 4
            subjs = left_lobectomy;
            struct_label = 'left_lobectomy';
        elseif g == 5
            subjs = right_lobectomy;
            struct_label = 'right_lobectomy';
        end
        
        for s = 1:length(subjs)
            
            % Load subject data
            fileName = strcat(subjs{s}, '_artmusePatient_dataAnalysis.mat');
            load(fileName);
            
            
            % loop through measures, conds etc to create group data summary
            for m = 1:length(measures)
                for c = 1:length(conds)
                    for z = 1:length(states)
                        for t = 1:length(trialTypes)
                            
                            tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', trialTypes{t}];
                            
                            GroupDataSummary.(measures{m}).(tmpLbl).(groups{g})(s,1) = DataSummary.(measures{m}).(tmpLbl);
                            
                        end
                    end
                end
            end
        end
        
        % loop through measures, conds etc to create means
        for m = 1:length(measures)
            for c = 1:length(conds)
                for z = 1:length(states)
                    for t = 1:length(trialTypes)
                        
                        tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', trialTypes{t}];
                        
                        GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{g}) = mean(GroupDataSummary.(measures{m}).(tmpLbl).(groups{g}),1);
                        
                    end
                end
            end
        end
    end
    
    %% save
    cd(dataPath)
    save(groupFileName,'GroupDataSummary', 'GroupDataSummaryMeans');
    
end

%% t-tests

% patients and controls separately
if runTtests==1
    load(groupFileName);
    for m = 1:length(measures)
        for c = 1:length(conds)
            for g = 1:2
                for t = 1:length(trialTypes)
                    
                    % art vs room on valid/invalid trials
                    tmpLabelArt = [upper(conds{c}(1)) '_Art_' trialTypes{t}];
                    tmpLabelRoom = [upper(conds{c}(1)) '_Room_' trialTypes{t}];
                    tmpLbl = ['Room_vs_Art_' trialTypes{t}];
                    
                    [h, p, ci, stats] = ttest(GroupDataSummary.(measures{m}).(tmpLabelRoom).(groups{g}), GroupDataSummary.(measures{m}).(tmpLabelArt).(groups{g}));
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).p = p;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).ci = ci;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).stats = stats;
                    
                    % if A', compare to chance
                    
                    for s = 1:length(states)
                        if strcmp(measures{m}, 'APrime')
                            
                            % art/room valid/invalid vs chance
                            tmpLabel = [upper(conds{c}(1)) '_' states{s} '_' trialTypes{t}];
                            tmpLbl = [states{s} '_' trialTypes{t} '_vs_Chance'];
                            
                            [h, p, ci, stats] = ttest(GroupDataSummary.(measures{m}).(tmpLabel).(groups{g}),0.5);
                            ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).p = p;
                            ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).ci = ci;
                            ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).stats = stats;
                            
                        end
                    end
                end
                
                for s = 1:length(states)
                
                    % art/room valid vs. invalid for control and patients
                    tmpLabelValid = [upper(conds{c}(1)) '_' states{s} '_Valid'];
                    tmpLabelInvalid = [upper(conds{c}(1)) '_' states{s} '_Invalid'];
                    tmpLbl = [states{s} '_Valid_vs_Invalid'];

                    [h, p, ci, stats] = ttest(GroupDataSummary.(measures{m}).(tmpLabelValid).(groups{g}), GroupDataSummary.(measures{m}).(tmpLabelInvalid).(groups{g}));
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).p = p;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).ci = ci;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).(groups{g}).stats = stats;

                end
            end
        end
    end
    
    for m = 1:length(measures)
        for c = 1:length(conds)
            for s = 1:length(states)
                for t = 1:length(trialTypes)
            
                    % art/room valid/invalid for controls vs patients
                    tmpLabel = [upper(conds{c}(1)) '_' states{s} '_' trialTypes{t}];
                    tmpLbl = [states{s} '_' trialTypes{t} '_patients_vs_controls'];

                    [h, p, ci, stats] = ttest2(GroupDataSummary.(measures{m}).(tmpLabel).(groups{2}), GroupDataSummary.(measures{m}).(tmpLabel).(groups{1}));
                    ttests.(conds{c}).(tmpLbl).(measures{m}).p = p;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).ci = ci;
                    ttests.(conds{c}).(tmpLbl).(measures{m}).stats = stats;
                end
            end
        end
    end
    
    % comparing conditions
    for g = 1:2
        for m = 1:length(measures)
            for s = 1:length(states)
                for t = 1:length(trialTypes)
                    
                    % art valid
                    tmpControlLabel = ['C_' states{s} '_' trialTypes{t}];
                    tmpExperimentalLabel = ['E_' states{s} '_' trialTypes{t}];
                    tmpLbl = [states{s} '_' trialTypes{t} '_control_vs_experimental'];
                    
                    [h, p, ci, stats] = ttest(GroupDataSummary.(measures{m}).(tmpControlLabel).(groups{g}), GroupDataSummary.(measures{m}).(tmpExperimentalLabel).(groups{g}));
                    ttests.(groups{g}).(tmpLbl).(measures{m}).p = p;
                    ttests.(groups{g}).(tmpLbl).(measures{m}).ci = ci;
                    ttests.(groups{g}).(tmpLbl).(measures{m}).stats = stats;
                end
            end
        end
    end
    
    % save t-tests
    cd(dataPath)
    save(ttestFileName,'ttests');
end

%% plot data

if makePlots == 1
    load(groupFileName);
    for m = 1:length(measures)
        for c = 1:length(conds)
            
            figure('Color',[1 1 1], 'Position', [100, 100, 1049, 895]);
            set(gcf,'name', measures{m});
            
            hold on
            subplot(1,1,1);
            
            % x variables
            i = 1;
            j = 2;
            
            for s = 1:length(states)
                tmpLbl = [upper(conds{c}(1)), '_', states{s}, '_', trialTypes{1}];
                
                % plot mean line, points and error bars for controls
                x1=i-.25;
                x2=i+.25;
                line([x1 x2],[GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{1}),GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{1})],'LineWidth',4,'Color',colToUse{c})
                
                plotSpread(GroupDataSummary.(measures{m}).(tmpLbl).(groups{1}), 'xValues', i);
                set(findall(gcf,'type','line','color','b'),'markerSize',50,'color', colToUse{c})
                
                tmpSEM=std(GroupDataSummary.(measures{m}).(tmpLbl).(groups{1}))/sqrt(numControls);
                errorbar(i,GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{1}),tmpSEM,'.k','LineWidth',4);
                hold on
                
                % plot mean line and error bars for all patients
                x1=j-.25;
                x2=j+.25;
                line([x1 x2],[GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{2}),GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{2})],'LineWidth',4,'Color',colToUse{c});
                
                tmpSEM=std(GroupDataSummary.(measures{m}).(tmpLbl).(groups{2}))/sqrt(numPatients);
                errorbar(j,GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{2}),tmpSEM,'.k','LineWidth',4);
                hold on
                
                if multiSymbols == 1
                    % data point for hypoxic patient as diamond
                    xPos=repmat(j,1,length(GroupDataSummary.(measures{m}).(tmpLbl).(groups{3}))); % determines size of group
                    scatter(xPos,GroupDataSummary.(measures{m}).(tmpLbl).(groups{3}),300,'d','MarkerEdgeColor',colToUse{c},'LineWidth',3)
                    
                    % data point for left lobectomy patient as circle
                    xPos=repmat(j,1,length(GroupDataSummary.(measures{m}).(tmpLbl).(groups{4}))); % determines size of group
                    scatter(xPos,GroupDataSummary.(measures{m}).(tmpLbl).(groups{4}),300,'o','MarkerEdgeColor',colToUse{c},'LineWidth',3)
                    
                    % data point for right lobectomy patient as triangle
                    xPos=repmat(j,1,length(GroupDataSummary.(measures{m}).(tmpLbl).(groups{5}))); % determines size of group
                    scatter(xPos,GroupDataSummary.(measures{m}).(tmpLbl).(groups{5}),300,'^','MarkerEdgeColor',colToUse{c},'LineWidth',3)
                elseif multiSymbols == 0
                    % plots data points for ALL patients as circles
                    plotSpread(GroupDataSummary.(measures{m}).(tmpLbl).(groups{2}), 'xValues', j,'distributionMarkers','o');
                    set(findall(gcf,'type','line','color','b'),'markerSize',15,'color', colToUse{c},'LineWidth',3)
                end
                
                i=i+2;
                j=j+2;
            end
            
            % axes, etc
            xlim([0 5]);
            xlabel([], 'FontSize', 24);
            line([0 5], [0 0], 'LineWidth', 6, 'Color', 'k');
            box off
            set(gca,'FontName','Arial','FontSize',24, 'LineWidth', 6)
            xNames = {'Healthy Participants', 'Patients'};
            set(gca,'xtick',[1:2, 3:4]);
            set(gca,'XTickLabel', xNames, 'FontSize', 18);
            
            % set measure/state specific limits and label positions
            for i=1:length(groups) % finds max data point
                tmpMax = max(GroupDataSummary.(measures{m}).(tmpLbl).(groups{i}));
            end
            
            tmpMax=ceil(tmpMax); % rounds max up to nearest integer
            yMax = tmpMax + 1; % yMax is the maximum Y limit
            yText = tmpMax * 0.15; % yTest is where the x-axis labeling is placed
            
            if strcmp(measures{m},'APrime')
                line([0 5],[0.5 0.5], 'LineWidth', 6,'Color','k','LineStyle','--') % dashed line at 0.5
                ylim([0 1]);
                ylabel('a-prime', 'FontSize', 24);
                text(1.5, -.1, 'art', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
                text(3.5, -.1, 'room', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
            elseif strcmp(measures{m}, 'RT')
                ylim([0 yMax]);
                ylabel('reaction time', 'FontSize', 24);
                text(1.5, -yText, 'art', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
                text(3.5, -yText, 'room', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
            elseif strcmp(measures{m}, 'InverseEfficiency')
                ylim([0 yMax]);
                ylabel('inverse efficiency', 'FontSize', 24);
                text(1.5, -yText, 'art', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
                text(3.5, -yText, 'room', 'FontSize', 24, 'FontName', 'Arial','HorizontalAlignment','center');
            end
            
            if c == 1
                tmpCondLabel = 'control trials';
            elseif c == 2
                tmpCondLabel = 'experimental trials';
            end
            
            title(tmpCondLabel, 'FontSize',24, 'FontName', 'Arial');
            hold on
        end
    end
end


