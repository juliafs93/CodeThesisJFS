function[]=mainMS2_NucMemb_3D_fromBF(parameters,manual)
% BEFORE START DO manual = true
%%
if manual == true 
    clearvars('-except', 'manual') 
    [File,Path] = uigetfile('*.*','select file for name / MAX.tif','/Volumes/JFS/MS2/');
    Name = '_3D_nucmemb/'
    Nickname='KukRNAi m&z nup107'; Rep = 2; % CHANGE NICKNAME AND REPEAT # HERE
    mkdir([Path,File,Name])
    PathToSave = [Path,File,Name,File]; 
    show = 'on'
    
    Flip = [0,0] % first to flip vertically 2nd to flip horizontally
    From = 1;%230
    nc14 = 1;
    To='NA'; %NA
    Delay=0;
    Notes = '';
    try
        [Dummy,Comments] = system(['mdls -raw -name kMDItemFinderComment "',Path,File,'"'])
        Comments = strsplit(Comments,', ');
        try;Index = find(cellfun(@(x) isempty(x), strfind(lower(Comments),'flip')) == 0);
        D = Comments{Index}; D = strsplit(D,' '); Flip = [str2num(D{2}(1)),str2num(D{2}(2))];end
        try;Index = find(cellfun(@(x) isempty(x), strfind(lower(Comments),'nc14')) == 0);
        D = Comments{Index}; D = strsplit(D,' '); nc14 = str2num(D{2});end
        try;Index = find(cellfun(@(x) isempty(x), strfind(lower(Comments),'delay')) == 0);
        D = Comments{Index}; D = strsplit(D,' '); Delay = str2num(D{2});end
        try;Index = find(cellfun(@(x) isempty(x), strfind(lower(Comments),'to')) == 0);
        D = Comments{Index}; D = strsplit(D,' '); To = str2num(D{2});end
        try;Index = find(cellfun(@(x) isempty(x), strfind(lower(Comments),'from')) == 0);
        D = Comments{Index}; D = strsplit(D,' '); From = str2num(D{2});end
    catch
        disp('Comments not found! set Flip, nc14 and delay');   
    end

    Divisions = 1;
    Spots = 0

else
    [Path, File, Name, Nickname, Rep, From,nc14,To,TimeRes, Delay,Flip, Notes,Divisions,Spots] = parameters{:};
    %To=NaN;
    mkdir([Path,File,Name]) %uncomment
    PathToSave = [Path,File,Name,File]; %uncomment
    show = 'off';
end

%

reader = bfGetReader([Path,File]);
[Bits,Width,Height, Channels, Slices, Frames, Frames0, XRes, YRes, ZRes,Zoom,TimeRes,Settings] = readMetadataBFOME(reader);
try
    XYRes=mean(round(mean([XRes,YRes]),2));
    ZRes = abs(mean(round(ZRes,2)));
end

%
if strcmp(To,'NA')==1; To=Frames-1;
else
    if isnumeric(To) == 0 
        To = str2num(To); end; end;
%
Frames = To-From;


