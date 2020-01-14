clear all
MetaFile = ' margherita';
MetaFile = ' mutBG';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter', '\t');

PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15


PairstoSelect = {
        {'^m5m8peve$','^m5m8peve wRi$','^m5m8peve aTubG4$'},...
        {'^m5m8peve wRi$','^m5m8peve HRi$','^m5m8peve GroRi$','^m5m8peve EzRi$'},...
        {'^m5m8peve wRi$','^m5m8peve med7Ri$','^m5m8peve skdRi$'},...
        {'^m5m8peve wRi$','^m5m8peve zldRi$','^m5m8peve grhRi$'},...
        {'^m5m8peve wRi$','^m5m8peve nejRi$','^m5m8peve trrRi$','^m5m8peve TrlRi$'}
        }
    
Nicknames = {
    {'+','aTubG4 > wRi', 'aTubG4 > +'},...
    {'wRi','HRi', 'GroRi','E(z)Ri'},...
    {'wRi','med7Ri', 'skdRi'},...
    {'wRi','zldRi', 'grhRi'},...
    {'wRi','nejRi', 'trrRi','TrlRi'}
        }
PaletteEach = {[1,2,3],[1,7,12,11],[1,9,13],[1,15,13],[1,15,14,9]}

n = 5

SelectedN = PairstoSelect{n}
SelectedNames = Nicknames{n}
Palette = PaletteMain(PaletteEach{n},:);


% Plotting # ON cells

%figure; 
% for n = 1:length(SelectedN)
%     Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, SelectedN{n})))';
%     ExpLabels{n} = info.Nickname{Index(1)};
%     
%  Fig1 = figure('PaperSize',[11,8.5],'PaperUnits','inches','resize','on', 'visible','on');
%         Fig1.Renderer='Painters';
% for n = Index
%     Parameters = info(n,:);
%     Table2Vars(Parameters);
%     load([Path, File,Name,File,'_Data.mat'])
%     Struct2Vars(Data);
%     plot(TimeScale,sum(OnOff,2),'-','LineWidth',1); hold on
%     xlim([10,30])
%     ylim([0,30])
%     xlabel('time into nc14 (min)')
%     ylabel('# of ON cells')
% end
% print(Fig1,['/Volumes/Mac OS/Margherita/analysis/',info.Nickname{Index(1)},'_cellsON_zoom.pdf'],'-fillpage', '-dpdf');
%   
% end
% for n = 1:length(SelectedN)
%     Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, SelectedN{n})))';
%     ExpLabels{n} = info.Nickname{Index(1)};
%     
%  Fig1 = figure('PaperSize',[11,8.5],'PaperUnits','inches','resize','on', 'visible','on');
%         Fig1.Renderer='Painters';
% for n = Index
%     Parameters = info(n,:);
%     Table2Vars(Parameters);
%     load([Path, File,Name,File,'_Data.mat'])
%     Struct2Vars(Data);
%     plot(TimeScale,sum(OnOff,2),'-','LineWidth',1); hold on
%     xlim([0,60])
%     ylim([0,60])
%     xlabel('time into nc14 (min)')
%     ylabel('# of ON cells')
% end
% 
% print(Fig1,['/Volumes/Mac OS/Margherita/analysis/',info.Nickname{Index(1)},'_cellsON.pdf'],'-fillpage', '-dpdf');
% 
%     
% end  
% close all

%  re-classify derepressed cells
MSE_absAll = {};
ME_absAll = {};
NE_absAll = {};
NaN_absAll = {};
SumDrAll = {};
SumMlAll = {};
SumBAll = {};
PercOnMSEAll = {};
AllIndex = [];

%Palette = [105,139,34;54,100,139;205,149,12]./255;


for n = 1:length(SelectedN)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, SelectedN{n})))';
    ExpLabels{n} = info.Nickname{Index(1)};
    AllIndex = [AllIndex,Index]
    SumDr = []; SumMl = []; SumB = [];
    MSE = []; ME = []; NE = []; NaNs = [];
    MSE_abs = []; ME_abs = []; NE_abs = []; NaN_abs = [];
    PercOnMSE = [];

