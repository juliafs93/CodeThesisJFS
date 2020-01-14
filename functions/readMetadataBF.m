function[Bits,Width,Height, Channels, Slices, Frames, XRes, YRes, ZRes,Zoom,TimeRes] = readMetadataBF(LIF)

%%
Info = strsplit(string(LIF{1,2}),', ')';
%%
Bits = FindInMetadata(Info,'BitSize');
TimeRes = FindInMetadata(Info,'CycleTime');
Pinhole = FindInMetadata(Info,'|PinholeAiry');
ScanMode = FindInMetadata(Info,'ScanMode');
ScanMode = FindInMetadata(Info,'ScanSpeed');
Zoom = FindInMetadata(Info,'|Zoom');
Order = FindInMetadata(Info,'DimensionOrder');
Channels = FindInMetadata(Info,'SizeC');
Frames = FindInMetadata(Info,'SizeT');
Width = FindInMetadata(Info,'SizeX');
Height = FindInMetadata(Info,'SizeY');
Slices = FindInMetadata(Info,'SizeZ');

%%
%%
for s = 1:size(LIF,1)
Im1 = LIF{1,1}{1,1};
[Height,Width] = size(Im1);
Info1 =  strsplit(LIF{1,1}{1,2},'; ');
Which = find(cellfun(@(x) isempty(x),strfind(Info1, 'Z='))==0);
D = strsplit(Info1{Which},'/'); Slices(s) = str2num(D{2});
Which = find(cellfun(@(x) isempty(x),strfind(Info1, 'C='))==0);
D = strsplit(Info1{Which},'/'); Channels(s) = str2num(D{2});
Which = find(cellfun(@(x) isempty(x),strfind(Info1, 'T='))==0);
D = strsplit(Info1{Which},'/'); Frames(s) = str2num(D{2});
end
%%
XRes = 0;
YRes = 0;
ZRes = 0;
end