%
if manual
    MetaFile = ' Dillan';
    Metadata = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter', '\t');
    NewMetadata = cell2table({Path,File,Name,Frames,Slices,Bits,TimeRes,XYRes,ZRes,...
      Delay,Nickname, Rep,Zoom,strjoin(arrayfun(@(x) num2str(x),Flip,'UniformOutput',false),','),From,nc14,To,[Notes,' ',Settings]},...
        'VariableNames', {'Path','File','Name','Frames', 'Slices','Bits','TimeRes','XYRes','ZRes','Delay','Nickname','Rep','Zoom','Flip','From','nc14','To','Notes'});
    SaveMetadata = [Metadata;NewMetadata];
    writetable(SaveMetadata,['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'Delimiter', '\t');
end
%%
Membranes = 0
NucMemb = 1
MedFilt = 3; %%3 in px
InputLow = 0; %%0.1
InputHigh = 1; % was 1
%if round(Zoom,2) == 0.75; LogRadius = 5; end
%if round(Zoom,2) == 2; LogRadius = 15; end %15 for zoom, 5 for zoomed out
LogRadius = 4./XYRes*0.4; %0.4 from HG's scripts
ThresLevel = 0.05;
DiskSize = round(1.5./XYRes); %in px, not used?
WatershedParameter = 1; % was 1
Thicken = round(1./XYRes); %in px
RemoveSize = round(10./(XYRes^2.*ZRes)); %10 um^3 in px volume. nc14 nuc is aprox 33 um^3
Distance = 6; %nuclei allowed to move 6um
%if Zoom == 0.75; Distance = 12; end
%if Zoom == 2; Distance = 15; end %15p for zoom, 12p for zoomed out
MaxN = 2;
%Divisions = 1;

toTrack = zeros(Height, Width, Slices,Frames);
Segmented_RGB = zeros(Height, Width, 3,Frames);
Stats_table = cell(Frames,1);

% THESE ARE THE IMPORTANT PARAMETERS FOR NUCLEAR MEMBRANES
if NucMemb
    ThresLevel = 0.2 %FIXED THRESHOLD LEVEL FOR INITIAL SEGMENTATION
    %ThresLevel = 0.1 for nupGFP, 0.25 for nupRFP high gain
    GaussFilt = 1; %GAUSSIAN FILTERING RADIUS
    WatershedParameter = 0.25; % AMOUNT OF WATERSHEDING (when lower more watershed, when higher less)
    Thicken = 2; % leave at 2
    RemoveSize = 10; % objects smaller than this (in um^3) will be deleted
    RemoveSizeHigh = 200; % objects bigger than this (in um^3) will be deleted
    Divisions = 1; %leave at 1. how to fix conflicts when two nuclei match to 1. it will add new labels for both of them but most likely match can be fixed afterwards
    Distance = 4; % maximum distance (in um) for finding a closest neighbour
    MaxN = 5; % maximum # of frames back that tries to find a closest neighbour, if no one found, a new label is created

    toTrack = zeros(Height, Width, round(Slices*ZRes/XYRes),Frames);
end


if Channels == 1
    ChannelToTrack = 1;
else
    ChannelToTrack = 2;
end

disp(['filtering ref frame, f',num2str(nc14),'...']);
    toThreshold = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,ChannelToTrack,nc14);
    toThreshold = imresize3(toThreshold,[Width,Height,round(Slices*ZRes/XYRes)]);
    refFilt = imgaussfilt3(toThreshold,GaussFilt)./(2^Bits-1);
%%
MaxL = 1; 

for f = 1:Frames
    disp(['reading and segmenting f',num2str(f),'...']);
    toThreshold = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,ChannelToTrack,f);
    if Membranes
        toThreshold = imresize3(toThreshold,[Width,Height,round(Slices*ZRes/XYRes)]);
    end
    if NucMemb
        % resize to make isotropic voxels
        toThreshold = imresize3(toThreshold,[Width,Height,round(Slices*ZRes/XYRes)]);
        parameters = num2cell([GaussFilt, ThresLevel, Width, Height, Slices, XYRes, XYRes, Bits, WatershedParameter, Thicken, RemoveSize, RemoveSizeHigh]);
        [Dummy1,Dummy2,Dummy3] = ThresNucMemb_3D(toThreshold, parameters, refFilt);
    else
        [toThreshold] = Filter_3D(toThreshold, MedFilt, 'off');
        [toThreshold] = ContrastMSD_3D(toThreshold,InputLow, InputHigh,Bits,'off');
        [Dummy1 ,Dummy2 , Dummy3] = SegmentEmbryo_3D(toThreshold,LogRadius, @ThresLabNBs_3D, num2cell([RemoveSize DiskSize WatershedParameter RemoveSize ThresLevel Thicken]),'off',[XYRes,XYRes,ZRes]);
    end
    toTrack(:,:,:,f) = Dummy1;
    Segmented_RGB(:,:,:,f) = Dummy2(:,:,:,1);
    Stats_table{f,1} = Dummy3{1,1}; 
    MaxL = max(MaxL, max(max(max(Dummy1))));
end

% new ZRes after isotropic voxels, old one stored
if NucMemb
    ZResOld = ZRes; ZRes = XYRes;
    
     %Description = sprintf('ImageJ=1.48c\nimages=%s\nchannels=1\nslices=%s\nframes=%s\nhyperstack=true\nloop=false\n',...
    %num2str(size(toTrack,3)*size(toTrack,4)),num2str(size(toTrack,3)),num2str(size(toTrack,4)));
    %Write4D(toTrack, PathToSave, '_segmented4D.tiff', Description);
end
%mov = immovie(Segmented_RGB);
%implay(mov);
%clear Segmented_RGB
%clear mov

  %% to rescue right labels from toTrack even if already started tracking