for i = 1:length(Index)
    x = Index(i);
    Parameters = info(x,:);
    Table2Vars(Parameters);
    load([Path, File,Name,File,'_Data.mat']);
    Struct2Vars(Data);
    minOn = 5;
    Labels = Properties.NewLabel;
    [~, ~,PropertiesNew, Fig] = DefineExpAll(MaxF,MaxFBG,CentX,Labels,Baseline,TimeRes,3,60,SplitEarly,nc14,Delay,minOn);
    close all
    Properties.Onset = PropertiesNew.Onset;
    
    Tderepressed = TimeScale>=10 & TimeScale<=30;
    derepressed = sum(OnOff(Tderepressed,:))>0;
    SumDr(i) = sum(derepressed) %sum of all derepressed cells 
    FindDr = find(derepressed) %cell number position

    Tmidline= TimeScale>=30;
    midline = sum(OnOff(Tmidline,:))>(2.*60./TimeRes);
    SumMl(i) = sum(midline) 
    FindMl = find(midline) 
    
    %MSEcells = Properties.Region == 'MSE';
    both = derepressed & midline;
    SumB(i) = sum(both)
    FindB = find(both)

    LateTracks = Properties.Type == 'LateTrack'; % replace type of expression in properties table
    Properties.TypeD = Properties.Type;
    Properties.TypeD(derepressed) = 'Derepressed';
    Properties.TypeD(midline) = 'Midline';
    Properties.TypeD(both) = 'Both';
    Properties.TypeD(LateTracks) = 'LateTrack';

    NormF = (MaxF-Baseline').*Baseline(1)./Baseline'
    Data.Properties = Properties;
    Data.NormF = NormF;
    save([Path, File,Name,File,'_Data.mat'],'Data')
    
    
    
            PathToSave = [Path,File,Name,File]; 
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        
        try
            ImLab = CentroidsF;
        catch
           
            load([PathToSave, '_Stats.mat']);
            Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
            Im = Merged_meanF_maxGFP(:,:,F)./255;
            Width = size(Im,1); 
            Height = size(Im,2);
             % rescue boundariesL from StatsGFP
            cmap = jet(1000000);
            cmap_shuffled = cmap(randperm(size(cmap,1)),:);
            boundariesL = zeros(Height,Width,Frames);
            for f = 1:length(Stats_GFP)
                 disp(num2str(f))
                 SingleFrame = Stats_GFP{f};
                 Tracked3D = zeros(Height,Width,Slices);
                 for n = 1:size(SingleFrame,1)
                     Tracked3D(SingleFrame.PixelIdxList{n}) =  SingleFrame.Label(n);
                 end
                 %toTrack(:,:,:,f) = Tracked3D;
                 TrackedBoundL = MAX_proj_3D(Tracked3D);
                 [BoundariesBW, ~, ~] = BoundariesTracked_3D(Tracked3D,cmap_shuffled,'off');
                 boundariesL(:,:,f) = BoundariesBW .* TrackedBoundL;
            end            
            
            
            Width = size(boundariesL,1); Height = size(boundariesL,2);
            ImLab = boundariesL(:,:,max(1,F-5):min(F+5,Frames));
            
            for f = 1:size(ImLab,3)
                Stats{f} = regionprops('table',ImLab(:,:,f),'Centroid');
                Stats{f}.Label = [1:height(Stats{f})]';
            end
            [AllF] = MergeAll(Stats, TimeRes);
            AllF = splitvars(AllF);
            Labels = unique(AllF.Label); LabelsOld = Labels;
            [CentXF] = Reshape(AllF,Frames,Labels,'Centroid_1','Label');
            [CentYF] = Reshape(AllF,Frames,Labels,'Centroid_2','Label');
            PosX = nanmean(CentXF,1);
            PosY = nanmean(CentYF,1);
             PosX(isnan(PosX)) = [];
             PosY(isnan(PosY)) = [];
            Indices = sub2ind([size(ImLab,1),size(ImLab,2)],floor(PosY), floor(PosX));
            ImLab = zeros(size(ImLab,1),size(ImLab,2));
            ImLab(Indices) = 1;
            Data.CentroidsF = ImLab;
            save([PathToSave,'_Data.mat'],'Data');
        end
        PathToSaveR = [Path,File,Name,'regions/',File]; 
        Regions = imread([PathToSaveR,'_regions.tiff']);
           
        TotalMSE = ImLab.*(Regions == 2);
        PercOnMSE(i) = sum(Properties.Region == 'MSE')./sum(TotalMSE(:));
    
        
        Selected = find([Properties.TypeD=='Derepressed'|Properties.TypeD=='Both']);
        
        %LabelsSelected = Labels(Selected);
        PosX = floor(nanmean(CentX(max(1,F-5): F+5,Selected),1));
        PosY = floor(nanmean(CentY(max(1,F-5): F+5,Selected),1));
        %Indices = sub2ind(size(Regions),PosY,PosX);
        % added to prevent too many NaNs when cells are not tracked in the
        % F-5:F+5 window
        PosX(isnan(PosX)) = floor(nanmean(CentX(max(1,nc14): nc14-Delay+40*60./TimeRes,Selected(isnan(PosX))),1));
        PosY(isnan(PosY)) = floor(nanmean(CentY(max(1,nc14): nc14-Delay+40*60./TimeRes,Selected(isnan(PosY))),1));
        Indices = sub2ind(size(Regions),PosY,PosX);
        Selected = Selected(~isnan(Indices));
        %LabelsSelected = LabelsSelected(~isnan(Indices));
        PosX = PosX(~isnan(Indices));
        PosY = PosY(~isnan(Indices));
        Indices = Indices(~isnan(Indices));
        RegionsInd = Regions(Indices);
        ME = Selected(RegionsInd==1);
        MSE = Selected(RegionsInd==2);
        NE = Selected(RegionsInd==3);
        DE = Selected(RegionsInd==4);
        Properties.Region = string(repmat('NaN',length(Properties.Type),1));
        Properties.Region(ME) = string(repmat('ME',length(ME),1));
        Properties.Region(MSE) = string(repmat('MSE',length(MSE),1));
        Properties.Region(NE) = string(repmat('NE',length(NE),1));
        Properties.Region(DE) = string(repmat('DE',length(DE),1));
        
      % proportion of de-repressed cells in each region
    RegionsProp = Properties.Region(Properties.TypeD == 'Derepressed' | Properties.TypeD == 'Both')
    MSE(i) = sum(RegionsProp == 'MSE')/length(RegionsProp)
    ME(i) = sum(RegionsProp == 'ME')/length(RegionsProp)
    NE(i) = sum(RegionsProp == 'NE')/length(RegionsProp)
    NaN(i) = sum(RegionsProp == 'NaN')/length(RegionsProp)
    
    MSE_abs(i) = sum(RegionsProp == 'MSE')
    ME_abs(i) = sum(RegionsProp == 'ME')
    NE_abs(i) = sum(RegionsProp == 'NE')
    NaN_abs(i) = sum(RegionsProp == 'NaN')  
        
        
%     Fig7 = figure('PaperSize',[20,15],'PaperUnits','inches','resize','on', 'visible','on');
% 
%     CentXOn = CentX.*OnOff; 
%     CentYOn = CentY.*OnOff; 
%         Tderepressed = TimeScale>=15 & TimeScale<=25;
%     plot(CentXOn(Tderepressed,:).*XYRes, CentYOn(Tderepressed,:).*XYRes,'.m'); hold on
%     plot(CentXOn(Tmidline,:).*XYRes, CentYOn(Tmidline,:).*XYRes,'.g')
%     axis equal
%     xlim([0,400].*XYRes) ; ylim([0,400].*XYRes)
%     ax = gca;
%     ax.YDir = 'reverse'
%     xlabel('A --------------------------- x position (um) --------------------------- P')
%     ylabel('y position (um)')
%     title('location of derepressed and midline cells after 15 minutes into nc14')
%     %legend('derepressed (15-30m)','midline (30m on)')
%     print(Fig7,['/Volumes/Mac OS/Margherita/analysis/',Nickname,'_',num2str(Rep),'.pdf'],'-fillpage', '-dpdf');
% 
            clear CentroidsF;

end
    SumDrAll{n} = SumDr;
    SumMlAll{n} = SumMl;
    SumBAll{n} = SumB;
    
    MSE_absAll{n} = MSE_abs;
    ME_absAll{n} = ME_abs;
    NE_absAll{n} = NE_abs;
    NaN_absAll{n} = NaN_abs;
    
    PercOnMSEAll{n} = PercOnMSE;
    


end
% sum_all = sum([MSE_abs,ME_abs,NE_abs,NaN_abs])
% MSE(end+1) = sum(MSE_abs) / sum_all
% ME(end+1) = sum(ME_abs) / sum_all
% NE(end+1) = sum(NE_abs) / sum_all
% NaN(end+1) = sum(NaN_abs) / sum_all


%subplot(131); 
SumDrAll = Cell2Mat(SumDrAll);
SumMlAll = Cell2Mat(SumMlAll);
SumBAll = Cell2Mat(SumBAll);
PercOnMSEAll = Cell2Mat(PercOnMSEAll);
MSE_absAll = Cell2Mat(MSE_absAll);
ME_absAll = Cell2Mat(ME_absAll);
NE_absAll = Cell2Mat(NE_absAll);
NaN_absAll = Cell2Mat(NaN_absAll);
%
%
Fig1 = figure('PaperSize',[50,15],'PaperUnits','inches','resize','on', 'visible','on');
            cmap_3 = [255,120,120;096,085,176;95,181,241;150,150,150]./255;
          %set(Fig1,'defaultAxesColorOrder',cmap_3)
          set(Fig1,'defaultAxesColorOrder',Palette)

     

Jitter = 0.5; %Jitter./2 cant be > BarW 
BarW = 0.35; FaceAlpha = 0.3; DotSize = 15; LineWidth = 2; FontSizeTitle = 16; FontSize = 14;
set(gca,'FontSize',FontSize)
subplot(151);
plotBoxplot([SumDrAll],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,70])
 ylabel('# active cells 10-30''')

 subplot(152);
