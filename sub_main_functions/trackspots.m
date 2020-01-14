
%% START OF SPOT TRACKING AFTER RUNNING THE FIRST SECTION OF MainMS2


MAX_G = zeros(Height, Width,Frames);
   %Stats_GFP = cell(Frames,1);
   StatsSpots = cell(Frames,1);
   if Spots ~= 0
   MAX_GSeg = zeros(Height, Width,Frames);
   MAX_GGaussF = zeros(Height, Width,Frames);
   MAX_meanFGauss = zeros(Height, Width,Frames);
   end
   maxWorkers = 6;
if Spots ~= 0
try
    parpool(maxWorkers);  % 6 is the number of cores the Garcia lab server can reasonably handle per user at present.
catch
    try
        parpool; %in case there aren't enough cores on the computer 
    catch
    end
    %parpool throws an error if there's a pool already running. 
end
end
for f = 1:Frames
    disp(['reading f',num2str(f),'...']);
    G = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,1,f);
    %[Stats, ~, ~] = getStatsF_3D(toTrack(:,:,:,f), G); 
    %[Stats] = PrintF_3D(Stats,Path,File,Name,0);
    MAX_G(:,:,f) = MAX_proj_3D(G);
    if Spots ~= 0
        GSeg = zeros(Height, Width,Slices);
        GGaussF = zeros(Height, Width,Slices);
        Threshold = 160;%before 150
        Shadows = 0;
        [SSpots] = segmentSpots_JF(G, Threshold,Shadows, XYRes);
        %SpotsAll{f} = SSpots;
        if numel(fieldnames(SSpots)) ~= 0
            Positions = [[SSpots.Fits.CentX]', [SSpots.Fits.CentY]', [SSpots.Fits.brightestZ]'];
            Intensities = [SSpots.Fits.MaxInt]';
            Indices = [sub2ind(size(G), Positions(:,2),Positions(:,1),Positions(:,3))];
            GSeg(Indices) = 1;
            GGaussF(Indices) = Intensities;
        end
        for z=1:size(GSeg,3)
         GSeg(:,:,z) = bwmorph(GSeg(:,:,z), 'thicken',1);
        end
        SpotsLabelled = bwlabeln(GSeg,6);
        [StatsS, ~, ~] = getStatsF_3D(SpotsLabelled, GGaussF); 
        StatsSpots{f} = StatsS{1,1};
        
        GSeg = max(GSeg,[],3);
        GSeg = bwmorph(GSeg, 'thicken',2);
        GSeg = GSeg*4095;
        MAX_GSeg(:,:,f) = GSeg;
        MAX_GGaussF(:,:,f) = max(GGaussF,[],3);
 
        %[StatsGauss, ~, ~] = getStatsF_3D(toTrack(:,:,:,f), GGaussF); 
        %[StatsGauss] = PrintF_3D(StatsGauss,Path,File,Name,Spots);
%         try
%             Stats{1,1}.MaxGauss = StatsGauss{1,1}.Max;
%             Stats{1,1}.PositionGaussX = StatsGauss{1,1}.SpotPositionX;
%             Stats{1,1}.PositionGaussY = StatsGauss{1,1}.SpotPositionY;
%             Stats{1,1}.PositionGaussZ = StatsGauss{1,1}.SpotPositionZ;
%             [ReplacedSpots] = ReplaceLabelsbyF_3D(toTrack(:,:,:,f), Stats, 0,2^(Bits+1)-1,'MaxGauss');
%             MAX_meanFGauss(:,:,f) = max(ReplacedSpots,[],3);
%             Stats{1,1}.MaxGauss2 = StatsGauss{1,1}.Max2;
%             Stats{1,1}.Position2GaussX = StatsGauss{1,1}.Spot2PositionX;
%             Stats{1,1}.Position2GaussY = StatsGauss{1,1}.Spot2PositionY;
%             Stats{1,1}.Position2GaussZ = StatsGauss{1,1}.Spot2PositionZ;
%         end
    end    
    %[toTrack(:,:,:,f)] = ReplaceLabelsbyF_3D(toTrack(:,:,:,f), Stats, 0,2^Bits-1,'Max');
    %Stats_GFP{f,1} = Stats{1,1};
end
clear G
save([Path,File,Name,File,'_StatsSpots.mat'],'StatsSpots','-v7.3');

%%
%MaxL = 200
MaxL = max(cellfun(@(x) height(x),StatsSpots));
Distance = 4; MaxN = 3; Divisions = 0;
cmap = jet(1000000);
    cmap_shuffled = cmap(randperm(size(cmap,1)),:);
    newLabel=MaxL+1;
    StatsSpots{1,:}.Label = (1:size(StatsSpots{1,:},1))';
    if Divisions
            StatsSpots{1,:}.Parent = zeros(size(StatsSpots{1,:},1),1);
            StatsSpots{1,:}.Daughters = zeros(size(StatsSpots{1,:},1),2);
    end
    toReplace = StatsSpots{1,:}(1,:); 
    for r = 1:size(toReplace,2); try; toReplace(1,r) = table(NaN);end; end
     SingleFrame = StatsSpots{1};
         Tracked3D = zeros(Height,Width,  Slices);
         for n = 1:size(SingleFrame,1)
             Tracked3D(SingleFrame.PixelIdxList{n}) =  SingleFrame.Label(n);
         end
    TrackedBoundL = zeros(Height, Width,Frames);
    TrackedBoundL(:,:,1) = MAX_proj_3D(Tracked3D(:,:,:,1));
    for f=2:size(StatsSpots,1)
        disp(['frame ',num2str(f-1),' to ',num2str(f)])
        StatsSpots{f,:}.Label = (1:size(StatsSpots{f,:},1))';
        SingleFrame = StatsSpots{f};
         Tracked3D = zeros(Height,Width,  Slices);
         for n = 1:size(SingleFrame,1)
             
                Tracked3D(SingleFrame.PixelIdxList{n}) =  SingleFrame.Label(n);
            
         end
        F1_0 = Tracked3D;
        F1_t = zeros(size(Tracked3D));
        FromT = f-MaxN; if FromT < 1; FromT = 1; end
        SubStats = StatsSpots(FromT:f,1);
        [F1_t, ~, SubStats, newLabel] = TrackWithDivisions_3D(SubStats,F1_0,F1_t, cmap_shuffled,f,Distance,newLabel,MaxN,Divisions,toReplace,XYRes, ZRes);  %for others   
        Tracked3D = F1_t(:,:,:);
        StatsSpots(FromT:f,1) = SubStats;
        TrackedBoundL(:,:,f) = MAX_proj_3D(F1_t);
    end
    %[toTrack , ~, Stats_tracked] = Tracking_3D(toTrack, Stats_table, cmap_shuffled, Distance,MaxN,Divisions,'off','off');
    %clear Stats_table
    [BoundariesBW, Boundaries_RGB, ~] = BoundariesTracked_3D(permute(TrackedBoundL,[1,2,4,3]),cmap_shuffled,show);
    [Boundaries_RGB] = TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay);
    WriteRGB(double(Boundaries_RGB), PathToSave, '_segmented_tracked_boundaries_spots_RGB.tiff','none')

    save([Path,File,Name,File,'_StatsSpots_tracked0.mat'],'StatsSpots','-v7.3');
