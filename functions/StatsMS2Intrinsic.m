function[Stats,AC,FFB, Fig] = StatsMS2(Traces, Plot, Fig, ACLag, TimeRes,Legend,LS, Bootstrap,Cumulative, Intrinsic)
    %CumTraces = []; CumMean=[];CumVar=[];FF=[];
        %CumTraces = cumsum(Traces,1);
        %CumMean = nanmean(CumTraces,2);
        %CumVar = nansum((CumMean-CumTraces(:,:)).^2,2);
        %FF = CumVar./CumMean;
        %for i = 1:size(E,2)
            %AutoCorr(:,i) = autocorr(E(:,i),ACLag);
        %    AutoCorr(:,i) = acf(E(:,i),ACLag,0);
        %end
        %ACMean = nanmean(AutoCorr,2);
        %ACMean((ACLag+1):size(E,1)) = NaN;
        

        if Intrinsic
            Random = randperm(size(Traces,2));
            if rem(length(Random),2) ~= 0
                Random = Random(2:end);
            end
            TracesA = Traces(:,Random(1:length(Random)/2));
            TracesB = Traces(:,Random(length(Random)/2+1:end));
            [Stats,FFB] = StatsBootsIntrinsic(TracesA,TracesB, Bootstrap,Cumulative);
        else
            [Stats,FFB] = StatsBoots(Traces, Bootstrap,Cumulative);

        end
        [ACMean,BootsSD, BootsCI] = weighted_autocorrelation(Traces, ACLag,Bootstrap);
        ACSDer = diff(ACMean,2)./max(diff(ACMean,2));
        %ACMean((ACLag+1):size(Traces,1)) = NaN;
        %BootsSD((ACLag+1):size(Traces,1)) = NaN;
        %Stats.AutoCorr = ACMean;
        %Stats.AutoCorrSD = BootsSD;
        CI = {'Instant','Cumulative'};
    
    figure(Fig)
    if Plot==1
        %hold on
        subplot(231); errorbar([1:length(Stats.CMean)]*TimeRes/60, Stats.CMean,Stats.CMeanSD,Stats.CMeanSD, 'DisplayName',Legend,'LineStyle',LS); ...
            title([CI{Cumulative+1},' mean']); ylabel('F (AU)'); xlabel('t (min)'); legend('show');  hold on
        subplot(232); errorbar([1:length(Stats.CVar)]*TimeRes/60,Stats.CVar,Stats.CVarSD,Stats.CVarSD, 'DisplayName',Legend,'LineStyle',LS); ...
            title([CI{Cumulative+1},' variance']);ylabel('F (AU)'); xlabel('t (min)');legend('show'); hold on
        if Intrinsic
            subplot(232); errorbar([1:length(Stats.CVar)]*TimeRes/60,Stats.CCoVar,Stats.CCoVarSD,Stats.CCoVarSD, 'DisplayName',Legend,'LineStyle',LS); ...
            title([CI{Cumulative+1},' variance']);ylabel('F (AU)'); xlabel('t (min)');legend('show'); hold on
        end
        subplot(233); errorbar([1:length(Stats.FF)]*TimeRes/60,Stats.FF,Stats.FFSD,Stats.FFSD,'DisplayName',Legend,'LineStyle',LS); ...
            title([CI{Cumulative+1},' Fano factor']);ylabel('Fano factor'); xlabel('t (min)');legend('show'); hold on
        subplot(236); errorbar([1:length(ACMean)]*TimeRes/60,ACMean,BootsSD,BootsSD, 'DisplayName',Legend);...
            title('Autocorrelated fluorescence');ylabel('ACF'); xlabel('t (min)');legend('show'); hold on
        %subplot(236); yyaxis right; plot([1:length(ACSDer)]*TimeRes/60,ACSDer, 'DisplayName',Legend);...
         %   title('Autocorrelated fluorescence');ylabel('Autocorrelation'); xlabel('t (min)');legend('show'); hold on
       
    end
    AC.ACMean = ACMean;
    AC.ACSD = BootsSD;
    %Fig = gcf;
end