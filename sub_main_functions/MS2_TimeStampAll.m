function[]=MS2_TimeStampAll(Path,File,Name,manual);
% BEFORE START DO manual = true
%%
if manual == true
    [File,Path] = uigetfile('*.*','select file for name / MAX.tif','/Volumes/JFS/MS2/');
    Name = '_3D/'
    Nickname='m5m8peve Ez'; Rep = 1;
end  
    PathToSave = [Path,File,Name,File]; 
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
    catch
        disp('Comments not found! set Flip, nc14 and delay');   
    end


reader = bfGetReader([Path,File]);
[Bits,Width,Height, Channels, Slices, Frames, Frames0, XRes, YRes, ZRes,Zoom,TimeRes,Settings] = readMetadataBFOME(reader);
try
    XYRes=mean(round(mean([XRes,YRes]),2));
    ZRes = mean(round(ZRes,2));
end

%
To=Frames-1;
Frames = To-From;

if manual
Metadata = readtable('~/Google Drive/MATLAB_R_scripts/metadata MS2 3D.txt','Delimiter', '\t');
NewMetadata = cell2table({Path,File,Name,Frames,Bits,TimeRes,XYRes,ZRes,...
  Delay,Nickname, Rep,Zoom,strjoin(arrayfun(@(x) num2str(x),Flip,'UniformOutput',false),','),From,nc14,To,[Notes,' ',Settings]},...
    'VariableNames', {'Path','File','Name','Frames', 'Bits','TimeRes','XYRes','ZRes','Delay','Nickname','Rep','Zoom','Flip','From','nc14','To','Notes'});
SaveMetadata = [Metadata;NewMetadata];
writetable(SaveMetadata,'~/Google Drive/MATLAB_R_scripts/metadata MS2 3D.txt','Delimiter', '\t');
end
%%
Boundaries_RGB = Read3dRGB([PathToSave, '_segmented_tracked_boundaries_RGB.tiff']);
[Boundaries_RGB] = TimeStamp(uint8(Boundaries_RGB),TimeRes,nc14,Delay);
WriteRGB(double(Boundaries_RGB), PathToSave, '_segmented_tracked_boundaries_RGB.tiff','none')

try
FTL_tracked_divisions_RGB = Read3dRGB([PathToSave, '_segmented_tracked_divisions_RGB.tiff']);
[FTL_tracked_divisions_RGB] = TimeStamp(uint8(FTL_tracked_divisions_RGB),TimeRes,nc14,Delay);
WriteRGB(double(FTL_tracked_divisions_RGB), PathToSave, '_segmented_tracked_divisions_RGB.tiff','none')
end

Merged_meanF_maxGFP = uint8(Read3d([PathToSave, '_maxF_maxGFP.tiff']));
Merged_meanF_maxGFP = permute(Merged_meanF_maxGFP,[1,2,4,3]);
Merged_meanF_maxGFP_RGB = cat(3,Merged_meanF_maxGFP,Merged_meanF_maxGFP,Merged_meanF_maxGFP);
[Merged_meanF_maxGFP_RGB] = TimeStamp(Merged_meanF_maxGFP_RGB,TimeRes,nc14,Delay);
Merged_meanF_maxGFP(:,:,:) = Merged_meanF_maxGFP_RGB(:,:,1,:);
Merged_meanF_maxGFP = permute(Merged_meanF_maxGFP,[1,2,4,3]);
Write8b(double(Merged_meanF_maxGFP), PathToSave, '_maxF_maxGFP.tiff')

FTL_tracked_meanF_maxGFP_boundaries_selected = Read3dRGB([PathToSave, '_maxF+SelAll.tiff']);
[FTL_tracked_meanF_maxGFP_boundaries_selected] = TimeStamp(uint8(FTL_tracked_meanF_maxGFP_boundaries_selected),TimeRes,nc14,Delay);
WriteRGB(double(FTL_tracked_meanF_maxGFP_boundaries_selected), PathToSave, '_maxF+SelAll.tiff','none')

