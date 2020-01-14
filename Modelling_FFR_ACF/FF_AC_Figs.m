
clear all
Path = '/Users/julia/Google Drive jf565/Gillespie/data/'
set(0,'defaultAxesFontSize',12)


%%
%% compare one experiment with another
clear all
Experiment = 'FigsPaper'
Path = ['/Users/julia/Google Drive jf565/Gillespie/data/',Experiment,'/'];
mkdir(Path)


Cumulative = 0;Intrinsic = 'AP'; Mode = 'Med'
OutPath = [Path,Experiment,'_',Mode,'_C',num2str(Cumulative),'_I',Intrinsic];
OutAll = {};
ACLag = 10; % in minutes
Bootstrap = 50; 

MetaFile = ' enhprom';
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Selection = 'MSE';Shift = [0,0];MinClean = 30; CompLate = 1;


[OutAll{end+1}] = CompareFFAC(Path,Info,{'m5m8psimE','m5m8peve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpsimE','simMSEpeve'},Selection,Shift,ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode);


MetaFile = ' ecNICD';
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

MinClean = 10; CompLate = 0; 

[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve eveNICD'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},'ME',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeve 2xeveNICD'},'ME',[-5,-10],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve +','simMSEpeveSPS +'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
[OutAll{end+1}] = CompareFFAC(Path,Info,{'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},'ME',[-5,-5],ACLag,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)

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
    Label(i) = join(Names,' vs ');
    if i == 1 | i == 2
        FF = Out.FFL;
        FFSD = Out.FFLSD;
        AC1 = Out.ACL{1};
        AC2 = Out.ACL{2};
    end
      
    if contains(Mode,'Aligned')
        FF = Out.FFE;
        FFSD = Out.FFESD;
        AC1 = Out.ACE{1};
        AC2 = Out.ACE{2};
    end  
    
    PlotMiniAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    
    FFMean(i) = nanmean(FF(length(FF)*0:length(FF)*0.7));
    FFMeanSD(i) = nanstd(FF(length(FF)*0:length(FF)*0.7));
    %end
end
print(FigE,[OutPath,'.pdf'],'-fillpage', '-dpdf');
%%
close all
errorbar(FFMean,[1:length(OutAll)],  FFMeanSD, FFMeanSD,'*','horizontal'); hold on;
plot([1:length(OutAll)].*0+1,[1:length(OutAll)])
yticklabels(Label)
yticks([1:length(OutAll)])
set(gca, 'Ydir', 'reverse')
box off
%xtickangle(90)
%%
close all
 FigE = figure('PaperSize',[10 20],'PaperUnits','inches','resize','on','visible','on');
     FigE.Renderer='Painters';

set(0,'defaultAxesFontSize',8)
errorbar([1:length(OutAll)],FFMean,  FFMeanSD, FFMeanSD,'*'); hold on;
plot([1:length(OutAll)],[1:length(OutAll)].*0+1)
xticklabels(Label)
xticks([1:length(OutAll)])
ylim([0,2])
%set(gca, 'Ydir', 'reverse')
box off
xtickangle(90)
print(FigE,[OutPath,'_FF.pdf'],'-fillpage', '-dpdf');
