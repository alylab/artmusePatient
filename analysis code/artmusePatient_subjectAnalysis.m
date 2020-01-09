% subject analysis code for artmusePatient
%
% Mariam Aly
% October 2016
%
% this code calculates aprime, reaction times, inverse inefficiency accuracy, 
% hit, false alarm, correct rejection and miss rates from the .mat file 
% associated with artmusePatient instead of the .txt file
%
% it will also analyze multiple subjects at once
%
% this is the first step in analyzing data and is used for all patient and
% healthy participant groups ran on artmusePatient
%
% december 2019 modification to calculate D' using the snodgrass correction
% which ensure no hit rate = 1 or false alarm rate = 0 
%
% december 2019 modification to log transform reaction times 
%
% for use, make sure to have this code in the same directory as the 'data'
% folder
%
% nicholas ruiz
% october 2019
% =======================================================

clear all

%% directories
    
    % finds current directory and adds 'data' folder
    cd ..
    currentPath = pwd;
    dataPath = [currentPath '/data']; % '/data' for Mac OS and '\data' for Windows
    addpath(dataPath)

%% directories etc
    subjs = {'101','102','103','104','105','106','107','201','202','203','204','205','206'...
        '207','208','209','210','211','212','213','214'}; % put subject IDs in quotes, separate by comma
    
    conds = {'controlCond', 'exptCond'};
    states = {'Art', 'Room'};
    validity = {'Valid', 'Invalid'};

%% subject loop

