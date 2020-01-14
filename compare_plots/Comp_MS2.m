%% compare all repeats of each experiment or each separately
clear all
%Path = '/Users/julia/Google Drive jf565/comp MS2/OnOff/';


MetaFile = '';
MetaFile = ' enhprom';
%MetaFile = ' ecNICD';
MetaFile = ' mutBG';
%MetaFile = ' margherita';

%MetaFile = ' 2c';

%MetaFile = ' other';

Path = ['/Users/julia/Google Drive jf565/comp MS2/',MetaFile,'/'];
mkdir(Path)


Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter','\t');
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';
% RGB values from ggplot colors
%PalettePoints <-c('steelblue1','olivedrab2',"orangered2",'darkgoldenrod1','grey70','grey35','slateblue3')
%PaletteMeans <-c('steelblue4','olivedrab4',"orangered3",'darkgoldenrod3','grey40','grey20','slateblue4')
PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100]./255;
PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80]./255;

%PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;


set(0,'defaultAxesFontSize',16)
%set(0,'defaultAxesFontName', 'Myriad Pro')

%% margherita
YLim = 1100; % limit Y axis flupreecence plot
Selection = '';
XLim = [0,60]; % limits X axis, time into nc14
    CompareMeans({'m5m8peve Ez RNAi','m5m8peve Ez RNAi m&z'},1,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    % 3 to compare repeats within one experiment
    CompareMeans({'m5m8peve Ez RNAi'},3,Info,Path, Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve Ez RNAi'},1,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        CompareMeans({'m5m8peve Ez RNAi'},3,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve Ez RNAi'},1,Info,Path, Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])


%% compare all repeats within one experiment
    %CompareMeans({'m5m8pevez 2xeveNICD'},3,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
     %CompareMeans({'m5m8peve IB'},3,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim]);

YLim = 1500;Selection = '';XLim = [XLim,90]
UniqueN = table2array(unique(Exps(:,1))); 
%
Log = [];
for n = 1:length(UniqueN)
    try
        CompareMeans(UniqueN(n),3,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim]);
    catch
        Log = [Log, 'error in ',UniqueN(n),'\n'   ]
    end
end
%% %% compare one experiment with another

