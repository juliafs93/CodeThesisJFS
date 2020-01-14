%%
clear all
%Path = '/Users/julia/Google Drive jf565/comp MS2/OnOff/';
PathMain = '/Users/julia/Google Drive jf565/comp MS2/bursting';
mkdir(PathMain)

MetaFile = '';
MetaFile = ' ecNICD';
%MetaFile = ' margherita';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

Exps = cell2table(info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';

close all
%PaletteMain = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;130,130,130;80,80,80;]./255;

PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %pruple1, purple2. 13:14
    205,55,0]./255; %red. 15
    

% Input{16}.Nicknames = {'^m5m8peve w RNAi$','^m5m8peve Gro RNAi$','^m5m8peve Ez RNAi$'}
% Input{16}.ExpLabels = {'w RNAi','E(z) RNAi','Gro RNAi'};
% Input{16}.Selections = {'MSE','MSE','MSE'};
% Input{16}.Palette = [105,139,34;54,100,139;205,149,12]./255;

Input{1}.Nicknames = {'^simMSEpeve \+$','^simMSEpeve eveNICD$','^simMSEpeve 2xeveNICD$'}
Input{1}.ExpLabels = {'WT','eve-NICD','2xeve-NICD'};
Input{1}.Selections = {'ME','ME','ME'};
Input{1}.Palette = PaletteMain([6:8],:);


Input{2}.Nicknames = {'^simMSEpeve \+$','^simMSEpeve eveNICD$','^simMSEpeve eveNICDtwi$'}
Input{2}.ExpLabels = {'WT','eve-NICD','eve-NICD-twi'};
Input{2}.Selections = {'ME','ME','ME'};
Input{2}.Palette = PaletteMain([6,7,10],:);


Input{3}.Nicknames = {'^simMSEpeve \+$','^simMSEpeveSPS \+$','^simMSEpeve eveNICD$','^simMSEpeveSPS eveNICD$'}
Input{3}.ExpLabels = {'+ WT','SPS WT','+ NICD','SPS NICD'};
Input{3}.Selections = {'ME','ME','ME','ME'};
Input{3}.Palette = PaletteMain([1,6,2,7],:);
%Input{3}.Palette = PaletteMain([4,7,2,8],:);


Input{4}.Nicknames = {'^m8NEpeve \+$','^m8NEpeve eveNICD$'}
Input{4}.ExpLabels = {'m8NE WT','m8NE eveNICD'};
Input{4}.Selections = {'ME','ME'};
Input{4}.Palette = PaletteMain([13,14],:);


Input{5}.Nicknames = {'^m5m8pevel eveNICD$','^m5m8pevel 2xeveNICD$'}
Input{5}.ExpLabels = {'eve-NICD','2xeve-NICD'};
Input{5}.Selections = {'DE','DE'};
Input{5}.Palette = PaletteMain([3,4],:);


Input{6}.Nicknames = {'^m5m8peve \+$','^m5m8peveiSPS \+$','^m5m8peve eveNICD$','^m5m8peveiSPS eveNICD$'}
Input{6}.ExpLabels = {'m5m8 +','m5m8iSPS +','m5m8 1x','m5m8iSPS 1x'};
Input{6}.Selections = {'MSE','MSE','MSE','MSE'};
Input{6}.Palette = PaletteMain([1,3,2,4],:);


Input{7}.Nicknames = {'^simMSEpeve \+$','^simMSEpeveSPS \+$','^simMSEpeve eveNICD$','^simMSEpeveSPS eveNICD$'}
Input{7}.ExpLabels = {'sim +','simSPS +','sim 1x','simSPS 1x'};
Input{7}.Selections = {'MSE','MSE','MSE','MSE'};
Input{7}.Palette = PaletteMain([1,6,2,7],:);



% combined m5m8 DE and sim ME
Input{8}.Nicknames = [Input{5}.Nicknames,Input{1}.Nicknames];
Input{8}.ExpLabels = [Input{5}.ExpLabels,Input{1}.ExpLabels];
Input{8}.Selections = [Input{5}.Selections,Input{1}.Selections];
Input{8}.Palette = [Input{5}.Palette;Input{1}.Palette];


