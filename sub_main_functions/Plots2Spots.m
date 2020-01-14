%% manual ONOFF
clear all
%MetaFile = ' other';
%MetaFile = ' ecNICD';

%Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%Palette = [255,120,120;096,085,176;95,181,241;80,159,115]./255; Palette = Palette(2:4,:);

PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %pruple1, purple2. 13:14
    205,55,0]./255; %red. 15


Input{1}.Nicknames = {'^m5m8pevezx2$','^simMSEpevezx2$'}
Input{1}.ExpLabels = {'m5m8-peve', 'sim-peve'};
Input{1}.Palette = PaletteMain([3,6],:);
Input{1}.MetaFile = ' other';

Input{2}.Nicknames = {'^m5m8pevezx2$','^simMSEpevezx2$','^m5m8peve\+simMSEpevez$'}
Input{2}.ExpLabels = {'m5m8-peve', 'sim-peve','m5m8+sim'};
Input{2}.Palette = PaletteMain([1,2,15],:);
Input{2}.MetaFile = ' other';


Input{3}.Nicknames = {'^m5m8pevex2.? eveNICD'}
Input{3}.ExpLabels = {'MSE','NE','DE'};
Input{3}.Palette = [096,085,176;95,181,241;80,159,115]./255;
Input{3}.MetaFile = ' ecNICD';


Input{4}.Nicknames = {'^m5m8pevezx2$','^simMSEpevezx2$','^m5m8peve\+simMSEpevez$','^m8NEpevex2$'}
Input{4}.ExpLabels = {'m5m8-peve', 'sim-peve','m5m8+sim','m8NE'};
Input{4}.Palette = PaletteMain([3,6,15,13],:);
Input{4}.MetaFile = ' other';

Input{5}.Nicknames = {'^m5m8peve\+simMSEpevez$','^m8NEpevex2$'}
Input{5}.ExpLabels = {'m5m8+sim','m8NE'};
Input{5}.Palette = PaletteMain([15,13],:);
Input{5}.MetaFile = ' other';

Input{6}.Nicknames = {'^m5m8pevezx2$','^m5m8Dtwidlpevex2$'}
Input{6}.ExpLabels = {'m5m8','m5m8Dtwidl'};
Input{6}.Palette = PaletteMain([1,3],:);
Input{6}.MetaFile = ' other';

Input{7}.Nicknames = {'^m5m8pevezx2$','^m5m8Dtwidlpevex2$','^m8NEpevex2$'}
Input{7}.ExpLabels = {'m5m8','m5m8Dtwidl','m8NE'};
Input{7}.Palette = PaletteMain([1,3,13],:);
Input{7}.MetaFile = ' other';

for e = [4]
    clearvars('-except','Input','e'); 
MetaFile = Input{e}.MetaFile;
Nicknames = Input{e}.Nicknames;
ExpLabels = Input{e}.ExpLabels;
Palette = Input{e}.Palette

Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

set(0,'defaultAxesColorOrder',Palette)



OnsetAll = cell(1,length(Nicknames));
EndAll = cell(1,length(Nicknames));
RepOnsetAll = cell(1,length(Nicknames));