% MaxL = 1;
% for f = 1:200
%         disp(['reading and segmenting f',num2str(f),'...']);
%         TL = toTrack(:,:,:,f);
%         TL = bwlabeln(TL,6);
%          Stats = regionprops('table',TL,'Area','Centroid','BoundingBox');  
%         
%          Stats.Label = [1:length(Stats.Area)]';
% %         ToRemove = find((Stats.Area.*(XYRes^3) < RemoveSize) | (Stats.Area.*(XYRes^3) > RemoveSizeHigh) | (Stats.BoundingBox(:,1) < 1));
% %         Stats(ToRemove,:) = [];
% %         PixelsToRemove = ismember(TL,ToRemove);
% %         %REmoved = zeros(size(TL)); REmoved(PixelsToRemove) = 1;
% %         TL(PixelsToRemove) = 0;
% %         close all
% %         TL = bwlabeln(TL,6);
% %         
%          %Stats = regionprops('table',TL,'Area','Centroid','BoundingBox');  
%          Stats_table{f,1} = Stats;
%         toTrack(:,:,:,f) = TL;
%         MaxL = max(MaxL, max(max(max(TL))));
% end
% clear toTrack2
% %
%% tracking
% cant put into function because it would duplicate toTrack when modifying
% it and it crashes

    cmap = jet(1000000);
    cmap_shuffled = cmap(randperm(size(cmap,1)),:);
    newLabel=MaxL+1;
    Stats_table{1,:}.Label = (1:size(Stats_table{1,:},1))';
    if Divisions
            Stats_table{1,:}.Parent = zeros(size(Stats_table{1,:},1),1);
            Stats_table{1,:}.Daughters = zeros(size(Stats_table{1,:},1),2);
    end
    toReplace = Stats_table{1,:}(1,:); 
    for r = 1:size(toReplace,2); try; toReplace(1,r) = table(NaN);end; end
     
    TrackedBoundL = zeros(Height, Width,Frames);
    TrackedBoundL(:,:,1) = MAX_proj_3D(toTrack(:,:,:,1));
    for f=2:size(toTrack,4)
        disp(['frame ',num2str(f-1),' to ',num2str(f)])
        F1_0 = toTrack(:,:,:,f);
        F1_t = zeros(size(toTrack(:,:,:,f)));
        FromT = f-MaxN; if FromT < 1; FromT = 1; end
        SubStats = Stats_table(FromT:f,1);
        [F1_t, ~, SubStats, newLabel] = TrackWithDivisions_3D(SubStats,F1_0,F1_t, cmap_shuffled,f,Distance,newLabel,MaxN,Divisions,toReplace,XYRes, ZRes);  %for others   
        toTrack(:,:,:,f) = F1_t(:,:,:);
        Stats_table(FromT:f,1) = SubStats;
        TrackedBoundL(:,:,f) = MAX_proj_3D(F1_t);
    end
    %[toTrack , ~, Stats_tracked] = Tracking_3D(toTrack, Stats_table, cmap_shuffled, Distance,MaxN,Divisions,'off','off');
    %clear Stats_table
    [BoundariesBW, Boundaries_RGB, ~] = BoundariesTracked_3D(toTrack,cmap_shuffled,show);
    %[Boundaries_RGB] = double(TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay));
    WriteRGB(Boundaries_RGB, PathToSave, '_segmented_tracked_boundaries_RGB.tiff','none')

    % write labels after cleaning
%if NucMemb    
    %Description = sprintf('ImageJ=1.48c\nimages=%s\nchannels=1\nslices=%s\nframes=%s\nhyperstack=true\nloop=false\n',...
    %num2str(size(toTrack,3)*size(toTrack,4)),num2str(size(toTrack,3)),num2str(size(toTrack,4)));
    %Write4D(toTrack, PathToSave, '_tracked4D.tiff', Description);
%    printLabels_new(Boundaries_RGB,Stats_table,2,'off', PathToSave, '_segmented_tracked_info.tiff','none')
%end
% %%
% toTrack2 = Read5d([PathToSave, '_segmented4D.tiff'],1,161,114);
% %toTrack = Read5d([PathToSave, '_tracked4D.tiff'],Channels,Slices,Frames);
% toTrack2 = permute(toTrack2,[1,2,4,5,3]);
% %imagesc(max(toTrack(:,:,:,1),[],3))
%  %%   
% 
%     %TrackedBoundL = MAX_proj_3D(toTrack);
%     if Divisions
%         [~,FTL_tracked_divisions_RGB,Phylogeny, Families] = PhylogenyDivisions(Stats_table,TrackedBoundL,1, Frames,cmap_shuffled,'on');
%         writetable(cell2table(Phylogeny),[Path,File,Name,File,'_phylogeny.txt']);
%         writetable(Families,[Path,File,Name,File,'_families.txt']);
%         clear Phylogeny; clear Families;
%         %[FTL_tracked_divisions_RGB] = double(TimeStamp(uint8(FTL_tracked_divisions_RGB),TimeRes,nc14,Delay));
%         WriteRGB(FTL_tracked_divisions_RGB, PathToSave, '_segmented_tracked_divisions_RGB.tiff','none')
%         clear FTL_tracked_divisions_RGB;
%     end
%     
%     boundariesL = BoundariesBW .* TrackedBoundL;
%     Write16b(boundariesL, PathToSave, '_boundariesL.tiff', 'none');
%     clear BoundariesBW; clear TrackedBoundL;
%     %

%% clean objects tracked for less than minimum after tracking and deleting 
% them from toTrack (CHANGE SO THAT IT DOES IT AFTER FIX TRACKING)

minNumb = 5

    [AllF] = MergeAll(Stats_table, TimeRes);
        AllF = splitvars(AllF);
        %
        Labels = unique(AllF.Label); LabelsOld = Labels;
        [Area] = Reshape(AllF,Frames,Labels,'Area','Label');
        
        noNaNnum = sum(~isnan(Area),1);
        ToDelete = (noNaNnum <= minNumb);
        % delete tracks less than minNumb
        LabelsToDelete = Labels(ToDelete);
        Labels(ToDelete) = [];
        Area(:,ToDelete) = [];