% combined m5m8DE and m8NE ME
Input{9}.Nicknames = [Input{5}.Nicknames,Input{4}.Nicknames];
Input{9}.ExpLabels = [Input{5}.ExpLabels,Input{4}.ExpLabels];
Input{9}.Selections = [Input{5}.Selections,Input{4}.Selections];
Input{9}.Palette = [Input{5}.Palette;Input{4}.Palette];

Input{10}.Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$'}
Input{10}.ExpLabels = {'m5m8 +','m5m8Dtwi +','m5m8Ddl +','m5m8 1x','m5m8Dtwi 1x','m5m8Ddl 1x'};
Input{10}.Selections = {'MSE','MSE','MSE','MSE','MSE','MSE','MSE'};
Input{10}.Palette = PaletteMain([1,9,11,2,10,12],:);

Input{11}.Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peveDtwidl \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$','^m5m8peveDtwidl eveNICD$'}
Input{11}.ExpLabels = {'m5m8 +','m5m8Dtwi +','m5m8Ddl +','m5m8Dtwidl +','m5m8 1x','m5m8Dtwi 1x','m5m8Ddl 1x','m5m8Dtwidl 1x'};
Input{11}.Selections = {'MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE'};
Input{11}.Palette = PaletteMain([1,9,11,3,2,10,12,4],:);

Input{12}.Nicknames = {'^m5m8pevel eveNICD$','^m5m8pevel eveNICDtwi$','^simMSEpevel eveNICD$','^simMSEpevel eveNICDtwi$'}
Input{12}.ExpLabels = {'m5m8 NICD','m5m8 NICDtwi','sim NICD','sim NICDtwi'};
Input{12}.Selections = {'NE','NE','NE','NE'};
Input{12}.Palette = PaletteMain([1,4,2,7],:);

Input{13}.Nicknames = {'^m5m8pevel eveNICD$','^m5m8pevel eveNICDtwi$','^m5m8pevel eveNICDdl$','^simMSEpevel eveNICD$','^simMSEpevel eveNICDtwi$'}
Input{13}.ExpLabels = {'m5m8 NICD','m5m8 NICDtwi','m5m8 NICDdl','sim NICD','sim NICDtwi'};
Input{13}.Selections = {'DE','DE','DE','DE','DE'};
Input{13}.Palette = PaletteMain([1,4,5,2,7],:);

Input{14}.Nicknames = {'^m5m8pevel eveNICD$','^m5m8peveDtwil eveNICD$','^m5m8peveDdll eveNICD$'}
Input{14}.ExpLabels = {'m5m8 1x','m5m8Dtwi 1x','m5m8Ddl 1x'};
Input{14}.Selections = {'DE','DE','DE','DE'};
Input{14}.Palette = PaletteMain([2,10,12],:);

Input{15}.Nicknames = {'^m5m8peve \+$','^m5m8peveDtwi \+$','^m5m8peveDdl \+$','^m5m8peveDtwidl \+$','^m8NEpeve \+$','^m5m8peve eveNICD$','^m5m8peveDtwi eveNICD$','^m5m8peveDdl eveNICD$','^m5m8peveDtwidl eveNICD$','^m8NEpeve eveNICD$',}
Input{15}.ExpLabels = {'m5m8 +','m5m8Dtwi +','m5m8Ddl +','m5m8Dtwidl +','m8NE +','m5m8 1x','m5m8Dtwi 1x','m5m8Ddl 1x','m5m8Dtwidl 1x','m8NE 1x'};
Input{15}.Selections = {'MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE','MSE'};
Input{15}.Palette = PaletteMain([1,9,11,3,13,2,10,12,4,14],:);

Input{16}.Nicknames = {'^m5m8pevel eveNICD$','^m5m8pevex2l eveNICD$'}
Input{16}.ExpLabels = {'m5m8 NICD','m5m8x2 NICD'};
Input{16}.Selections = {'DE','DE'};
Input{16}.Palette = PaletteMain([1,4],:);

Input{17}.Nicknames = {'^m5m8peve \+$','^m5m8peveDtwidl \+$','^m5m8peve eveNICD$','^m5m8peveDtwidl eveNICD$'}
Input{17}.ExpLabels = {'m5m8 +','m5m8Dtwidl +','m5m8 1x','m5m8Dtwidl 1x'};
Input{17}.Selections = {'MSE','MSE','MSE','MSE'};
Input{17}.Palette = PaletteMain([1,3,2,4],:);


Limits = [0, 90];
minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;

