
%%
clear all
%Path = '/Users/julia/Google Drive jf565/comp MS2/OnOff/';
Path = '/Users/julia/Google Drive jf565/comp MS2/';
mkdir(Path)

MetaFile = '';
%MetaFile = ' enhprom';
MetaFile = ' ecNICD';
%MetaFile = ' mutBG';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

Exps = cell2table(info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';


%%
close all


Nicknames = {'^m5m8pevez$','m5m8peve Ez:TTG','m5m8peve TTG, mEz'}
ExpLabels = {'WT','Ez:TTG','TTG, mEz'};
Selection = '';
MinT = 15;
MaxT = 25;

Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$',}
ExpLabels = {'WT +','Dtwi +','WT NICD','Dtwi NICD',};

Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$',}
ExpLabels = {'m5m8 WT', 'm5m8Dtwi WT','m5m8Ddl WT','m5m8 eveNICD','m5m8Dtwi eveNICD','m5m8Ddl eveNICD',};

Selection = 'MSE';
MinT = 55;
MaxT = 55;

Jitter = 0.5;

MaxRow = length(Nicknames);
OnPerFrameAll = cell(1,MaxRow);

RepOnPerFrame = cell(1,MaxRow);

MaxCol = 1;

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
     MaxCol = max(MaxCol,length(Index));
for i = [1:length(Index)]
        x = Index(i);
        %
        Parameters = info(x,:);
        Table2Vars(Parameters);
        Flip = str2double(strsplit(Flip,','));
        PathToSave = [Path,File,Name,File]; 
        %load([PathToSave, '_Stats.mat']);
        minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
        boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        Im = Merged_meanF_maxGFP(:,:,F)./255;
        ImLab = boundariesL(:,:,F);
        Width = size(Im,1); Height = size(Im,2);
        load([PathToSave,'_Data.mat']);
        Struct2Vars(Data);
        
        Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline')];
        if strcmp(Selection,'') == 0
                Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & Properties.Region == Selection];
        end
      %
        OnOff = CleanOnOff(OnOff(:,Selected),5);
        OnOffTimeOff = OnOff(max(1,MinT*60/TimeRes+nc14-Delay):MaxT*60/TimeRes+nc14-Delay,:);
        OnPerFrame = sum(OnOffTimeOff,2);
                
               
                % % cells on
        OnPerFrameAll{Exp} = [OnPerFrameAll{Exp}; [OnPerFrame]];
        
        RepOnPerFrame{Exp} = [RepOnPerFrame{Exp};repmat(i,length([OnPerFrame]),1)];
        

end
end
%
OnPerFrameAll = Cell2Mat(OnPerFrameAll);

RepOnPerFrame = Cell2Mat(RepOnPerFrame);

%
%ExpLabels = {'WT','eve-NICD'};
set(0,'defaultAxesFontSize',16)
%set(0,'defaultAxesFontName', 'MyriadPro-Regular')
%set(0,'defaultTextFontName', 'MyriadPro-Regular')
%set(0,'defaulttextinterpreter', 'latex')
     set(0, 'DefaultFigureRenderer', 'painters');

 

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_cellsON_',cell2mat(join(ExpLabels,'_vs_')),'.pdf']
    Fig = figure('PaperSize',[40 20],'PaperUnits','inches','resize','on', 'visible','off');
subplot(1,2,1); 
boxplot(OnPerFrameAll,'Labels',ExpLabels,'BoxStyle','outline', 'Widths',0.2,'Symbol','.','Jitter',1,'Whisker',0,'Notch','on'); 
title('# cells ON 15-25'''); box off; 
ylim([0,30])
set(findobj(gca, 'type', 'line'), 'linew',1)


CMAP = parula(MaxCol+1);
BarW = 0.3;
Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;BarW./2];

