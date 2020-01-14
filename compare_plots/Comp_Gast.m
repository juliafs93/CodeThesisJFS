%% COMPARE GASTRULATION
clear all
%Path = '/Users/julia/Google Drive jf565/comp MS2/OnOff/';


MetaFile = '';
MetaFile = ' enhprom';
%MetaFile = ' ecNICD';
MetaFile = ' mutBG';
%MetaFile = ' margherita';
%MetaFile = ' all';

%MetaFile = ' 2c';

%MetaFile = ' other';

PathF = ['/Users/julia/Google Drive jf565/comp gast/',MetaFile,'/'];
mkdir(PathF)


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

%%
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

    % CELLULARIZATION
    XLim = [-20,60];
    YLim = 0.15;Selection = '';
    CompareGastrulation({'m5m8pevezo','m5m8peve Dl', 'm5m8peve neur'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareGastrulation({'m5m8peve mDr:TTG','m5m8peve Ez:TTG', 'm5m8peve TTG, mEz'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareGastrulation({'m5m8peveIII', 'm5m8peveIII CTG:+', 'm5m8peveIII slam:+'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints, PaletteMeans,[0,YLim])
    %CompareGastrulation({'m5m8peveIII CTG', 'm5m8peveIII slam'},1,Info,PathF,Exps, Selection,XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareGastrulation({'m5m8peveIII', 'm5m8peveIII slam:CTG:CTG', 'm5m8peveIII slam'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,9,3],:), PaletteMeans([1,9,3],:),[0,YLim])
    CompareGastrulation({'m5m8peveIII', 'm5m8peveIII slam'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,3],:), PaletteMeans([1,3],:),[0,YLim])
    CompareGastrulation({'m5m8peveIII'},3,Info,PathF,Exps, '',XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareGastrulation({'m5m8pevez','m5m8peve Nullo', 'm5m8peve Nullo:+'},1,Info,PathF,Exps, Selection,XLim,PalettePoints, PaletteMeans,[0,YLim])
    CompareGastrulation({'m5m8pevez','m5m8peve IB','m5m8peve Arm'},1,Info,PathF,Exps, Selection,XLim,PalettePoints, PaletteMeans,[0,YLim])
     
    % GASTRULATION 
    XLim = [-20,70];
    CompareGastrulation({'m5m8peve','m5m8peve eveNICD','vndEEEpeve'},1,Info,PathF,Exps, 'MSE', XLim,PalettePoints([1,2,14],:), PaletteMeans([1,2,14],:),[0,YLim])
    CompareGastrulation({'m5m8peve eveNICD','vndEEEpeve'},1,Info,PathF,Exps, 'NE',XLim,PalettePoints([2,14],:), PaletteMeans([2,14],:),[0,YLim])
    CompareGastrulation({'m5m8peve','vndEEEpeve'},1,Info,PathF,Exps, 'MSE|NE',XLim,PalettePoints([3,14],:), PaletteMeans([3,14],:),[0,YLim])

    CompareGastrulation({'m5m8peve','m5m8peve Fog:+','m5m8peve Fog'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'m5m8peve wRi','m5m8peve ctaRi','m5m8peve RhoGEF2Ri'},1,Info,PathF,Exps,'MSE',XLim,PalettePoints([1,9,6],:), PaletteMeans([1,9,6],:),[0,YLim],30)
    
    CompareGastrulation({'m5m8peve'},3,Info,PathF,Exps,'MSE',XLim,PaletteGray, PaletteGray,[0,YLim],[])
    CompareGastrulation({'m5m8peve Fog'},3,Info,PathF,Exps, 'MSE',XLim,PaletteGreen, PaletteGreen,[0,YLim])
    CompareGastrulation({'m5m8peve wRi'},3,Info,PathF,Exps,'MSE',XLim,PaletteGray, PaletteGray,[0,YLim],30)
    CompareGastrulation({'m5m8peve ctaRi'},3,Info,PathF,Exps,'MSE',XLim,PaletteYellow, PaletteYellow,[0,YLim],30)

    
    XLim = [-20,60];
    CompareGastrulation({'m5m8peve eveNICD','m5m8peve Fog:+ eveNICD','m5m8peve Fog eveNICD'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'m5m8peve eveNICD','m5m8peve Fog:+ eveNICD','m5m8peve Fog eveNICD'},1,Info,PathF,Exps, 'NE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'m5m8peve Fog eveNICD'},3,Info,PathF,Exps, 'MSE',XLim,PaletteGreen, PaletteGreen,[0,YLim])
    CompareGastrulation({'m5m8peve Fog:+ eveNICD'},3,Info,PathF,Exps, 'MSE',XLim,PaletteGray, PaletteGray,[0,YLim])
    CompareGastrulation({'m5m8peve eveNICD'},3,Info,PathF,Exps, 'MSE',XLim,PaletteGray, PaletteGray,[0,YLim])

    CompareGastrulation({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,PathF,Exps, '',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,PathF,Exps, 'NE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'vndEEEpeve','vndEEEpeve Fog:+','vndEEEpeve Fog'},1,Info,PathF,Exps, 'MSE|NE',XLim,PalettePoints([1,5,3],:), PaletteMeans([1,5,3],:),[0,YLim])
    CompareGastrulation({'vndEEEpeve Fog'},3,Info,PathF,Exps, 'MSE|NE',XLim,PalettePoints, PaletteMeans,[0,YLim])

   
    
 
    XLim = [-20,60];
    CompareGastrulation({'m5m8peve wRi eveNICD','m5m8peve ctaRi eveNICD'},1,Info,PathF,Exps,'MSE',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],15)
    CompareGastrulation({'m5m8peve wRi eveNICD','m5m8peve ctaRi eveNICD'},1,Info,PathF,Exps,'NE',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],15)

    CompareGastrulation({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,PathF,Exps, '',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],0)
    CompareGastrulation({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,PathF,Exps, 'MSE',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],0)
    CompareGastrulation({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,PathF,Exps, 'NE',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],0)
    CompareGastrulation({'vndEEEpeve wRi','vndEEEpeve ctaRi'},1,Info,PathF,Exps, 'MSE|NE',XLim,PalettePoints([1,9],:), PaletteMeans([1,9],:),[0,YLim],0)
    CompareGastrulation({'vndEEEpeve ctaRi'},3,Info,PathF,Exps, '',XLim,PalettePoints, PaletteMeans,[0,YLim],0)
    CompareGastrulation({'vndEEEpeve wRi'},3,Info,PathF,Exps, '',XLim,PalettePoints, PaletteMeans,[0,YLim],0)
 
%%

XLim = [-40,80]
Which = 3 % 1 to merge all repeats, 3 for each

UniqueN = table2array(unique(Exps(:,Which))); 
%UniqueN = table2array(Exps(find(cellfun(@(x) strcmp(x,'m5m8peve ctaRi'),table2array(Exps(:,1)))==1)',3));

%UniqueN = UniqueN(30:end)
Subplots = 24;
NCol = 3;
for n = 1:(floor(length(UniqueN)/Subplots)+1)
    Fig1 = figure('PaperSize',[50 50],'PaperUnits','inches','resize','on', 'visible','off');
    Fig1.Renderer='Painters';
    set(Fig1,'defaultAxesColorOrder',[[144,191,91]./255;[209,28,71]./255]);
    %
    Selection = 'MSE'; %will try Region and if it doesnt exist still do ~= 'EarlyOnly'. still always plots all early only before 15min and selection afer 15min
    %try
    ToSave = [PathF];
    for i = 1:Subplots
        try
            Index = find(cellfun(@(x) strcmp(x,UniqueN{(n-1)*Subplots+i}),table2array(Exps(:,Which)))==1)';
            for x = 1:length(Index)
                try
                Experiment = [Exps.Nickname{Index(x)},' ',num2str(Exps.Rep(Index(x)))]
                PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
                Info.Name{Index(x)},Info.File{Index(x)}];                 
                load([PathToSave,'_Data.mat']);
                Struct2Vars(Data);
                Parameters = Info(Index(x),:);
                Table2Vars(Parameters);
            
           
                if strcmp(Selection,'') == 1
                    Selected = [Properties.Type ~= 'EarlyOnly'];
                else
                    try
                        Selected = [Properties.Type ~= 'EarlyOnly' & Properties.Region == Selection];
                        Experiment = [Experiment,'_',Selection]
                    catch
                        Selected = [Properties.Type ~= 'EarlyOnly'];
                    end
                end
                
                minOn = 5;
                Labels = Properties.NewLabel;
                [~, ~,PropertiesNew, ~] = DefineExpAll(MaxF,MaxFBG,CentX,Labels,Baseline,TimeRes,3,60,SplitEarly,nc14,Delay,minOn);
                %close Fig
                Properties.Onset = PropertiesNew.Onset;
                Properties.Type = PropertiesNew.Type;
                Norm = ((MaxF-Baseline').*Baseline(1)./Baseline').*(2.^(12-Bits));
                Norm(Norm==0) = NaN;
                NormBG = (MaxFBG-Baseline').*Baseline(1)./Baseline';
                NormBG(NormBG==0) = NaN;
                
                MeantoPlot = [nanmean(Norm(1:nc14-Delay+15*60/TimeRes,Properties.Type == 'EarlyOnly'),2);...
                    nanmean(Norm(nc14-Delay+15*60/TimeRes+1:end,Selected),2)];
                
                MovX = abs(diff(CentX,1,1))*XYRes;
                MovY = abs(diff(CentY,1,1))*XYRes;
                MovZ = abs(diff(CentZ,1,1))*ZRes;
                MovXYZ = sqrt(MovX.^2+MovY.^2+MovZ.^2)./TimeRes;
                MovXYZ = (MovY)./TimeRes;
                
                Fig3 = figure('PaperSize',[45 15],'PaperUnits','inches','resize','on', 'visible','on');
                X = CentX(nc14-Delay+1:end,Selected); Y = CentY(nc14-Delay+1:end,Selected);
                I = Norm(nc14-Delay+1:end,Selected); M = MovXYZ(nc14-Delay+1:end,Selected); M(end+1,:)= NaN;
                T = repmat(TimeScale(nc14-Delay+1:end),1,sum(Selected));
                subplot(131);scatter(X(:),Y(:),[],T(:)./T(end)*100,'filled');
                axis equal; xlim([1,size(CentroidsF,1)]);ylim([1,size(CentroidsF,2)])
                subplot(132);scatter(X(:),Y(:),[],M(:)./0.2*100,'filled');
                axis equal; xlim([1,size(CentroidsF,1)]);ylim([1,size(CentroidsF,2)])
                subplot(133);scatter(X(:),Y(:),[],I(:)./3000*100,'filled');
                axis equal; xlim([1,size(CentroidsF,1)]);ylim([1,size(CentroidsF,2)]);
                print(Fig3,[ToSave,'PlotsEach/',Experiment,'_scatter.pdf'],'-fillpage', '-dpdf');

%                 uncomment to draw transitions
                %try
                    disp('here')
                    GastValues = Data.GastValues;
                    PeakT = GastValues(:,1);
                    PeakF = GastValues(:,2);
                    GastT = GastValues(:,3);
                    
                    
                    % DELETE LATER. JUST TO SAVE PLOT
                    %%%%%%%%%%%%%%%%%%%%%%%%%
                    Fig2 = figure('PaperSize',[15 15],'PaperUnits','inches','resize','on', 'visible','on');
                        subplot(211)
                        plot(TimeScale,MeantoPlot, '-','Color',[144,191,91]./255,'LineWidth',1); hold on 
                        title('Select Peak#1, transition and Peak#2 (NaN @ t<0)')
                        plot(PeakT,PeakF,'*r')
                        xlim([0,70])

                        subplot(212)
                        yyaxis left
                        plot(TimeScale,CentY, '-','Color',[[61,131,183]./255,0.3],'LineWidth',0.5); hold on 
                        title('Select Begining, peak and end of gastrulation (NaN @ t<0)')
                        yyaxis right
                        plot(TimeScale(1:end-1),medfilt1(nanmean(MovXYZ(:,Selected),2),5),'-','Color',[33,63,86]./255,'LineWidth',1)
                        yyaxis left
                        plot([GastT,GastT],[0,400],'--')
                        xlim([0,70])

                        hold off
                     %%%%%%%%%%%%%%%%%%%%%%%   
                    print(Fig2,[ToSave,'PlotsEach/',Experiment,'.pdf'],'-fillpage', '-dpdf');
                close(Fig2)
                try
                catch    
                    answer = 'No';
                    while strcmp(answer,'Yes') ~= 1
                        Fig2 = figure();
                        subplot(211)
                        plot(TimeScale,MeantoPlot, '-','Color',[144,191,91]./255,'LineWidth',1); hold on 
                        title('Select Peak#1, transition and Peak#2 (NaN @ t<0)')
                        [PeakT,PeakF] = ginput(3); 
                        PeakF(PeakT<0) = NaN; PeakT(PeakT<0) = NaN
                        plot(PeakT,PeakF,'*r')

                        subplot(212)
                        yyaxis left
                        plot(TimeScale,CentY, '-','Color',[144,191,91]./255,'LineWidth',1); hold on 
                        title('Select Begining, peak and end of gastrulation (NaN @ t<0)')
                        yyaxis right
                        plot(TimeScale(1:end-1),medfilt1(nanmean(MovXYZ(:,Selected),2),5),'-','Color',[209,28,71]./255,'LineWidth',1)
                        [GastT,~] = ginput(3); 
                        yyaxis left
                        plot([GastT,GastT],[0,400],'--')
                        hold off
                        answer = questdlg('OK?');
                        if strcmp(answer,'Cancel' )  
                            close(Fig2)
                            GastValues = nan(3,3);
                            close all
                            break
                        end
                        %save mat
                        MeanF = [nanmean(MeantoPlot(max(1,30*60/TimeRes+nc14-Delay+1):min(Frames,+50*60/TimeRes+nc14-Delay+1))),NaN,NaN]';
                        GastValues = [PeakT,PeakF,GastT,MeanF];                        
                        close(Fig2)
                    end
                    % add to Data
                    Data.GastValues = GastValues;
                    save([PathToSave,'_Data.mat'],'Data');
                    close(Fig2)
                    pause(0.1)
                end
  
                %%%%% uncomment to just draw
%                 figure(Fig1);
%                 set(Fig1, 'Visible','off')
%                 subplot(Subplots/NCol,NCol,i); hold on
%                 yyaxis('left')
%                 plot(TimeScale,MeantoPlot, '-','Color',[144,191,91]./255,'LineWidth',1)
%                 plot(TimeScale,nanmean(NormBG,2), '-','Color',[200,200,200]./255,'LineWidth',1)
%                 plot(PeakT,PeakF,'*r')
%                 ylim([-100,1100])
%                 xlim([XLim]); 
%                 ylabel('Mean F (AU)')
%                 
%                 yyaxis('right')
%                 xlim([XLim]); 
%                 ylim([0,0.25]) 
%                 plot(TimeScale(1:end-1),medfilt1(nanmean(MovXYZ(:,Selected),2),5),'-','Color',[209,28,71]./255,'LineWidth',1)
%                 plot([GastT,GastT],[0,0.25],'--','Color',[209,28,71]./255,'LineWidth',1)
%                 title(Experiment)
%                     xlabel('Time into nc14 (min)')
%                     ylabel('Mean DV displacement (um/s)')


%                    
%                 plot(TimeScale,CentY(:,Selected),'LineStyle','-')
%                 plot(TimeScale,nanmean(CentY(:,Selected),2),'LineStyle','-')
%                 plot(TimeScale,nanmean(CentY(:,Selected),2)+nanstd(CentY,1,2),'LineStyle','--')
%                 plot(TimeScale,nanmean(CentY(:,Selected),2)-nanstd(CentY,1,2),'LineStyle','--')
%                 ylim([0,400])
                %%%%
                end
            end 
    end

    end
    if n==1
          print(Fig1,[ToSave,Selection,MetaFile,'gast.ps'],'-fillpage', '-dpsc');
     else
          print(Fig1,[ToSave,Selection,MetaFile,'gast.ps'],'-fillpage', '-dpsc','-append');
     end
end
close all

%%

%% correlate 
PaletteMain = [130,130,130;80,80,80; %grey1, grey2. 1,2
    142,183,36;105,139,34;62,81,16; %green1,green2,green3. 3:5
    61,131,183;54,100,139;33,63,86; %blue1,blue2,blue3. 6:8
    250,174,64;226,140,26; %yellow1, yellow2. 9:10
    167,51,170;104,15,107; %pink1, pink2. 11:12
    78,69,139; 54, 44,96; %purple1, purple2. 13:14
    205,55,0]./255; %red. 15

Which = 1 % 1 to merge all repeats, 3 for each
UniqueN = table2array(unique(Exps(:,Which))); 
PairstoSelect = {
    {'m5m8peve wRi','m5m8peve ctaRi','m5m8peve RhoGEF2Ri'},...
    {'m5m8peve wRi eveNICD','m5m8peve ctaRi eveNICD'},...
        {'m5m8peve','m5m8peve Fog:+', 'm5m8peve Fog'},...
        {'m5m8peve eveNICD','m5m8peve Fog:+ eveNICD', 'm5m8peve Fog eveNICD'},...
         {'Om5m8peve eveNICD','Om5m8peve Fog:+ eveNICD', 'Om5m8peve Fog eveNICD'},...
         {'vndEEEpeve','vndEEEpeve Fog:+', 'vndEEEpeve Fog'},...
    {'vndEEEpeve wRi','vndEEEpeve ctaRi'},...
        {'m5m8peve wRi','m5m8peve HRi','m5m8peve GroRi'},...
        {'m5m8peve wRi','m5m8peve med7Ri','m5m8peve skdRi'},...
        {'m5m8peve wRi','m5m8peve zldRi','m5m8peve grhRi'},...
        {'m5m8peve wRi','m5m8peve nejRi','m5m8peve trrRi','m5m8peve TrlRi'},...
        {'all'},...
        }
Nicknames = {
    {'\itwRi','\itctaRi','\itRhoGEF2Ri'},...
    {'\itwRi eveNICD','\itctaRi eveNICD'},...
        {'+','\itfog^{+/+/-}', '\itfog^{-}'},...
        {'+ \iteveNICD','\itFog^{+/+/-} eveNICD', '\itFog^{-} eveNICD'},...
                {'+ \iteveNICD','\itFog^{+/+/-} eveNICD', '\itFog^{-} eveNICD'},...
        {'+','\itfog^{+/+/-}', '\itfog^{-}'},...
           {'\itwRi','\itctaRi'},...
               {'\itwRi','\itHRi','\itGroRi'},...
               {'\itwRi','\itMED7Ri','\itskdRi'},...
               {'\itwRi','\itzldRi','\itgrhRi'},...
               {'\itwRi','\itnejRi','\ittrrRi','\itTrlRi'},...
        {'all'},...
        }
PaletteEach = {[1,9,6],...
    [2,10],...
    [1,5,3],...
    [1,5,3],...
    [1,5,3],...
    [1,14,13],...
    [1,13],...
    [1,7,12],[1,9,13],[1,15,13],[1,15,14,9],...
    [1]}
for n = [5]
SelectedN = PairstoSelect{n}
SelectedNames = Nicknames{n}
Palette = PaletteMain(PaletteEach{n},:);
Palette2 = kron(Palette,ones(2,1)); %duplicate each row consecutively
set(0,'defaultAxesColorOrder',Palette)
set(0,'defaultLegendAutoUpdate','on')

ToSave = [PathF,char(join(SelectedN,'_vs_'))];

Fig = figure('PaperSize',[45 30],'PaperUnits','inches','resize','on', 'visible','on');
Fig2 = figure('PaperSize',[40 12],'PaperUnits','inches','resize','on', 'visible','on');
%Fig2 = figure('PaperSize',[25 12],'PaperUnits','inches','resize','on', 'visible','on');
TranscTime = cell(1,length(SelectedN));
GastTime1 = cell(1,length(SelectedN));
GastTime2 = cell(1,length(SelectedN));
GastTime3 = cell(1,length(SelectedN));
Increase = cell(1,length(SelectedN));
PeakF1 = cell(1,length(SelectedN));

for i = 1:length(SelectedN)
    Selection = '';
        try
            Index = find(cellfun(@(x) strcmp(x,SelectedN{i}),table2array(Exps(:,Which)))==1)';
            if strcmp(SelectedN{i},'all'); Index = 1:height(Exps); end
            for x = 1:length(Index)
                try
                Experiment = [Exps.Nickname{Index(x)},' ',num2str(Exps.Rep(Index(x)))]
                PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
                Info.Name{Index(x)},Info.File{Index(x)}];                 
                load([PathToSave,'_Data.mat']);
                GastValues = Data.GastValues;
                PeakT = GastValues(:,1); PeakT(PeakT<0) = NaN;
                PeakF = GastValues(:,2);
                GastT = GastValues(:,3); GastT(GastT<0) = NaN;
                MeanF = GastValues(:,4);
                TranscTime{i} = [TranscTime{i},PeakT(2)];
                GastTime1{i} = [GastTime1{i},GastT(1)];
                GastTime2{i} = [GastTime2{i},GastT(2)];
                GastTime3{i} = [GastTime3{i},GastT(3)];
                Increase{i} = [Increase{i}, PeakF(3)-PeakF(1)];
                PeakF1{i} = [PeakF1{i},MeanF(1)];
                %TranscTimeAll{i} = [TranscTimeAll, TranscTime];
                %GastTime2All{i} = [GastTime2All,GastTime2];
                end
            end 
        end
        
  figure(Fig)      
  subplot(231); hold on
PlotScatter(GastTime1{i},TranscTime{i},SelectedNames{i}, 'Start of gastrulation (min into nc14)', 'Transition in levels (min)',1,0)

 subplot(232); hold on 
 PlotScatter(GastTime2{i},TranscTime{i},SelectedNames{i}, 'Start of ME invagination (min into nc14)', 'Transition in levels (min)',1,0)

 subplot(233); hold on 
 PlotScatter(GastTime3{i},TranscTime{i},SelectedNames{i}, 'End of gastrulation (min into nc14)', 'Transition in levels (min)',1,0)

  subplot(234); hold on    
 PlotScatter(GastTime2{i}-GastTime1{i},Increase{i},SelectedNames{i}, 'Length 1st gast half (min)','Increase in levels (AU)',1,0)
 
 subplot(235); hold on  
 PlotScatter(GastTime3{i}-GastTime2{i},Increase{i},SelectedNames{i}, 'Length 2nd gast half (min)','Increase in levels (AU)',1,0)
 
 subplot(236); hold on      
 PlotScatter(GastTime3{i}-GastTime1{i},Increase{i},SelectedNames{i}, 'Gastrulation length (min)','Increase in levels (AU)',1,0)
 

%  figure(Fig2)
%  subplot(1,10,[1:4]); hold on
%   PlotScatter(GastTime2{i},TranscTime{i},SelectedNames{i}, 'Start of ME invagination (min into nc14)', 'Transition in levels (min)',1,0)

end
 figure(Fig)

  subplot(231); hold on
PlotScatter([GastTime1{:}],[TranscTime{:}],'All', 'Start of gastrulation (min into nc14)', 'Transition in levels (min)',0,1)

 subplot(232); hold on 
 PlotScatter([GastTime2{:}],[TranscTime{:}],'All', 'Start of ME invagination (min into nc14)', 'Transition in levels (min)',0,1)

 subplot(233); hold on 
 PlotScatter([GastTime3{:}],[TranscTime{:}],'All', 'End of gastrulation (min into nc14)', 'Transition in levels (min)',0,1)

print(Fig,[ToSave,MetaFile,'_GastCorr.pdf'],'-fillpage', '-dpdf');

 figure(Fig2)
 %subplot(1,10,[1:4]); hold on 
 %PlotScatter([GastTime2{:}],[TranscTime{:}],'All', 'Peak of gastrulation (min into nc14)', 'Transition in levels (min)',0,1)


GastTime3 = Cell2Mat(GastTime3);
GastTime2 = Cell2Mat(GastTime2);
GastTime1 = Cell2Mat(GastTime1);
PeakF1 = Cell2Mat(PeakF1);
Jitter = 0.5; %Jitter./2 cant be > BarW 
BarW = 0.35; FaceAlpha = 0.3; DotSize = 15; LineWidth = 2; FontSizeTitle = 16; FontSize = 14;
set(gca,'FontSize',FontSize)

subplot(151); hold on     
plotBoxplot([GastTime2],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[30,70])
ylabel('Start of ME invagination (min)')
 
subplot(152); hold on     
plotBoxplot([GastTime2-GastTime1],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,30])
ylabel('Duration of apical constriction (min)')

subplot(153); hold on     
plotBoxplot([GastTime3-GastTime2],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,30])
ylabel('Duration of ME invagination (min)')

subplot(154); hold on     
plotBoxplot([GastTime3-GastTime1],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[10,45])
ylabel('Duration of gastrulation (min)')


subplot(155); hold on     
plotBoxplot([PeakF1],SelectedNames,SelectedNames,Jitter,BarW,'',FontSize,DotSize,Palette,FaceAlpha,LineWidth,FontSizeTitle,[0,700])
ylabel('Mean Fluorescence 30-50'' (AU)')

 
print(Fig2,[ToSave,MetaFile,'_GastCorr_min.pdf'],'-fillpage', '-dpdf');

close all
end