MinContinuous = 10; %min t (min) at least one burst length

Jitter = 0.6; %Jitter./2 cant be > BarW
BarW = 0.4;
FaceAlpha = 0.3;
DotSize = 0.03;
LineWidth = 1.5;
FontSizeTitle = 10;
FontSize = 8;

%%
clear all
PathMain = '/Users/julia/Google Drive jf565/comp MS2/bursting';
mkdir(PathMain)

MetaFile = ' enhprom';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

Exps = cell2table(info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';

close all

PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15

Input{1}.Nicknames = {'^m5m8peve$','^simMSEpeve$','^m8NEpeve$',}
Input{1}.ExpLabels = {'m5m8','sim','m8NE'};
Input{1}.Selections = {'MSE','MSE','MSE'};
Input{1}.Palette = PaletteMain([1,2,13],:);

Input{2}.Nicknames = {'^m5m8peve$','^simMSEpeve$'}
Input{2}.ExpLabels = {'m5m8','sim'};
Input{2}.Selections = {'MSE','MSE'};
Input{2}.Palette = PaletteMain([3,6],:);

% Nicknames = {'^m5m8peve$','^m5m8hsp70$','^m5m8pm5$','^m5m8pm6$','^m5m8pm7$','^m5m8pm8$','^m5m8psimE$'}
% ExpLabels = {'peve','hsp70','pm5','pm6','pm7','pm8','psimE'};
% Selection = 'EarlyOnly';
% Limits = [-50, 15];
% minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = -50;

Limits = [0, 90];
minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;


MinContinuous = 10; %min t (min) at least one burst length

Jitter = 0.6; %Jitter./2 cant be > BarW
BarW = 0.4;
FaceAlpha = 0.3;
DotSize = 0.03;
LineWidth = 1.5;
FontSizeTitle = 10;
FontSize = 8;
%%
clear all
PathMain = '/Users/julia/Google Drive jf565/comp MS2/bursting';
mkdir(PathMain)

MetaFile = ' mutBG';

info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);

