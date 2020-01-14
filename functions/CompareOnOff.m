%%
close all


Nicknames = {'^m5m8pevez$','m5m8peve Ez:TTG','m5m8peve TTG, mEz'}
ExpLabels = {'WT','Ez:TTG','TTG, mEz'};
%Selection = 'ME';
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
        Data = load([PathToSave,'_Data.mat']);
        Struct2Vars(Data.Data);
      %
        OnOff = CleanOnOff(OnOff,5);
        OnOffTimeOff = OnOff(max(1,15*60/TimeRes+nc14-Delay):25*60/TimeRes+nc14-Delay,:);
        OnPerFrame = sum(OnOffTimeOff,2);
                
               
                % % cells on
        OnPerFrameAll{Exp} = [OnPerFrameAll{Exp}; [OnPerFrame]];
        
        RepOnPerFrame{Exp} = [RepOnPerFrame{Exp};repmat(i,length([OnPerFrame]),1)];
        

end
end
%
OnPerFrameAll = Cell2Mat(OnPerFrameAll);

RepOnPerFrame = Cell2Mat(RepOnPerFrame);

%%
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
title('# cells ON 15-25'''); box off; ylim([0,30])
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
title('# cells ON 15-25'''); box off; ylim([0,30]); xlim([0+Jitter,length(Nicknames)+Jitter]); 



%export_fig FileOut -pdf
%saveas(Fig,FileOut,'pdf')
print(Fig,FileOut,'-fillpage','-dpdf');
%print(Fig,FileOut,'-dtiff');

%%
Nicknames = {'^m5m8peve$','^simMSEpeve$','^m5m8pevez$','^m5m8pevez \+$','^simMSEpevez \+$'}
ExpLabels = {'m5m8-peve', 'simMSE-peve','m5m8-pevez','m5m8-peve +', 'simMSE-peve +',};
Exp = 1
Selection = '';
Jitter = 0.5;

OnsetAll = [];
EndAll = [];
APAll = [];
RepAll = [];

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
        Data = load([PathToSave,'_Data.mat']);
        Struct2Vars(Data.Data);
      %
        OnOff = CleanOnOff(OnOff,5);
    
    Properties.NormAP = (Properties.AP_position - Width./2).*XYRes;

    Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & Properties.TimeOn > 10];
    if strcmp(Selection,'') == 0
            Selected = [(Properties.Type=='ShortMidline'|Properties.Type=='LongMidline') & Properties.TimeOn > 5 & Properties.Region == Selection];

    end
     PropertiesSelected = Properties (Selected,:);
     %subplot(131);plot([rand(1,length(PropertiesSelected.Onset))],PropertiesSelected.Onset,'.r'); hold on
     %scatter([rand(1,length(PropertiesSelected.End))],PropertiesSelected.End,'.b'); ylim([0,90])
     %subplot(132);boxplot([PropertiesSelected.Onset,PropertiesSelected.End],'Jitter',0.5,'Symbol','.','Whisker',1); ylim([0,90])
     %subplot(133);
%     plot(PropertiesSelected.NormAP,PropertiesSelected.Onset,'.b'); hold on
 %    plot(PropertiesSelected.NormAP,PropertiesSelected.End,'.r');  ylim([0,90])
     OnsetAll = [OnsetAll;PropertiesSelected.Onset];
     EndAll =[EndAll; PropertiesSelected.End];
     APAll = [APAll;PropertiesSelected.NormAP];
     RepAll = [RepAll;repmat(i,length([PropertiesSelected.Onset]),1)];
end    

OnsetAll(abs(APAll) > Width*XYRes./4) = [];
EndAll(abs(APAll) > Width*XYRes./4) = [];
RepAll(abs(APAll) > Width*XYRes./4) = [];
APAll(abs(APAll) > Width*XYRes./4) = [];

%
    Fig = figure('PaperSize',[20 30],'PaperUnits','inches','resize','on', 'visible','off');
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