for f = 1:size(toTrack,4)
        disp(num2str(f))
        TL = toTrack(:,:,:,f);
        PixelsToRemove = ismember(TL,LabelsToDelete);
        TL(PixelsToRemove) = 0;
        toTrack(:,:,:,f) = TL;
end

 [~, Boundaries_RGB_clean, ~] = BoundariesTracked_3D(toTrack,cmap_shuffled,show);
    %[Boundaries_RGB] = double(TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay));
    WriteRGB(Boundaries_RGB_clean, PathToSave, '_segmented_tracked_boundaries_RGB_clean.tiff','none')
    printLabels_new(Boundaries_RGB,Stats_table,2,'off', PathToSave, '_segmented_tracked_info.tiff','none')


 %% rescue toTrack from Stats3D and delete discarded objects
% load([Path,File,Name,File,'_Stats3D.mat']);
% toTrack = zeros(Height,Width, round(Slices*ZResOld/XYRes), Frames);
%     for f = 1:length(Stats_tracked_3D)
%         disp(num2str(f))
%          SingleFrame = Stats_tracked_3D{f};
%          Tracked3D = zeros(Height,Width,round(Slices*ZResOld/XYRes));
%          for n = 1:size(SingleFrame,1)
%              Tracked3D(SingleFrame.VoxelIdxList{n}) =  SingleFrame.Label(n);
%          end
%           %PixelsToRemove = ismember(Tracked3D,LabelsToDelete);
%           %Tracked3D(PixelsToRemove) = 0;
%          toTrack(:,:,:,f) = Tracked3D;
%     end
    
     %[~, Boundaries_RGB_clean, ~] = BoundariesTracked_3D(toTrack,cmap_shuffled,show);
%     %[Boundaries_RGB] = double(TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay));
%     %WriteRGB(Boundaries_RGB_clean, PathToSave, '_segmented_tracked_boundaries_RGB_clean.tiff','none')
%     %printLabels_new(Boundaries_RGB,Stats_table,2,'off', PathToSave, '_segmented_tracked_info.tiff','none')

%% rescue toTrack from Stats_GFP
% toTrack = zeros(Height,Width, round(Slices*ZResOld/XYRes), Frames);
%     for f = 1:length(Stats_GFP)
%         disp(num2str(f))
%          SingleFrame = Stats_GFP{f};
%          Tracked3D = zeros(Height,Width,  round(Slices*ZResOld/XYRes));
%          for n = 1:size(SingleFrame,1)
%              Tracked3D(SingleFrame.PixelIdxList{n}) =  SingleFrame.Label(n);
%          end
%          toTrack(:,:,:,f) = Tracked3D;
%     end

%% GET 3D PROPERTIES OF NUCLEI AND 2D PROPERTIES IN CENTER SLICE
if NucMemb

Stats_tracked_3D = cell(Frames,1);
Stats_tracked_2D_Q1 = cell(Frames,1);
Stats_tracked_2D_Q2 = cell(Frames,1);
Stats_tracked_2D_Q3 = cell(Frames,1);
PropObjects = zeros(Frames,round(Slices*ZResOld/XYRes));

Fig = figure;
set(Fig,'Visible', 'on','PaperOrientation','landscape');
cmapgrad = parula(Frames*4);
set(gcf,'defaultAxesColorOrder',cmapgrad)
for f = 1:Frames
        disp(['running regionprops f',num2str(f),'...']);
        TL = toTrack(:,:,:,f);
        Stats3 = regionprops3(TL,'BoundingBox','Centroid','ConvexVolume',...
           'Orientation','PrincipalAxisLength','Solidity','SurfaceArea',...
           'Volume','VoxelIdxList');
        
        Stats3.Label = [1:length(Stats3.Volume)]';
        ToRemove = find(Stats3.Volume == 0);
        Stats3(ToRemove,:) = [];
        Stats_tracked_3D{f,1} = Stats3;
        
        %P = permute(TL==0,[3,2,1]);
        %P = sum(P,3); P = 1-sum(P,2)./max(sum(P,2));
        %plot(P); hold on
        %drawnow
        %[~,CenterSlice] = max(P); % center slice is where biggest proportion of objects in the frame
        for s = 1:size(TL,3)
            P(s) = sum(unique(TL(:,:,s))~=0);
        end
        
        if sum(P~=0) > 0
            P = P./max(P);
            plot(P); hold on
            PropObjects(f,:) = P;
            Indices = find(P>0.5);
            %CenterSlice = Indices(round(length(Indices)/2)); % center slice is the slice in the center of the top 50% of unique labels
            Slice25(f) = Indices(round(length(Indices)*0.25)); % center slice is the slice in the center of the top 50% of unique labels
            Slice50(f) = Indices(round(length(Indices)*0.5)); % center slice is the slice in the center of the top 50% of unique labels
            Slice75(f) = Indices(round(length(Indices)*0.75)); % center slice is the slice in the center of the top 50% of unique labels

            plot(Slice25(f),0.25,'.')
            plot(Slice50(f),0.5,'.')
            plot(Slice75(f),0.75,'.')

            drawnow

            Stats25 = regionprops('table',TL(:,:,Slice25(f)),'Area','BoundingBox',...
                'Centroid','ConvexArea','Eccentricity','EquivDiameter',...
                'Extent','Perimeter','Solidity');
            Stats25.Label = [1:length(Stats25.Area)]';
            ToRemove = find(Stats25.Area == 0);
            Stats25(ToRemove,:) = [];
            Stats_tracked_2D_Q1{f,1} = Stats25;

            Stats50 = regionprops('table',TL(:,:,Slice50(f)),'Area','BoundingBox',...
                'Centroid','ConvexArea','Eccentricity','EquivDiameter',...
                'Extent','Perimeter','Solidity');
            Stats50.Label = [1:length(Stats50.Area)]';
            ToRemove = find(Stats50.Area == 0);
            Stats50(ToRemove,:) = [];
            Stats_tracked_2D_Q2{f,1} = Stats50;

            Stats75 = regionprops('table',TL(:,:,Slice75(f)),'Area','BoundingBox',...
                'Centroid','ConvexArea','Eccentricity','EquivDiameter',...
                'Extent','Perimeter','Solidity');
            Stats75.Label = [1:length(Stats75.Area)]';
            ToRemove = find(Stats75.Area == 0);
            Stats75(ToRemove,:) = [];
            Stats_tracked_2D_Q3{f,1} = Stats75;
        else
            Slice25(f) = NaN;
            Slice50(f) = NaN;
            Slice75(f) = NaN;
            PropObjects(f,:) = NaN;
        end
