% this code loads in mtl lesion patients and age matched controls then
% creates an 'rmdata' variable that arranges the data such that it can be
% used for a three way repeated measures ANOVA 
%
% 'rmdata' is an n-by-5 matrix set up as such:
% column 1 = dependent variable 
% column 2 = independent variable 1 (within subjects)
% column 3 = independent variable 2 (within subjects)
% column 4 = independent variable 3 (within subjects)
% column 5 = subject number
%
% DV is aprime or reaction time; IVs are condition (control or relational); 
% state (art or room); valdity (valid or invalid)
%
% results are outputted into the command window
%
% this code relies on 'RMAOV33.m' make sure they are in
% the same directory when you run this code
%
% nicholas ruiz
% june 2019
% =======================================================================

clear all

%% directories + load data

    % finds current directory and adds 'data' folder
    cd ..
    currentPath = pwd;
    dataPath = [currentPath '/data']; % '/data' for Mac OS and '\data' for Windows
    addpath(dataPath)

    load('lesion_vs_control.mat')

%% variable names

measures = {'APrime','logRT'}; % 'DPrime', 'RT', 
conds = {'controlCond', 'exptCond'};
states = {'Art', 'Room'};
trialTypes = {'Valid', 'Invalid'};
groups = {'controls', 'patients'};

%% create rmdata variable

for g = 1:2
    
    if g == 1
        numSub = length(GroupDataSummary.APrime.E_Room_Valid.controls);
    elseif g == 2
        numSub = length(GroupDataSummary.APrime.E_Room_Valid.patients);
    end
    
    for m = 1:length(measures)
        count=0;
        for n = 1:numSub
            for c = 1:length(conds)
                for s = 1:length(states)
                    for t = 1:length(trialTypes)
                        
                        count=count+1;
                        tmpLabel = [upper(conds{c}(1)) '_' states{s} '_' trialTypes{t}];
                        
                        if count == 1
                            rmData.(measures{m}).(groups{g})=zeros(1,5);
                        end
                        
                        rmData.(measures{m}).(groups{g})(count,1) = GroupDataSummary.(measures{m}).(tmpLabel).(groups{g})(n);
                        rmData.(measures{m}).(groups{g})(count,2) = c; % IV 1 = condition
                        rmData.(measures{m}).(groups{g})(count,3) = s; % IV 2 = state
                        rmData.(measures{m}).(groups{g})(count,4) = t; % IV 3 = validity
                        rmData.(measures{m}).(groups{g})(count,5) = n;
                        
                    end
                end
            end
        end
    end
end

%% run rmANOVA

fprintf('\nAprime - Healthy Participants\n');
RMAOV33(rmData.APrime.controls)

fprintf('\nAprime - Patients\n');
RMAOV33(rmData.APrime.patients)

fprintf('\nLog Reaction Time - Healthy Participants\n');
RMAOV33(rmData.logRT.controls)

fprintf('\nLog Reaction Time - Patients\n');
RMAOV33(rmData.logRT.patients)
