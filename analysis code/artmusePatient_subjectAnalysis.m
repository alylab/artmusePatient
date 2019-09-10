% subject analysis code for artmusePatient
%
% Mariam Aly
% October 2016
%
% this code was edited to run for multiple subjects at once and is used for
% all populations run on artmusePatient
%
% for use, make sure to have this code in the same directory as the 'data'
% folder
%
% nicholas ruiz
% june 2019
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

%% subject loop

    for s=1:length(subjs)

        % name files according to subject
        fileToOpen = ['artmusePatient_' subjs{s} '.txt'];
        fileToSave = [subjs{s} '_artmusePatient_dataAnalysis.mat'];

        openData = fopen(fileToOpen);

        columnHeadings = {'trial' 'stimOnset' 'exptCond' 'stimNum' 'cue' 'probe' 'valid' 'resp' 'corResp' 'accuracy' 'RT',...
            'e_VArtH' 'e_VArtFA' 'e_VRoomH' 'e_VRoomFA' 'e_IVArtH' 'e_IVArtFA' 'e_IVRoomH' 'e_IVRoomFA',...
            'c_VArtH' 'c_VArtFA' 'c_VRoomH' 'c_VRoomFA' 'c_IVArtH' 'c_IVArtFA' 'c_IVRoomH' 'c_IVRoomFA'};

        rawDataCells = textscan(openData,'%d%.3f%d%d%d%d%d%d%d%d%.3f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f%.2f', ...
            'HeaderLines', 9, ...
            'CommentStyle', {'Block'});

        for i = 1:size(rawDataCells,2)
            rawData(:,i) = double(rawDataCells{i});
        end


        %% mean accuracy: control trials

        % control trials: valid art trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 1 && rawData(r,6) == 1
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.C_Art_Valid = acc;


        % control trials: invalid art trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 2 && rawData(r,6) == 1
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.C_Art_Invalid = acc;


        % control trials: valid room trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 2 && rawData(r,6) == 2
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.C_Room_Valid = acc;


        % control trials: invalid room trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 1 && rawData(r,6) == 2
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.C_Room_Invalid = acc;


        %% mean accuracy: experimental trials

        % experimental trials: valid art trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 1 && rawData(r,6) == 1
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.E_Art_Valid = acc;


        % experimental trials: invalid art trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 2 && rawData(r,6) == 1
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.E_Art_Invalid = acc;


        % experimental trials: valid room trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 2 && rawData(r,6) == 2
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.E_Room_Valid = acc;


        % experimental trials: invalid room trials
        tmpCount = 0; tmpAcc = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 1 && rawData(r,6) == 2
                if rawData(r,10) == 1
                    tmpAcc = tmpAcc + 1;
                    tmpCount = tmpCount + 1;
                elseif rawData(r,10) == 0
                    tmpCount = tmpCount + 1;
                elseif isnan(rawData(r,10))
                    ;
                end
            end
        end

        acc = tmpAcc/tmpCount;
        Accuracy.E_Room_Invalid = acc;


        %% mean RTs: control trials

        % control trials: valid art trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 1 && rawData(r,6) == 1
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.C_Art_Valid = rt;


        % control trials: invalid art trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 2 && rawData(r,6) == 1
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.C_Art_Invalid = rt;


        % control trials: valid room trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 2 && rawData(r,6) == 2
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.C_Room_Valid = rt;



        % control trials: invalid room trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 0 && rawData(r,5) == 1 && rawData(r,6) == 2
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.C_Room_Invalid = rt;



        %% mean RTs: experimental trials

        % experimental trials: valid art trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 1 && rawData(r,6) == 1
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.E_Art_Valid = rt;


        % experimental trials: invalid art trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 2 && rawData(r,6) == 1
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.E_Art_Invalid = rt;


        % experimental trials: valid room trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 2 && rawData(r,6) == 2
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.E_Room_Valid = rt;



        % experimental trials: invalid room trials
        tmpCount = 0; tmpRT = 0;

        for r = 1:size(rawData,1)
            if rawData(r,3) == 1 && rawData(r,5) == 1 && rawData(r,6) == 2
                if ~isnan(rawData(r,11))
                    tmpRT = tmpRT + rawData(r,11);
                    tmpCount = tmpCount + 1;
                end
            end
        end

        rt = tmpRT/tmpCount;
        RT.E_Room_Invalid = rt;



        %% control trials: hits and false alarms

        Hits.C_Art_Valid = rawData(end,20);
        Hits.C_Room_Valid = rawData(end,22);
        Hits.C_Art_Invalid = rawData(end,24);
        Hits.C_Room_Invalid = rawData(end,26);

        FA.C_Art_Valid = rawData(end,21);
        FA.C_Room_Valid = rawData(end,23);
        FA.C_Art_Invalid = rawData(end,25);
        FA.C_Room_Invalid = rawData(end,27);


        %% experimental trials: hits and false alarms

        Hits.E_Art_Valid = rawData(end,12);
        Hits.E_Room_Valid = rawData(end,14);
        Hits.E_Art_Invalid = rawData(end,16);
        Hits.E_Room_Invalid = rawData(end,18);

        FA.E_Art_Valid = rawData(end,13);
        FA.E_Room_Valid = rawData(end,15);
        FA.E_Art_Invalid = rawData(end,17);
        FA.E_Room_Invalid = rawData(end,19);



        %% control trials: inverse efficiency

        InverseEfficiency.C_Art_Valid = RT.C_Art_Valid/Accuracy.C_Art_Valid;
        InverseEfficiency.C_Art_Invalid = RT.C_Art_Invalid/Accuracy.C_Art_Invalid;
        InverseEfficiency.C_Room_Valid = RT.C_Room_Valid/Accuracy.C_Room_Valid;
        InverseEfficiency.C_Room_Invalid = RT.C_Room_Invalid/Accuracy.C_Room_Invalid;


        %% experimental trials: inverse efficiency

        InverseEfficiency.E_Art_Valid = RT.E_Art_Valid/Accuracy.E_Art_Valid;
        InverseEfficiency.E_Art_Invalid = RT.E_Art_Invalid/Accuracy.E_Art_Invalid;
        InverseEfficiency.E_Room_Valid = RT.E_Room_Valid/Accuracy.E_Room_Valid;
        InverseEfficiency.E_Room_Invalid = RT.E_Room_Invalid/Accuracy.E_Room_Invalid;


        %% control trials: A'

        % art valid
        if Hits.C_Art_Valid == FA.C_Art_Valid % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.C_Art_Valid = 0.5;
        elseif Hits.C_Art_Valid >= FA.C_Art_Valid
            APrime.C_Art_Valid = ((Hits.C_Art_Valid - FA.C_Art_Valid) * (1 + Hits.C_Art_Valid - FA.C_Art_Valid)) / (4*Hits.C_Art_Valid*(1-FA.C_Art_Valid)) + 0.5;
        elseif Hits.C_Art_Valid < FA.C_Art_Valid
            APrime.C_Art_Valid = 0.5 - (FA.C_Art_Valid - Hits.C_Art_Valid) * (1 + FA.C_Art_Valid - Hits.C_Art_Valid) / (4*FA.C_Art_Valid*(1-Hits.C_Art_Valid));
        end

        % art invalid
        if Hits.C_Art_Invalid == FA.C_Art_Invalid  % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.C_Art_Invalid = 0.5;
        elseif Hits.C_Art_Invalid >= FA.C_Art_Invalid
            APrime.C_Art_Invalid = ((Hits.C_Art_Invalid - FA.C_Art_Invalid) * (1 + Hits.C_Art_Invalid - FA.C_Art_Invalid)) / (4*Hits.C_Art_Invalid*(1-FA.C_Art_Invalid)) + 0.5;
        elseif Hits.C_Art_Invalid < FA.C_Art_Invalid
            APrime.C_Art_Invalid = 0.5 - (FA.C_Art_Invalid - Hits.C_Art_Invalid) * (1 + FA.C_Art_Invalid - Hits.C_Art_Invalid) / (4*FA.C_Art_Invalid*(1-Hits.C_Art_Invalid));
        end


        % room valid
        if Hits.C_Room_Valid ==  FA.C_Room_Valid % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.C_Room_Valid = 0.5;
        elseif Hits.C_Room_Valid >= FA.C_Room_Valid
            APrime.C_Room_Valid = ((Hits.C_Room_Valid - FA.C_Room_Valid) * (1 + Hits.C_Room_Valid - FA.C_Room_Valid)) / (4*Hits.C_Room_Valid*(1-FA.C_Room_Valid)) + 0.5;
        elseif Hits.C_Room_Valid < FA.C_Room_Valid
            APrime.C_Room_Valid = 0.5 - (FA.C_Room_Valid - Hits.C_Room_Valid) * (1 + FA.C_Room_Valid - Hits.C_Room_Valid) / (4*FA.C_Room_Valid*(1-Hits.C_Room_Valid));
        end



        % room invalid
        if Hits.C_Room_Invalid == FA.C_Room_Invalid  % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.C_Room_Invalid = 0.5;
        elseif Hits.C_Room_Invalid >= FA.C_Room_Invalid
            APrime.C_Room_Invalid = ((Hits.C_Room_Invalid - FA.C_Room_Invalid) * (1 + Hits.C_Room_Invalid - FA.C_Room_Invalid)) / (4*Hits.C_Room_Invalid*(1-FA.C_Room_Invalid)) + 0.5;
        elseif Hits.C_Room_Invalid < FA.C_Room_Invalid
            APrime.C_Room_Invalid = 0.5 - (FA.C_Room_Invalid - Hits.C_Room_Invalid) * (1 + FA.C_Room_Invalid - Hits.C_Room_Invalid) / (4*FA.C_Room_Invalid*(1-Hits.C_Room_Invalid));
        end


        %% experimental trials: A'

        % art valid
        if Hits.E_Art_Valid == FA.E_Art_Valid % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.E_Art_Valid = 0.5;
        elseif Hits.E_Art_Valid >= FA.E_Art_Valid
            APrime.E_Art_Valid = ((Hits.E_Art_Valid - FA.E_Art_Valid) * (1 + Hits.E_Art_Valid - FA.E_Art_Valid)) / (4*Hits.E_Art_Valid*(1-FA.E_Art_Valid)) + 0.5;
        elseif Hits.E_Art_Valid < FA.E_Art_Valid
            APrime.E_Art_Valid = 0.5 - (FA.E_Art_Valid - Hits.E_Art_Valid) * (1 + FA.E_Art_Valid - Hits.E_Art_Valid) / (4*FA.E_Art_Valid*(1-Hits.E_Art_Valid));
        end

        % art invalid
        if Hits.E_Art_Invalid == FA.E_Art_Invalid % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.E_Art_Invalid = 0.5;
        elseif Hits.E_Art_Invalid >= FA.E_Art_Invalid
            APrime.E_Art_Invalid = ((Hits.E_Art_Invalid - FA.E_Art_Invalid) * (1 + Hits.E_Art_Invalid - FA.E_Art_Invalid)) / (4*Hits.E_Art_Invalid*(1-FA.E_Art_Invalid)) + 0.5;
        elseif Hits.E_Art_Invalid < FA.E_Art_Invalid
            APrime.E_Art_Invalid = 0.5 - (FA.E_Art_Invalid - Hits.E_Art_Invalid) * (1 + FA.E_Art_Invalid - Hits.E_Art_Invalid) / (4*FA.E_Art_Invalid*(1-Hits.E_Art_Invalid));
        end


        % room valid
        if Hits.E_Room_Valid == FA.E_Room_Valid  % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.E_Room_Valid = 0.5;
        elseif Hits.E_Room_Valid >= FA.E_Room_Valid
            APrime.E_Room_Valid = ((Hits.E_Room_Valid - FA.E_Room_Valid) * (1 + Hits.E_Room_Valid - FA.E_Room_Valid)) / (4*Hits.E_Room_Valid*(1-FA.E_Room_Valid)) + 0.5;
        elseif Hits.E_Room_Valid < FA.E_Room_Valid
            APrime.E_Room_Valid = 0.5 - (FA.E_Room_Valid - Hits.E_Room_Valid) * (1 + FA.E_Room_Valid - Hits.E_Room_Valid) / (4*FA.E_Room_Valid*(1-Hits.E_Room_Valid));
        end



        % room invalid
        if Hits.E_Room_Invalid == FA.E_Room_Invalid % if 0 hits and 0 false alarms, A' is NaN -- should be at chance though, 0.5
            APrime.E_Room_Invalid = 0.5;
        elseif Hits.E_Room_Invalid >= FA.E_Room_Invalid
            APrime.E_Room_Invalid = ((Hits.E_Room_Invalid - FA.E_Room_Invalid) * (1 + Hits.E_Room_Invalid - FA.E_Room_Invalid)) / (4*Hits.E_Room_Invalid*(1-FA.E_Room_Invalid)) + 0.5;
        elseif Hits.E_Room_Invalid < FA.E_Room_Invalid
            APrime.E_Room_Invalid = 0.5 - (FA.E_Room_Invalid - Hits.E_Room_Invalid) * (1 + FA.E_Room_Invalid - Hits.E_Room_Invalid) / (4*FA.E_Room_Invalid*(1-Hits.E_Room_Invalid));
        end

    % create data summary structure
    DataSummary = struct('Accuracy',Accuracy,'RT',RT, 'Hits',Hits,'FalseAlarms',FA,'InverseEfficiency',InverseEfficiency,'APrime',APrime);

    % save
    cd(dataPath)
    save(fileToSave,'DataSummary','rawData', 'columnHeadings');

    end