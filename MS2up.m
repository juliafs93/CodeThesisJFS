%% MS2

%% PATH TO METADATA
%info = readtable('~/Google Drive/MATLAB_R_scripts/metadata MS2.txt','Delimiter','\t')
%% 
clear variables

MetaFile = ' Ch3 Ch4 DevCell19';
MetaFile = ' Ch5';
MetaFile = ' Ch6';
MetaFile = ' Ch6 membranes';
MetaFile = ' Ch6 nucmemb';



info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter', '\t');
%
Paths  = info.Path;
Files = info.File;
Names = info.Name
Nicknames = info.Nickname
Reps = info.Rep; 
From = info.From;
nc14 = info.nc14;
To = string(info.To);
TimeRes = info.TimeRes;
Delay = info.Delay;
SplitEarly = info.SplitEarly;
Flip = info.Flip; Flip = cellfun(@(x) str2num(x),Flip,'UniformOutput',false);
try
Channel1 = info.Channel1;
Channel2 = info.Channel2;
end
Notes = info.Notes;
%
%writetable(info,'~/Google Drive/MATLAB_R_scripts/metadata MS2 3D.txt','Delimiter','\t')


%% 

info.Nickname(Index)

for x = [1]
    
    disp(x)
    set(0, 'DefaulttextInterpreter', 'none')
    Divisions = 1; Spots = 0;
    parameters = {Paths{x}, Files{x}, Names{x},Nicknames{x}, Reps(x),From(x),nc14(x),To{x}, TimeRes(x), Delay(x),Flip{x}, SplitEarly(x), Notes{x}, Divisions, Spots};
  %     MS2_TimeStampAll(Paths{x},Files{x},Names{x},0)
  %MS2_macroImageJ_OrthViews(Paths{x},Files{x},0,Channel1{x}, Channel2{x})
 MS2_macroImageJ(Paths{x}, Files{x},0);  mainMS2_3D_fromBF(parameters,false)
  %AnalyzeTraces(1,1,Spots, info, x); %first arg is manual, second regions (0 no regions, 1 draw/rerun, 2 overwrite), third spots
    %get_3Dprops_from_stats(parameters,0);
    clearvars('-except','Index','info', 'Paths','Files','Names','Nicknames','Reps','From','nc14','To','TimeRes','Delay','Flip','SplitEarly','Channel1','Channel2','Notes'); 
   %end
end 