%%
toTrack = zeros(Height,Width, Slices, Frames);
    for f = 1:length(StatsSpots)
        disp(num2str(f))
         SingleFrame = StatsSpots{f};
         Tracked3D = zeros(Height,Width,  Slices);
         for n = 1:size(SingleFrame,1)
             Tracked3D(SingleFrame.PixelIdxList{n}) =  SingleFrame.Label(n);
         end
         toTrack(:,:,:,f) = Tracked3D;
    end
    
[BoundariesBW, Boundaries_RGB, ~] = BoundariesTracked_3D(toTrack,cmap_shuffled,show);
    [Boundaries_RGB] = TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay);
    WriteRGB(double(Boundaries_RGB), PathToSave, '_segmented_tracked_boundaries_spots_RGB.tiff','none')

Factor = 2; % 1 in macbook, 2 in pro
printLabels_new(Boundaries_RGB,StatsSpots,Factor,'off', PathToSave, '_segmented_tracked_info.tiff','packbits')

%%
for f = 1:size(StatsSpots)
    StatsSpots{f}.Max = StatsSpots{f}.MaxIntensity;
end
%
minNumb = 5; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
%[PropAll] = AnalyzeTraces(0,0,Spots,StatsSpots,TimeRes,Frames,Slices,Bits,XYRes, ZRes,Width, Height,minNumb,Smooth, minOn,minPDis,SplitShortLong,SplitEarly,nc14,Delay,PathToSave,Nickname,Rep);
 
