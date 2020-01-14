
clear all
Path = '/Users/julia/Google Drive jf565/Gillespie/data/'
set(0,'defaultAxesFontSize',12)

%%
Path = [uigetdir('/Users/julia/Google Drive jf565/Gillespie/data/'),'/'];
set(0,'defaultAxesFontSize',12)

%% compare early and late for each repeat or all together
set(0,'defaultAxesFontSize',12)
Which = 1 % 1 to merge all repeats, 3 for each

%MetaFile = '';
MetaFile = ' enhprom';
%MetaFile = ' ecNICD';
%MetaFile = ' mutBG';

Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = num2str(Info.Rep);
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',Exps.Rep(x)];end
Exps.Exp = Exp';
UniqueN = table2array(unique(Exps(:,Which)));
%

    MinClean = 50;
    Mode = 'Med'
    ACLag = 50; Bootstrap = 50;Cumulative = 0; 
%OutAll = struct;
for n = 1:length(UniqueN)
    try
    [OutAll{n}] = CompareFFAC(Path,Info,UniqueN(n),'MSE',[0,0],ACLag,Bootstrap,MinClean,Cumulative,1, Mode);
    end
end

save([Path,'OutAllEarlyLate_',Mode,'_C',num2str(Cumulative),'.mat'],'OutAll')
%%
load([Path,'OutAllEarlyLate_',Mode,'_C',num2str(Cumulative),'.mat'])

 FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
set(0,'defaultAxesFontSize',12)

for i = 1:length(OutAll)
    try
    subplot(4,4,i);
    Out = OutAll{i};
    
    TimeRes = Out.TimeRes;
    FF = Out.FFE;
    FFSD = Out.FFESD;
    AC1 = Out.ACE{1};
    AC2 = Out.ACL{1};
    Exp = Out.Exp;
    Names = {[Out.Names{:},' <m1>'],[Out.Names{:},' <m2>']};
    
    PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    end
end

print(FigE,[Path,'StatsAll_EarlyLate_',Mode,'_C',num2str(Cumulative),'.pdf'],'-fillpage', '-dpdf');

%%
%% compare one experiment with another
clear all
MetaFile = '';
MetaFile = ' enhprom';
Path = ['/Users/julia/Google Drive jf565/Gillespie/data/',MetaFile,'/'];
mkdir(Path)
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
%MetaFile = ' mutBG';

Experiment = 'Promoters'
Selection = 'MSE';Shift = [0,0];ACLag = 50; Bootstrap = 50; MinClean = 30;Cumulative = 0;Intrinsic = 'Onset'; CompLate = 1;Mode = 'Med'

OutPath = [Path,Experiment,'_',Mode,'_C',num2str(Cumulative),'_I',Intrinsic];

OutAll = {};
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8hsp70','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peve','m5m8pm5'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8pm6','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8pm7','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8pm8','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8psimE','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpsimE','simMSEpeve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);

save([OutPath,'.mat'],'OutAll')
%%
load([OutPath,'.mat'])

 FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
set(0,'defaultAxesFontSize',12)
set(gcf, 'InvertHardCopy', 'off');


for i = 1:length(OutAll)
    %try
    subplot(4,4,i);
    Out = OutAll{i};
    
    TimeRes = Out.TimeRes;
    FF = Out.FFL;
    FFSD = Out.FFLSD;
    AC1 = Out.ACL{1};
    AC2 = Out.ACL{2};
    Exp = Out.Exp;
    Names = Out.Names;
    
    if ~isempty(strfind(Mode,'Aligned'))
        FF = Out.FFE;
        FFSD = Out.FFESD;
        AC1 = Out.ACE{1};
        AC2 = Out.ACE{2};
    end    
    PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    %end
end

print(FigE,[OutPath,'.pdf'],'-fillpage', '-dpdf');

%%
clear all
MetaFile = ' ecNICD';
Path = ['/Users/julia/Google Drive jf565/Gillespie/data/',MetaFile,'/'];
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
mkdir(Path)

Experiment = 'MSE'

ACLag = 50; Bootstrap = 50; MinClean = 30;Cumulative = 0;Intrinsic='Onset';CompLate = 0; Mode = 'Med'
OutPath = [Path,Experiment,'_',Mode,'_C',num2str(Cumulative),'_I',Intrinsic];

OutAll = {};

[OutAll{1}] = CompareFFAC(Path,Info,{'m5m8peve +','m5m8peve eveNICD'},'MSE',[0,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peve eveNICD','m5m8peve 2xeveNICD'},'MSE',[-15,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peve +','m5m8peve 2xeveNICD'},'MSE',[0,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve eveNICD'},'MSE',[0,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},'MSE',[-10,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve 2xeveNICD'},'MSE',[0,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeveSPS +'},'MSE',[0,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},'MSE',[-10,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeveSPS +','simMSEpeveSPS eveNICD'},'MSE',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','m5m8peve eveNICD'},'MSE',[-10,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveiSPS +','m5m8peve +'},'MSE',[0,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveiSPS eveNICD','m5m8peve eveNICD'},'MSE',[-15,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveiSPS +','m5m8peveiSPS eveNICD'},'MSE',[0,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDtwi +','m5m8peve +'},'MSE',[5,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDtwi eveNICD','m5m8peve eveNICD'},'MSE',[-10,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDdl +','m5m8peve +'},'MSE',[0,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDdl eveNICD','m5m8peve eveNICD'},'MSE',[-10,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)

