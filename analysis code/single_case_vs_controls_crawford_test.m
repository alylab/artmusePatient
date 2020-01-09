% this script compares performance of the single hippocampal amnesic case vs a group of 
% age matched controls and calculates a t value adapted from Crawford and Howell (2009)
%
% it will output a t value and a p value as well as confidence intervals
%
% for use, make sure to have this code in the same directory as the 'data'
% folder 
%
% nicholas ruiz 
% sometime late 2018
% =======================================================================

clear all

%% directories 

    % finds current directory and adds 'data' folder
    cd ..
    currentPath = pwd;
    dataPath = [currentPath '/data']; % '/data' for Mac OS and '\data' for Windows
    addpath(dataPath)

%% name the data

    groupFileName = 'single_case_vs_controls'; 
    
%% specify subjects
      
    control_subjs = {'201','202','205','207'};
    patients = {'101'};

    numControls = length(control_subjs);

    colToUse = {[1 0.42 0.42],[0.39 0.72 1]};
    
    criticalTval = 3.182446; % t disribution for 3 degrees of freedom with critical value of 95%

%% data titles

    measures = {'APrime','DPrime','logRT', 'RT', 'InverseEfficiency'};
    conds = {'controlCond', 'exptCond'};
    states = {'Art', 'Room'};
    trialTypes = {'Valid', 'Invalid'};
    groups = {'controls', 'patients'};
    
%% group data

for g = 1:length(groups) % for controls and patients

    if g == 1
        subjs = control_subjs;
        struct_label = 'controls';
    elseif g == 2
        subjs = patients;
        struct_label = 'patients';
    end

    for s = 1:length(subjs)

        % Load subject data
        fileName = strcat(subjs{s}, '_dataAnalysis.mat');
        load(fileName);


        % loop through measures, conds etc to create group data summary
        for m = 1:length(measures)
            for c = 1:length(conds)
                for z = 1:length(states)
                    for tt = 1:length(trialTypes)

                        tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', trialTypes{tt}];

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
                for tt = 1:length(trialTypes)

                    tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', trialTypes{tt}];

                    GroupDataSummaryMeans.(measures{m}).(tmpLbl).(groups{g}) = mean(GroupDataSummary.(measures{m}).(tmpLbl).(groups{g}),1);

                end
            end
        end
    end
end
    
%% calculate n

    n = length(control_subjs);
    
%% calculate crawford t value and confidence intervals

    for c = 1:length(conds)
        for s = 1:length(states)

            tmpLbl = [upper(conds{c}(1)), '_', states{s}, '_', trialTypes{1}];

            x1.(tmpLbl) = GroupDataSummaryMeans.(measures{1}).(tmpLbl).(groups{2}); % patient performance 
            x2.(tmpLbl) = GroupDataSummaryMeans.(measures{1}).(tmpLbl).(groups{1}); % mean control performance 
            standard_dev.(tmpLbl) = std(GroupDataSummary.(measures{1}).(tmpLbl).(groups{1})); % std of control sample

            t.(tmpLbl) = ((x1.(tmpLbl)) - (x2.(tmpLbl)))/((standard_dev.(tmpLbl))*(sqrt((n+1)/n))); % calculate crawford t value

            p.(tmpLbl) = tcdf((t.(tmpLbl)),(n-1)); % p value calculated using student's t test
            
            % calculate confidence intervals
            
            meanDiff.(tmpLbl) = x1.(tmpLbl) - x2.(tmpLbl); % mean difference of patients minus controls
            tmpCI = criticalTval * ((standard_dev.(tmpLbl))*(sqrt((n+1)/n))); % t distribution value multiplied by denominator of crawford t value calculation
            
            lowerCI = meanDiff.(tmpLbl) - tmpCI; % calculate lower and upper CI's by  adding/subtracting the tmp value from the mean difference
            upperCI = meanDiff.(tmpLbl) + tmpCI; 
            
            ci.(tmpLbl) = [lowerCI upperCI];

        end
    end
    
%% save file

cd(dataPath)
save(groupFileName,'GroupDataSummary', 'GroupDataSummaryMeans','x1','x2','standard_dev','t','p','meanDiff','criticalTval','ci');