[AllF] = MergeAll(StatsSpots, TimeRes);
        AllF = splitvars(AllF);
        %
        Labels = unique(AllF.Label); LabelsOld = Labels;
        [MaxF] = Reshape(AllF,Frames,Labels,'Max','Label');
        noNaNnum = sum(~isnan(MaxF),1);
        ToDelete = noNaNnum <= minNumb;
        % delete tracks less than minNumb
        Labels(noNaNnum <= minNumb) = [];
        MaxF(:,noNaNnum <= minNumb) = [];
        %[Baseline, baseline,MaxFBG, BG, BGLabels] = BaselinefromBG(MaxF,Labels, Smooth,minOn);
        % remove BG Labels
        %Labels = Labels(~BG);
        BG = zeros(size(Labels))
        %parpool(4)

        %spmd
        tic
        MaxF = CleanMatrixValues(AllF,Frames,LabelsOld,'Max',ToDelete,BG);
        CentX = CleanMatrixValues(AllF,Frames,LabelsOld,'Centroid_1',ToDelete,BG);
        CentY = CleanMatrixValues(AllF,Frames,LabelsOld,'Centroid_2',ToDelete,BG);
        CentZ = CleanMatrixValues(AllF,Frames,LabelsOld,'Centroid_3',ToDelete,BG);
        toc
        
        Baseline = ones(1,size(MaxF,1));
         [LabelsE,LabelsS] = FixTrackingEnds(MaxF,Labels,TimeRes,CentX,CentY,CentZ,minPDis,nc14);
        % replace old and new labels
        %spmd
        [~, MaxF] = ReplaceLabels(Labels,LabelsE,LabelsS,MaxF);
        [~, CentX] = ReplaceLabels(Labels,LabelsE,LabelsS,CentX);
        [~, CentY] = ReplaceLabels(Labels,LabelsE,LabelsS,CentY);
        [Labels, CentZ] = ReplaceLabels(Labels,LabelsE,LabelsS,CentZ);
        [MedFilt, OnOff,Properties, Fig] = DefineExpAll(MaxF,[NaN],CentX,Labels,Baseline,TimeRes,Smooth,SplitShortLong,SplitEarly,nc14,Delay,minOn);
        [Properties] = ReplaceLabelsProps(Labels,LabelsE,LabelsS,Properties);
        disp('tracking fixed')
        
         Selected = [Properties.Type=='EarlyOnly'|Properties.Type=='ShortMidline'|Properties.Type=='LongMidline'];
    if sum(Selected) == 0
        Selected = logical(Selected +1);
    end
    % count bursts and frequency
    [BurstNum,BurstLength,BurstPeriod,BurstPeak,BurstMax,OffTimeAll] = CountBursts(MaxF,OnOff, Selected,minOn,1,TimeRes);
    TimeScale = ([1: Frames] - nc14+Delay).*TimeRes./60;
    Limits = [(1 - nc14+Delay).*TimeRes./60, 90];
    
    PlotSelected(Selected, TimeScale,Baseline,MaxF,MedFilt,OnOff,Properties,BurstPeak,TimeRes,Bits,nc14, Delay,Limits,[PathToSave,'_selected.ps']);
  
        %%   
        MedFilt = 3; %%3 in px
