function[Out] = CompareFFAC(Path,Info,SelectedN,Selection,Shift,ACLagMin,Bootstrap,MinClean,Cumulative,Intrinsic,CompLate, Mode)
Nicknames = Info.Nickname;
UniqueN = unique(Nicknames);
%SelectedN = UniqueN(PairstoSelect{s})
%SelectedN = PairstoSelect{s}
Rep = Info.Rep;
 %ACLag = 50; Bootstrap = 50;Cumulative = 0;
 FigE = figure('PaperSize',[35 20],'PaperUnits','inches','resize','on','visible','off');
 %FigL = figure('PaperSize',[35 20],'PaperUnits','inches','resize','on');
 FFE = {}; FFL = {};

for n = 1:length(SelectedN)
     ToSave = [Path,cell2mat(join(SelectedN,' vs ')),'_',Mode,'_min',num2str(MinClean),'_C',num2str(Cumulative),'_I',Intrinsic,'_Boots',num2str(Bootstrap),'_ACL',num2str(ACLagMin)];
    Index = find(cellfun(@(x) strcmp(x,SelectedN{n}),Nicknames)==1)';
    if strcmp(Selection,'') == 0; SelectionOut = ['_',Selection]; else SelectionOut = Selection; end
    if sum(Shift ~= 0) ; SelectionOut = [Selection,'_shifted']; else SelectionOut = Selection; end

    %E = []; L = []; 
    NormMerged = [];
    PropertiesMerged = table();
    TimeScaleMerged = [];
    for x = 1:size(Index,2)
        Repeats = [Nicknames{Index(x)},' ',num2str(Rep(Index(x)))];
        %try
            
                PathToSave = [Info.Path{Index(x)},Info.File{Index(x)},...
                    Info.Name{Index(x)},Info.File{Index(x)}]; 
                load([PathToSave,'_Data.mat']);
                try
                    MaxF = Data.Data.MaxF;
                    MedFilt = Data.Data.MedFilt;
                    OnOff = Data.Data.OnOff;
                    Properties = Data.Data.Properties;
                    Baseline = Data.Data.Baseline;
                    TimeScale = Data.Data.TimeScale;

                catch
                    MaxF = Data.MaxF;
                    MedFilt = Data.MedFilt;
                    OnOff = Data.OnOff;
                    Properties = Data.Properties;
                    Baseline = Data.Baseline;
                    TimeScale = Data.TimeScale;

                end
                OnOff = CleanOnOff(OnOff,5);
                Bits = Info.Bits(Index(x));
                
               
                if strcmp(Selection,'') == 1
                    Selected = [Properties.Type=='ShortMidline'|Properties.Type=='LongMidline'];
                else
                    Selected = Properties.Type~='EarlyOnly' & Properties.Region==Selection;
                end
                
                TimeRes = Info.TimeRes(Index(x));
                nc14 = Info.nc14(Index(x));
                Delay = Info.Delay(Index(x));
                
                SelectedMinOn = sum(OnOff(max(1,15*60/TimeRes+nc14-Delay:end),:),1) > MinClean;
                Selected = Selected & SelectedMinOn';
                
                MaxF = MaxF(:,Selected);
                MedFilt = MedFilt(:,Selected);
                OnOff = OnOff(:,Selected);
                Properties = Properties(Selected,:);
                
                minOn = 5;
                SplitEarly = 0;
                SplitMSE = max(round(nc14-Delay + SplitEarly*60/TimeRes),1); %frame to split
                OnOffString = join(string(double(OnOff(SplitMSE:end,:))),'',1);
                OnPeriods = strfind(OnOffString,repmat('1',1,minOn));
                %Midline = cellfun(@(x) ~isempty(x), OnPeriods);
                On = cellfun(@(x) x(1), OnPeriods);
                Off = cellfun(@(x) x(end), OnPeriods)+minOn-1;
                OnPeriods = zeros(size(OnOff));
                for l = 1:length(On)
                	OnPeriods(max(1,SplitMSE+On(l)-4):SplitMSE+Off(l)-1,l) = 1;
                end
                
                switch Mode
                    case {'Max','MaxAligned'}
                        Norm = (MaxF-Baseline').*Baseline(1)./Baseline'.*2^(12-Bits);
                    case {'Med','MedAligned'}
                        Norm = (MedFilt-Baseline').*Baseline(1)./Baseline'.*2^(12-Bits);
                    case {'MaxOF','MaxOFAligned'}
                        Norm = (MaxF-Baseline').*OnOff.*Baseline(1)./Baseline'.*2^(12-Bits);
                    case {'MedOF','MedOFAligned'}
                        Norm = (MedFilt-Baseline').*OnOff.*Baseline(1)./Baseline'.*2^(12-Bits);
                    case {'MaxOP','MaxOPAligned'}
                        Norm = (MaxF-Baseline').*OnPeriods.*Baseline(1)./Baseline'.*2^(12-Bits);
                    case {'MedOP','MedOPAligned'}
                        Norm = (MedFilt-Baseline').*OnPeriods.*Baseline(1)./Baseline'.*2^(12-Bits);
                end
                %Norm(Norm==0) = NaN;
                for l = 1:length(On)
                	Norm(1:max(1,SplitMSE+On(l)-4),l) = NaN;
                    Norm(SplitMSE+Off(l)-1:end,l) = NaN;
                end
                
                 Properties.NormAP = (Properties.AP_position-min(Properties.AP_position))./max(Properties.AP_position);

                [NormMerged,PropertiesMerged,TimeScaleMerged] = MergeFMatrix(Norm,NormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes);

%                 E1 = nan(round(20*60./TimeRes+1), length(find(Selected)));
%                 
%                 Start = max(1,(30+Shift(n))*60./TimeRes+nc14-Delay);
%                 D = Norm(Start:(50+Shift(n))*60./TimeRes+nc14-Delay,Selected);
%                 E1(1:size(D,1),:) = D;
%                 
%                 L1 = nan(round(20*60./TimeRes+1), length(find(Selected)));
%                 Last = min(size(Norm,1), 70*60./TimeRes+nc14-Delay);
%                 D = Norm(50*60./TimeRes+nc14-Delay:Last,Selected);
%                 L1(1:size(D,1),:) = D;
            
%             E = [E,E1];
%             L = [L,L1];
        %end
    end
    
    %switch Mode
        %case {'MaxAligned','MedAligned','MaxOPAligned','MedOPAligned', 'MaxOFAligned','MedOFAligned'}
        if ~isempty(strfind(Mode,'Aligned'))
            disp('here')
            MaxTime = 40;
            [NormAligned,TimeScaleAligned] = AlignFMatrixtoOnset(NormMerged,PropertiesMerged,TimeScaleMerged,MaxTime,TimeRes);
            Shift = [0,0];
            E = NormAligned(1:20*60./TimeRes,:);
            %size(E)
            L = NormAligned(20*60./TimeRes+1:end,:);   
            %size(L)
        %otherwise
        else
            nc14Merged = find(round(TimeScaleMerged) == 0);
            if isempty(nc14Merged); nc14Merged = - TimeScaleMerged(1)*60/TimeRes; end
            Start = max(1,(30+Shift(n))*60./TimeRes + nc14Merged);
            E = NormMerged(Start:(50+Shift(n))*60./TimeRes+nc14Merged,:);
            L = nan(round(20*60./TimeRes+1), size(NormMerged,2));
            Last = min(size(NormMerged,1), 70*60./TimeRes+nc14Merged);
            D = NormMerged(50*60./TimeRes+nc14Merged:Last,:);
            L(1:size(D,1),:) = D;        
    end
    

    [E,L,todel] = CleanTraces(E,L,MinClean,[Path,SelectedN{n},Mode,'_min',num2str(MinClean),SelectionOut],1); % MinN
    PropertiesMergedClean = PropertiesMerged;
    PropertiesMergedClean(todel,:) = [];
    
    figure(FigE); subplot(234); plot([1:size(E,1)]*TimeRes/60,nanmean(E,2),'DisplayName',[SelectedN{n},' <m1>']); hold on
        if CompLate
            plot([size(E,1)+1:size(E,1)+size(L,1)]*TimeRes/60,nanmean(L,2),'DisplayName',[SelectedN{n},' <m2>']);
        end
            title('Mean');ylabel('F (AU)'); xlabel('t (min)');ylim([0,4095]);legend('show');


       if isempty(Intrinsic) == 0
           switch Intrinsic
                case 'Random'
                     Sorting = randperm(size(E,2));
                case 'AP'
                    [~,Sorting] = sort(PropertiesMergedClean.NormAP);
                case 'Total'
                    [~,Sorting] = sort(PropertiesMergedClean.TotalmRNA);
                case 'Onset'
                    [~,Sorting] = sort(PropertiesMergedClean.Onset);
           end
            
            if rem(length(Sorting),2) ~= 0
                Sorting = Sorting(2:end);
            end
            TracesE{1} = E(:,Sorting(1:2:length(Sorting)));
            TracesE{2} = E(:,Sorting([1:2:length(Sorting)]+1));
            if CompLate; 
               TracesL{1} = L(:,Sorting(1:2:length(Sorting)));
               TracesL{2} = L(:,Sorting([1:2:length(Sorting)]+1));
            end
        else
            TracesE{1} = E;
            if CompLate; TracesL{1} = L;end
       end    
            
    %try
    ACLag = ACLagMin*60./TimeRes;
        [StatsE, ACE{n}, FFE{n}, FigE] = StatsMS2(TracesE, 1, FigE, ACLag,TimeRes,SelectedN{n},'-',Bootstrap,Cumulative);
        if CompLate
            [StatsL, ACL{n}, FFL{n}, FigE] = StatsMS2(TracesL, 1, FigE, ACLag,TimeRes,SelectedN{n},'--',Bootstrap,Cumulative);
        end
        %FFE(:,n) = [StatsE.FF];
        %FFL(:,n) = [StatsL.FF]';
    %end
end

if length(SelectedN) > 1
    FFESD = nanstd(FFE{2} ./ FFE{1},1,2);  FFE = nanmean(FFE{2} ./ FFE{1},2);  
else
    FFESD = nanstd(FFL{1} ./ FFE{1},1,2);  FFE = nanmean(FFL{1} ./ FFE{1},2); 
end
Out.FFE = FFE; Out.FFESD = FFESD;
Out.ACE = ACE;
Out.TimeRes = TimeRes;
if CompLate; Out.ACL = ACL; end

if CompLate & length(SelectedN) > 1; 
    FFLSD = nanstd(FFL{2} ./ FFL{1},1,2);  
    FFL = nanmean(FFL{2} ./ FFL{1},2); 
    Out.FFL = FFL; Out.FFLSD = FFLSD;
end
FigE,subplot(235);
    errorbar([1:length(FFE)]*TimeRes/60, FFE, FFESD,FFESD, 'LineStyle','-','DisplayName','FFRatio <m1>'); ...
    title('Fano factor ratio');ylabel('FF2 / FF1'); xlabel('t (min)');legend('show'); hold on;
    if CompLate & length(SelectedN) > 1; 
        errorbar([1:length(FFL)]*TimeRes/60, FFL, FFLSD,FFLSD, 'LineStyle','-','DisplayName','FFRatio <m2>');...
    end
    set(FigE,'defaultLegendAutoUpdate','off')
    line([1:length(FFE)].*TimeRes/60,[1:length(FFE)].*0+1,'LineStyle','--','Color','k'); ylim([-5,10]);
    figure(FigE); subplot(236); hold on

    if length(SelectedN) > 1
        % if comp2, compare for sure early with early
        PlotColormapOverlap(ACE{1},ACE{2},TimeRes,-0.25,0.1)
        % only if CompLate then also compare late
        if CompLate
            PlotColormapOverlap(ACL{1},ACL{2},TimeRes,-0.25,0.1)
        end
    else % comparing early/late
        PlotColormapOverlap(ACE{1},ACL{1},TimeRes,-0.25,0.1)
        
    end

        
     line([1:ACLag]*TimeRes/60,[1:ACLag]*0,'LineStyle','--','Color', 'k');legend('show');

FigE, suptitle(cell2mat(join(SelectedN,' vs ')));





print(FigE,[ToSave,'_Stats',SelectionOut,'.pdf'],'-fillpage', '-dpdf');
Out.Exp = SelectionOut;
Out.Names = SelectedN;
close all
end