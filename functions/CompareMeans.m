function[] = CompareMeans(SelectedN,Which,Info, PathPlots,Exps, Selection, MeansOnly, XLim,PalettePoints, PaletteMeans, varargin)
    Heatmaps = 3000;
    try
        if ~isempty(varargin{1})
            YLimits = varargin{1};
        end
        if ~isempty(varargin{2})
            Heatmaps = varargin{2};
        end
        if ~isempty(varargin{3})
            SplitEarlyOverride = varargin{3}; 
        end
    end
    %try
    %Selection = '';
    if MeansOnly == 1
        Fig1 = figure('PaperSize',[30 50],'PaperUnits','inches','resize','on', 'visible','on');
        Fig1.Renderer='Painters';
    else
        Fig2 = figure('PaperSize',[30 50],'PaperUnits','inches','resize','on', 'visible','on');
        Fig2.Renderer='Painters';
        
    end
    
    Fig3 = figure('PaperSize',[17 50],'PaperUnits','inches','resize','on', 'visible','on');
    Fig3.Renderer='Painters';

     
    if Which == 3
        Index = find(cellfun(@(x) strcmp(x,SelectedN{1}),table2array(Exps(:,1)))==1)';
        SelectedN = table2cell(Exps(Index,3));
    end
    
     ToSave = [PathPlots,char(join(SelectedN,'_vs_'))];
        FigH = figure('PaperUnits','inches','PaperSize',[4*length(SelectedN) 10],'Units','points','resize','on', 'visible','on','DefaultAxesFontSize', 7);
        FigH.Renderer='Painters';
  
    for i = 1:length(SelectedN)
        Index = find(cellfun(@(x) strcmp(x,SelectedN{i}),table2array(Exps(:,Which)))==1)';
        PropertiesMerged = table();
        TimeScaleMerged = [];
        NormMerged = [];
        MeanNormMerged =[];
        OnOffMerged = [];

        %try
        for x = 1:size(Index,2)
            %try
            Experiment = [Exps.Nickname{Index(x)},' ',num2str(Exps.Rep(Index(x)))]
            PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
            Info.Name{Index(x)},Info.File{Index(x)}]; 
            load([PathToSave,'_Data.mat']);
            Struct2Vars(Data);
            Parameters = Info(Index(x),:);
            Table2Vars(Parameters);
            
            try SplitEarly = SplitEarlyOverride; end
            %if SplitEarly ~= 15
                %SplitEarly =30; 
                minOn = 5;
                Labels = Properties.NewLabel;
                [~, ~,PropertiesNew, ~] = DefineExpAll(MaxF,MaxFBG,CentX,Labels,Baseline,TimeRes,3,60,SplitEarly,nc14,Delay,minOn);
                %close Fig
                Properties.Onset = PropertiesNew.Onset;
                Properties.Type = PropertiesNew.Type;
            %end
            
            
            if strcmp(Selection,'') == 1
                Selected = [Properties.Type ~= 'BG'];
            else
                Selected = Properties.Type ~= 'EarlyOnly' & Properties.Region == Selection;
                if contains(Selection,'|')
                    Selected = [];
                    Selections = strsplit(Selection,'|');
                    for s = 1:length(Selections)
                    	Selected(s,:) = Properties.Type ~= 'EarlyOnly' & Properties.Region == Selections{s};
                    end
                    Selected = sum(Selected,1) ~= 0;
                    
                end    
            end
            
           
            SplitEarlyF = max([SplitEarly*60./TimeRes+nc14-Delay,1]);
            OnOff = CleanOnOff(OnOff,minOn);
            [OnOff] = CleanNaNs(MedFilt,OnOff, minOn*2);
            Norm = ((MaxF-Baseline').*Baseline(1)./Baseline').*(2.^(12-Bits));
            %Norm = (MaxF-Baseline').*OnOff.*Baseline(1)./Baseline'.*(2.^(12-Bits));
            Norm(Norm==0) = NaN;
            Limits = [0, 90];
            
            %uncomment to plot selected for each repeat
            [BurstNum,BurstLength,BurstPeriod,BurstPeak,BurstMax,OffTimeAll,BurstSize] = CountBursts(Norm,OnOff, Selected,minOn,SplitEarlyF,TimeRes);
            PlotSelected(Selected, TimeScale,Baseline,MaxF,MedFilt,OnOff,Properties,BurstPeak,TimeRes,Bits,nc14, Delay,Limits,[PathPlots,'/',Info.File{Index(x)},'_selected_',Selection,'.ps']);
%             
            MaxF = MaxF(:,Selected);
            MedFilt = MedFilt(:,Selected);
            OnOff = OnOff(:,Selected);
            Properties = Properties(Selected,:);
            Properties.NormAP = (Properties.AP_position-min(Properties.AP_position))./max(Properties.AP_position);
            Norm = Norm(:,Selected);
            OnOff(isnan(MaxF)) = NaN;
            MeanNormEach = nanmean(Norm,2);

            [NormMerged,~,~] = MergeFMatrix(Norm,NormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     
            [MeanNormMerged,~,~] = MergeFMatrix(MeanNormEach,MeanNormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     
            [OnOffMerged,PropertiesMerged,TimeScaleMerged] = MergeFMatrix(OnOff,OnOffMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     

        end
        
       [NormMerged,~,~] = MergeFMatrix([NaN],NormMerged,table(0),PropertiesMerged,[0],TimeScaleMerged,TimeRes);
       [MeanNormMerged,~,~] = MergeFMatrix([NaN],MeanNormMerged,table(0),PropertiesMerged,[0],TimeScaleMerged,TimeRes);
       [OnOffMerged,PropertiesMerged,TimeScaleMerged] = MergeFMatrix([NaN],OnOffMerged,table(0),PropertiesMerged,[0],TimeScaleMerged,TimeRes);
        MeanNormMerged(:,end) = [];
        
       % ColorArg is 8 value colormap with info for allPoints, allMidPoints,
       % shortPoints, longPoints, allMeans, allMidMeans, shortMeans, longMeans
       % repeat value for each 4 times, it will update with every repeat
       ColorArg = [PalettePoints(i,:);PalettePoints(i,:);PalettePoints(i,:);PalettePoints(i,:);...
       PaletteMeans(i,:);PaletteMeans(i,:);PaletteMeans(i,:);PaletteMeans(i,:)];
       Selected = [PropertiesMerged.Type ~= 'BG'];
       YLimits = [min(0,min(MaxF(:))), max(2^Bits-1,max(MaxF(:)))];
        try
            YLimits = varargin{1};
        end  
       if MeansOnly == 1
            Fig1 = PlotMeansFractionShaded(NormMerged,MeanNormMerged,OnOffMerged,TimeScaleMerged,Selected,PropertiesMerged,Bits,ColorArg,Fig1,1,SelectedN{i},XLim, YLimits);
       else
            Fig2 = PlotMeans(NormMerged,OnOffMerged,TimeScaleMerged,Selected,PropertiesMerged,Bits,ColorArg,Fig2,0,SelectedN{i},XLim, YLimits);
       end
       
    %end
    if Heatmaps ~= 0
        MaxTime = 30;
        Selected = PropertiesMerged.Type ~= 'EarlyOnly';
        [NormAligned,TimeScaleAligned] = AlignFMatrixtoOnset(NormMerged,PropertiesMerged,TimeScaleMerged,MaxTime,TimeRes);
        [OnOffAligned,~] = AlignFMatrixtoOnset(OnOffMerged,PropertiesMerged,TimeScaleMerged,MaxTime,TimeRes);
        Fig3 = PlotMeansFractionShaded(NormAligned,NormAligned,OnOffAligned,TimeScaleAligned,Selected,PropertiesMerged,Bits,ColorArg,Fig3,1,SelectedN{i},[0,MaxTime], YLimits);
        %Fig3 = PlotMeans(NormAligned,TimeScaleAligned,Selected,PropertiesMerged,Bits,ColorArg,Fig3,1,SelectedN{i},[0,MaxTime], YLimits);
        [FigH] = PlotHeatmaps(FigH,NormMerged,Selected,PropertiesMerged,TimeScaleMerged,SelectedN,TimeRes,XLim,i,Heatmaps);
    end
    
    
    end
    if strcmp(Selection,'') == 0; Selection = ['_',Selection];end
    if MeansOnly == 1
        print(Fig1,[ToSave,Selection,'_means.pdf'],'-fillpage', '-dpdf');
    else
        print(Fig2,[ToSave,Selection,'.pdf'],'-fillpage', '-dpdf');
    end
    

    if Heatmaps ~= 0
        print(Fig3,[ToSave,Selection,'_aligned.pdf'],'-fillpage', '-dpdf');
        print(FigH,[ToSave,Selection,'_heatmaps.pdf'],'-fillpage', '-dpdf');
    end
    close all
    %end
end