for Exp = 1:length(Nicknames)

    Index = find(cellfun(@(x) ~isempty(x),regexp(Info.Nickname, Nicknames{Exp},'match')))
    %Index = [20,21]
    %Index = [23:26]
    SpotIntensities = [];
    All = [];
    Merged1 = [];
    Merged2 = [];
    PropertiesMerged1 = table();
    PropertiesMerged2 = table();
    TimeScaleMerged = [];
    AllRegions = [];
    for x = Index'
        try
        Parameters = Info(x,:);
        Table2Vars(Parameters);
        Table = readtable([Path,File,'_manualONOFF.txt'],'ReadVariableNames',false,'Delimiter','\t');   
        PathToSave = [Path,File,Name,File]; 
        minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        
        
        Mat = table2array(Table(:,1:4));
        Mat(Mat==0) = NaN;
        Mat = (Mat-nc14+Delay).*TimeRes./60;
        All = [All,Mat'];
        try 
            Regions = Table(:,5);
        catch
            Regions = table(repmat('MSE',height(Table(:,1)),1));
        end
        AllRegions = [AllRegions;Regions]
        
        try
        load([PathToSave,'_Data.mat']);
        Struct2Vars(Data);
        SelectedLabels = [table2array(readtable([PathToSave,'_selectedx2.txt'],'Delimiter',','))]'
        Selected = arrayfun(@(x) ismember(x,SelectedLabels),Properties.Label);
        SplitEarlyF = max([SplitEarly*60./TimeRes+nc14-Delay,1]);
        Spots1 = MaxFGauss(SplitEarlyF:end,Selected); 
        Spots2 = MaxFGauss2(SplitEarlyF:end,Selected);  
        
       Properties.NormAP = (Properties.AP_position-min(Properties.AP_position))./max(Properties.AP_position);

       [Merged1,PropertiesMerged1,TimeScaleMerged] = MergeFMatrix(Spots1,Merged1,Properties(Selected,:),PropertiesMerged1,TimeScale,TimeScaleMerged,TimeRes);
       [Merged2,PropertiesMerged2,TimeScaleMerged] = MergeFMatrix(Spots2,Merged2,Properties(Selected,:),PropertiesMerged2,TimeScale,TimeScaleMerged,TimeRes);

       Spots1 = Spots1(:);
        Spots2 = Spots2(:);
        SpotIntensities = [SpotIntensities;[Spots1,Spots2]];

        end
        
        MaxFManual = [];
        try
            Files = dir([Path,File,Name,'/*.xls']); Files = {Files.name};
            for n = 1:length(Files); 
                FileName = [Path,File,Name,Files{n}]; 
                Table = readtable(FileName,'ReadRowNames',true,'FileType','text')
                Times = Table.Slice;
                Max = Table.Max;
                NewTrace = nan(size(TimeScale));
                NewTrace(Times) = Max.*2.^(Bits-8);
                MaxFManual(:,n) = NewTrace;
            end
            %Norm = (MaxFManual-Baseline').*Baseline(1)./Baseline';
            OnOff = ~isnan(MaxFManual);
            MedFilt = medfilt1(MaxFManual,3,[],1,'includenan','zeropad');
            Selected = [1:size(Norm,2)]; minOn = 5; SplitEarlyF = SplitEarly*60./TimeRes + nc14 - Delay;
            Limits = [0,90];
            [BurstNum,BurstLength,BurstPeriod,BurstPeak,BurstMax,OffTimeAll,BurstSize] = CountBursts(Norm,OnOff, Selected,minOn,SplitEarlyF,TimeRes);
             PlotSelected(Selected, TimeScale,Baseline,MaxFManual,MedFilt,OnOff,Properties,BurstPeak,TimeRes,Bits,nc14, Delay,Limits,[PathToSave,'selected_manualtrack.ps']);
%            
        end
        end
    end
    Rand = logical(round(rand(1,size(All,2))));
    NewAll = All;
    NewAll(1,Rand) = All(2,Rand);
    NewAll(2,Rand) = All(1,Rand);
    Rand = logical(round(rand(1,size(All,2))));
    NewAll(3,Rand) = All(4,Rand);
    NewAll(4,Rand) = All(3,Rand);
%     Sub = NewAll(1:2,:);
%     Sub(Sub > 50) = NaN;
%     NewAll(1:2,:) = Sub;
    All = NewAll;
    AllONOFF{Exp} = All;
    OnsetAll{Exp} = [All(1,:),All(2,:)];
    EndsAll{Exp} = [All(3,:),All(4,:)];
    RepOnset{Exp} = ones(length(EndsAll{Exp}),1);
    AllOnmixed{Exp} = [All(1,:),All(2,:)];
    AllOffmixed{Exp} = [All(3,:),All(4,:)];
    SpotIntensitiesAll{Exp} = SpotIntensities;
    Gauss1Merged{Exp} = Merged1;
    Gauss2Merged{Exp} = Merged2;
    AllProperties{Exp} = PropertiesMerged1;
    end

OnsetAll = Cell2Mat(OnsetAll);
EndAll = Cell2Mat(EndAll);
RepOnsetAll = Cell2Mat(RepOnsetAll);


%% instrinsic/extrinsic noise from manual ONOFF
for Exp = 1:length(Nicknames)
    if strcmp(MetaFile,' ecNICD') == 1
        All = AllONOFF{1}; 
        All = All(:, cellfun(@(x) ~isempty(x),regexp(table2cell(AllRegions), ExpLabels{Exp},'match')) )% TAKE ONLY SELECTED REGION
    else
        All = AllONOFF{Exp}
    end
    % to calculate intrinsic and extrinsic use only nuclei with 2 ons or 2
    % offs. ie. dont count nuclei that switch on only 1 spot for variance
    % (wouldnt be counted anyways for covariance but might increase
    % extrinsic noise)
    On2 = find(~isnan((All(1,:)).*(All(2,:))));
    Off2 = find(~isnan((All(3,:)).*(All(4,:))));
    VarOn = nanvar([All(1,On2),All(2,On2)])
    VarOff = nanvar([All(3,Off2),All(4,Off2)])
    %VarOn = mean([nanvar(All(1,:)),nanvar(All(2,:))])
    %VarOff = mean([nanvar(All(3,:)),nanvar(All(4,:))])
    %VarOn = nanvar(nanmean([All(1,:);All(2,:)]))
    %VarOff = nanvar(nanmean([All(3,:);All(4,:)]))
    CoVarOn = nanmean((nanmean(All(1,On2)) - All(1,On2)) .* (nanmean(All(2,On2)) -  All(2,On2)))
    CoVarOff = nanmean((nanmean(All(3,Off2)) - All(3,Off2)) .* (nanmean(All(4,Off2)) -  All(4,Off2)))

    %IntNoiseOn = nanmean((nanmean(All(1,:)) - All(1,:) - nanmean(All(2,:)) + All(2,:)).^2)/2
    %IntNoiseOff = nanmean((nanmean(All(3,:)) - All(3,:) - nanmean(All(4,:)) + All(4,:)).^2)/2

    IntNoiseOn2 = VarOn - CoVarOn
    IntNoiseOff2 = VarOff - CoVarOff
    % contribution from intrinsic noise and signaling to total variability
    ContNoiseOn = IntNoiseOn2 ./ VarOn
    ContNoiseOff = IntNoiseOff2 ./ VarOff
    ContSigOn(Exp) = 1 - IntNoiseOn2 ./ VarOn
    ContSigOff(Exp) = 1 - IntNoiseOff2 ./ VarOff
    AmountIntOn(Exp) = IntNoiseOn2;
    AmountIntOff(Exp) = IntNoiseOff2;
     AmountExtOn(Exp) = CoVarOn;
    AmountExtOff(Exp) = CoVarOff;
    % percentage of cells that have either two non nans in onset or two non
    % nans in ends
    Perc2S(Exp) = length(find(~isnan(All(1,:).*All(2,:)) | ~isnan(All(3,:).*All(4,:))))./length(All(1,:));
        NEach(Exp) = length(All(1,:));

end
%%
% %% instrinsic/extrinsic noise IN DIFFERENT REGIONS
% if strcmp(MetaFile,' ecNICD') == 1
% for Exp = [1:3]
%     ExpLabels = {'MSE','NE','DE'};
%     All = AllONOFF{1}; 
%     All = All(:, cellfun(@(x) ~isempty(x),regexp(table2cell(AllRegions), ExpLabels{Exp},'match')) )% TAKE ONLY SELECTED REGION
%     VarOn = nanvar([All(1,:),All(2,:)])
%     VarOff = nanvar([All(3,:),All(4,:)])
%     %VarOn = mean([nanvar(All(1,:)),nanvar(All(2,:))])
%     %VarOff = mean([nanvar(All(3,:)),nanvar(All(4,:))])
%     %VarOn = nanvar(nanmean([All(1,:);All(2,:)]))
%     %VarOff = nanvar(nanmean([All(3,:);All(4,:)]))
%     CoVarOn = nanmean((nanmean(All(1,:)) - All(1,:)) .* (nanmean(All(2,:)) -  All(2,:)))
%     CoVarOff = nanmean((nanmean(All(3,:)) - All(3,:)) .* (nanmean(All(4,:)) -  All(4,:)))
% 
%     IntNoiseOn = nanmean((nanmean(All(1,:)) - All(1,:) - nanmean(All(2,:)) + All(2,:)).^2)/2
%     IntNoiseOff = nanmean((nanmean(All(3,:)) - All(3,:) - nanmean(All(4,:)) + All(4,:)).^2)/2
% 
%     IntNoiseOn2 = VarOn - CoVarOn
%     IntNoiseOff2 = VarOff - CoVarOff
%     % contribution from intrinsic noise and signaling to total variability
%     ContNoiseOn = IntNoiseOn2 ./ VarOn
%     ContNoiseOff = IntNoiseOff2 ./ VarOff
%     ContSigOn(Exp) = 1 - IntNoiseOn2 ./ VarOn
%     ContSigOff(Exp) = 1 - IntNoiseOff2 ./ VarOff
%     AmountIntOn(Exp) = IntNoiseOn2;
%     AmountIntOff(Exp) = IntNoiseOff2;
%      AmountExtOn(Exp) = CoVarOn;
%     AmountExtOff(Exp) = CoVarOff;
% % percentage of cells that have either two non nans in onset or two non
%     % nans in ends
%     Perc2S(Exp) = length(find(~isnan(All(1,:).*All(2,:)) | ~isnan(All(3,:).*All(4,:))))./length(All(1,:));
%     NEach(Exp) = length(All(1,:));
% end
% end
%% BAR plot amounts intrinsic and extrinsic and percentage each

FileName = ['2spots/comp_x2', char(join(ExpLabels,'_vs_'))]
%FileName = 'eveNICD'



% both extrinsic an intrinsic in the same plot
Fig = figure('PaperUnits','inches','PaperSize',[6,4],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
Bar = bar([AmountIntOn;AmountExtOn;AmountIntOff;AmountExtOff],'grouped')
for i = 1:numel(Bar);XPos(i,:) = Bar(i).XData + Bar(i).XOffset; end
text(XPos(:), [AmountIntOn,AmountExtOn,AmountIntOff,AmountExtOff], cellstr(string(round([AmountIntOn,AmountExtOn,AmountIntOff,AmountExtOff],2))), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',6)
    set(gca,'FontSize',6)
    legend(ExpLabels,'Location','northwest')
    ylabel('variability (min^2)')
    xticklabels({'intrinsic','extrinsic','intrinsic','extrinsic'})
    box off
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_intext_manual.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');
clear Bar
clear XPos

% percentage extrinsic and intrinsic with shading
Fig = figure('PaperUnits','inches','PaperSize',[6,4],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
bar([ContSigOn;ContSigOn].*0+1,'FaceAlpha',0.5); hold on
Bar = bar([1-ContSigOn;1-ContSigOff]);
pause(0.001)%need for right XPos values
for i = 1:numel(Bar);XPos(i,:) = Bar(i).XData + Bar(i).XOffset; end
text(XPos(:), [1-ContSigOn,1-ContSigOff]-0.05, cellstr(strcat(string(round([1-ContSigOn,1-ContSigOff]*100,1))',"%")), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',6)
    legend(ExpLabels,'Location','bestoutside')
ylabel('% total variability')
    xticklabels({'onset','end'})
    set(gca,'FontSize',6)
    box off
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_noise_manual.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');
clear Bar
clear XPos

% PROPORTION CELLS WITH ONE AND TWO SPOTS
Fig = figure('PaperUnits','inches','PaperSize',[6,4],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
if size(Perc2S,1) == 1; Perc2S = [Perc2S;Perc2S]; NEach = [NEach;NEach]; end
bar(ones(size(Perc2S)),'FaceAlpha',0.5); hold on
Bar = bar([Perc2S]);
pause(0.0001)%need for right XPos values
for i = 1:numel(Bar);XPos(i,:) = Bar(i).XData + Bar(i).XOffset; end
Perc2S = Perc2S'; NEach = NEach';
text(XPos(:), Perc2S(:)-0.05, cellstr(strcat(string(round(Perc2S(:)*100,1))',"%")), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',6)
    legend(ExpLabels,'Location','bestoutside')
text(XPos(:), Perc2S(:)*0, cellstr(string(NEach)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom','FontSize',6)
    legend(ExpLabels,'Location','bestoutside')
ylabel('% cells')
    %xticklabels(Nicknames)
    set(gca,'FontSize',6)
    box off
    clear Bar
clear XPos
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_1_vs_2_spots.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');

close all

%% DISTRIBUTIONS DIFF TIMES ONSET AND END
Fig = figure('PaperUnits','inches','PaperSize',[12,6],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',4)
    set(gcf,'defaultLegendAutoUpdate','off')

    %Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    %Palette = [255,120,120;096,085,176;95,181,241;80,159,115]./255;

for Exp = 1:length(ExpLabels)
    if strcmp(MetaFile,' ecNICD') == 1
        All = AllONOFF{1}; 
        All = All(:, cellfun(@(x) ~isempty(x),regexp(table2cell(AllRegions), ExpLabels{Exp},'match')) )% TAKE ONLY SELECTED REGION
    else
        All = AllONOFF{Exp}
    end
    
    DiffOn = abs(All(1,:)-All(2,:)); DiffOn(isnan(DiffOn)) = [];
    DiffOff = abs(All(3,:)-All(4,:)); DiffOff(isnan(DiffOff)) = [];
    Random = randperm(size(All,2));
    AllShuffled = All;
    AllShuffled(2,:) = AllShuffled(2,Random);
    AllShuffled(4,:) = AllShuffled(4,Random);
    DiffOnRandom = abs(AllShuffled(1,:)-AllShuffled(2,:)); DiffOnRandom(isnan(DiffOnRandom)) = [];
    DiffOffRandom = abs(AllShuffled(3,:)-AllShuffled(4,:)); DiffOffRandom(isnan(DiffOffRandom)) = [];

    subplot(2,length(ExpLabels),Exp);
    histogram(DiffOn,'BinWidth',1,'Normalization','probability','FaceColor',Palette(Exp,:),'DisplayName',ExpLabels{Exp},'FaceAlpha',0.4);hold on
    histogram(DiffOnRandom,'BinWidth',1,'Normalization','probability','FaceColor',[0.7,0.7,0.7],'DisplayName',[ExpLabels{Exp},' random'],'FaceAlpha',0.5);hold on
    lgn = legend('boxoff')
    lgn.FontSize = 8;
    plot([5,5],[0,0.5],'--','Color',Palette(Exp,:))
    text(2,0.45,[num2str(round(length(find(DiffOn < 5))./length(DiffOn)*100,1)),'%'],'FontSize',8)
    xlim([0,20]); ylim([0,0.5])
    xlabel('time (min)')
    ylabel('% cells')
    set(get(gca, 'XLabel'), 'Units', 'Normalized','Position', [0.9,-0.1,0],'Rotation',0);
    set(get(gca, 'YLabel'), 'Units', 'Normalized','Position', [0,1.05,0],'Rotation',0);
    set(gca,'FontSize',8)
    box off
    
    subplot(2,length(ExpLabels),Exp+length(ExpLabels));
    histogram(DiffOff,'BinWidth',1,'Normalization','probability','FaceColor',Palette(Exp,:),'DisplayName',ExpLabels{Exp},'FaceAlpha',0.4);hold on
    histogram(DiffOffRandom,'BinWidth',1,'Normalization','probability','FaceColor',[0.7,0.7,0.7],'DisplayName',[ExpLabels{Exp}, 'random'],'FaceAlpha',0.5   );hold on
    lgn = legend('boxoff')
    lgn.FontSize = 8;
        plot([5,5],[0,0.5],'--','Color',Palette(Exp,:))
            text(2,0.45,[num2str(round(length(find(DiffOff < 5))./length(DiffOff)*100,1)),'%'],'FontSize',8)

    xlim([0,20]);ylim([0,0.5])
    legend boxoff
    xlabel('time (min)')
        ylabel('% cells')
    set(get(gca, 'XLabel'), 'Units', 'Normalized','Position', [0.9,-0.1,0],'Rotation',0);
    set(get(gca, 'YLabel'), 'Units', 'Normalized','Position', [0,1.05,0],'Rotation',0);
    set(gca,'FontSize',8)
    box off
    

end
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_noise_hist_manual.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');
%% SCATTER ONSET AND ENDS
Fig = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',10)
     set(0, 'DefaultFigureRenderer', 'painters'); 
     set(0,'defaulttextinterpreter', 'tex')
    %Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%Palette = [130,130,130;80,80,80;205,55,0]./255;

for Exp = 1:length(Nicknames)
    if strcmp(MetaFile,' ecNICD') == 1
        All = AllONOFF{1}; 
        All = All(:, cellfun(@(x) ~isempty(x),regexp(table2cell(AllRegions), ExpLabels{Exp},'match')) )% TAKE ONLY SELECTED REGION
    else
        All = AllONOFF{Exp}
    end
    plot([All(1,:);All(3,:)],[All(2,:);All(4,:)],':','Color',[0.8,0.8,0.8]); hold on
    plot(All(1,:), All(2,:),'*','Color',Palette(Exp,:),'MarkerSize',2,'LineWidth',0.5); hold on
    plot(All(3,:), All(4,:),'o','Color',Palette(Exp,:),'MarkerSize',2,'LineWidth',0.5); axis equal
    xlim([20,80])
    ylim([20,80])
    box off; xlabel('time (min) Allele 1')
    ylabel('time (min) Allele 2')
    set(gca,'FontSize',6)
end
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_ONOFF_x2_manual.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');

% %% SCATTER ONSET AND ENDS DIFFERENT REGIONS
% if strcmp(MetaFile,' ecNICD') == 1
% Fig = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
% set(0,'defaultAxesFontSize',10)
%      set(0, 'DefaultFigureRenderer', 'painters'); 
%      set(0,'defaulttextinterpreter', 'tex')
%  %   Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
% %Palette = [130,130,130;80,80,80;205,55,0]./255;
%             Palette = [255,120,120;096,085,176;95,181,241;80,159,115]./255; Palette = Palette(2:4,:);
% 
%     ExpLabels = {'MSE','NE','DE'};
% for Exp = 1:length(ExpLabels)
%     All = AllONOFF{1}; 
%     All = All(:, cellfun(@(x) ~isempty(x),regexp(table2cell(AllRegions), ExpLabels{Exp},'match')) )% TAKE ONLY SELECTED REGION
%     %plot([All(1,:);All(3,:)],[All(2,:);All(4,:)],':','Color',[0.8,0.8,0.8]); hold on
%     plot(All(1,:), All(2,:),'*','Color',Palette(Exp,:),'MarkerSize',2,'LineWidth',0.5); hold on
%     %plot(All(3,:), All(4,:),'o','Color',Palette(Exp,:),'MarkerSize',2,'LineWidth',0.5); axis equal
%     xlim([0,70])
%     ylim([0,70])
%     box off; xlabel('time (min) Allele 1')
%     ylabel('time (min) Allele 2')
%     set(gca,'FontSize',6)
% end
% FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_ONOFF_x2_manual.pdf']
% print(Fig,FileOut,'-fillpage','-dpdf');
% end
%% SCATTER ALL INTENSITIES

Fig = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
FigRandom = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);

set(0,'defaultAxesFontSize',10)
     set(0, 'DefaultFigureRenderer', 'painters'); 
     set(0,'defaulttextinterpreter', 'tex')
    %Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%Palette = [130,130,130;80,80,80;205,55,0]./255;

for Exp = 1:length(Nicknames)
    Spots1 = Gauss1Merged{Exp}; Spots1 = Spots1(:);
    Spots2 = Gauss2Merged{Exp};
    Shuffled = Spots2(:,randperm(size(Spots2,2)));
    Spots2 = Spots2(:);
    Shuffled = Shuffled(:);
%     SpotIntensities = SpotIntensitiesAll{Exp};
    SpotIntensities = [Spots1,Spots2];
    %GoodOnes = find(~isnan(SpotIntensities(:,1)) & ~isnan(SpotIntensities(:,2)));
    %SpotIntensities = SpotIntensities(GoodOnes,:);
    %Shuffled = SpotIntensities(randperm(length(SpotIntensities(:,2))),2);
    [R,P] = corrcoef(SpotIntensities(:,1),SpotIntensities(:,2),'Alpha',0.1,'Rows','complete');
    [R(2,1),P(2,1)]
    figure(Fig); scatter(SpotIntensities(:,1), SpotIntensities(:,2),1,'.','MarkerEdgeAlpha',0.3,'DisplayName',[ExpLabels{Exp},'  ',num2str(round(R(2,1),2)),'  ',num2str(P(2,1))]); hold on
    xlim([0,inf])
    ylim([0,inf])
    box off; xlabel('Intensity (AU) Allele 1')
    legend boxoff
    ylabel('Intensity (AU) Allele 2')
    set(gca,'FontSize',6)
    [R,P] = corrcoef(SpotIntensities(:,1),Shuffled,'Alpha',0.1,'Rows','complete');
    [R(2,1),P(2,1)]
    figure(FigRandom); scatter(SpotIntensities(:,1), Shuffled,1,'.','MarkerEdgeAlpha',0.3,'DisplayName',[ExpLabels{Exp},'  ',num2str(round(R(2,1),2)),'  ',num2str(P(2,1))]); hold on
    xlim([0,inf])
    ylim([0,inf])
    box off; xlabel('Intensity (AU) Allele 1')
    ylabel('Intensity (AU) Allele 2 random')
    set(gca,'FontSize',6)
    legend boxoff

    
    

end


FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_Intensity_x2_manual.pdf'];
print(Fig,FileOut,'-fillpage','-dpdf');
FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'_IntensityRandom_x2_manual.pdf'];
print(FigRandom,FileOut,'-fillpage','-dpdf');


%% CORRELATION OVER TIME

%Fig = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
%FigRandom = figure('PaperUnits','inches','PaperSize',[3,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);

set(0,'defaultAxesFontSize',10)
     set(0, 'DefaultFigureRenderer', 'painters'); 
     set(0,'defaulttextinterpreter', 'tex')
    %Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%Palette = [130,130,130;80,80,80;205,55,0]./255;

for Exp = 1:length(Nicknames)
    Spots1 = Gauss1Merged{Exp}; 
    Spots2 = Gauss2Merged{Exp};
    Shuffled = Spots2(:,randperm(size(Spots2,2)));
     
    % random assignment
    Mean = nanmean([Spots1,Spots2],2);
    Var = nanvar([Spots1,Spots2],1,2);
    Mean1 = nanmean(Spots1,2);
    Mean2 = nanmean(Spots2,2);
    CoVar = nanmean([(Spots1-Mean1).*(Spots2-Mean2)],2);
    FF = (Var-CoVar)./Mean;
    FFT = Var./Mean
    
    CoVarShuffled = nanmean([(Spots1-Mean1).*(Shuffled-Mean2)],2);
    FFShuffled = (Var-CoVarShuffled)./Mean;
    FFT = Var./Mean
    
    % closest AP neighbor
    PropertiesMerged = AllProperties{Exp};
    [~, Sorted] = sort(PropertiesMerged.AP_position);
    if (length(Sorted) - floor(length(Sorted)/2)*2) ~= 0
        Sorted = Sorted(2:end)
    end
    Sorted1 = Spots1(:,Sorted);
    Sorted2 = Spots2(:,Sorted);
    Scramble = [1:length(Sorted)]
    SortedClosest = [Scramble(2:2:end);Scramble(1:2:end)];SortedClosest = SortedClosest(:) 
    Sorted2Closest = Spots2(:,SortedClosest);
   
    Mean = nanmean([Sorted1,Sorted2],2);
    VarSorted = nanvar([Sorted1,Sorted2],1,2);
    Mean1 = nanmean(Sorted1,2);
    Mean2 = nanmean(Sorted2,2);
    CoVarSorted = nanmean([(Sorted1-Mean1).*(Sorted2-Mean2)],2);
    FFSorted = (VarSorted-CoVarSorted)./Mean;
    FFTSorted = VarSorted./Mean
    
    CoVarSortedShuffled = nanmean([(Sorted1-Mean1).*(Sorted2Closest-Mean2)],2);
    FFShortedShuffled = (VarSorted-CoVarSortedShuffled)./Mean;
    FFT = VarSorted./Mean
    
    
    % closest onset neighbor
    PropertiesMerged = AllProperties{Exp};
    [~, Sorted] = sort(PropertiesMerged.Onset);
    if (length(Sorted) - floor(length(Sorted)/2)*2) ~= 0
        Sorted = Sorted(2:end)
    end
    Sorted1 = Spots1(:,Sorted);
    Sorted2 = Spots2(:,Sorted);
    Scramble = [1:length(Sorted)]
    SortedClosest = [Scramble(2:2:end);Scramble(1:2:end)];SortedClosest = SortedClosest(:) 
    Sorted2Closest = Spots2(:,SortedClosest);
   
    Mean = nanmean([Sorted1,Sorted2],2);
    VarOnset = nanvar([Sorted1,Sorted2],1,2);
    Mean1 = nanmean(Sorted1,2);
    Mean2 = nanmean(Sorted2,2);
    CoVarOnset = nanmean([(Sorted1-Mean1).*(Sorted2-Mean2)],2);
    FFSorted = (VarOnset-CoVarOnset)./Mean;
    FFTSorted = VarOnset./Mean
    
    CoVarOnsetShuffled = nanmean([(Sorted1-Mean1).*(Sorted2Closest-Mean2)],2);
    FFShortedShuffled = (VarOnset-CoVarOnsetShuffled)./Mean;
    FFT = VarOnset./Mean
    
    Fig = figure('PaperUnits','inches','PaperSize',[15,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);

    figure(Fig); subplot(141); plot(Var,'DisplayName','var'); hold on; plot(CoVar,'DisplayName','covar'); legend boxoff; title('real pairs')
            subplot(142); plot(Var,'DisplayName','var'); hold on; plot(CoVarShuffled,'DisplayName','covar'); legend boxoff; title('random pairs')
            subplot(143); plot(VarSorted,'DisplayName','var'); hold on; plot(CoVarSortedShuffled,'DisplayName','covar'); legend boxoff; title('closest AP pairs')
            subplot(144); plot(VarOnset,'DisplayName','var'); hold on; plot(CoVarOnsetShuffled,'DisplayName','covar'); legend boxoff; title('closest onset pairs')

    
%     %GoodOnes = find(~isnan(SpotIntensities(:,1)) & ~isnan(SpotIntensities(:,2)));
%     %SpotIntensities = SpotIntensities(GoodOnes,:);
%     %Shuffled = SpotIntensities(randperm(length(SpotIntensities(:,2))),2);
%     [R,P] = corrcoef(SpotIntensities(:,1),SpotIntensities(:,2),'Alpha',0.1,'Rows','complete');
%     [R(2,1),P(2,1)]
%     figure(Fig); scatter(SpotIntensities(:,1), SpotIntensities(:,2),1,'.','MarkerEdgeAlpha',0.3,'DisplayName',[ExpLabels{Exp},'  ',num2str(round(R(2,1),2)),'  ',num2str(P(2,1))]); hold on
%     xlim([0,inf])
%     ylim([0,inf])
%     box off; xlabel('Intensity (AU) Allele 1')
%     legend boxoff
%     ylabel('Intensity (AU) Allele 2')
%     set(gca,'FontSize',6)
%     [R,P] = corrcoef(SpotIntensities(:,1),Shuffled,'Alpha',0.1,'Rows','complete');
%     [R(2,1),P(2,1)]
%     figure(FigRandom); scatter(SpotIntensities(:,1), Shuffled,1,'.','MarkerEdgeAlpha',0.3,'DisplayName',[ExpLabels{Exp},'  ',num2str(round(R(2,1),2)),'  ',num2str(P(2,1))]); hold on
%     xlim([0,inf])
%     ylim([0,inf])
%     box off; xlabel('Intensity (AU) Allele 1')
%     ylabel('Intensity (AU) Allele 2 random')
%     set(gca,'FontSize',6)
%     legend boxoff
        FileOut = ['/Users/julia/Google Drive jf565/comp MS2/',FileName,'covariance_pairs_',ExpLabels{Exp},'.pdf'];
      print(Fig,FileOut,'-fillpage','-dpdf');
    
    

end


% FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_Intensity_x2_manual.pdf'];
% print(Fig,FileOut,'-fillpage','-dpdf');
% FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_IntensityRandom_x2_manual.pdf'];
% print(FigRandom,FileOut,'-fillpage','-dpdf');

end

%%
Exp = 1
Selection = '';
Jitter = 0.5;

% OnsetAll = [All(1,:),All(2,:)];
% EndAll = [All(3,:),All(4,:)];
% APAll = (rand(length(OnsetAll),1)-0.5).*Jitter+1,

OnsetAll = Cell2Mat(AllOnmixed);
EndAll = Cell2Mat(AllOffmixed);
%RepAll = ones(size(OnsetAll));


%
Fig = figure('PaperUnits','inches','PaperSize',[2.5,3],'Units','points','resize','off', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',10)
     set(0, 'DefaultFigureRenderer', 'painters');


Palette = [142,183,36;61,131,183;205,55,0;105,139,34;54,100,139;62,81,16;33,63,86]./255;  
Palette = Palette([1:length(Nicknames)],:)

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

FileOut = ['/Users/julia/Google Drive jf565/comp MS2/comp_ONOFF_mixx2_manual.pdf']
print(Fig,FileOut,'-fillpage','-dpdf');



%% ON OFF from spots = 2, with manually selected traces

All = [];
Index = [20,21]

for i = 1:length(Index)
    x = Index(i);
    Parameters = Info(x,:);
            Table2Vars(Parameters);
            Flip = str2double(strsplit(Flip,','));
            PathToSave = [Path,File,Name,File]; 
            %load([PathToSave, '_Stats.mat']);
            minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
            %Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
            %boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);
            %F = max(round(35*60/TimeRes)+nc14-Delay,1);
            %Im = Merged_meanF_maxGFP(:,:,F)./255;
            %Width = size(Im,1); Height = size(Im,2);


    load([PathToSave,'_Data.mat']);
    try
            Struct2Vars(Data.Data);
    catch
        Struct2Vars(Data);
    end
            OnOff1 = double(~isnan(MaxFGauss));
            OnOff2 = double(~isnan(MaxFGauss2));
            %OnOff1 = double(MaxFGauss > 1.2*Baseline');
            %OnOff2 = double(MaxFGauss2 > 1.2*Baseline');

    SplitMSE = max(round(nc14-Delay + SplitEarly*60/TimeRes),1); %frame to split
    Selected = (Properties.Type == 'ShortMidline' | Properties.Type == 'LongMidline') & Properties.TimeOn > 5;
    SelectedLabels = [table2array(readtable([PathToSave,'_selectedx2.txt'],'Delimiter',','))]'
    Selected = arrayfun(@(x) ismember(x,SelectedLabels),Properties.Label)
    %Selected = Properties.Type == 'LateTrack'

    %OnOff1(isnan(MaxFGauss)==1) = NaN;
    %OnOff2(isnan(MaxFGauss2)==1) = NaN;
    OnOff1 = OnOff1(SplitMSE:end,Selected);
    OnOff2 = OnOff2(SplitMSE:end,Selected);
    OnOffString = join(string(double(OnOff1)),'',1);
    OnPeriods = strfind(OnOffString,repmat('1',1,minOn));
    On = nan(length(OnPeriods),1);
    Off = nan(length(OnPeriods),1);
    GoodOnes = cellfun(@(x) ~isempty(x), OnPeriods);
    On(GoodOnes) = cellfun(@(x) x(1), OnPeriods(GoodOnes));
    Off(GoodOnes) = cellfun(@(x) x(end), OnPeriods(GoodOnes))+minOn-1;
    On1 = [(On+SplitMSE-nc14+Delay).*TimeRes./60]'
    Off1 = [(Off+SplitMSE-nc14+Delay).*TimeRes./60]'

    OnOffString = join(string(double(OnOff2)),'',1);
    OnPeriods = strfind(OnOffString,repmat('1',1,minOn));
    On = nan(length(OnPeriods),1);
    Off = nan(length(OnPeriods),1);
    GoodOnes = cellfun(@(x) ~isempty(x), OnPeriods);
    On(GoodOnes) = cellfun(@(x) x(1), OnPeriods(GoodOnes));
    Off(GoodOnes) = cellfun(@(x) x(end), OnPeriods(GoodOnes))+minOn-1;
    On2 = [(On+SplitMSE-nc14+Delay).*TimeRes./60]'
    Off2 = [(Off+SplitMSE-nc14+Delay).*TimeRes./60]'

    All1 = [On1;On2;Off1;Off2]
    All = [All,All1];
    
    
    Selected1 = MaxFGauss(SplitMSE:end,Selected);
    Selected2 = MaxFGauss2(SplitMSE:end,Selected);
    Var_1 = nanmean((nanmean(Selected1,2)-Selected1).^2,2);
    Var_2 = nanmean((nanmean(Selected2,2)-Selected2).^2,2);
    Var_all = nanmean([Var_1,Var_2],2);
    % covariance; extrinsic/correlation noise
    CoVar = [nanmean((nanmean(Selected1,2)-Selected1).*(nanmean(Selected2,2)-Selected2),2)];
    IntNoise = Var_all - CoVar;
    %IntNoise2 = nanmean((((Selected1+Selected2)./2-Selected1) - (nanmean(Selected2,2)-Selected2)).^2,2)/2;
        IntNoise2 = nanmean((((Selected1+Selected2)./2-Selected1) - ((Selected1+Selected2)./2-Selected2)).^2,2)/2;
    %plot([IntNoise,IntNoise2,Var_all,CoVar])
    plot([Var_all,CoVar])
    plot(nanmean((Selected1-Selected2).^2,2))

    
     Selected1 = MaxFGauss(SplitMSE:end,Selected);
    Selected2 = MaxFGauss2(SplitMSE:end,Selected);
    Var_1 = nanmean((Selected1+Selected2)./2-Selected1.^2,2);
    Var_2 = nanmean((Selected1+Selected2)./2-Selected2.^2,2);
    Var_all = nanmean([Var_1,Var_2],2);
    % covariance; extrinsic/correlation noise
    CoVar = [nanmean((Selected1-(Selected1+Selected2)./2).*(Selected2-(Selected1+Selected2)./2),2)];
    IntNoise = Var_all - CoVar;
    %IntNoise2 = nanmean((((Selected1+Selected2)./2-Selected1) - (nanmean(Selected2,2)-Selected2)).^2,2)/2;
        IntNoise2 = nanmean((((Selected1+Selected2)./2-Selected1) - ((Selected1+Selected2)./2-Selected2)).^2,2)/2;
    %plot([IntNoise,IntNoise2,Var_all,CoVar])
    plot([Var_all,CoVar])
    plot(nanmean((Selected1-Selected2).^2,2))

end
%%
 
%%

AP = nanmean(CentX,1);
Properties1 = table(Properties.Label, AP','VariableNames',{'Label','AP_position'});
SplitMSE = max(round(nc14-Delay + SplitEarly*60/TimeRes),1); %frame to split
OnOffString = join(string(double(OnOff1(SplitMSE:end,:))),'',1);
OnPeriods = strfind(OnOffString,repmat('1',1,minOn));
Midline = cellfun(@(x) ~isempty(x), OnPeriods);
On = cellfun(@(x) x(1), OnPeriods(Midline));
Off = cellfun(@(x) x(end), OnPeriods(Midline))+minOn-1;
Properties1.Onset = nan(size(Properties1.Label)); 
Properties1.End = nan(size(Properties1.Label));
Properties1.TimeOn = nan(size(Properties1.Label));
Properties1.Onset(Midline) = [On.*TimeRes./60]'+ SplitEarly;
Properties1.End(Midline) =[Off.*TimeRes./60]' + SplitEarly;
Properties1.TimeOn = Properties1.End - Properties1.Onset;