for s=1:length(subjs)
    
    cd(dataPath);
    
    % opens data files associated with that subject and names output analysis file accordingly
    openMatData = ['artmusePatient_' subjs{s} '.mat'];
    openTxtData = ['artmusePatient_' subjs{s} '.txt'];
    
    fileToSave = [subjs{s} '_dataAnalysis.mat'];
    
    matData = open(openMatData);
    txtData = fopen(openTxtData);
    
    % prepares .txt file to be open and read
    columnHeadings = {'trial' 'stimOnset' 'exptCond' 'stimNum' 'cue' 'probe' 'valid' 'resp' 'corResp' 'accuracy' 'RT',...
        'e_VArtH' 'e_VArtFA' 'e_VRoomH' 'e_VRoomFA' 'e_IVArtH' 'e_IVArtFA' 'e_IVRoomH' 'e_IVRoomFA',...
        'c_VArtH' 'c_VArtFA' 'c_VRoomH' 'c_VRoomFA' 'c_IVArtH' 'c_IVArtFA' 'c_IVRoomH' 'c_IVRoomFA'};
    
    % creates rawTxtData file which imports raw data from the .txt file associated with subject s
    rawDataCells = textscan(txtData,'%d%.3f%d%d%d%d%d%d%d%d%.3f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f', ...
        'HeaderLines', 9,'CommentStyle', {'Block'});
    
    for i = 1:size(rawDataCells,2)
        rawTxtData(:,i) = double(rawDataCells{i});
    end
    
    % creates a table of the .txt file from rawTxtData for further use in analysis and to save with data
    txtTable = array2table(rawTxtData,'VariableNames',columnHeadings);
    
    %% calculate hit, false alarm, correct rejection and miss rate from data saved in .mat file
    
    Hits.C_Art_Valid = matData.cntrl_valid_ArtProbe_HitRate;
    Hits.C_Room_Valid = matData.cntrl_valid_RoomProbeHitRate;
    Hits.C_Art_Invalid = matData.cntrl_invalid_ArtProbeHitRate;
    Hits.C_Room_Invalid = matData.cntrl_invalid_RoomProbeHitRate;
    
    Hits.E_Art_Valid = matData.expt_valid_ArtProbe_HitRate;
    Hits.E_Room_Valid = matData.expt_valid_RoomProbeHitRate;
    Hits.E_Art_Invalid = matData.expt_invalid_ArtProbeHitRate;
    Hits.E_Room_Invalid = matData.expt_invalid_RoomProbeHitRate;
    
    FA.C_Art_Valid = matData.cntrl_valid_ArtProbe_FARate;
    FA.C_Room_Valid = matData.cntrl_valid_RoomProbe_FARate;
    FA.C_Art_Invalid = matData.cntrl_invalid_ArtProbe_FARate;
    FA.C_Room_Invalid = matData.cntrl_invalid_RoomProbe_FARate;
    
    FA.E_Art_Valid = matData.expt_valid_ArtProbe_FARate;
    FA.E_Room_Valid = matData.expt_valid_RoomProbe_FARate;
    FA.E_Art_Invalid = matData.expt_invalid_ArtProbe_FARate;
    FA.E_Room_Invalid = matData.expt_invalid_RoomProbe_FARate;
    
    CR.C_Art_Valid = matData.cntrl_valid_ArtProbe_CRRate;
    CR.C_Room_Valid = matData.cntrl_valid_RoomProbe_CRRate;
    CR.C_Art_Invalid = matData.cntrl_invalid_ArtProbe_CRRate;
    CR.C_Room_Invalid = matData.cntrl_invalid_RoomProbe_CRRate;
    
    CR.E_Art_Valid = matData.expt_valid_ArtProbe_CRRate;
    CR.E_Room_Valid = matData.expt_valid_RoomProbe_CRRate;
    CR.E_Art_Invalid = matData.expt_invalid_ArtProbe_CRRate;
    CR.E_Room_Invalid = matData.expt_invalid_RoomProbe_CRRate;
    
    Miss.C_Art_Valid = matData.cntrl_valid_ArtProbeMissRate;
    Miss.C_Room_Valid = matData.cntrl_valid_RoomProbeMissRate;
    Miss.C_Art_Invalid = matData.cntrl_invalid_ArtProbeMissRate;
    Miss.C_Room_Invalid = matData.cntrl_invalid_RoomProbeMissRate;
    
    Miss.E_Art_Valid = matData.expt_valid_ArtProbeMissRate;
    Miss.E_Room_Valid = matData.expt_valid_RoomProbeMissRate;
    Miss.E_Art_Invalid = matData.expt_invalid_ArtProbeMissRate;
    Miss.E_Room_Invalid = matData.expt_invalid_RoomProbeMissRate;
    
    %%  calculate A' for all trial types
    
    for c = 1:length(conds)
        for z = 1:length(states)
            for v = 1:length(validity)
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', validity{v}];
                
                if Hits.(tmpLbl) == FA.(tmpLbl) % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
                    APrime.(tmpLbl) = 0.5;
                elseif Hits.(tmpLbl) >= FA.(tmpLbl)
                    APrime.(tmpLbl) = ((Hits.(tmpLbl) - FA.(tmpLbl)) * (1 + Hits.(tmpLbl) - FA.(tmpLbl))) / (4*Hits.(tmpLbl) * (1 - FA.(tmpLbl))) + 0.5;
                elseif Hits.(tmpLbl) < FA.(tmpLbl)
                    APrime.(tmpLbl) = 0.5 - (FA.(tmpLbl) - Hits.(tmpLbl)) * (1 + FA.(tmpLbl) - Hits.(tmpLbl)) / (4*FA.(tmpLbl) * (1 - Hits.(tmpLbl)));
                end
                
            end
        end
    end
    
    %% calculate hit and false alarm rates and conduct snodgrass correction for dprime 
    
    for c = 0:1 % text file utilizes 0 as control trials and 1 as experimental trials
        for z = 1:length(states)
            for v = 0:1 % text file utilizes 0 as invalid trials and 1 as valid trials
                
                % creates extra variables to ensure the 'tmpLbl' variable calls the correct cells
                if v == 0
                    q = 2;
                elseif v == 1
                    q = 1;
                end
                
                if c == 0
                    w = 1;
                elseif c == 1
                    w = 2;
                end
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{w}(1)), '_', states{z}, '_', validity{q}];
    
                Hits_raw.(tmpLbl) = 0; 
                FA_raw.(tmpLbl) = 0;
                Miss_raw.(tmpLbl) = 0;
                CR_raw.(tmpLbl) = 0;
                present.(tmpLbl) = 0; 
                absent.(tmpLbl) = 0;
                
                for r = 1:size(txtTable.trial,1)
                    if txtTable.exptCond(r) == c && txtTable.probe(r) == z && txtTable.valid(r) == v
                        if txtTable.corResp(r) == 1
                            if txtTable.resp(r) == 1
                                
                                present.(tmpLbl) = present.(tmpLbl) + 1;
                                Hits_raw.(tmpLbl) = Hits_raw.(tmpLbl) + 1;
                                
                            elseif txtTable.resp(r) == 0
                                
                                present.(tmpLbl) = present.(tmpLbl) + 1;
                                Miss_raw.(tmpLbl) = Miss_raw.(tmpLbl) + 1;
                                
                            end
                        elseif txtTable.corResp(r) == 0
                            if txtTable.resp(r) == 1
                                
                                absent.(tmpLbl) = absent.(tmpLbl) + 1;
                                FA_raw.(tmpLbl) = FA_raw.(tmpLbl) + 1;
                                
                            elseif txtTable.resp(r) == 0
                                
                                absent.(tmpLbl) = absent.(tmpLbl) + 1;
                                CR_raw.(tmpLbl) = CR_raw.(tmpLbl) + 1;
                                
                            end
                        end
                    end
                end
                
                Hits_corr.(tmpLbl) = (Hits_raw.(tmpLbl) + 0.5) / (present.(tmpLbl) + 1);
                FA_corr.(tmpLbl) = (FA_raw.(tmpLbl) + 0.5) / (absent.(tmpLbl) + 1);
                Miss_corr.(tmpLbl) = Miss_raw.(tmpLbl) / present.(tmpLbl);
                CR_corr.(tmpLbl) = CR_raw.(tmpLbl) / absent.(tmpLbl);
                
            end
        end
    end    
                
    %% calculate D' for all trial types
    
    for c = 1:length(conds)
        for z = 1:length(states)
            for v = 1:length(validity)
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', validity{v}];
                
                DPrime.(tmpLbl) = norminv(Hits_corr.(tmpLbl)) - norminv(FA_corr.(tmpLbl));
                
            end
        end
    end
    
    %% calculate accuracy for all trial types
    
    for c = 0:1 % text file utilizes 0 as control trials and 1 as experimental trials
        for z = 1:length(states)
            for v = 0:1 % text file utilizes 0 as invalid trials and 1 as valid trials
                
                % creates extra variables to ensure the 'tmpLbl' variable calls the correct cells
                if v == 0
                    q = 2;
                elseif v == 1
                    q = 1;
                end
                
                if c == 0
                    w = 1;
                elseif c == 1
                    w = 2;
                end
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{w}(1)), '_', states{z}, '_', validity{q}];
                
                % temporary counter for each trial type
                tmpCount.(tmpLbl) = 0; tmpAcc.(tmpLbl) = 0;
                
                for r = 1:size(txtTable.trial,1)
                    if txtTable.exptCond(r) == c && txtTable.probe(r) == z && txtTable.valid(r) == v
                        if txtTable.accuracy(r) == 1
                            
                            tmpAcc.(tmpLbl) = tmpAcc.(tmpLbl) + 1;
                            tmpCount.(tmpLbl) = tmpCount.(tmpLbl) + 1;
                            
                        elseif txtTable.accuracy(r) == 0
                            
                            tmpCount.(tmpLbl) = tmpCount.(tmpLbl) + 1;
                            
                        elseif isnan(txtTable.accuracy(r))
                            ;
                        end
                    end
                end
                
                % final accuracy variable for each trial type
                Accuracy.(tmpLbl) = tmpAcc.(tmpLbl)/tmpCount.(tmpLbl);
                
            end
        end
    end
    
    %% calculate RTs for all trial types
    
    for c = 0:1 % text file utilizes 0 as control trials and 1 as experimental trials
        for z = 1:length(states)
            for v = 0:1 % text file utilizes 0 as invalid trials and 1 as valid trials
                
                % creates extra variables to ensure the 'tmpLbl' variable calls the correct cells
                if v == 0
                    q = 2;
                elseif v == 1
                    q = 1;
                end
                
                if c == 0
                    w = 1;
                elseif c == 1
                    w = 2;
                end
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{w}(1)), '_', states{z}, '_', validity{q}];
                
                % temporary counter for each trial type
                tmpCount.(tmpLbl) = 0; tmpRT.(tmpLbl) = 0;
                
                for r = 1:size(txtTable.trial,1)
                    if txtTable.exptCond(r) == c && txtTable.probe(r) == z && txtTable.valid(r) == v
                        if ~isnan(txtTable.RT(r))
                            
                            tmpRT.(tmpLbl) = tmpRT.(tmpLbl) + txtTable.RT(r);
                            tmpCount.(tmpLbl) = tmpCount.(tmpLbl) + 1;
                            
                        end
                    end
                end
                
                % final RT variable for each trial type
                RT.(tmpLbl) = tmpRT.(tmpLbl)/tmpCount.(tmpLbl);
                
            end
        end
    end
    
    %% calculate log RTs for all trial types
    
    for c = 0:1 % text file utilizes 0 as control trials and 1 as experimental trials
        for z = 1:length(states)
            for v = 0:1 % text file utilizes 0 as invalid trials and 1 as valid trials
                
                % creates extra variables to ensure the 'tmpLbl' variable calls the correct cells
                if v == 0
                    q = 2;
                elseif v == 1
                    q = 1;
                end
                
                if c == 0
                    w = 1;
                elseif c == 1
                    w = 2;
                end
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{w}(1)), '_', states{z}, '_', validity{q}];
                
                % temporary counter for each trial type
                tmpCount.(tmpLbl) = 0; tmpLogRT.(tmpLbl) = 0;
                
                for r = 1:size(txtTable.trial,1)
                    if txtTable.exptCond(r) == c && txtTable.probe(r) == z && txtTable.valid(r) == v
                        if ~isnan(txtTable.RT(r))
                            
                            tmpLRT = log(txtTable.RT(r));
                            
                            tmpLogRT.(tmpLbl) = tmpLogRT.(tmpLbl) + tmpLRT;
                            tmpCount.(tmpLbl) = tmpCount.(tmpLbl) + 1;
                            LRTcheck.(tmpLbl)(tmpCount.(tmpLbl)) = r;
                            
                        end
                    end
                end
                
                % final RT variable for each trial type
                logRT.(tmpLbl) = tmpLogRT.(tmpLbl)/tmpCount.(tmpLbl);
                
            end
        end
    end
    
    %% calulate inverse efficiency for all trial types
    for c = 1:length(conds)
        for z = 1:length(states)
            for v = 1:length(validity)
                
                % temporary variable used to correctly label trial type by condition, state and validity
                tmpLbl = [upper(conds{c}(1)), '_', states{z}, '_', validity{v}];
                
                InverseEfficiency.(tmpLbl) = RT.(tmpLbl)/Accuracy.(tmpLbl);
                
            end
        end
    end
    
    
    %% create data summary structure and saves data
    DataSummary = struct('APrime',APrime,'DPrime',DPrime,'RT',RT,'logRT',logRT,'InverseEfficiency',InverseEfficiency,'Accuracy',Accuracy,'Hits',Hits,'Hits_corr',Hits_corr,'FA',FA,'FA_corr',FA_corr,'CR',CR','Misses',Miss');
    
    cd(dataPath);
    save(fileToSave,'DataSummary','txtTable','matData');
    
end