subplot(1,2,2); 
CatX = repmat([1:1:length(Nicknames)],length(OnPerFrameAll),1);
patch([Cat;flip(Cat)],[repmat(quantile(OnPerFrameAll,0.25),2,1);repmat(quantile(OnPerFrameAll,0.75),2,1)],'red','EdgeColor','none','FaceAlpha',0.3); hold on
gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, OnPerFrameAll(:), RepOnPerFrame(:),CMAP); hold on
plot(Cat,repmat(nanmean(OnPerFrameAll),2,1),'-r','DisplayName','mean')
plot(Cat,repmat(quantile(OnPerFrameAll,0.25),2,1),'-','DisplayName','Q1','Color',[1,0,0,0.5])
plot(Cat,repmat(quantile(OnPerFrameAll,0.75),2,1),'-','DisplayName','Q3','Color',[1,0,0,0.5])
legend off
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
set(findobj(gca, 'type', 'line'), 'linew',2)
%title('# cells ON 15-25'''); box off; 
title('# cells ON 55'''); box off; 

ylim([0,20]); 
xlim([0+Jitter,length(Nicknames)+Jitter]); 



%export_fig FileOut -pdf
%saveas(Fig,FileOut,'pdf')
print(Fig,FileOut,'-fillpage','-dpdf');
%print(Fig,FileOut,'-dtiff');

%%
clear all
Path = '/Users/julia/Google Drive jf565/comp MS2/';
mkdir(Path)

MetaFile = ' enhprom';
Nicknames = {'^m5m8peve$','^simMSEpeve$'}
ExpLabels = {'m5m8-peve', 'sim-peve'};
Selection = 'MSE';

% MetaFile = ' ecNICD';
% Nicknames = {'^m5m8peve \+$','^simMSEpeve \+$'}
% ExpLabels = {'m5m8-peve +', 'simMSE-peve +',};
% Selection = 'MSE';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Exps = cell2table(info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';


Exp = 1
Jitter = 0.5;

    
MaxRow = length(Nicknames);
OnsetAll = cell(1,MaxRow);
EndAll = cell(1,MaxRow);
APAll = cell(1,MaxRow);
RepAll = cell(1,MaxRow);

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
for i = [1:length(Index)]
        Parameters = info(Index(i),:);
        Table2Vars(Parameters);
        Flip = str2double(strsplit(Flip,','));
        PathToSave = [Path,File,Name,File]; 
        %load([PathToSave, '_Stats.mat']);
        minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
        %boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        Im = Merged_meanF_maxGFP(:,:,F)./255;
        %ImLab = boundariesL(:,:,F);
        Width = size(Im,2); Height = size(Im,1);
        load([PathToSave,'_Data.mat']);
        Struct2Vars(Data);
      %
        OnOff = CleanOnOff(OnOff,5);
    
    TotalOn = nansum(OnOff(SplitEarly*60/TimeRes:end,:),1).*TimeRes/60; %total on time from SplitEarly
    
    Properties.NormAP = (Properties.AP_position - Width./2).*XYRes;

    Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 10];
    if strcmp(Selection,'') == 0
            Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 10 & Properties.Region == Selection];

    end
     PropertiesSelected = Properties (Selected,:);
     %subplot(131);plot([rand(1,length(PropertiesSelected.Onset))],PropertiesSelected.Onset,'.r'); hold on
     %scatter([rand(1,length(PropertiesSelected.End))],PropertiesSelected.End,'.b'); ylim([0,90])
     %subplot(132);boxplot([PropertiesSelected.Onset,PropertiesSelected.End],'Jitter',0.5,'Symbol','.','Whisker',1); ylim([0,90])
     %subplot(133);
