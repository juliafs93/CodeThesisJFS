

%% %% compare one experiment with another

%%
%% enh / prom
clear all
set(0,'defaultAxesFontSize',16)
MetaFile = ' enhprom';
Path = ['/Users/julia/Google Drive jf565/comp MS2/FigsV2/'];
mkdir(Path)
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';
PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;130,130,130;80,80,80]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;130,130,130; 50,50,50]./255;


YLim = 1200;
Selection = 'MSE';
XLim = [-50,80];
Heatmaps = 3000;
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, 'MSE', 1, [0,60],PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve','simMSEpeve','m5m8psimE','simMSEpsimE'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([8,9,1,2],:), PaletteMeans([8,9,1,2],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8hsp70','m5m8pm5','m5m8pm6','m5m8pm7','m5m8pm8','m5m8peve',},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([2:4,7,1,8],:), PaletteMeans([2:4,7,1,8],:),[0,YLim],Heatmaps)
    %CompareMeans({'m5m8pm7','m5m8psimE','m5m8peve',},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([7,4,1],:), PaletteMeans([7,4,1],:),[0,YLim],Heatmaps)

    %CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %   CompareMeans({'m5m8peve'},3,Info,Path,Exps, 'MSE', 1, [0,60],PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    %CompareMeans({'simMSEpsimE'},3,Info,Path,Exps, 'MSE', 1, [0,60],PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    PaletteMeans = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %pruple1, purple2. 13:14
    205,55,0]./255; %red. 15
    PalettePoints = PaletteMeans;
    CompareMeans({'m5m8peve','simMSEpeve','m8NEpeve'},1,Info,Path,Exps, Selection, 1, [0,60],PalettePoints([1,2,13],:), PaletteMeans([1,2,13],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve','simMSEpeve','m8NEpeve','m5m8peveIII'},1,Info,Path,Exps, Selection, 1, [0,60],PalettePoints([1,2,13,4],:), PaletteMeans([1,2,13,4],:),[0,YLim],Heatmaps)

    %% mut BG
    clear all
set(0,'defaultAxesFontSize',16)
MetaFile = ' mutBG';
Path = ['/Users/julia/Google Drive jf565/comp MS2/FigsV2/'];
mkdir(Path)
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';
PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100;130,130,130;]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80;130,130,130;]./255;

    
    XLim = [-20,80];
    YLim = 1200;Selection = 'MSE';
    Heatmaps = 3000;
    CompareMeans({'m5m8pevezo','m5m8peve Dl', 'm5m8peve neur'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([9,2,3],:), PaletteMeans([9,2,3],:),[0,YLim],Heatmaps)
    %CompareMeans({'m5m8pevezo','m5m8peve Dl', 'm5m8peve neur'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([1,3,9],:), PaletteMeans([1,3,9],:),[0,YLim],Heatmaps)

   %% ectopic NICD
   clear all
set(0,'defaultAxesFontSize',16)
set(0,'defaultAxesColorOrder','default')

   MetaFile = ' ecNICD';
   Path = ['/Users/julia/Google Drive jf565/comp MS2/FigsV2/'];
    mkdir(Path)
    Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
    Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
    Exps.Rep = Info.Rep;
    for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
    Exps.Exp = Exp';

    XLim = [-50,60]
    YLim = 1200    
    Selection = '';
    Heatmaps = 1;

    PaletteMeans = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %pruple1, purple2. 13:14
    205,55,0]./255; %red. 15

    PalettePoints = PaletteMeans;
    % eve-NICD x 1
    Heatmaps = 3000;
    
    %CompareMeans({'m5m8peve +','simMSEpeve +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,6,4,7],:), PaletteMeans([3,6,4,7],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','simMSEpeve +','m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,6,4,7],:), PaletteMeans([3,6,4,7],:),[0,YLim],Heatmaps)

    % eve-NICD x2
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim],Heatmaps)
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,7],:), PaletteMeans([1,2,7],:),[0,YLim],Heatmaps)
    %CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD',},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,4,5,6],:), PaletteMeans([3,4,5,6],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([3,6,4,7],:), PaletteMeans([3,6,4,7],:),[0,YLim],Heatmaps)

    % saturation pm5
    %CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8pm5 +','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,15],:), PaletteMeans([1,15],:),[0,YLim],Heatmaps)
    %CompareMeans({'m5m8peve +','m5m8pm5 +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([9,3],:), PaletteMeans([9,3],:),[0,YLim],Heatmaps)

    %CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3:7],:), PaletteMeans([3:7],:),[0,YLim])

    % Dtwi Ddl
    %CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peveDtwi +','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveDtwi +',},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,10],:), PaletteMeans([2,10],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveDtwi +','m5m8peveDdl +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9,11],:), PaletteMeans([1,9,11],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwi eveNICD','m5m8peveDdl eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,10,12],:), PaletteMeans([2,10,12],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveDtwi +','m5m8peveDdl +','m5m8peveDtwidl +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9,11,3],:), PaletteMeans([1,9,11,3],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwi eveNICD','m5m8peveDdl eveNICD','m5m8peveDtwidl eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,10,12,4],:), PaletteMeans([2,10,12,4],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveDtwidl +','m8NEpeve +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3,13],:), PaletteMeans([1,3,13],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwidl eveNICD','m8NEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4,14],:), PaletteMeans([2,4,14],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveDtwidl +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwidl eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim],Heatmaps)

     % SPS, all separate
    CompareMeans({'m5m8peve eveNICD','m5m8peveiSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim],Heatmaps)
    CompareMeans({'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,7],:), PaletteMeans([2,7],:),[0,YLim],Heatmaps)
    CompareMeans({'m5m8peve +','m5m8peveiSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim],Heatmaps)
    CompareMeans({'simMSEpeve +','simMSEpeveSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,6],:), PaletteMeans([1,6],:),[0,YLim],Heatmaps)
     CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peveiSPS +','m5m8peveiSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,3,4],:), PaletteMeans([1,2,3,4],:),[0,YLim],Heatmaps)
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeveSPS +','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,5,6],:), PaletteMeans([1,2,5,6],:),[0,YLim],Heatmaps)
    
     Heatmaps = 2000;
    % ME levels and SPS
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([6:8],:), PaletteMeans([6:8],:),[0,YLim],Heatmaps)
    CompareMeans({'simMSEpeve +','simMSEpeveSPS +','simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([1,6,2,7],:), PaletteMeans([1,6,2,7],:),[0,YLim],Heatmaps)

    % others
    CompareMeans({'m5m8pevel eveNICD','m5m8pevel 2xeveNICD'},1,Info,Path,Exps, 'DE', 1, XLim,PalettePoints([4,5],:), PaletteMeans([4,5],:),[0,YLim],Heatmaps)
    CompareMeans({'m8NEpeve +','m8NEpeve eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([13,14],:), PaletteMeans([13,14],:),[0,YLim],Heatmaps)

     Heatmaps = 3000;
    % eveNICD, evetwi
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve eveNICDtwi','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4,7],:), PaletteMeans([1,2,4,7],:),[0,YLim],Heatmaps)

    % DV position
    %CompareMeans({'m5m8pevel eveNICD','m5m8pevel 2xeveNICD','simMSEpevel eveNICD'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([4,5,7],:), PaletteMeans([4,5,7],:),[0,YLim],Heatmaps)
    %CompareMeans({'m5m8peve eveNICD','simMSEpevel eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([4,5,7],:), PaletteMeans([4,5,7],:),[0,YLim],Heatmaps)
