
%% compare all repeats of each experiment or each separately
clear all



MetaFile = ' mutBG';
%MetaFile = ' Dillan';


Path = ['/Users/julia/Google Drive jf565/comp 3D/',MetaFile,'/'];
mkdir(Path)


Info = readtable(['~/Google Drive jf565/MATLAB_R_scripts/metadata MS2 3D',MetaFile,'.txt'],'ReadVariableNames', true,'Delimiter','\t');
Exps = cell2table(Info.Nickname, 'VariableNames',{'Nickname'});
Exps.Rep = Info.Rep;
for x=1:size(Exps,1); Exp{x} = [Exps.Nickname{x},' ',num2str(Exps.Rep(x))];end
Exps.Exp = Exp';

PalettePoints = [179,238,58;99,184,255;238,64,0;255,185,15;255,80,250;89,89,89;105,89,205;100,100,100]./255;
PaletteMeans = [105,139,34;
    255,80,250;
    99,184,255;
    255,185,15;
    102,102,102;
    51,51,51;
    71,60,139;
    80,80,80]./255;

%PalettePoints = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;
%PaletteMeans = [142,183,36;61,131,183;105,139,34;54,100,139;62,81,16;33,63,86]./255;


set(0,'defaultAxesFontSize',16)
%set(0,'defaultAxesFontName', 'Myriad Pro')



%% 3D props NupGFP
XLim = [-20,50];
    YLim = inf; Selection = '';
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity',30)
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_2',30)
    CompareProperty({'nup107GFP V'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_3',30)
    
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,150],'Volume',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,1],'Solidity',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,200],'SurfaceArea',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,15],'PrincipalAxisLength_1',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,15],'PrincipalAxisLength_2',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,15],'PrincipalAxisLength_3',30)
    
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(2,:), PaletteMeans(3,:),[0,20],'Area3',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(5,:), PaletteMeans(2,:),[0,20],'Area2',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,20],'Area1',30)

    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(2,:), PaletteMeans(3,:),[0,15],'Perimeter3',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(5,:), PaletteMeans(2,:),[0,15],'Perimeter2',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,15],'Perimeter1',30)
    
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,1],'Eccentricity1',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(5,:), PaletteMeans(2,:),[0,1],'Eccentricity2',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(2,:), PaletteMeans(3,:),[0,1],'Eccentricity3',30)

    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,YLim],'EquivDiameter1',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,YLim],'EquivDiameter2',30)
    CompareProperty({'nup107GFP V'},1,Info,Path,Exps,'', XLim,PalettePoints(4,:), PaletteMeans(1,:),[0,YLim],'EquivDiameter3',30)

    
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'nup107GFP V', 'm5m8II'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)
    
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(4,:),[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Eccentricity3',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(4,:),[0,YLim],'Area1',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Area2',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Area3',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(4,:),[0,YLim],'Perimeter1',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Perimeter2',30)
    CompareProperty({'m5m8IInup'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Perimeter3',30)
    
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area1',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area2',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area3',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter1',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter2',30)
    CompareProperty({'m5m8IInup'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter3',30)
    
    CompareProperty({'nup107GFP V','nup107GFP L'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'nup107GFP V','nup107GFP L'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)

%% 3D props Kuk and cta histones

    XLim = [-20,70];
    YLim = Inf; Selection = '';
    
    % number after nicknames can be 1 (combine all repeats and do mean) or
    % 3 (plot mean of each repeat separately, can do only one genotype at a
    % time).
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Extent1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Extent2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Area3',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Perimeter3',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Extent3',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity3',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)
    
    
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_3',30)
    
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(1,:),[0,YLim],'Area1',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(1,:),[0,YLim],'Perimeter1',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(1,:),[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Area2',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Perimeter2',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(2,:),[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Area3',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Perimeter3',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans(3,:),[0,YLim],'Eccentricity3',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'m5m8peve wRi'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)

    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Solidity',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'SurfaceArea',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_3',30)
    
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)

    Palette = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15
    PalettePoints = Palette([1,9],:); PaletteMeans = PalettePoints;
        XLim = [-20,50];
        Selection = 'ME';
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,350],'Volume',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,1],'Solidity',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,350],'SurfaceArea',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'PrincipalAxisLength_2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'PrincipalAxisLength_3',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,25],'Area1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,25],'Area2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,25],'Area3',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'Perimeter1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'Perimeter2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,20],'Perimeter3',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,1],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,1],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi'},1,Info,Path,Exps,Selection, XLim,PalettePoints, PaletteMeans,[0,1],'Eccentricity3',30)

    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity1',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity2',30)
    CompareProperty({'m5m8peve wRi','m5m8peve ctaRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Eccentricity3',30)

    
    CompareProperty({'m5m8peveIII kukRi m&z'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8peveIII kukRi m&z'},3,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
%% 3D props histones Ventral vs Lateral
    CompareProperty({'m5m8peve wRi','m5m8pevel wRi eveNICD'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'Volume',30)
    CompareProperty({'m5m8peve wRi','m5m8pevel wRi eveNICD'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_1',30)
    CompareProperty({'m5m8peve wRi','m5m8pevel wRi eveNICD'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_2',30)
                CompareProperty({'m5m8peve wRi','m5m8pevel wRi eve . NICD'},1,Info,Path,Exps,'', XLim,PalettePoints, PaletteMeans,[0,YLim],'PrincipalAxisLength_3',30)

      %% compare means kuk
Path = ['/Users/julia/Google Drive jf565/comp MS2/',MetaFile,'/'];
mkdir(Path)

      XLim = [-20,70];
    YLim = 1500;Selection = '';
  
                CompareMeans({'m5m8peve wRi','m5m8peveIII kukRi m&z'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],30)
                CompareMeans({'m5m8peve wRi','m5m8peveIII kukRi m&z','m5m8peveIII kukRi m'},1,Info,Path,Exps,'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],30)
                CompareMeans({'m5m8peveIII kukRi m&z'},3,Info,Path,Exps,'MSE', 1, XLim,PalettePoints, PaletteMeans,[0,YLim],[],30)