[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDtwidl +','m5m8peve +'},'MSE',[5,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8peveDtwidl eveNICD','m5m8peve eveNICD'},'MSE',[-5,-15],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate,Mode)

save([OutPath,'.mat'],'OutAll')

%%
load([OutPath,'.mat'])

 FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
     FigE.Renderer='Painters';

set(0,'defaultAxesFontSize',12)
set(gcf, 'InvertHardCopy', 'off');

for i = 1:length(OutAll)
    %try
    subplot(4,4,i);
    Out = OutAll{i};
    
    TimeRes = Out.TimeRes;
    FF = Out.FFE;
    FFSD = Out.FFESD;
    AC1 = Out.ACE{1};
    AC2 = Out.ACE{2};
    Exp = Out.Exp;
    Names = Out.Names;
    
   if ~isempty(strfind(Mode,'Aligned'))
        FF = Out.FFE;
        FFSD = Out.FFESD;
        AC1 = Out.ACE{1};
        AC2 = Out.ACE{2};
    end  
    
    PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    %end
end
print(FigE,[OutPath,'.pdf'],'-fillpage', '-dpdf');

%%
clear all
MetaFile = ' ecNICD';
Path = ['/Users/julia/Google Drive jf565/Gillespie/data/',MetaFile,'/'];
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
mkdir(Path)

Experiment = 'ME'
ACLag = 50; Bootstrap = 50; Cumulative = 0;Intrinsic = 'Random', CompLate = 0; Mode = 'Med';
OutPath = [Path,Experiment,'_',Mode,'_C',num2str(Cumulative),'_I',Intrinsic];

OutAll = {};
MinClean = 10;

[OutAll{1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve eveNICD'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{2}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},'ME',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{3}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve 2xeveNICD'},'ME',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{4}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeveSPS +'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{5}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{6}] = CompareFFAC(Path,Info,{'simMSEpeveSPS +','simMSEpeveSPS eveNICD'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{7}] = CompareFFAC(Path,Info,{'m8NEpeve +','m8NEpeve eveNICD'},'ME',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{8}] = CompareFFAC(Path,Info,{'m5m8pevel eveNICD','m5m8pevel 2xeveNICD'},'DE',[-10,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

save([OutPath,'.mat'],'OutAll')


%%
load([OutPath,'.mat'])

 FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
     FigE.Renderer='Painters';

set(0,'defaultAxesFontSize',12)
set(gcf, 'InvertHardCopy', 'off');

for i = 1:length(OutAll)
    %try
    subplot(4,4,i);
    Out = OutAll{i};
    
    TimeRes = Out.TimeRes;
    FF = Out.FFE;
    FFSD = Out.FFESD;
    AC1 = Out.ACE{1};
    AC2 = Out.ACE{2};
    Exp = Out.Exp;
    Names = Out.Names;
    
    if contains(Mode,'Aligned')
        FF = Out.FFE;
        FFSD = Out.FFESD;
        AC1 = Out.ACE{1};
        AC2 = Out.ACE{2};
    end  
    
    PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    %end
end
print(FigE,[OutPath,'.pdf'],'-fillpage', '-dpdf');

%%
%% test 2c
clear all
set(0,'defaultAxesFontSize',12)
Which = 1 % 1 to merge all repeats, 3 for each

%MetaFile = ' ecNICD';
MetaFile = ' 2c';
MetaFile = ' enhprom';

Path = ['/Users/julia/Google Drive jf565/Gillespie/data/',MetaFile,'/'];
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter','\t');
mkdir(Path)


Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = num2str(Info.Rep);
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',Exps.Rep(x)];end
Exps.Exp = Exp';
UniqueN = table2array(unique(Exps(:,Which)));
%

    MinClean = 10;
    Mode = 'Med'
    ACLag = 50; Bootstrap = 50;Cumulative = 0; 
    CompLate = 0;
    
        [OutAll{1}] = CompareFFAC(Path,Info,{'m5m8peve','m5m8peve'},'',[-30,-30],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
        [OutAll{1}] = CompareFFAC(Path,Info,{'eve2','eve2'},'',[-30,-30],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
        [OutAll{1}] = CompareFFAC(Path,Info,{'m5m8peve +','m5m8peve +'},'MSE',[0,0],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

    [OutAll{1}] = CompareFFAC(Path,Info,{'eve2','eve2PP7'},'',[-30,-30],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
    [OutAll{2}] = CompareFFAC(Path,Info,{'eve2','eve2PP7'},'MSE',[-30,-30],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)


save([Path,'Outeve_',Mode,'_C',num2str(Cumulative),'.mat'],'OutAll')
%%
load([Path,'Outeve_',Mode,'_C',num2str(Cumulative),'.mat'])

 FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
    FigE.Renderer='Painters';

set(0,'defaultAxesFontSize',12)
set(gcf, 'InvertHardCopy', 'off');

for i = 1:length(OutAll)
    try
    subplot(4,4,i);
    Out = OutAll{i};
    
    TimeRes = Out.TimeRes;
    FF = Out.FFE;
    FFSD = Out.FFESD;
    AC1 = Out.ACE{1};
    AC2 = Out.ACE{2};
    Exp = Out.Exp;
    Names = Out.Names;
    
    PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    end
end

print(FigE,[Path,'StatsAll_eve_',Mode,'_C',num2str(Cumulative),'.pdf'],'-fillpage', '-dpdf');

%%

CompareFFAC(Info,SelectedN,Selection,Shift,ACLag,Bootstrap,Cumulative,Intrinsic,CompLate, Mode)