end

save([Path,File,Name,File,'_Stats3D.mat'],'Stats_tracked_3D','-v7.3');
save([Path,File,Name,File,'_Stats2D_Q1.mat'],'Stats_tracked_2D_Q1','-v7.3');
save([Path,File,Name,File,'_Stats2D_Q2.mat'],'Stats_tracked_2D_Q2','-v7.3');
save([Path,File,Name,File,'_Stats2D_Q3.mat'],'Stats_tracked_2D_Q3','-v7.3');

print(Fig,[PathToSave,'_Slices.pdf'],'-fillpage', '-dpdf');

TableQ = array2table([(1:Frames)',Slice25', Slice50', Slice75'],'VariableNames',{'Frame','SliceQ1','SliceQ2','SliceQ3'});
writetable(TableQ,[PathToSave,'_Slices.txt'],'Delimiter','\t')
%writetable(PropObjects,[PathToSave,'_PropObjects.txt'],'Delimiter','\t')
Data3D.PropObjects = PropObjects;
Data3D.QuartileSlices = TableQ;

Data3D = NuclearMembraneProperties(0, Path, File, Name, Stats_tracked_3D, TimeRes, Frames, nc14, Delay, Data3D);
save([Path,File,Name,File,'_Data3D.mat'],'Data3D','-v7.3');

end  


%%
if NucMemb
    parameters = table(Bits,Channels,Slices, sum(Frames0),Frames,Width,Height,From, To, GaussFilt,InputLow,InputHigh,LogRadius,ThresLevel,WatershedParameter,DiskSize,Thicken,RemoveSize,RemoveSizeHigh,Distance,MaxN,TimeRes,XYRes,ZRes,Flip,Zoom);
    writetable(parameters,[Path,File,Name,File,'_parameters.txt']);
end
   %% measures fluorescence in ms2mcp channel

   MAX_G = zeros(Height, Width,Frames);
   Stats_GFP = cell(Frames,1);
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
    if NucMemb
        % resize to make isotropic voxels
        G = imresize3(G,[Width,Height,round(Slices*ZResOld/XYRes)]);
    end
    [Stats, ~, ~] = getStatsF_3D(toTrack(:,:,:,f), G); 
    [Stats] = PrintF_3D(Stats,Path,File,Name,0);
    MAX_G(:,:,f) = MAX_proj_3D(G);
    if Spots ~= 0
        GSeg = zeros(Height, Width,Slices);
        GGaussF = zeros(Height, Width,Slices);
        Threshold = 150;
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
        SpotsLabelled = bwlabeln(GSeg,6);
        [StatsS, ~, ~] = getStatsF_3D(SpotsLabelled, GGaussF); 
        StatsSpots{f} = StatsS{1,1};
        
        GSeg = max(GSeg,[],3);
        GSeg = bwmorph(GSeg, 'thicken',3);
        GSeg = GSeg*4095;
        MAX_GSeg(:,:,f) = GSeg;
        MAX_GGaussF(:,:,f) = max(GGaussF,[],3);
 
        [StatsGauss, ~, ~] = getStatsF_3D(toTrack(:,:,:,f), GGaussF); 
        [StatsGauss] = PrintF_3D(StatsGauss,Path,File,Name,Spots);
        try
            Stats{1,1}.MaxGauss = StatsGauss{1,1}.Max;
            Stats{1,1}.PositionGaussX = StatsGauss{1,1}.SpotPositionX;
            Stats{1,1}.PositionGaussY = StatsGauss{1,1}.SpotPositionY;
            Stats{1,1}.PositionGaussZ = StatsGauss{1,1}.SpotPositionZ;
            [ReplacedSpots] = ReplaceLabelsbyF_3D(toTrack(:,:,:,f), Stats, 0,2^(Bits+1)-1,'MaxGauss');
            MAX_meanFGauss(:,:,f) = max(ReplacedSpots,[],3);
            Stats{1,1}.MaxGauss2 = StatsGauss{1,1}.Max2;
            Stats{1,1}.Position2GaussX = StatsGauss{1,1}.Spot2PositionX;
            Stats{1,1}.Position2GaussY = StatsGauss{1,1}.Spot2PositionY;
            Stats{1,1}.Position2GaussZ = StatsGauss{1,1}.Spot2PositionZ;
        end
    end    
    [toTrack(:,:,:,f)] = ReplaceLabelsbyF_3D(toTrack(:,:,:,f), Stats, 0,2^Bits-1,'Max');
    Stats_GFP{f,1} = Stats{1,1};