plotBoxplot([MSE_absAll],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,70])
 ylabel('# active cells 10-30'' MSE')
 
 subplot(153);
plotBoxplot([ME_absAll],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,70])
 ylabel('# active cells 10-30'' ME')

 subplot(154);
plotBoxplot([NE_absAll],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,70])
 ylabel('# active cells 10-30'' NE')

 subplot(155);
plotBoxplot([NaN_absAll],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,70])
 ylabel('# active cells 10-30'' NaN')


 print(Fig1,['/Users/julia/Google Drive jf565/comp MS2/derepression/cellsDR_M_region',char(join(SelectedNames,'_')),'.pdf'],'-fillpage', '-dpdf');
%
Fig1 = figure('PaperSize',[50,15],'PaperUnits','inches','resize','on', 'visible','on');
            cmap_3 = [255,120,120;096,085,176;95,181,241;150,150,150]./255;
          %set(Fig1,'defaultAxesColorOrder',cmap_3)
          set(Fig1,'defaultAxesColorOrder',Palette)

subplot(141);
All = SumDrAll
Jitter = 0.5
XValues = repmat([1:size(All,2)],size(All,1),1) + [(rand(1,size(All,1))-0.5).*Jitter]';
plot(XValues,All, '.', 'MarkerSize',10); hold on
ax = gca;
ax.ColorOrderIndex = 1;
plot([[1:size(All,2)]-0.25;[1:size(All,2)]+0.25],[nanmean(All,1);nanmean(All,1)],'-','LineWidth',2);
xlim([0,size(All,2)+1])
xticks([1:1:size(All,2)])
xticklabels(ExpLabels)
xtickangle(45)
ylim([0,70])
title('# cells derepressed')

