function[] = CompareGastrulation(SelectedN,Which,Info, PathPlots,Exps, Selection, XLim,PalettePoints, PaletteMeans, varargin)
    try
        if ~isempty(varargin{1})
            YLimits = varargin{1};
        end

        if ~isempty(varargin{2})
            SplitEarlyOverride = varargin{2}; 
        end
    end
    
        Fig1 = figure('PaperSize',[30 50],'PaperUnits','inches','resize','on', 'visible','on');
        Fig1.Renderer='Painters';

  
    if Which == 3
        Index = find(cellfun(@(x) strcmp(x,SelectedN{1}),table2array(Exps(:,1)))==1)';
        SelectedN = table2cell(Exps(Index,3));
    end
    
     ToSave = [PathPlots,char(join(SelectedN,'_vs_'))];
       
    for i = 1:length(SelectedN)
        Index = find(cellfun(@(x) strcmp(x,SelectedN{i}),table2array(Exps(:,Which)))==1)';
        PropertiesMerged = table();
        TimeScaleMerged = [];
        NormMerged = [];
        MeanNormMerged =[];
        OnOffMerged = [];
        GastTimes = [];
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
            
            
            if strcmp(Selection,'') == 1
                    Selected = [Properties.Type ~= 'EarlyOnly'];
                else
                    try
                        Selected = [Properties.Type ~= 'EarlyOnly' & Properties.Region == Selection];
                        Experiment = [Experiment,'_',Selection]
                    catch
                        Selected = [Properties.Type ~= 'EarlyOnly'];
                    end
                end
        
             minOn = 5;
                Labels = Properties.NewLabel;
                [~, ~,PropertiesNew, ~] = DefineExpAll(MaxF,MaxFBG,CentX,Labels,Baseline,TimeRes,3,60,SplitEarly,nc14,Delay,minOn);
                %close Fig
                Properties.Onset = PropertiesNew.Onset;
                Properties.Type = PropertiesNew.Type;
                Norm = ((MaxF-Baseline').*Baseline(1)./Baseline').*(2.^(12-Bits));
                Norm(Norm==0) = NaN;
                NormBG = (MaxFBG-Baseline').*Baseline(1)./Baseline';
                NormBG(NormBG==0) = NaN;
                
                MeantoPlot = [nanmean(Norm(1:nc14-Delay+15*60/TimeRes,Properties.Type == 'EarlyOnly'),2);...
                    nanmean(Norm(nc14-Delay+15*60/TimeRes+1:end,Selected),2)];
                
                MovX = abs(diff(CentX,1,1))*XYRes;
                MovY = abs(diff(CentY,1,1))*XYRes;
                MovZ = abs(diff(CentZ,1,1))*ZRes;
                %MovXYZ = sqrt(MovX.^2+MovY.^2+MovZ.^2)./TimeRes;
                MovXYZ = (MovY)./TimeRes;
                
                try
                    disp('here')
                    GastValues = Data.GastValues;
                    PeakT = GastValues(:,1);
                    PeakF = GastValues(:,2);
                    GastT = GastValues(:,3);
                catch    
                    answer = 'No';
                    while strcmp(answer,'Yes') ~= 1
                        Fig2 = figure();
                        subplot(211)
                        plot(TimeScale,MeantoPlot, '-','Color',[144,191,91]./255,'LineWidth',1); hold on 
                        title('Select Peak#1, transition and Peak#2 (NaN @ t<0)')
                        [PeakT,PeakF] = ginput(3); 
                        PeakF(PeakT<0) = NaN; PeakT(PeakT<0) = NaN
                        plot(PeakT,PeakF,'*r')

                        subplot(212)
                        yyaxis left
                        plot(TimeScale,CentY, '-','Color',[144,191,91]./255,'LineWidth',1); hold on 
                        title('Select Begining, peak and end of gastrulation (NaN @ t<0)')
                        yyaxis right
                        plot(TimeScale(1:end-1),medfilt1(nanmean(MovXYZ(:,Selected),2),5),'-','Color',[209,28,71]./255,'LineWidth',1)
                        [GastT,~] = ginput(3); 
                        yyaxis left
                        plot([GastT,GastT],[0,400],'--')
                        hold off
                        answer = questdlg('OK?');
                        if strcmp(answer,'Cancel' )  
                            close(Fig2)
                            GastValues = nan(3,3);
                            break
                        end
                        %save mat
                        MeanF = [nanmean(MeantoPlot(nc14-Delay+1+[30:50*60/TimeRes])),NaN,NaN]';
                        GastValues = [PeakT,PeakF,GastT,MeanF];                        close(Fig2)
                    end
                    % add to Data
                    Data.GastValues = GastValues;
                    save([PathToSave,'_Data.mat'],'Data');
                end
  
                
                
            
            
            
            
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
            
            % uncomment to plot selected for each repeat
%             [BurstNum,BurstLength,BurstPeriod,BurstPeak,BurstMax,OffTimeAll,BurstSize] = CountBursts(Norm,OnOff, Selected,minOn,SplitEarlyF,TimeRes);
%             PlotSelected(Selected, TimeScale,Baseline,MaxF,MedFilt,OnOff,Properties,BurstPeak,TimeRes,Bits,nc14, Delay,Limits,[PathPlots,'/',Info.File{Index(x)},'_selected_',Selection,'.ps']);
% %         
            Norm = MovXYZ;

            MaxF = MaxF(:,Selected);
            OnOff = OnOff(:,Selected);
            Properties = Properties(Selected,:);
            Properties.NormAP = (Properties.AP_position-min(Properties.AP_position))./max(Properties.AP_position);
            Norm = Norm(:,Selected);
            OnOff(isnan(MaxF)) = NaN;
            MeanNormEach = nanmean(Norm,2);

            [NormMerged,~,~] = MergeFMatrix(Norm,NormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     
            [MeanNormMerged,~,~] = MergeFMatrix(MeanNormEach,MeanNormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     
            [OnOffMerged,PropertiesMerged,TimeScaleMerged] = MergeFMatrix(OnOff,OnOffMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);     
            GastTimes(:,:,x) = GastT;
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
            Fig1 = PlotMeansFractionShaded(NormMerged,MeanNormMerged,OnOffMerged,TimeScaleMerged,Selected,PropertiesMerged,Bits,ColorArg,Fig1,1,SelectedN{i},XLim, YLimits);
        
            figure(Fig1)
            subplot(411); ylabel('Mean DV displacement (um/s)')
            subplot(412); ylabel('Mean DV displacement (um/s)')
            	%plot([GastT,GastT],[0,400],'--','Color',PalettePoints(i,:))
                MeanGastT = nanmean(GastTimes,3);
                SEMGast = nanstd(GastTimes,[],3)./sqrt(sum(~isnan(GastTimes),3));
                
                t=1;
                plot([MeanGastT(t),MeanGastT(t)],[0,YLimits(2)],'--','Color',PalettePoints(i,:),'HandleVisibility','off')
                Poly = polyshape([MeanGastT(t)-SEMGast(t),MeanGastT(t)-SEMGast(t),MeanGastT(t)+ SEMGast(t),MeanGastT(t)+ SEMGast(t)],[0,YLimits(2),YLimits(2),0]);
                plot(Poly,'LineStyle','none','FaceColor',[PalettePoints(i,:),0.3],'HandleVisibility','off');
                t=2;
                plot([MeanGastT(t),MeanGastT(t)],[0,YLimits(2)],'-','Color',PalettePoints(i,:),'HandleVisibility','off')
                Poly = polyshape([MeanGastT(t)-SEMGast(t),MeanGastT(t)-SEMGast(t),MeanGastT(t)+ SEMGast(t),MeanGastT(t)+ SEMGast(t)],[0,YLimits(2),YLimits(2),0]);
                plot(Poly,'LineStyle','none','FaceColor',[PalettePoints(i,:),0.3],'HandleVisibility','off');
                t=3;
                plot([MeanGastT(t),MeanGastT(t)],[0,YLimits(2)],':','Color',PalettePoints(i,:),'HandleVisibility','off')
                Poly = polyshape([MeanGastT(t)-SEMGast(t),MeanGastT(t)-SEMGast(t),MeanGastT(t)+ SEMGast(t),MeanGastT(t)+ SEMGast(t)],[0,YLimits(2),YLimits(2),0]);
                plot(Poly,'LineStyle','none','FaceColor',[PalettePoints(i,:),0.3],'HandleVisibility','off');
        
              
            subplot(413); ylabel('Mean DV displacement (um/s)')

            subplot(414); ylabel('Mean DV displacement (um/s)')

    
    
    end
    if strcmp(Selection,'') == 0; Selection = ['_',Selection];end
    
    print(Fig1,[ToSave,Selection,'_gast.pdf'],'-fillpage', '-dpdf');
   
    
    close all
    %end
end