end
clear G
%
%%


%%
MAX_meanF = MAX_proj_3D(toTrack);
clear toTrack
Merged_meanF_maxGFP = (MAX_G./(2.^(Bits-8))+MAX_meanF);
Merged_meanF_maxGFP = uint8(permute(Merged_meanF_maxGFP,[1,2,4,3]));
Merged_meanF_maxGFP_RGB = cat(3,Merged_meanF_maxGFP,Merged_meanF_maxGFP,Merged_meanF_maxGFP);
[Merged_meanF_maxGFP_RGB] = TimeStamp(Merged_meanF_maxGFP_RGB,TimeRes,nc14,Delay);
Merged_meanF_maxGFP(:,:,:) = Merged_meanF_maxGFP_RGB(:,:,1,:);
Merged_meanF_maxGFP = double(permute(Merged_meanF_maxGFP,[1,2,4,3]));
Write8b(Merged_meanF_maxGFP, PathToSave, '_maxF_maxGFP.tiff')

if Spots ~= 0
    Merged_meanF_maxGFPGauss = (MAX_G./(2.^(Bits-8))+MAX_meanFGauss);
    Merged_meanF_maxGFPGauss = uint8(permute(Merged_meanF_maxGFPGauss,[1,2,4,3]));
    Merged_meanF_maxGFP_RGB = cat(3,Merged_meanF_maxGFPGauss,Merged_meanF_maxGFPGauss,Merged_meanF_maxGFPGauss);
    [Merged_meanF_maxGFP_RGB] = TimeStamp(Merged_meanF_maxGFP_RGB,TimeRes,nc14,Delay);
    Merged_meanF_maxGFPGauss(:,:,:) = Merged_meanF_maxGFP_RGB(:,:,1,:);
    Merged_meanF_maxGFPGauss = double(permute(Merged_meanF_maxGFPGauss,[1,2,4,3]));
    Write8b(Merged_meanF_maxGFPGauss, PathToSave, '_maxF_maxGFP_Gauss.tiff')
    
    Merged_meanF_maxGFPGauss = (MAX_G./(2.^(Bits-8))+MAX_GSeg./(2.^(Bits-8+1)));
    Merged_meanF_maxGFPGauss = uint8(permute(Merged_meanF_maxGFPGauss,[1,2,4,3]));
    Merged_meanF_maxGFP_RGB = cat(3,Merged_meanF_maxGFPGauss,Merged_meanF_maxGFPGauss,Merged_meanF_maxGFPGauss);
    [Merged_meanF_maxGFP_RGB] = TimeStamp(Merged_meanF_maxGFP_RGB,TimeRes,nc14,Delay);
    Merged_meanF_maxGFPGauss(:,:,:) = Merged_meanF_maxGFP_RGB(:,:,1,:);
    Merged_meanF_maxGFPGauss = double(permute(Merged_meanF_maxGFPGauss,[1,2,4,3]));
    Write8b(Merged_meanF_maxGFPGauss, PathToSave, '_maxF_maxGFP_Spots.tiff')
end

if Spots == 2
    [Stats_GFP] = Retrack2Spots(Stats_GFP);
end

parameters = table(Bits,Channels,Slices, sum(Frames0),Frames,Width,Height,From, To, MedFilt,InputLow,InputHigh,LogRadius,ThresLevel,WatershedParameter,DiskSize,Thicken,RemoveSize,Distance,MaxN,TimeRes,XYRes,ZRes,Flip,Zoom);
writetable(parameters,[Path,File,Name,File,'_parameters.txt']);
%

disp('done')
save([Path,File,Name,File,'_Stats.mat'],'Stats_GFP','-v7.3');

% save in metadata
% minNumber = 10;
% MinOn = 5;
% BinMins = 3;
%system(['/usr/local/bin/Rscript --verbose ~julia/Google\ Drive/MATLAB_R_scripts/RunfromMatlab.R ',num2str(minNumber),' ',num2str(MinOn),' ',num2str(BinMins)]);
% to select cells fromR