subplot(142);
All = SumBAll
Jitter = 0.5
XValues = repmat([1:size(All,2)],size(All,1),1) + [(rand(1,size(All,1))-0.5).*Jitter]';
plot(XValues,All, '.', 'MarkerSize',10); hold on
ax = gca;
ax.ColorOrderIndex = 1;
plot([[1:size(All,2)]-0.25;[1:size(All,2)]+0.25],[nanmean(All,1);nanmean(All,1)],'-','LineWidth',2);
xlim([0,size(All,2)+1])
xticks([1:1:size(All,2)])
xticklabels(ExpLabels)
xtickangle(45)
ylim([0,70])
title('# of derepressed cells that become the midline')

subplot(143);
All = SumBAll./SumDrAll
Jitter = 0.5
XValues = repmat([1:size(All,2)],size(All,1),1) + [(rand(1,size(All,1))-0.5).*Jitter]';
plot(XValues,All, '.', 'MarkerSize',10); hold on
ax = gca;
ax.ColorOrderIndex = 1;
plot([[1:size(All,2)]-0.25;[1:size(All,2)]+0.25],[nanmean(All,1);nanmean(All,1)],'-','LineWidth',2);
xlim([0,size(All,2)+1])
xticks([1:1:size(All,2)])
xticklabels(ExpLabels)
xtickangle(45)
ylim([0,1])
title('% of cells both derepressed and midline')


