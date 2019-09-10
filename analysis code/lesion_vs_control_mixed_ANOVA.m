% this code loads in mtl lesion patients and age matched controls then
% creates an 'mmdata' variable that arranges the data such that it can be
% used for a mixed model anova
%
% 'mmdata' is an n-by-4 matrix set up as such:
% column 1 = dependent variable 
% column 2 = between subjects factor
% column 3 = within subjects factor
% column 4 = subject number 
%
% DV is created for Aprime, Reaction time and Inverse efficiency; the
% between subjects factor is group (patients or healthy participants);
% within subjects factor is condition (control or relational) you can
% change this in line 44 depending on the condition you'd like to examine
%
% results are outputted into the command window
%
% this code relies on 'mixed_between_within_anova.m' make sure they are in
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

measures = {'APrime', 'RT', 'InverseEfficiency'};
conds = {'controlCond', 'exptCond'};
states = {'Art', 'Room'};
trialTypes = {'Valid', 'Invalid'};
groups = {'controls', 'patients'};

%% data loop

for m = 1:length(measures)
    
    for c = 1:length(conds)
        
        count=0;
        tmpN=0;
        
        for g = 1:2
            
            if g == 1
                numSub = length(GroupDataSummary.APrime.E_Room_Valid.controls);
            elseif g == 2
                numSub = length(GroupDataSummary.APrime.E_Room_Valid.patients);
            end
            for n = 1:numSub
                
                % total subject counter
                tmpN=tmpN+1;
                
                for s = 1:length(states)
                    
                    count=count+1;
                    
                    % change conds to 1 or 2 to look at control/expt trials
                    tmpLabel = [upper(conds{c}(1)) '_' states{s} '_' trialTypes{1}];
                    
                    if count == 1
                        mmData.(measures{m}).(conds{c})=zeros(1,4);
                    end
                    
                    % Y or dependent variable
                    mmData.(measures{m}).(conds{c})(count,1) = GroupDataSummary.(measures{m}).(tmpLabel).(groups{g})(n);
                    
                    % f1
                    mmData.(measures{m}).(conds{c})(count,2) = g; % group (between subs factor)
                    
                    % f2
                    mmData.(measures{m}).(conds{c})(count,3) = s; % state (within subs factor)
                    
                    % s or subject
                    mmData.(measures{m}).(conds{c})(count,4) = tmpN; % subject codes
                    
                end
            end
        end
    end
end

%% run ANOVA

disp('Aprime Control Trials');
[SSQs, DFs, MSQs, Fs, Ps] = mixed_between_within_anova(mmData.APrime.controlCond)

disp('Aprime Relational Trials');
[SSQs, DFs, MSQs, Fs, Ps] = mixed_between_within_anova(mmData.APrime.exptCond)

disp('RT Control Trials');
[SSQs, DFs, MSQs, Fs, Ps] = mixed_between_within_anova(mmData.RT.controlCond)

disp('RT Relational Trials');
[SSQs, DFs, MSQs, Fs, Ps] = mixed_between_within_anova(mmData.RT.exptCond)