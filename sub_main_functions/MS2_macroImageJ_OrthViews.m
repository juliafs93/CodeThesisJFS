 function[]=MS2_macroImageJ_OrthViews(Path,File,manual,Channel1, Channel2)
% BEFORE START DO manual = true
%%
if manual == true
    [File,Path] = uigetfile('*.*','select file for name / MAX.tif','/Volumes/Mac OS/MS2/');
    Name = '_3D/'

    Nickname='m5m8peve gap43mCh'; Rep = 2; SplitEarly = 15; Channel1 = 'MCP'; Channel2 = 'memb';
    Nickname='m5m8peve DlmSca'; Rep = 2; SplitEarly = 15; Channel1 = 'MCP'; Channel2 = 'memb';
    Nickname='NiGFP'; Rep = 1; SplitEarly = 15; Channel1 = 'memb'; Channel2 = NaN;
    Nickname='sqhGFP DlmSca'; Rep = 3; SplitEarly = 15; Channel1 = 'memb'; Channel2 = 'memb';
    Nickname='spiderGFP hisRFP'; Rep = 2; SplitEarly = 15; Channel1 = 'memb'; Channel2 = 'his';
    Nickname='Nup107GFP'; Rep = 2; SplitEarly = 15; Channel1 = 'nucmemb'; Channel2 = NaN;
    Nickname='slam:+ DlmSca'; Rep = 2; SplitEarly = 15; Channel1 = 'memb'; Channel2 = NaN;


            
            %MetaFile = ' enhprom';
            %MetaFile = ' ecNICD';
            MetaFile = ' membranes';
            %MetaFile = ' nucmemb';
            %MetaFile = ' other';
            %MetaFile = ' javier';
           % MetaFile = ' 2c';
           MetaFile = '';

end  
    PathToSave = [Path,File]; 

    Flip = [0,0] % first to flip vertically 2nd to flip horizontally
    From = 1;%230
    nc14 = 1;
    To='NA'; %NA
    Delay=0;
    SplitEarly = 15;
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

if strcmp(To,'NA')==1; To=Frames-1;
else
    if isnumeric(To) == 0 
        To = str2num(To); end; end;
Frames = To-From;
%
%

if manual

Metadata = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'Delimiter', '\t');

NewMetadata = cell2table({Path,File,Name,Frames,Slices,Bits,TimeRes,XYRes,ZRes,...
  Delay,SplitEarly,Nickname, Rep,Zoom,strjoin(arrayfun(@(x) num2str(x),Flip,'UniformOutput',false),','),From,nc14,To,Channel1,Channel2,[Notes,' ',Settings]},...
    'VariableNames', {'Path','File','Name','Frames','Slices', 'Bits','TimeRes','XYRes','ZRes','Delay','SplitEarly','Nickname','Rep','Zoom','Flip','From','nc14','To','Channel1','Channel2','Notes'});