InputLow = 0; %%0.1
InputHigh = 1;
%if round(Zoom,2) == 0.75; LogRadius = 5; end
%if round(Zoom,2) == 2; LogRadius = 15; end %15 for zoom, 5 for zoomed out
LogRadius = 4./XYRes*0.4;
ThresLevel = 0.05;
DiskSize = round(1.5./XYRes); %in px, not used?
WatershedParameter = 1;
Thicken = round(1./XYRes); %in px
RemoveSize = round(10./(XYRes^2.*ZRes)); %10 um^3 in px volume. nc14 nuc is aprox 33 um^3

        f = max(round(45*60/TimeRes)+nc14-Delay,1);

         toThreshold = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,2,f);
   [toThreshold] = Filter_3D(toThreshold, MedFilt, 'off');
    [toThreshold] = ContrastMSD_3D(toThreshold,InputLow, InputHigh,Bits,'off');
    [Dummy1 ,Dummy2 , Dummy3] = SegmentEmbryo_3D(toThreshold,LogRadius, @ThresLabNBs_3D, num2cell([RemoveSize DiskSize WatershedParameter RemoveSize ThresLevel Thicken]),'off',[XYRes,XYRes,ZRes]);
    toTrack(:,:,:,f) = Dummy1;
    Segmented_RGB(:,:,:,f) = Dummy2(:,:,:,1);
    Stats_table = Dummy3{1,1}; 
    Stats_table.Nuc = [1:height(Stats_table)]'
    
    %% assign spots to nuc
    
  %load([PathToSave,'_Stats.mat']);
  %Stats_GFP = Stats_GFP.Stats_GFP;
    Properties.Nuc = nan(height(Properties),1);
    for Index = 1:size(MaxF,2)
        disp(Index)
        FramesOn = find(MaxF(:,Index) ~= 0 & isnan(MaxF(:,Index))==0);
        NucList = [];
        for f = 1:length(FramesOn)
                    
            %Properties.Label;
            SpotX = CentX(FramesOn(f),Index);
            SpotY = CentY(FramesOn(f),Index);
            SpotZ = CentZ(FramesOn(f),Index);
            eucledian = sqrt((SpotX - Stats_GFP{FramesOn(f)}.Centroid(:,1)).^2 +     (SpotY - Stats_GFP{FramesOn(f)}.Centroid(:,2)).^2 +     (SpotZ - Stats_GFP{FramesOn(f)}.Centroid(:,3)).^2);
            closest = find(eucledian == min(eucledian));
            NucList = [NucList,Stats_GFP{FramesOn(f)}.Label(closest)]
       
        end
            Properties.Nuc(Index) = mode(NucList);

    end
    
    %%
    
    [U, I] = unique(Properties.Nuc, 'first');
    x = 1:length(Properties.Nuc);
    x(I) = []; Duplicates = Properties.Nuc(x)
    Properties(Properties.Nuc == Duplicates(1),:)
    
    %%
    
    Nuc = unique(Properties.Nuc)
    
    
    for n = 1:(floor(length(Nuc)/30)+1)
    disp([num2str(n),'/',num2str((floor(length(find(Selected))/30)+1))])
    Fig = figure('PaperSize',[30 50],'PaperUnits','inches','resize','on', 'visible','off');
        for i=1:30
            try
            Which = Properties.Nuc == Nuc((n-1)*30+i);
            Tracks = MaxF(:,Which);
            if isempty(Tracks) == 0
            subplot(10,3,i); plot(TimeScale,Tracks); hold on;
             ylim([0, 2^(Bits+1.5)-1]);
            xlim([-20,90]);
            title(join(['#',num2str(Properties.Nuc((n-1)*30+i)),' ',Properties.Type((n-1)*30+i)]));
            hold off
            end
        end
        end
     if n==1
          print(Fig,[PathToSave,'_nuc_2spots.ps'],'-fillpage', '-dpsc');
     else
          print(Fig,[PathToSave,'_nuc_2spots.ps'],'-fillpage', '-dpsc','-append');
     end
    end
    close all