subplot(144);
All = PercOnMSEAll.*100
Jitter = 0.5
XValues = repmat([1:size(All,2)],size(All,1),1) + [(rand(1,size(All,1))-0.5).*Jitter]';
plot(XValues,All, '.'); hold on
ax = gca;
ax.ColorOrderIndex = 1;
plot([[1:size(All,2)]-0.25;[1:size(All,2)]+0.25],[nanmean(All,1);nanmean(All,1)],'-','LineWidth',2);
xlim([0,size(All,2)+1])
xticks([1:1:size(All,2)])
xticklabels(ExpLabels)
xtickangle(45)
ylim([0,100])
title('% MSE cells ON')




 print(Fig1,['/Users/julia/Google Drive jf565/comp MS2/derepression/cellsDR_M_region2',char(join(SelectedNames,'_')),'.pdf'],'-fillpage', '-dpdf');


%subplot(122);
Fig2 = figure('PaperSize',[20,15],'PaperUnits','inches','resize','on', 'visible','on');
            cmap_3 = [255,120,120;096,085,176;95,181,241;150,150,150]./255;
          set(Fig2,'defaultAxesColorOrder',cmap_3)

StackedData = [[ME_absAll(:)]';[MSE_absAll(:)]';[NE_absAll(:)]';[NaN_absAll(:)]']';
ToR = sum(~isnan(StackedData),2)==0;
StackedData(ToR,:) = [];
bar(StackedData,'stacked','FaceAlpha',0.7)
xlim([0,length(AllIndex)+1])
title('# of cells derepressed per region')
ylabel('# of cells')
legend('Mesoderm', 'Mesectoderm', 'Neuroectoderm','not assigned')
xticks([1:1:length(AllIndex)])
xticklabels(info.Nickname(AllIndex))
xtickangle(45)

print(Fig2,['/Users/julia/Google Drive jf565/comp MS2/derepression/cellsONregion',char(join(SelectedNames,'_')),'.pdf'],'-fillpage', '-dpdf');

close all
%% compare means & heatmaps


MetaFile = ' margherita';
MetaFile = ' mutBG';



%Path = ['/Users/julia/Google Drive jf565/comp MS2/',MetaFile,'/'];
Path = '/Volumes/Mac OS/Margherita/analysis/'
mkdir(Path)


Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter','\t');
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';

PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80]./255;


set(0,'defaultAxesFontSize',16)
%set(0,'defaultAxesFontName', 'Myriad Pro')

YLim = 1100; % limit Y axis flupreecence plot
Selection = '';
XLim = [0,60]; % limits X axis, time into nc14
Heatmaps = 1500;
    CompareMeans({'m5m8peve w RNAi','m5m8peve Gro RNAi', 'm5m8peve Gro RNAi m&z?', 'm5m8peve Ez RNAi','m5m8peve Ez RNAi m&z?','m5m8peve Ez RNAi m&z'},1,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve w RNAi','m5m8peve Gro RNAi','m5m8peve Gro RNAi m&z?', 'm5m8peve Ez RNAi','m5m8peve Ez RNAi m&z?','m5m8peve Ez RNAi m&z'},1,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)

    % 3 to compare repeats within one experiment
    CompareMeans({'m5m8peve Ez RNAi'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
        CompareMeans({'m5m8peve Ez RNAi'},3,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)

         CompareMeans({'m5m8peve Ez RNAi m&z?'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
        CompareMeans({'m5m8peve Ez RNAi m&z?'},3,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)

          CompareMeans({'m5m8peve Ez RNAi m&z'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
        CompareMeans({'m5m8peve Ez RNAi m&z'},3,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)

        CompareMeans({'m5m8peve w RNAi'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
            CompareMeans({'m5m8peve w RNAi'},3,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)

           CompareMeans({'m5m8peve Gro RNAi'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
           CompareMeans({'m5m8peve Gro RNAi'},3,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)


    % mutant Ez/TTG
            CompareMeans({'m5m8peve mDr:TTG','m5m8peve Ez:TTG','m5m8peve TTG, mEz'},1,Info,Path, Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        CompareMeans({'m5m8peve mDr:TTG','m5m8peve Ez:TTG','m5m8peve TTG, mEz'},1,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