%     plot(PropertiesSelected.NormAP,PropertiesSelected.Onset,'.b'); hold on
 %    plot(PropertiesSelected.NormAP,PropertiesSelected.End,'.r');  ylim([0,90])
      Except = ((PropertiesSelected.AP_position-400) < -400)| ((PropertiesSelected.AP_position-400) > 400)
     OnsetAll{Exp} = [OnsetAll{Exp};PropertiesSelected.Onset(~Except')];
     EndAll{Exp} =[EndAll{Exp}; PropertiesSelected.End(~Except')];
     APAll{Exp} = [APAll{Exp};PropertiesSelected.NormAP(~Except')];
     RepAll{Exp} = [RepAll{Exp};repmat(i,length([PropertiesSelected.Onset(~Except')]),1)];
end   
end

OnsetAll = Cell2Mat(OnsetAll);
EndAll = Cell2Mat(EndAll);
RepAll = Cell2Mat(RepAll);

%OnsetAll(abs(APAll) > Width*XYRes./4) = [];
%EndAll(abs(APAll) > Width*XYRes./4) = [];
%RepAll(abs(APAll) > Width*XYRes./4) = [];
%APAll(abs(APAll) > Width*XYRes./4) = [];

%%


% OnsetAll = [All(1,:),All(2,:)];
% EndAll = [All(3,:),All(4,:)];
% APAll = (rand(length(OnsetAll),1)-0.5).*Jitter+1,

%OnsetAll = Cell2Mat(AllOnmixed);
%EndAll = Cell2Mat(AllOffmixed);
%RepAll = ones(size(OnsetAll));


%
Fig = figure('PaperUnits','inches','PaperSize',[2.5,4],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',10)
     set(0, 'DefaultFigureRenderer', 'painters');

Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;  
Palette = Palette([1:length(Nicknames)],:)

%Palette = [130,130,130;80,80,80;205,55,0]./255;

%CatX = repmat([1:1:length(Nicknames)],length(OnsetAll),1);
CMAP = gray(length(Index));
BarW = 0.7;
Jitter = 0.5;
CatX = repmat([1:1:length(Nicknames)],length(OnsetAll),1);
Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;BarW./2];
patch([Cat;flipud(Cat)],[repmat(quantile(OnsetAll,0.25),2,1);repmat(quantile(OnsetAll,0.75),2,1)],[1:length(Nicknames)]','EdgeColor','none','FaceAlpha',0.5); hold on
gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, OnsetAll(:), CatX(:),Palette,'*',2); hold on
%set(Fig,'defaultAxesColorOrder',Palette)
plot(Cat,repmat(nanmean(OnsetAll),2,1),'-','DisplayName','mean','Color',[0.3,0.3,0.3])
%set(gca, 'ColorOrderIndex', 1)
plot(Cat,repmat(quantile(OnsetAll,0.25),2,1),'-','DisplayName','Q1','Color',[0.6,0.6,0.6])
%set(gca, 'ColorOrderIndex', 1)
plot(Cat,repmat(quantile(OnsetAll,0.75),2,1),'-','DisplayName','Q3','Color',[0.6,0.6,0.6])
colormap(Palette)

patch([Cat;flipud(Cat)],[repmat(quantile(EndAll,0.25),2,1);repmat(quantile(EndAll,0.75),2,1)],[1:length(Nicknames)]','EdgeColor','none','FaceAlpha',0.5); hold on
gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, EndAll(:), CatX(:),Palette,'o',2); hold on
plot(Cat,repmat(nanmean(EndAll),2,1),'-','DisplayName','mean','Color',[0.3,0.3,0.3])
plot(Cat,repmat(quantile(EndAll,0.25),2,1),'-','DisplayName','Q1','Color',[0.6,0.6,0.6])
plot(Cat,repmat(quantile(EndAll,0.75),2,1),'-','DisplayName','Q3','Color',[0.6,0.6,0.6])
colormap(Palette)

legend off
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
%set(findobj(gca, 'type', 'line'), 'linew',2)
%title(ExpLabels{Exp}); 
box off; 
ylim([0,90]);
ylabel('time into nc14 (min)')
    set(gca,'FontSize',6)
    
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_ONOFF_',char(join(ExpLabels,'_')),'.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');

%%

    Fig = figure('PaperSize',[20 30],'PaperUnits','inches','resize','on', 'visible','on');
set(0,'defaultAxesFontSize',16)
     set(0, 'DefaultFigureRenderer', 'painters');
     
%CatX = repmat([1:1:length(Nicknames)],length(OnsetAll),1);
CMAP = gray(length(Index));
BarW = Width./4
CatX = APAll;
Cat = repmat([1:1:1],2,1)+[-BarW./2;BarW./2];
patch([Cat;flip(Cat)],[repmat(quantile(OnsetAll,0.25),2,1);repmat(quantile(OnsetAll,0.75),2,1)],[0,189,194]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
gscatter(CatX(:), OnsetAll(:), RepAll(:),[0,189,194]./255); hold on
plot(Cat,repmat(nanmean(OnsetAll),2,1),'-','DisplayName','mean','Color',[0,189,194,255]./255)
plot(Cat,repmat(quantile(OnsetAll,0.25),2,1),'-','DisplayName','Q1','Color',[0,189,194,150]./255)
plot(Cat,repmat(quantile(OnsetAll,0.75),2,1),'-','DisplayName','Q3','Color',[0,189,194,150]./255)

patch([Cat;flip(Cat)],[repmat(quantile(EndAll,0.25),2,1);repmat(quantile(EndAll,0.75),2,1)],[245,118,109]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
gscatter(CatX(:), EndAll(:), RepAll(:),[245,118,109]./255); hold on
plot(Cat,repmat(nanmean(EndAll),2,1),'-','DisplayName','mean','Color',[245,118,109]./255)
plot(Cat,repmat(quantile(EndAll,0.25),2,1),'-','DisplayName','Q1','Color',[245,118,109,150]./255)
plot(Cat,repmat(quantile(EndAll,0.75),2,1),'-','DisplayName','Q3','Color',[245,118,109,150]./255)

legend off
%xticks([1:1:length(Nicknames)])
%xticklabels(ExpLabels)
set(findobj(gca, 'type', 'line'), 'linew',2)
title(ExpLabels{Exp}); box off; 
ylim([0,90]); xlim([-Width./4.*XYRes-5,+Width./4.*XYRes+5]); 
ylabel('time into nc14 (min)')
xlabel('relative AP position (um)')

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_ONOFF_',ExpLabels{Exp},'.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');


%%
%% compare onset

Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$',}
ExpLabels = {'m5m8 WT', 'm5m8Dtwi WT','m5m8Ddl WT','m5m8 eveNICD','m5m8Dtwi eveNICD','m5m8Ddl eveNICD',};

Selection = 'MSE';

Exp = 1

Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
    
MaxRow = length(Nicknames);

OnsetAll = cell(1,MaxRow);
EndAll = cell(1,MaxRow);
APAll = cell(1,MaxRow);
RepAll = cell(1,MaxRow);


MaxCol = 1;

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
     MaxCol = max(MaxCol,length(Index));
    
for i = [1:length(Index)]
        Parameters = info(Index(i),:);
        Table2Vars(Parameters);
        Flip = str2double(strsplit(Flip,','));
        PathToSave = [Path,File,Name,File]; 
        %load([PathToSave, '_Stats.mat']);
        minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
        %boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        Im = Merged_meanF_maxGFP(:,:,F)./255;
        %ImLab = boundariesL(:,:,F);
        Width = size(Im,2); Height = size(Im,1);
        load([PathToSave,'_Data.mat']);
        Struct2Vars(Data);
      %
        OnOff = CleanOnOff(OnOff,5);
        TotalOn = nansum(OnOff(SplitEarly*60/TimeRes:end,:),1).*TimeRes/60; %total on time from SplitEarly
    
    Properties.NormAP = (Properties.AP_position - Width./2).*XYRes;

    Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 5];
    if strcmp(Selection,'') == 0
            Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 5 & Properties.Region == Selection];

    end
     PropertiesSelected = Properties (Selected,:);
     %subplot(131);plot([rand(1,length(PropertiesSelected.Onset))],PropertiesSelected.Onset,'.r'); hold on
     %scatter([rand(1,length(PropertiesSelected.End))],PropertiesSelected.End,'.b'); ylim([0,90])
     %subplot(132);boxplot([PropertiesSelected.Onset,PropertiesSelected.End],'Jitter',0.5,'Symbol','.','Whisker',1); ylim([0,90])
     %subplot(133);
%     plot(PropertiesSelected.NormAP,PropertiesSelected.Onset,'.b'); hold on
 %    plot(PropertiesSelected.NormAP,PropertiesSelected.End,'.r');  ylim([0,90])
     OnsetAll{Exp} = [OnsetAll{Exp};PropertiesSelected.Onset];
     EndAll{Exp} =[EndAll{Exp}; PropertiesSelected.End];
     APAll{Exp} = [APAll{Exp};PropertiesSelected.NormAP];
     RepAll{Exp} = [RepAll{Exp};repmat(i,length([PropertiesSelected.Onset]),1)];
end    

end

OnsetAll = Cell2Mat(OnsetAll);
EndAll = Cell2Mat(EndAll);
RepAll = Cell2Mat(RepAll);
% OnsetAll(abs(APAll) > Width*XYRes./4) = [];
% EndAll(abs(APAll) > Width*XYRes./4) = [];
% RepAll(abs(APAll) > Width*XYRes./4) = [];
% APAll(abs(APAll) > Width*XYRes./4) = [];

%
Fig = figure('PaperUnits','inches','PaperSize',[2.5 3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',8)
     set(0, 'DefaultFigureRenderer', 'painters');
     
CatX = repmat([1:1:length(Nicknames)],length(OnsetAll),1);
CMAP = parula(MaxCol+1);
BarW = 0.4;
Jitter = 0.6;
%CatX = APAll;
% ON times
Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;BarW./2];
patch([Cat;flip(Cat)],[repmat(quantile(OnsetAll,0.25),2,1);repmat(quantile(OnsetAll,0.75),2,1)],[0,189,194]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, OnsetAll(:), RepAll(:),CMAP,'.',4); hold on
plot(Cat,repmat(nanmean(OnsetAll),2,1),'-','DisplayName','mean','Color',[0,189,194,255]./255)
plot(Cat,repmat(quantile(OnsetAll,0.25),2,1),'-','DisplayName','Q1','Color',[0,189,194,150]./255)
plot(Cat,repmat(quantile(OnsetAll,0.75),2,1),'-','DisplayName','Q3','Color',[0,189,194,150]./255)

% OFF times
%patch([Cat;flip(Cat)],[repmat(quantile(EndAll,0.25),2,1);repmat(quantile(EndAll,0.75),2,1)],[245,118,109]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
%gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, EndAll(:), RepAll(:),[245,118,109]./255); hold on
%plot(Cat,repmat(nanmean(EndAll),2,1),'-','DisplayName','mean','Color',[245,118,109]./255)
%plot(Cat,repmat(quantile(EndAll,0.25),2,1),'-','DisplayName','Q1','Color',[245,118,109,150]./255)
%plot(Cat,repmat(quantile(EndAll,0.75),2,1),'-','DisplayName','Q3','Color',[245,118,109,150]./255)

legend off
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
set(findobj(gca, 'type', 'line'), 'linew',1)
set(gca,'FontSize',6)
%title(ExpLabels{Exp}); box off; 
ylim([0,60]);
ylabel('onset (min)')
set(get(gca, 'YLabel'), 'Units', 'Normalized','Position', [0.05,1.05,0],'Rotation',0,'FontSize',6);
%xlabel('relative AP position (um)')

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_ONOFF_',Selection,'_',cell2mat(join(ExpLabels,'_vs_')),'.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');
%%
%% total time ON

Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$',}
ExpLabels = {'m5m8 WT', 'm5m8Dtwi WT','m5m8Ddl WT','m5m8 eveNICD','m5m8Dtwi eveNICD','m5m8Ddl eveNICD',};

Selection = 'MSE';

Exp = 1

Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
    
MaxRow = length(Nicknames);

OnsetAll = cell(1,MaxRow);
EndAll = cell(1,MaxRow);
APAll = cell(1,MaxRow);
RepAll = cell(1,MaxRow);


MaxCol = 1;

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
     MaxCol = max(MaxCol,length(Index));
    
for i = [1:length(Index)]
        Parameters = info(Index(i),:);
        Table2Vars(Parameters);
        Flip = str2double(strsplit(Flip,','));
        PathToSave = [Path,File,Name,File]; 
        %load([PathToSave, '_Stats.mat']);
        minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
        %boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        Im = Merged_meanF_maxGFP(:,:,F)./255;
        %ImLab = boundariesL(:,:,F);
        Width = size(Im,2); Height = size(Im,1);
        load([PathToSave,'_Data.mat']);
        Struct2Vars(Data);
      %
        OnOff = CleanOnOff(OnOff,5);
        TotalOn = nansum(OnOff(SplitEarly*60/TimeRes:end,:),1).*TimeRes/60; %total on time from SplitEarly
    
    Properties.NormAP = (Properties.AP_position - Width./2).*XYRes;

    Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 5];
    if strcmp(Selection,'') == 0
            Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & TotalOn' > 5 & Properties.Region == Selection];

    end
     PropertiesSelected = Properties (Selected,:);
     %subplot(131);plot([rand(1,length(PropertiesSelected.Onset))],PropertiesSelected.Onset,'.r'); hold on
     %scatter([rand(1,length(PropertiesSelected.End))],PropertiesSelected.End,'.b'); ylim([0,90])
     %subplot(132);boxplot([PropertiesSelected.Onset,PropertiesSelected.End],'Jitter',0.5,'Symbol','.','Whisker',1); ylim([0,90])
     %subplot(133);
%     plot(PropertiesSelected.NormAP,PropertiesSelected.Onset,'.b'); hold on
 %    plot(PropertiesSelected.NormAP,PropertiesSelected.End,'.r');  ylim([0,90])
     %OnsetAll{Exp} = [OnsetAll{Exp};PropertiesSelected.TimeOn];
     OnsetAll{Exp} = [OnsetAll{Exp};TotalOn(Selected)'];
     EndAll{Exp} =[EndAll{Exp}; PropertiesSelected.End];
     APAll{Exp} = [APAll{Exp};PropertiesSelected.NormAP];
     RepAll{Exp} = [RepAll{Exp};repmat(i,length([TotalOn(Selected)']),1)];
end    

end

OnsetAll = Cell2Mat(OnsetAll);
EndAll = Cell2Mat(EndAll);
RepAll = Cell2Mat(RepAll);
% OnsetAll(abs(APAll) > Width*XYRes./4) = [];
% EndAll(abs(APAll) > Width*XYRes./4) = [];
% RepAll(abs(APAll) > Width*XYRes./4) = [];
% APAll(abs(APAll) > Width*XYRes./4) = [];

%
Fig = figure('PaperUnits','inches','PaperSize',[2.5 3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',8)
     set(0, 'DefaultFigureRenderer', 'painters');
     
CatX = repmat([1:1:length(Nicknames)],length(OnsetAll),1);
CMAP = parula(MaxCol+1);
BarW = 0.4;
Jitter = 0.6;
%CatX = APAll;
% ON times
Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;BarW./2];
patch([Cat;flip(Cat)],[repmat(quantile(OnsetAll,0.25),2,1);repmat(quantile(OnsetAll,0.75),2,1)],[0,189,194]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, OnsetAll(:), RepAll(:),CMAP,'.',4); hold on
plot(Cat,repmat(nanmean(OnsetAll),2,1),'-','DisplayName','mean','Color',[0,189,194,255]./255)
plot(Cat,repmat(quantile(OnsetAll,0.25),2,1),'-','DisplayName','Q1','Color',[0,189,194,150]./255)
plot(Cat,repmat(quantile(OnsetAll,0.75),2,1),'-','DisplayName','Q3','Color',[0,189,194,150]./255)

% OFF times
%patch([Cat;flip(Cat)],[repmat(quantile(EndAll,0.25),2,1);repmat(quantile(EndAll,0.75),2,1)],[245,118,109]./255,'EdgeColor','none','FaceAlpha',0.3); hold on
%gscatter(CatX(:)+(rand(length(CatX(:)),1)-0.5).*Jitter, EndAll(:), RepAll(:),[245,118,109]./255); hold on
%plot(Cat,repmat(nanmean(EndAll),2,1),'-','DisplayName','mean','Color',[245,118,109]./255)
%plot(Cat,repmat(quantile(EndAll,0.25),2,1),'-','DisplayName','Q1','Color',[245,118,109,150]./255)
%plot(Cat,repmat(quantile(EndAll,0.75),2,1),'-','DisplayName','Q3','Color',[245,118,109,150]./255)

legend off
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
set(findobj(gca, 'type', 'line'), 'linew',1)
set(gca,'FontSize',6)
%title(ExpLabels{Exp}); box off; 
ylim([0,60]);
ylabel('total time ON  (min)')
set(get(gca, 'YLabel'), 'Units', 'Normalized','Position', [0.05,1.05,0],'Rotation',0,'FontSize',6);
%xlabel('relative AP position (um)')

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_timeON_',Selection,'_',cell2mat(join(ExpLabels,'_vs_')),'.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');