%% to segment green in 2D
% if Spots
%     MedFilt = 0;SigmaFilt = 1; %%3
%     InputLow = 0; %%0.1
%     InputHigh = 0.5;
%     if round(Zoom,2) == 0.75; LogRadius = 1; end
%     if round(Zoom,2) == 2; LogRadius = 1.5; end %15 for zoom, 5 for zoomed out
%     ThresLevel = 0.03;
%     DiskSize = 1;
%     WatershedParameter = 0;
%     Thicken = 1;
%     RemoveSize = 5;
%     Distance = 4; %spots allowed to move 6um
%     %if Zoom == 0.75; Distance = 12; end
%     %if Zoom == 2; Distance = 15; end %15p for zoom, 12p for zoomed out
%     MaxN = 5;
%     Divisions = 1;
%     toTrack = zeros(Height, Width, Slices,Frames);
%     toThreshold3G = zeros(Height, Width,Frames);
%     Segmented_RGB = zeros(Height, Width, 3,Frames);
%     Stats_table = cell(Frames,1);
%     MaxL = 1; 
%     %
%     for f = 1:Frames
%         disp(['reading and filtering f',num2str(f),'...']);
%         toThreshold = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,1,f);
%        [toThreshold] = Filter_3D(toThreshold, MedFilt, 'off', SigmaFilt);
%         %[toThreshold] = ContrastMSD_3D(toThreshold,InputLow, InputHigh,Bits,'off');
%         toThreshold3G(:,:,f) =  MAX_proj_3D(toThreshold);
%         %     [Dummy1 ,Dummy2 , Dummy3] = SegmentEmbryo_3D(toThreshold,LogRadius, @ThresLabNBs_3D, num2cell([RemoveSize DiskSize WatershedParameter RemoveSize ThresLevel Thicken]),'off');
%     %     toTrack(:,:,:,f) = Dummy1;
%     %     Segmented_RGB(:,:,:,f) = Dummy2(:,:,:,1);
%     %     Stats_table{f,1} = Dummy3{1,1}; 
%     %     MaxL = max(MaxL, max(max(max(Dummy1))));
%     end
%     [toThreshold3G] = Contrast(toThreshold3G, InputLow, InputHigh,0,Bits,show);
%     [FTL_G FTL_RGB_G Stats_table_G] = FindSpots(toThreshold3G, @ThresLab, num2cell([LogRadius ThresLevel RemoveSize 3]),Bits,show);
%     %
%     SplitTrack = 1; Fill = 0; Divisions = 1;
%     cmap = jet(1000000);   
%     cmap_shuffled = cmap(randperm(size(cmap,1)),:);
%     [FTL_tracked FTL_tracked_RGB Stats_tracked] = Tracking2modes(FTL_G, Stats_table_G, @Tracknextframe5, cmap_shuffled, 0,Distance,0,MaxN,1,Frames,'off',SplitTrack,Fill,Divisions,XYRes,show);
% 
%        %%
%        MAX_G = zeros(Height, Width,Frames);
%        Stats_GFP_G = cell(Frames,1);
%     for f = 1:Frames
%         disp(['reading f',num2str(f),'...']);
%         G = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,1,f);
%         [Stats, ~, ~] = getStatsF_3Dmask(FTL_tracked(:,:,f), G); 
%         MAX_G(:,:,f) = MAX_proj_3D(G);
%         [Stats] = PrintF_3D(Stats,Path,File,Name,'on',f);
%         [toTrack(:,:,:,f)] = ReplaceLabelsbyF_3D(toTrack(:,:,:,f), Stats, 0,2^Bits-1,'Max');
%         Stats_GFP_G{f,1} = Stats{1,1};
%     end
%     clear G
%     %
%     MAX_meanF = MAX_proj_3D(toTrack);
%     save([Path,File,Name,File,'_Stats_G.mat'],'Stats_GFP_G','-v7.3');
%     clear toTrack
%     Merged_meanF_maxGFP = (MAX_G./(2.^(Bits-8))+MAX_meanF);
%     Write8b(Merged_meanF_maxGFP, PathToSave, '_maxF_maxGFP_G.tiff')
%     % FIX tracking
%     minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 20;
%     [PropAll] = AnalyzeTraces(Stats_GFP_G,TimeRes,Frames,Bits,XYRes, ZRes,Width, Height,minNumb,Smooth, minOn,minPDis,SplitShortLong,SplitEarly,nc14,Delay,PathToSave,0);
% 
% end

%%
minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;

if NucMemb
    minNumb = 5;
    [PropAll] = AnalyzeTraces(0,0,Spots,Stats_GFP,TimeRes,Frames,round(Slices*ZResOld/XYRes),Bits,XYRes, ZRes,Width, Height,minNumb,Smooth, minOn,minPDis,SplitShortLong,SplitEarly,nc14,Delay,PathToSave,Nickname,Rep);
else
    [PropAll] = AnalyzeTraces(0,0,Spots,Stats_GFP,TimeRes,Frames,Slices,Bits,XYRes, ZRes,Width, Height,minNumb,Smooth, minOn,minPDis,SplitShortLong,SplitEarly,nc14,Delay,PathToSave,Nickname,Rep); 