SaveMetadata = [Metadata;NewMetadata];
writetable(SaveMetadata,['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'Delimiter', '\t');
end

To=sum(Frames0)-1;
Frames = To-From;

%%
NewSlices = round(Slices*ZRes/XYRes);
RXYT = zeros(Height,Width,Frames);
GXYT = zeros(Height,Width,Frames);
RXZT = zeros(NewSlices,Width,Frames);
GXZT = zeros(NewSlices,Width,Frames);
RYZT = zeros(Height,NewSlices,Frames);
GYZT = zeros(Height,NewSlices,Frames);

if Channels == 3; 
    TLend = zeros(Height, Width,Frames);
end
%
OrthDepth = 3;
for f = 1:Frames
    disp(['reading f',num2str(f),'...']);
    
    if strcmp(Channel1,'memb') | strcmp(Channel1,'his') | strcmp(Channel1,'nucmemb')
        G = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,1,f);
        GXYT(:,:,f) = max(G(:,:,5:Slices-5),[],3);
        GYZT(:,:,f) = imresize(permute(max(G(:,round(Width/2)-OrthDepth:round(Width/2)+OrthDepth,:),[],2),[1,3,2]),[Height,NewSlices]);
        %GYZT(:,:,f) = imresize(permute(max(G(:,:,:),[],2),[1,3,2]),[Height,NewSlices]);
        GXZT(:,:,f) = imresize(permute(max(G(round(Height/2)-OrthDepth:round(Height/2)+OrthDepth,:,:),[],1),[3,2,1]),[NewSlices,Width]);
    end
    if strcmp(Channel1,'MCP') 
       G = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,1,f);
        GXYT(:,:,f) = max(G,[],3);
        GYZT(:,:,f) = imresize(permute(max(G,[],2),[1,3,2]),[Height,NewSlices]);
        GXZT(:,:,f) = imresize(permute(max(G,[],1),[3,2,1]),[NewSlices,Width]);
    end
    
    if Channels > 1 & (strcmp(Channel2,'memb') | strcmp(Channel2,'his')| strcmp(Channel2,'nucmemb') )      
        R = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,2,f);
        RXYT(:,:,f) = max(R(:,:,5:Slices-5),[],3);
        RYZT(:,:,f) = imresize(permute(max(R(:,round(Width/2)-OrthDepth:round(Width/2)+OrthDepth,:),[],2),[1,3,2]),[Height,NewSlices]);
        %RYZT(:,:,f) = imresize(permute(max(R(:,:,:),[],2),[1,3,2]),[Height,NewSlices]);
        RXZT(:,:,f) = imresize(permute(max(R(round(Height/2)-OrthDepth:round(Height/2)+OrthDepth,:,:),[],1),[3,2,1]),[NewSlices,Width]);
    elseif Channels > 1
        R = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,2,f);
        RXYT(:,:,f) = max(R,[],3);
        RYZT(:,:,f) = imresize(permute(max(R,[],2),[1,3,2]),[Height,NewSlices]);
        RXZT(:,:,f) = imresize(permute(max(R,[],1),[3,2,1]),[NewSlices,Width]);        
    end
    
    if Channels == 3
       TL = ReadSingleStack(reader,Channels,Slices,Frames0,Flip,From,3,f);
       TLend(:,:,f) = TL(:,:,Slices);
    end
end
%
% if Channels > 1
%     [XYT] = CombineGR(GXYT,RXYT,Bits);
%     [XZT] = CombineGR(GXZT,RXZT,Bits);
%     Combined = cat(1,XZT,XYT);
% else
%     [XYT] = CombineGR(GXYT,[],Bits);
%     [XZT] = CombineGR(GXZT,[],Bits);
%     Combined = cat(1,XZT,XYT);
% end
%% measure membrane length

if strcmp(Channel1,'memb') | strcmp(Channel1,'nucmemb')
    [MaxHeight1] = MeasureMembranes(GXZT,Bits);
    writetable(array2table(MaxHeight1'),[Path,File,'_MembraneLengthCh1.txt'],'Delimiter', '\t');  
end

if Channels > 1 & (strcmp(Channel2,'memb') | strcmp(Channel2,'nucmemb') )      
    [MaxHeight2] = MeasureMembranes(RXZT,Bits);
    writetable(array2table(MaxHeight2'),[Path,File,'_MembraneLengthCh2.txt'],'Delimiter', '\t');  
end

%% combine and save

if Channels == 2
    Combined1 = cat(2,zeros(NewSlices,NewSlices,Frames),RXZT,GXZT);
    Combined2 = cat(2,RYZT,RXYT,GXYT);
    Combined = cat(1,Combined1,Combined2).*2^(8-Bits);
    Combined = cat(4,Combined,Combined,Combined);
    Combined = permute(Combined,[1,2,4,3]);
end

if Channels == 1
    Combined1 = cat(2,zeros(NewSlices,NewSlices,Frames),GXZT);
    Combined2 = cat(2,GYZT,GXYT);
    Combined = cat(1,Combined1,Combined2).*2^(8-Bits);
    Combined = cat(4,Combined,Combined,Combined);
    Combined = permute(Combined,[1,2,4,3]);
end

    [Combined] = TimeStamp(uint8(Combined),TimeRes,nc14,Delay);

WriteRGB(Combined, PathToSave, '_CombinedOrthViews.tiff','none')
%
if Channels == 3
    TLRGB = permute(cat(4,TLend,TLend,TLend),[1,2,4,3]).*255./(2^Bits-1);
    Combined = cat(2,XYT,TLRGB);
    [Combined] = TimeStamp(Combined,TimeRes,nc14,Delay);
    WriteRGB(Combined, PathToSave, '_CombinedTL.tiff','none')
end

