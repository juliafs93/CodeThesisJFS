

%% %% compare one experiment with another

%%
%% enh / prom
clear all
set(0,'defaultAxesFontSize',16)
MetaFile = ' enhprom';
Path = ['/Users/julia/Google Drive jf565/comp MS2/Figs/'];
mkdir(Path)
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';
PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80]./255;


YLim = 1100;Selection = '';
XLim = [-50,80];

    CompareMeans({'m5m8peve','simMSEpeve','m5m8psimE','simMSEpsimE'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8hsp70','m5m8pm5','m5m8pm6','m5m8pm7','m5m8pm8','m5m8psimE',},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
   
    %% mut BG
    clear all
set(0,'defaultAxesFontSize',16)
MetaFile = ' mutBG';
Path = ['/Users/julia/Google Drive jf565/comp MS2/Figs/'];
mkdir(Path)
Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';
PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80]./255;

    
    XLim = [-20,80];
    YLim = 1100;Selection = '';
    CompareMeans({'m5m8peve','m5m8peve Dl', 'm5m8peve neur'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    
   %% ectopic NICD
   clear all
set(0,'defaultAxesFontSize',16)
   MetaFile = ' ecNICD';
   Path = ['/Users/julia/Google Drive jf565/comp MS2/Figs/'];
    mkdir(Path)
    Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true);
    Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
    Exps.Rep = Info.Rep;
    for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
    Exps.Exp = Exp';

    XLim = [-50,60]
    YLim = 1100    
    Selection = '';
        
    % eve-NICD x 1
    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    CompareMeans({'m5m8peve +','simMSEpeve +','m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        
    % eve-NICD x2
     PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3,5],:), PaletteMeans([1,3,5],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4,6],:), PaletteMeans([2,4,6],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD',},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,4,5,6],:), PaletteMeans([3,4,5,6],:),[0,YLim])
        
    % saturation pm5
    PalettePoints = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    PaletteMeans = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8pm5 +','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;80,80,80]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;80,80,80]./255;
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3:7],:), PaletteMeans([3:7],:),[0,YLim])

    % Dtwi
    PalettePoints = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    PaletteMeans = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peveDtwi +','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

     % SPS, only NICD or WT
    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peveiSPS eveNICD','simMSEpeveSPS eveNICD','m8NEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,3,4,5],:), PaletteMeans([1,2,3,4,5],:),[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +','m5m8peveiSPS +','simMSEpeveSPS +','m8NEpeve +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,3,4,5],:), PaletteMeans([1,2,3,4,5],:),[0,YLim])
         
    % ME levels and SPS
     PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;80,80,80;50,50,50]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;;80,80,80;50,50,50]./255;
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,6],:), PaletteMeans([2,4,6],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeveSPS +','simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,7,4,8],:), PaletteMeans([2,7,4,8],:),[0,YLim])


    % eveNICD, evetwi
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve eveNICDtwi','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
