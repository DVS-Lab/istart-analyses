function MID2BIDS_ISTART_7EVs

subj_list = 'subj_list.txt';
% check to see if subjects file exists
if(exist(subj_list, 'file') == 0)
    fprintf('File does not exist: %s\n\n', subj_list);
    return;
end

durc = ones(1, 50);
ae = string(1:50);
ce = string(1:50);

%configure run #
for r = 1:2 %loop both runs

%set path, i.e., under istart MID folder (or any folder immediately above the
%"data" folder)
maindir = pwd; % under istart-analysis\derivatives\fsl_task-MID
datadir = '/data/projects/istart/Monetary_Incentive/';
cond = fullfile(datadir, 'timing', sprintf('run1%.mat',r));
load(cond);

for k=1:50
    if run.cond(k) == 1
    ae{k} = 'AntLgGain';
    elseif run.cond(k) == 2
    ae{k} = 'AntLgLoss';
    elseif run.cond(k) == 3
    ae{k} = 'AntSmGain';
    elseif run.cond(k) == 4
    ae{k} = 'AntSmLoss';
    elseif run.cond(k) == 5
    ae{k} = 'AntNeu';
    end
end

fid = fopen('subj_list.txt');
tline = fgetl(fid);

%go over folder for each P defined as any 4-digit number
while ischar(tline)
    
    %use frewind(fid) to reset,  
    subj = sprintf('%04s',tline);  %looping the whole list
    %subj = sprintf('%04d',1003);  %to hard code
    %set and load what file to call (for onsets and durations)
    ifname = fullfile(datadir, 'data', subj, sprintf('run-%d_output.mat', r)); 
    %load the behavioral data (matlab output)
    load(ifname);
    
    %organize onsets, durations and events in columns
    %calculate duration (i.e., target starts minus trial starts)
        dura = [output.target_starts' - output.trial_starts'];
        feedback_starts = [output.target_starts' + 1];
        
    %put onsets, durations, and trial type in organization (anticipation)
        a = [output.trial_starts; dura'; ae];         

    %Rename hit and miss in output.outcome
    
    for k = 1:50
            if output.outcome(k) == 1
            ce(k) = 'ConHit';
            elseif output.outcome(k) == 0
            ce(k) = 'ConMiss';
            end
    end
  
    %put onsets, durations, and trial type in organization (consumption)
        c = [feedback_starts'; durc; ce];
    %Name my output .tsv
        ofname = sprintf('sub-%s_task-MID_run-%d_events.tsv',subj,r);
    %make new folder
    mkdir('tsv',sprintf('sub-%s',subj));   
    %set output directory
        output = fullfile(maindir,'tsv', sprintf('sub-%s',subj));
    %set the complete path and file name for .txt (bids) output
        myfile = fullfile(output,ofname);
    %create and put the headers and 3-column data into the tsv
    fileid = fopen(myfile,'w');
    fprintf(fileid,'onsets\tdurations\ttrial_type\n');
    fprintf(fileid,'%f\t%f\t%s\n',a);
    fprintf(fileid,'%f\t%f\t%s\n',c);
    
    %to look at next ID in subj_list.txt
    tline = fgetl(fid);
end
end
end

%lg = 1
%ll = 2
%sg = 3
%sl = 4
%neu = 5
%hit = 6
%miss = 7

%Note:
% 2020.01.17: 1001, 1002, 1003, and 1004 does not use standard filename format