%%
%% enh / prom
YLim = 1100;Selection = 'MSE';
XLim = [-50,70];
    CompareMeans({'m5m8peve'},1,Info,Path, Exps, 'MSE', 1, XLim,[142,183,36]./255, [142,183,36]./255,[0,YLim])
    CompareMeans({'m5m8peve','m5m8peveIII'},1,Info,Path, Exps, 'MSE', 1, XLim,PalettePoints([3,5],:), PaletteMeans([3,5],:),[0,YLim])
    CompareMeans({'m5m8peve','m5m8hsp70'},1,Info,Path, Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8pm5'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8pm6'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8pm7'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8pm8'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8psimE'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([3,6],:), PaletteMeans([3,6],:),[0,YLim])
    CompareMeans({'simMSEpeve','simMSEpsimE'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','simMSEpeve','m5m8psimE','simMSEpsimE'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8hsp70','m5m8pm5','m5m8pm6','m5m8pm7','m5m8pm8','m5m8psimE',},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve','m5m8pm7','m5m8psimE',},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([3,13,9],:), PaletteMeans([3,13,9],:),[0,YLim])

    %CompareMeans({'m5m8peve','m5m8pevez'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %CompareMeans({'m5m8pevezx2','m5m8peve'},Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,2000])
    %% mut BG
    PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15
    PalettePoints = PaletteMain; PaletteMeans = PaletteMain;
    PaletteGray = repmat([130,130,130]./255,10,1);
    PaletteGreen = repmat([142,183,36]./255,10,1);
    PaletteYellow = repmat([250,174,64]./255,10,1);
    PaletteBlue = repmat([61,131,183]./255,10,1);

    % CELLULARIZATION
    XLim = [-20,60];
    YLim = 1100;Selection = '';
    CompareMeans({'m5m8pevezo','m5m8peve Dl', 'm5m8peve neur'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve mDr:TTG','m5m8peve Ez:TTG', 'm5m8peve TTG, mEz'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveIII', 'm5m8peveIII CTG:+', 'm5m8peveIII slam:+'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %CompareMeans({'m5m8peveIII CTG', 'm5m8peveIII slam'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveIII', 'm5m8peveIII slam:CTG:CTG', 'm5m8peveIII slam'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9,3],:), PaletteMeans([1,9,3],:),[0,YLim])
    CompareMeans({'m5m8peveIII', 'm5m8peveIII slam'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peveIII'},3,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8pevez','m5m8peve Nullo', 'm5m8peve Nullo:+'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8pevez','m5m8peve IB','m5m8peve Arm'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
     
    % GASTRULATION 
    XLim = [-20,70];
    CompareMeans({'m5m8peve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3],:), PaletteMeans([3],:),[0,YLim])
    CompareMeans({'m5m8peve','m5m8peve eveNICD','vndEEEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,14],:), PaletteMeans([1,2,14],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','vndEEEpeve'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,14],:), PaletteMeans([2,14],:),[0,YLim])
    CompareMeans({'m5m8peve','vndEEEpeve'},1,Info,Path,Exps, 'MSE|NE', 1, XLim,PalettePoints([3,14],:), PaletteMeans([3,14],:),[0,YLim])
    CompareMeans({'m5m8peve','vndEEEpeve','pUbi'},1,Info,Path,Exps, 'MSE|NE', 1, XLim,PalettePoints([3,14,15],:), PaletteMeans([3,14,15],:),[0,YLim])
%    CompareMeans({'vndEEEpeve'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([14],:), PaletteMeans([14],:),[0,YLim])
%    CompareMeans({'m5m8peve','vndEEEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,14],:), PaletteMeans([3,14],:),[0,YLim])


    CompareMeans({'m5m8peve','m5m8peve Fog:+','m5m8peve Fog'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'m5m8peve wRi','m5m8peve ctaRi','m5m8peve RhoGEF2Ri'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,9,6],:), PaletteMeans([1,9,6],:),[0,YLim],[],30)
    
    CompareMeans({'m5m8peve'},3,Info,Path,Exps,'MSE', 1, XLim,PaletteGray, PaletteGray,[0,YLim],[])
    CompareMeans({'m5m8peve Fog'},3,Info,Path,Exps, 'MSE', 1, XLim,PaletteGreen, PaletteGreen,[0,YLim])
    CompareMeans({'m5m8peve wRi'},3,Info,Path,Exps,'MSE', 1, XLim,PaletteGray, PaletteGray,[0,YLim],[],30)
    CompareMeans({'m5m8peve ctaRi'},3,Info,Path,Exps,'MSE', 1, XLim,PaletteYellow, PaletteYellow,[0,YLim],[],30)
    CompareMeans({'m5m8peve RhoGEF2Ri'},3,Info,Path,Exps,'MSE', 1, XLim,PaletteBlue, PaletteBlue,[0,YLim],[],30)

    
    XLim = [-20,60];
    CompareMeans({'m5m8peve eveNICD','m5m8peve Fog:+ eveNICD','m5m8peve Fog eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peve Fog:+ eveNICD','m5m8peve Fog eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'m5m8peve Fog eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PaletteGreen, PaletteGreen,[0,YLim])
    CompareMeans({'m5m8peve Fog:+ eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PaletteGray, PaletteGray,[0,YLim])
    CompareMeans({'m5m8peve eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PaletteGray, PaletteGray,[0,YLim])

    CompareMeans({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,Path,Exps, 'MSE|NE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'vndEEEpeve Fog'},3,Info,Path,Exps, 'MSE|NE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

   
        CompareMeans({'Om5m8peve eveNICD','m5m8peve eveNICD','m5m8peve + eveNICDn'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PalettePoints,[0,YLim])
    CompareMeans({'Om5m8peve eveNICD','Om5m8peve Fog:+ eveNICD','Om5m8peve Fog eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'Om5m8peve eveNICD','Om5m8peve Fog:+ eveNICD','Om5m8peve Fog eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareMeans({'Om5m8peve eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'Om5m8peve Fog:+ eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'Om5m8peve Fog eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

 
    XLim = [-20,60];
    CompareMeans({'m5m8peve wRi eveNICD','m5m8peve ctaRi eveNICD'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],15)
    CompareMeans({'m5m8peve wRi eveNICD','m5m8peve ctaRi eveNICD'},1,Info,Path,Exps,'NE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],15)

    CompareMeans({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],0)
    CompareMeans({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],0)
    CompareMeans({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],0)
    CompareMeans({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,Path,Exps, 'MSE|NE', 1, XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],[],0)
    CompareMeans({'vndEEEpeve ctaRi'},3,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],0)
    CompareMeans({'vndEEEpeve wRi'},3,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],0)
 
    
    % 
     %% EPIG / MATERNAL FACTORS
    PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15
    PalettePoints = PaletteMain; PaletteMeans = PaletteMain;
    PaletteGray = repmat([130,130,130]./255,10,1);
    PaletteGreen = repmat([142,183,36]./255,10,1);
    PaletteYellow = repmat([250,174,64]./255,10,1);
    PaletteBlue = repmat([61,131,183]./255,10,1);

    % CELLULARIZATION
    XLim = [-20,60];
    YLim = 1100; Selection ='';
    
    % controls gal4
    CompareMeans({'m5m8peve','m5m8peve wRi','m5m8peve aTubG4'},1,Info,Path,Exps,'MSE|NE|ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],15)
    CompareMeans({'m5m8peve','m5m8peve wRi','m5m8peve aTubG4'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],30)
    %mediators
    CompareMeans({'m5m8peve wRi','m5m8peve med7Ri','m5m8peve skdRi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,9,13],:), PaletteMeans([1,9,13],:),[0,YLim],[],30)
    %pioneers
    CompareMeans({'m5m8peve wRi','m5m8peve zldRi','m5m8peve grhRi','m5m8peve TrlRi'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,15,13,9],:), PaletteMeans([1,15,13,9],:),[0,YLim],[],30)            
    %activators
    CompareMeans({'m5m8peve wRi','m5m8peve nejRi','m5m8peve trrRi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,15,14],:), PaletteMeans([1,15,14],:),[0,YLim],[],30)
    %repressors
    CompareMeans({'m5m8peve wRi','m5m8peve HRi', 'm5m8peve GroRi'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,7,12],:), PaletteMeans([1,7,12],:),[0,YLim],[],30)
    % to see derepression
    CompareMeans({'m5m8peve wRi','m5m8peve HRi', 'm5m8peve GroRi','m5m8peve EzRi'},1,Info,Path,Exps,'MSE|NE|ME', 1, XLim,PalettePoints([1,7,12,11],:), PaletteMeans([1,7,12,11],:),[0,YLim],[],15)
    CompareMeans({'m5m8peve wRi','m5m8peve EzRi'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,11],:), PaletteMeans([1,11],:),[0,YLim],[],30)
    %CompareMeans({'m5m8peve wRi eveNICD','m5m8peve HRi eveNICD'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints([1,7],:), PaletteMeans([1,7],:),[0,YLim])
    %CompareMeans({'m5m8peve wRi eveNICD','m5m8peve HRi eveNICD'},1,Info,Path,Exps,'NE', 1, XLim,PalettePoints([1,7],:), PaletteMeans([1,7],:),[0,YLim])


        
    %%
    YLim = 1100;Selection = '';
     XLim = [-50,90]
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,2,5,6],:), PaletteMeans([1,2,5,6],:),[0,YLim])
    CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'simMSEpeve'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

  
        %CompareMeans({'m5m8peve','simMSEpeve'},1,Info,Path,Exps, Selection, 0, XLim,PalettePoints, PaletteMeans)
    %% 2 alleles
    YLim = 1100;Selection = '';
     XLim = [-50,90]
    CompareMeans({'m5m8pevex2','simMSEpevex2'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

   %%
   XLim = [-50,70]
    YLim = 1100    
    Selection = '';
        %% eve-NICD x 1
    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;

    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([3,4],:), PaletteMeans([3,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([3,4],:), PaletteMeans([3,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,4],:), PaletteMeans([3,4],:),[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +','m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +','m5m8peve eveNICD','simMSEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %%
    PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100;100,100,100;100,100,100;100,100,100]./255;
    PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80;80,80,80;80,80,80;80,80,80]./255;

    CompareMeans({'m5m8peve eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'simMSEpeve eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %% eve-NICD x2
     PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;

    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, Selection, 1, XLim,PalettePoints([1,3,5],:), PaletteMeans([1,3,5],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3,5],:), PaletteMeans([1,3,5],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([3,5],:), PaletteMeans([3,5],:),[0,YLim])
    CompareMeans({'m5m8pevel eveNICD','m5m8pevel 2xeveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([3,5],:), PaletteMeans([3,5],:),[0,YLim])
    CompareMeans({'m5m8pevel eveNICD','m5m8pevel 2xeveNICD'},1,Info,Path,Exps, 'DE', 1, XLim,PalettePoints([3,5],:), PaletteMeans([3,5],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD25C','m5m8peve eveNICD','m5m8peve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3,3,5],:), PaletteMeans([1,3,3,5],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4,6],:), PaletteMeans([2,4,6],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,6],:), PaletteMeans([2,4,6],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4,6],:), PaletteMeans([2,4,6],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD',},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,4,5,6],:), PaletteMeans([3,4,5,6],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD',},1,Info,Path,Exps, '', 1, XLim,PalettePoints([3,4,5,6],:), PaletteMeans([3,4,5,6],:),[0,YLim])

    CompareMeans({'m5m8peve 2xeveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

    
    %% prob sim 25C is 51D
%     CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve eveNICD25C','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4,4,6],:), PaletteMeans([2,4,4,6],:),[0,YLim])
%     CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve eveNICD25C','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,4,6],:), PaletteMeans([2,4,4,6],:),[0,YLim])
%     CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeve eveNICD25C','simMSEpeve 2xeveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4,4,6],:), PaletteMeans([2,4,4,6],:),[0,YLim])
% 
%     CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve eveNICD25C','simMSEpeve eveNICD25C'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3,4,5,6],:), PaletteMeans([3,4,5,6],:),[0,YLim])

    %% Dtwi  Ddl
       PalettePoints = [142,183,36;105,139,34;130,130,130;80,80,80;105,89,205;]./255;
    PaletteMeans = [142,183,36;105,139,34;130,130,130;80,80,80;105,89,205;]./255;

    CompareMeans({'m5m8peve +','m5m8peveDtwi +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peveDtwi +','m5m8peveDtwi eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

        CompareMeans({'m5m8peveDtwi +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveDtwi eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

    CompareMeans({'m5m8peveDdl +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveDdl eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peveDdl +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peveDdl eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peveDdl eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8peveDdl +','m5m8peveDdl eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

    %% SPS sites
     PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100]./255;
    PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80]./255;
    
    CompareMeans({'simMSEpeveSPS +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'simMSEpeveSPS eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'simMSEpeveSPS eveNICD'},3,Info,Path,Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveiSPS +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'m5m8peveiSPS eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;

    CompareMeans({'simMSEpeve +','simMSEpeveSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeveSPS +'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])

    CompareMeans({'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4,6,6],:), PaletteMeans([2,4,6,6],:),[0,YLim])
    CompareMeans({'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,6,6],:), PaletteMeans([2,4,6,6],:),[0,YLim])
    CompareMeans({'simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4,6,6],:), PaletteMeans([2,4,6,6],:),[0,YLim])

    
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeveSPS +','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareMeans({'simMSEpeve +','simMSEpeve eveNICD','simMSEpeveSPS +','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    
    CompareMeans({'m5m8peve +','m5m8peveiSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peveiSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])

%% m8NE
        CompareMeans({'m8NEpeve eveNICD'},3,Info,Path,Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        CompareMeans({'m8NEpeve eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
CompareMeans({'m8NEpeve +'},3,Info,Path,Exps, 'ME', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        CompareMeans({'m8NEpeve +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %% SPS, only NICD or WT
    PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
    %CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8pevenSPS eveNICD','simMSEpeveSPS eveNICD','m5m8peveinsSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
    %CompareMeans({'m5m8peve +','simMSEpeve +','m5m8pevenSPS +','simMSEpeveSPS +','m5m8peveinsSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','simMSEpeveSPS eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','simMSEpeveSPS eveNICD','m8NEpeve eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4,5],:), PaletteMeans([1,2,4,5],:),[0,YLim])
    CompareMeans({'m5m8peve +','simMSEpeve +','simMSEpeveSPS +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
        CompareMeans({'simMSEpeve eveNICD','simMSEpeveSPS eveNICD','m8NEpeve eveNICD'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,5],:), PaletteMeans([2,4,5],:),[0,YLim])    
    CompareMeans({'m5m8peve +','simMSEpeve +','simMSEpeveSPS +','m8NEpeve +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4,5],:), PaletteMeans([1,2,4,5],:),[0,YLim])
        CompareMeans({'simMSEpeve +','simMSEpeveSPS +','m8NEpeve +'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([2,4,5],:), PaletteMeans([2,4,5],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','simMSEpeveSPS eveNICD','m8NEpeve eveNICD'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,2,4,5],:), PaletteMeans([1,2,4,5],:),[0,YLim])


    %% eveNICD, evetwi
    CompareMeans({'simMSEpeve eveNICD','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve eveNICD','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve eveNICD','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'ME', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'simMSEpeve eveNICD','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'simMSEpevel eveNICD','simMSEpevel eveNICDtwi'},1,Info,Path,Exps, 'DE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'simMSEpevel eveNICD','simMSEpevel eveNICDtwi'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])

   CompareMeans({'simMSEpeve eveNICDtwi'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
   CompareMeans({'simMSEpeve eveNICDtwi'},3,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
   CompareMeans({'simMSEpevel eveNICDtwi'},3,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
   CompareMeans({'simMSEpevel eveNICDtwi'},3,Info,Path,Exps, 'DE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])

   CompareMeans({'m5m8peve eveNICD','m5m8peve eveNICDtwi'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peve eveNICDtwi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
    CompareMeans({'m5m8peve eveNICD','m5m8peve eveNICDtwi'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
        CompareMeans({'m5m8pevel eveNICD','m5m8pevel eveNICDtwi'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])
        CompareMeans({'m5m8pevel eveNICD','m5m8pevel eveNICDtwi'},1,Info,Path,Exps, 'DE', 1, XLim,PalettePoints([1,2,4],:), PaletteMeans([1,2,4],:),[0,YLim])

  CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve eveNICDtwi','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
  CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve eveNICDtwi','simMSEpeve eveNICDtwi'},1,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

      CompareMeans({'m5m8peve eveNICDtwi'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
      CompareMeans({'m5m8peve eveNICDtwi'},3,Info,Path,Exps, '', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

  %% saturation pm5
      PalettePoints = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    PaletteMeans = [142,183,36;105,139,34;130,130,130;80,80,80;]./255;
    


        CompareMeans({'m5m8peve eveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
        CompareMeans({'m5m8peve eveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])
        CompareMeans({'m5m8peve eveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'NE', 1, XLim,PalettePoints([2,4],:), PaletteMeans([2,4],:),[0,YLim])

        CompareMeans({'m5m8peve +','m5m8pm5 +'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
        CompareMeans({'m5m8peve +','m5m8pm5 +'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
        CompareMeans({'m5m8peve +','m5m8peve eveNICD','m5m8pm5 +','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])

        PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;179,179,179;89,89,89;105,89,205;100,100,100;100,100,100;100,100,100;100,100,100]./255;
    PaletteMeans = [105,139,34;54,100,139;205,55,0;205,149,12;102,102,102;51,51,51;71,60,139;80,80,80;80,80,80;80,80,80;80,80,80]./255;
        CompareMeans({'m5m8pm5 +'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        CompareMeans({'m5m8pm5 eveNICD'},3,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim])
        %%
         PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;80,80,80]./255;
        PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86;80,80,80]./255;
        
            CompareMeans({'m5m8peve eveNICD','simMSEpeve eveNICD','m5m8peve 2xeveNICD','simMSEpeve 2xeveNICD','m5m8pm5 eveNICD'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3:7],:), PaletteMeans([3:7],:),[0,YLim])

%% Other things
XLim = [-50,60]
YLim = 1100;
            CompareMeans({'eve2','eve2PP7'},1,Info,Path,Exps, '', 1, XLim,PalettePoints([3:7],:), PaletteMeans([3:7],:),[0,YLim])
            CompareMeans({'eve2','eve2PP7'},1,Info,Path,Exps, 'MSE', 1, XLim,PalettePoints([3:7],:), PaletteMeans([3:7],:),[0,YLim])


%%

%% COMPARE # CELLS ON

Which = 1 % 1 to merge all repeats, 3 for each
UniqueN = table2array(unique(Exps(:,Which)));         
for n = 1:(floor(length(UniqueN)/20)+1)
    Fig1 = figure('PaperSize',[50 50],'PaperUnits','inches','resize','on', 'visible','on');
    Fig1.Renderer='Painters';
    %
    Selection = '';
    %try
    ToSave = [Path];
    for i = 1:20
        try
            Index = find(cellfun(@(x) strcmp(x,UniqueN{(n-1)*20+i}),table2array(Exps(:,Which)))==1)';
            for x = 1:length(Index)
                try
                Experiment = [Exps.Nickname{Index(x)},' ',num2str(Exps.Rep(Index(x)))]
                PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
                    Info.Name{Index(x)},Info.File{Index(x)}];                 
                Data = load([PathToSave,'_Data.mat']);
                OnOff = Data.Data.OnOff;
                OnOff = CleanOnOff(OnOff,5);
                Properties = Data.Data.Properties;
                Baseline = Data.Data.Baseline;
                TimeScale = Data.Data.TimeScale;
                Bits = Info.Bits(Index(x));
                TimeRes = Info.TimeRes(Index(x));
                nc14 = Info.nc14(Index(x));
                Delay = Info.Delay(Index(x));
                figure(Fig1);
                subplot(10,2,i); hold on
                plot(TimeScale,sum(OnOff,2))
                %ylim([0,6]) 
                xlim([XLim,90]); 
                title(Experiment)
                end
            end 
    end

    end
    if n==1
          print(Fig1,[ToSave,Selection,MetaFile,'numCellsOn.ps'],'-fillpage', '-dpsc');
     else
          print(Fig1,[ToSave,Selection,MetaFile,'numCellsOn.ps'],'-fillpage', '-dpsc','-append');
     end
end
close all
%%
%% COMPARE # CELLS ON BOXPLOTS

Which = 1 % 1 to merge all repeats, 3 for each
UniqueN = table2array(unique(Exps(:,Which))); 
Ncol = 3;
Nrow = 6;
for n = 1:(floor(length(UniqueN)/(Ncol*Nrow))+1)
    Fig1 = figure('PaperSize',[50 50],'PaperUnits','inches','resize','on', 'visible','on');
    Fig1.Renderer='Painters';
    %
    Selection = '';
    %try
    ToSave = [Path];
    
    for i = 1:(Ncol*Nrow)
        try
            Index = find(cellfun(@(x) strcmp(x,UniqueN{(n-1)*(Ncol*Nrow)+i}),table2array(Exps(:,Which)))==1)';
            OnPerFrame = [];
            for x = 1:length(Index)
                try
                Experiment = [Exps.Nickname{Index(x)},' ',num2str(Exps.Rep(Index(x)))]
                PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
                    Info.Name{Index(x)},Info.File{Index(x)}];                 
                Data = load([PathToSave,'_Data.mat']);
                OnOff = Data.Data.OnOff;
                OnOff = CleanOnOff(OnOff,5);
                Properties = Data.Data.Properties;
                Baseline = Data.Data.Baseline;
                TimeScale = Data.Data.TimeScale;
                Bits = Info.Bits(Index(x));
                TimeRes = Info.TimeRes(Index(x));
                nc14 = Info.nc14(Index(x));
                Delay = Info.Delay(Index(x));
                figure(Fig1);
                subplot(Nrow,Ncol,i); hold on
                OnOffTimeOff = OnOff(15*60/TimeRes+nc14-Delay:25*60/TimeRes+nc14-Delay,:);
                OnPerFrame(:,x) = sum(OnOffTimeOff,2);
                
                end
            end 
         boxplot(OnPerFrame,'BoxStyle','outline','Widths',0.2,'Symbol','.','Jitter',1,'Whisker',0,'Notch','on');
         ylim([0,15])
         ylabel('# cells ON 15-25''')
         %3.xlabel('repeat')
         title(UniqueN{(n-1)*(Ncol*Nrow)+i});box off;
            set(findobj(gca, 'type', 'line'), 'linew',1)
         
    end

    end
    if n==1
          print(Fig1,[ToSave,Selection,MetaFile,'numCellsOnBoxplot.ps'],'-fillpage', '-dpsc');
     else
          print(Fig1,[ToSave,Selection,MetaFile,'numCellsOnBoxplot.ps'],'-fillpage', '-dpsc','-append');
     end
end
close all