Exps = cell2table(info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';

close all

PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15

Input{1}.Nicknames = {'^m5m8peve wRi$','^m5m8peve med7Ri$','^m5m8peve skdRi$'}
Input{1}.ExpLabels = {'wRi','med7Ri','skdRi'};
Input{1}.Selections = {'MSE','MSE','MSE'};
Input{1}.Palette = PaletteMain([1,9,13],:);

Input{2}.Nicknames = {'^m5m8peve wRi eveNICD$','^m5m8peve HRi eveNICD$'}
Input{2}.ExpLabels = {'wRi NICD','HRi NICD'};
Input{2}.Selections = {'DE','DE'};
Input{2}.Palette = PaletteMain([1,4],:);

Input{3}.Nicknames = {'^m5m8peve wRi eveNICD$','^m5m8peve HRi eveNICD$'}
Input{3}.ExpLabels = {'wRi NICD','HRi NICD'};
Input{3}.Selections = {'MSE','MSE'};
Input{3}.Palette = PaletteMain([1,4],:);

Input{4}.Nicknames = {'^m5m8peve wRi$','^m5m8peve HRi$'}
Input{4}.ExpLabels = {'wRi','HRi'};
Input{4}.Selections = {'MSE','MSE'};
Input{4}.Palette = PaletteMain([1,4],:);

Input{5}.Nicknames = {'^m5m8peve wRi$','^m5m8peve zldRi$','^m5m8peve grhRi$','^m5m8peve TrlRi$'}
Input{5}.ExpLabels = {'wRi','zldRi', 'grhRi','TrlRi'};
Input{5}.Selections = {'MSE','MSE','MSE','MSE'};
Input{5}.Palette = PaletteMain([1,15,13,9],:);

Input{6}.Nicknames = {'^m5m8peve wRi$','^m5m8peve HRi$','^m5m8peve GroRi$'}
Input{6}.ExpLabels = {'wRi','HRi', 'GroRi'};
Input{6}.Selections = {'MSE','MSE','MSE'};
Input{6}.Palette = PaletteMain([1,7,12],:);

Input{7}.Nicknames = {'^m5m8peve$','^vndEEEpeve$','^vndEEEpeve$'}
Input{7}.ExpLabels = {'m5m8','vnd MSE','vnd NE'};
Input{7}.Selections = {'MSE','MSE','NE'};
Input{7}.Palette = PaletteMain([1,14,14],:);

Input{8}.Nicknames = {'^m5m8peve$','^vndEEEpeve$','^vndEEEpeve$'}
Input{8}.ExpLabels = {'m5m8','vnd MSE','vnd NE'};
Input{8}.Selections = {'MSE','MSE','NE'};
Input{8}.Palette = PaletteMain([1,14,14],:);

Input{9}.Nicknames = {'^m5m8peve wRi$','^m5m8peve nejRi$','^m5m8peve trrRi$'}
Input{9}.ExpLabels = {'wRi','nejRi','trrRi'};
Input{9}.Selections = {'MSE','MSE','MSE'};
Input{9}.Palette = PaletteMain([1,15,14],:);

Input{10}.Nicknames = {'^m5m8peve wRi$','^m5m8peve trrRi$','^m5m8peve TrlRi$'}
Input{10}.ExpLabels = {'wRi','trrRi','TrlRi'};
Input{10}.Selections = {'MSE','MSE','MSE'};
Input{10}.Palette = PaletteMain([1,14,9],:);

Input{11}.Nicknames = {'^m5m8peve wRi$','^m5m8peve EzRi$'}
Input{11}.ExpLabels = {'wRi','EzRi'};
Input{11}.Selections = {'MSE','MSE'};
Input{11}.Palette = PaletteMain([1,11],:);


Limits = [0, 90];
minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; 


MinContinuous = 10; %min t (min) at least one burst length

Jitter = 0.6; %Jitter./2 cant be > BarW
BarW = 0.4;
FaceAlpha = 0.3;
DotSize = 5;
LineWidth = 1.5;
FontSizeTitle = 10;
FontSize = 8;


%%
%for e = [1,3,6,9,11]
for e = [5,9]
%for e = 1:length(Input)
%%

Nicknames = Input{e}.Nicknames;
ExpLabels = Input{e}.ExpLabels;
Selections = Input{e}.Selections;
Palette = Input{e}.Palette;  
    
    
MaxRow = length(Nicknames);
BNumAll = cell(1,MaxRow);
BLenAll = cell(1,MaxRow);
MaxLenAll = cell(1,MaxRow);
BPerAll = cell(1,MaxRow);
BAmpAll = cell(1,MaxRow);
OffTimeAll = cell(1,MaxRow);
BSizeAll = cell(1,MaxRow);
OnsetAll = cell(1,MaxRow);
EndAll = cell(1,MaxRow);
TmAll = cell(1,MaxRow);


NumOn = [];
PercOn = [];
PercCont = [];
MaxCol = 1;

for Exp = 1:length(Nicknames)
    Index = find(cellfun(@(x) ~isempty(x),regexp(info.Nickname, Nicknames{Exp},'match')))
    info.Nickname(Index)
     MaxCol = max(MaxCol,length(Index));
    Selection = Selections{Exp};
for i = [1:length(Index)]
        x = Index(i);
        %
        Parameters = info(x,:);
        Table2Vars(Parameters);
        Flip = str2double(strsplit(Flip,','));
        PathToSave = [Path,File,Name,File]; 
        %load([PathToSave, '_Stats.mat']);
        %minNumb = 10; Smooth = 3; minOn = 5; minPDis = 10; SplitShortLong = 60; SplitEarly = 15;
        Merged_meanF_maxGFP = Read3d([PathToSave, '_maxF_maxGFP.tiff']);
        F = max(round(35*60/TimeRes)+nc14-Delay,1);
        Im = Merged_meanF_maxGFP(:,:,F)./255;
        Width = size(Im,1); Height = size(Im,2);
        clear CentroidF;
        load([PathToSave,'_Data.mat']);
        if length(fields(Data)) > 2
            Struct2Vars(Data);
        else
            Data = Data.Data;
            Struct2Vars(Data);
        end
        
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
%             StatsF = Stats_GFP{F};
%             CentXF = StatsF.Centroid(:,1);
%             CentYF = StatsF.Centroid(:,2);
            Indices = sub2ind([size(Im,1),size(Im,2)],floor(PosY), floor(PosX));
            ImLab = zeros(size(Im,1),size(Im,2));
            ImLab(Indices) = 1;
            Data.CentroidsF = ImLab;
            save([PathToSave,'_Data.mat'],'Data');
        end
        


      %

        if strcmp(Selection,'ME') | strcmp(Selection,'MSE') | strcmp(Selection,'NE') | strcmp(Selection,'DE') == 1
            %mkdir([Path,File,Name,'regions/'])
             PathToSave = [Path,File,Name,'regions/',File]; 
            %
                Regions = imread([PathToSave,'_regions.tiff']);
                cmap_3 = [255,120,120;096,085,176;95,181,241]./255;
                mkdir([Path,File,Name,'regions/'])
                PathToSave = [Path,File,Name,'regions/',File]; 
                Selected = find([Properties.Type~='EarlyOnly']);
            %LabelsSelected = Labels(Selected);
            PosX = floor(nanmean(CentX(max(1,F-5): min(F+5,Frames),Selected),1));
            PosY = floor(nanmean(CentY(max(1,F-5): min(F+5,Frames),Selected),1));
            Indices = sub2ind(size(Regions),PosY,PosX);
            Selected = Selected(~isnan(Indices));
            %LabelsSelected = LabelsSelected(~isnan(Indices));
            Indices = Indices(~isnan(Indices));
            RegionsInd = Regions(Indices);
            switch Selection
                case 'ME'
                    Value = 1;
                case 'MSE' 
                    Value = 2;
                case 'NE'
                    Value = 3;
                case 'DE' 
                    Value = 4;
            end
            
            Selected = Selected(RegionsInd==Value);
            %TotalCells = length(unique(ImLab.*(Regions == Value))) - 1;
            TotalCells = ImLab.*(Regions == Value);
            TotalCells = sum(TotalCells(:));
            %figure;imagesc(ImLab)
        end
        
        if strcmp(Selection,'EarlyOnly')
            Selected = find([Properties.Type=='EarlyOnly']); 
            TotalCells = length(unique(ImLab)) - 1;
        end
        
          if strcmp(Selection,'')
            Selected = find([Properties.Type ~= 'EarlyOnly']); 
            TotalCells = length(unique(ImLab)) - 1;
        end
        TimeScale = ([1:Frames] - nc14+Delay).*TimeRes./60;
        SplitEarlyF = max([SplitEarly*60./TimeRes+nc14-Delay,1]);
        %VarName = varname(ME);
        NormF = (MaxF-Baseline').*Baseline(1)./Baseline'.*2.^(12-Bits);
        OnOff = CleanOnOff(OnOff,minOn);
        [OnOff] = CleanNaNs(MedFilt,OnOff, minOn*2);
        try
            [BurstNum,BurstLength,BurstPeriod,BurstPeak,BurstMax,OffTime,BurstSize] = CountBursts(NormF,OnOff, Selected,minOn,SplitEarlyF,TimeRes);
        catch
            BurstNum = {}; BurstLength = {}; BurstPeriod = {}; BurstPeak = {};BurstMax = {}; OffTime = {}; BurstSize = {};
        end
        Onsets = Properties.Onset(Selected);
        Ends = Properties.End(Selected);
        TotmRNA = Properties.TotalmRNA(Selected);

        % % cells on
        NumOn(i,Exp) = length(Selected);
        PercOn(i,Exp) = length(Selected) ./ TotalCells;
        Continuous = cellfun(@(x)any(x > MinContinuous.*60./TimeRes),BurstLength);
        PercCont(i,Exp) = sum(Continuous)./length(Continuous);
        NumOn(NumOn == 0) = NaN;
        PercCont(PercOn == 0) = NaN;
        PercOn(PercOn == 0) = NaN;
        PercOn(PercOn > 1) = 1;
        MaxLengthEach = cellfun(@(x) max(x), BurstLength,'UniformOutput',false);
        BNumAll{Exp} = [BNumAll{Exp}; [BurstNum{:}]'];
        BLenAll{Exp} = [BLenAll{Exp}; abs([BurstLength{:}]')];
        MaxLenAll{Exp} = [MaxLenAll{Exp}; abs([MaxLengthEach{:}]')];
        BPerAll{Exp} = [BPerAll{Exp}; [BurstPeriod{:}]'];
        BAmpAll{Exp} = [BAmpAll{Exp}; [BurstMax{:}]'];
        OffTimeAll{Exp} = [OffTimeAll{Exp}; [OffTime{:}]'];
        BSizeAll{Exp} = [BSizeAll{Exp}; [BurstSize{:}]'];
        OnsetAll{Exp} = [OnsetAll{Exp}; [Onsets(:)]];
        EndAll{Exp} = [EndAll{Exp}; [Ends(:)]];
        TmAll{Exp} = [TmAll{Exp}; [TotmRNA(:)]];



end
end
%
BNumAll = Cell2Mat(BNumAll);
BLenAll = Cell2Mat(BLenAll);
MaxLenAll = Cell2Mat(MaxLenAll);
BPerAll = Cell2Mat(BPerAll);
BAmpAll = Cell2Mat(BAmpAll);
OffTimeAll = Cell2Mat(OffTimeAll);
BSizeAll = Cell2Mat(BSizeAll);
OnsetAll = Cell2Mat(OnsetAll);
EndAll = Cell2Mat(EndAll);
TmAll = Cell2Mat(TmAll);




%%
FileOut = [PathMain,'/comp_bursting_violin',cell2mat(join(unique(Selections),'_')),'_',cell2mat(join(ExpLabels,'_vs_')),'.pdf']
    %Fig = figure('PaperSize',[10*length(Nicknames) Height],'resize','off', 'visible','on','Units','points');
        Fig = figure('PaperUnits','inches','PaperSize',[3*length(Nicknames) 6],'Units','points','resize','on', 'visible','on','DefaultAxesFontSize', 4);
set(0,'defaultAxesFontSize',4)
      set(0, 'DefaultFigureRenderer', 'painters');
          set(gcf,'defaultLegendAutoUpdate','off')
          set(Fig,'defaultAxesColorOrder',Palette)
%   set(Fig,'defaultAxesFontSize',6)
 %     set(Fig, 'DefaultFigureRenderer', 'painters');

CMAP = bone(MaxCol+1);
CMAP = zeros(size(CMAP))+0.7;
CMAP(:,4) = FaceAlpha;
Cat = repmat([1:1:length(Nicknames)],2,1)+[-BarW./2;+BarW./2];

% % NUMBER CELLS ON
% subplot(2,5,1); 
%plotBoxplot(NumOn,Nicknames,ExpLabels,Jitter,BarW,'# active cells',FontSize,5,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,100])


% ONSET/ENDS VIOLIN
subplot(2,5,6); 
plotViolin(OnsetAll,Nicknames,ExpLabels,2,BarW,'onset/ends (min)',FontSize,0.2,LineWidth,FontSizeTitle,1,0)
plotViolin(EndAll,Nicknames,ExpLabels,2,BarW,'onset/ends (min)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,0)


% PERC CELLS ON
subplot(2,5,1); 

plotBoxplot(PercOn*100,Nicknames,ExpLabels,Jitter,BarW,'% active cells',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,100])
    

% PROPORTION SUSTAINED
subplot(2,5,2); 
plotBoxplot(PercCont*100,Nicknames,ExpLabels,Jitter,BarW,'% sustained profile',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,100])



% NUMBER OF BURSTS
subplot(2,5,7); 
plotViolin(BNumAll,Nicknames,ExpLabels,1,BarW,'bursts # / cell',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,0)


% ONSET/ENDS VIOLIN
subplot(2,5,8); 
plotViolin(TmAll,Nicknames,ExpLabels,100,BarW,'total mRNA (AU)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,0)


Log = 1;

% AMPLITUDE
subplot(2,5,3); 
plotViolin(BAmpAll,Nicknames,ExpLabels,100,BarW,'burst amplitude (AU)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,100,Log)

% TIME OFF
subplot(2,5,4); 
plotViolin(OffTimeAll.*TimeRes./60,Nicknames,ExpLabels,0.5,BarW,'off time (min)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,Log)

% LENGTH
subplot(2,5,5); 
plotViolin(BLenAll.*TimeRes./60,Nicknames,ExpLabels,0.5,BarW,'burst length (min)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,Log)

% MAX LENGTH EACH CELL
subplot(2,5,9); 
plotViolin(MaxLenAll.*TimeRes./60,Nicknames,ExpLabels,0.5,BarW,'max burst length (min)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,Log)

% PERIOD
% subplot(2,5,9); 
% plotViolin(BPerAll.*TimeRes./60,Nicknames,ExpLabels,0.5,BarW,'burst period (min)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,Log)

% SIZE
subplot(2,5,10); 
plotViolin(BSizeAll,Nicknames,ExpLabels,100,BarW,'burst size (AU)',FontSize,FaceAlpha,LineWidth,FontSizeTitle,1,Log)


%export_fig FileOut -pdf
%saveas(Fig,FileOut,'pdf')
print(Fig,FileOut,'-fillpage','-dpdf');
%print(Fig,FileOut,'-dtiff');
close all
%end

%%
% a test decision for the null hypothesis that the data in vectors x and y
% comes from independent random samples from normal distributions with
% equal means and equal but unknown variances, using the two-sample t-test.
% The alternative hypothesis is that the data in x and y comes from
% populations with unequal means. The result h is 1 if the test rejects the
% null hypothesis at the 5% significance level, and 0 otherwise
% 1 if coming from different normal distributions
%[h,p,ci,stats] = ttest2(BAmpAll(:,1),BAmpAll(:,2),'Vartype','unequal'); disp(h);p
%[h,p,ci,stats] = ttest2(BAmpAll(:,2),BAmpAll(:,3),'Vartype','unequal'); disp(h);p


% a test decision for the null hypothesis that the data in vector x comes
% from a distribution in the normal family, against the alternative that it
% does not come from such a distribution, using a Lilliefors test.
% 1 if not normally distributed
% lillietest(BAmpAll(:,1))
% lillietest(BAmpAll(:,2))
% lillietest(BAmpAll(:,3))


%a test decision for the null hypothesis that the data in vectors x1 and x2
%are from the same continuous distribution, using the two-sample
%Kolmogorov-Smirnov test. The alternative hypothesis is that x1 and x2 are
%from different continuous distributions. The result h is 1 if the test
%rejects the null hypothesis at the 5% significance level, and 0 otherwise
fileID = fopen([PathMain,'/comp_bursting_violin',cell2mat(join(unique(Selections),'_')),'_',cell2mat(join(ExpLabels,'_vs_')),'_ks.txt'],'a');
fprintf(fileID, '\nupdated on \t%s\n',date);
[h,p,ks2stat] = kstest2(BAmpAll(:,1),BAmpAll(:,2));
fprintf(fileID, 'amp12\t%E\t%s\n',p,asterisk(p));
[h,p,ks2stat] = kstest2(OffTimeAll(:,1),OffTimeAll(:,2));
fprintf(fileID, 'off12\t%E\t%s\n',p,asterisk(p));
[h,p,ks2stat] = kstest2(BLenAll(:,1),BLenAll(:,2));
fprintf(fileID, 'length12\t%E\t%s\n',p,asterisk(p));
[h,p,ks2stat] = kstest2(BSizeAll(:,1),BSizeAll(:,2));
fprintf(fileID, 'size12\t%E\t%s\n',p,asterisk(p));
if length(Nicknames) == 3
    [h,p,ks2stat] = kstest2(BAmpAll(:,2),BAmpAll(:,3));
    fprintf(fileID, 'amp23\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(OffTimeAll(:,2),OffTimeAll(:,3));
    fprintf(fileID, 'off23\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BLenAll(:,2),BLenAll(:,3));
    fprintf(fileID, 'length23\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BSizeAll(:,2),BSizeAll(:,3));
    fprintf(fileID, 'size23\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BAmpAll(:,1),BAmpAll(:,3));
    fprintf(fileID, 'amp13\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(OffTimeAll(:,1),OffTimeAll(:,3));
    fprintf(fileID, 'off13\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BLenAll(:,1),BLenAll(:,3));
    fprintf(fileID, 'length13\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BSizeAll(:,1),BSizeAll(:,3));
    fprintf(fileID, 'size13\t%E\t%s\n',p,asterisk(p));
end
if length(Nicknames) == 4
    [h,p,ks2stat] = kstest2(BAmpAll(:,3),BAmpAll(:,4));
    fprintf(fileID, 'amp34\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(OffTimeAll(:,3),OffTimeAll(:,4));
    fprintf(fileID, 'off34\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BLenAll(:,3),BLenAll(:,4));
    fprintf(fileID, 'length34\t%E\t%s\n',p,asterisk(p));
    [h,p,ks2stat] = kstest2(BSizeAll(:,3),BSizeAll(:,4));
    fprintf(fileID, 'size34\t%E\t%s\n',p,asterisk(p));
end

fclose(fileID);
end