end
%%
% PropAll = readtable([Path,File,Name,'Properties_all.txt']);
% Type = PropAll.Type;
% dummy = cellfun(@(X) strcmp(X,'EarlyOnly')==1,Type, 'UniformOutput',false);
% EarlyOnly = PropAll.Label([dummy{:}]==1);
% dummy = cellfun(@(X) strcmp(X,'EarlyMidline')==1,Type, 'UniformOutput',false);
% EarlyMidline = PropAll.Label([dummy{:}]==1);
% dummy = cellfun(@(X) strcmp(X,'LateMidline')==1,Type, 'UniformOutput',false);
% LateMidline = PropAll.Label([dummy{:}]==1);
% dummy = cellfun(@(X) strcmp(X,'Gastrulated')==1,Type, 'UniformOutput',false);
% Gastrulated = PropAll.Label([dummy{:}]==1);
%%
%boundariesL = Read3d([PathToSave, '_boundariesL.tiff']);

%%
% EarlyOnly = PropAll.NewLabel(PropAll.Type == 'EarlyOnly'); EarlyOnly = [EarlyOnly{:}]
% EarlyMidline = PropAll.NewLabel(PropAll.Type == 'ShortMidline'); EarlyMidline = [EarlyMidline{:}];
% LateMidline = PropAll.NewLabel(PropAll.Type == 'LongMidline'); LateMidline = [LateMidline{:}]
% Gastrulated = PropAll.NewLabel(PropAll.Type == 'Gastrulated'); Gastrulated = [Gastrulated{:}]
% 
% %boundariesL_BG = ismember(boundariesL,BG')*1;
% boundariesL_EO = ismember(boundariesL,EarlyOnly')*2;
% boundariesL_EM = ismember(boundariesL,EarlyMidline')*6;
% boundariesL_LM = ismember(boundariesL,LateMidline')*9;
% boundariesL_GT = ismember(boundariesL,Gastrulated')*6;
% boundariesL_selected = boundariesL_EO + boundariesL_EM + boundariesL_LM + boundariesL_GT;
% clear boundariesL; clear boundariesL_EO;clear boundariesL_EM;clear boundariesL_LM;clear boundariesL_GT;
% 
% cmap_5 = parula(10);
% 
% boundariesL_selected_RGB = zeros(size(boundariesL_selected,1),size(boundariesL_selected,2),3,size(boundariesL_selected,4));
% for f = [1:size(boundariesL_selected,3)]
%     boundariesL_selected_RGB(:,:,:,f) = label2rgb(boundariesL_selected(:,:,f), cmap_5, 'k', 'noshuffle');
% end  
% FTL_tracked_meanF_maxGFP_noB_selected = ~boundariesL_selected.*Merged_meanF_maxGFP;
% [FTL_tracked_meanF_maxGFP_boundaries_selected] = Merge8bRGB(FTL_tracked_meanF_maxGFP_noB_selected, boundariesL_selected_RGB,'off');
% clear FTL_tracked_meanF_maxGFP_noB_selected
% clear boundariesL_selected
% %mov = immovie(FTL_tracked_meanF_maxGFP_boundaries_selected);
% %implay(mov)
% [FTL_tracked_meanF_maxGFP_boundaries_selected] = double(TimeStamp(uint8(FTL_tracked_meanF_maxGFP_boundaries_selected),TimeRes,nc14,Delay));
% WriteRGB(FTL_tracked_meanF_maxGFP_boundaries_selected, PathToSave, '_maxF+SelAll.tiff','none')
%
% Factor = 1; % 1 in macbook, 2 in pro
% printLabels_new(FTL_tracked_meanF_maxGFP_boundaries_selected,Stats_GFP,Factor,'off', PathToSave, '_segmented_tracked_info.tiff','packbits')
disp('finished!')
%
clear variables
close all
%% to print all boundaries
% 
% FTL_tracked_meanF_maxGFP_noB = ~BoundariesBW.*Merged_meanF_maxGFP;
% [FTL_tracked_meanF_maxGFP_boundaries] = Merge8bRGB(FTL_tracked_meanF_maxGFP_noB, Boundaries1_RGB,show);
% WriteRGB(FTL_tracked_meanF_maxGFP_boundaries, PathToSave, '_maxF_maxGFP+bound.tiff','none')
% clear Boundaries_RGB
% clear FTL_tracked_meanF_maxGFP_noB
% %%
% Merged_meanF_maxGFP_RGB(:,:,1,:) = Merged_meanF_maxGFP(:,:,:);
% Merged_meanF_maxGFP_RGB(:,:,2,:) = Merged_meanF_maxGFP(:,:,:);
% Merged_meanF_maxGFP_RGB(:,:,3,:) = Merged_meanF_maxGFP(:,:,:);
% 
% Factor = 2; % 1 in macbook, 2 in pro
% printLabels_new(Merged_meanF_maxGFP_RGB,Stats_GFP,Factor,'off', PathToSave, '_segmented_tracked_info.tiff','packbits')

end

