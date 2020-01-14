function[Stats,FFB, Fig] = StatsMS2(Traces, Plot, Fig, ACLag, TimeRes,Legend,LS, Bootstrap,Cumulative)
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
        [Stats,FFB] = StatsBoots(Traces, Bootstrap,Cumulative);
        [ACMean,BootsSD] = weighted_autocorrelation(Traces, ACLag,Bootstrap);
        %ACMean((ACLag+1):size(Traces,1)) = NaN;
        %BootsSD((ACLag+1):size(Traces,1)) = NaN;
        %Stats.AutoCorr = ACMean;
        %Stats.AutoCorrSD = BootsSD;
    
    figure(Fig)
    if Plot==1
        %hold on
        subplot(231); errorbar([1:length(Stats.CMean)]*TimeRes/60, Stats.CMean,Stats.CMeanSD,Stats.CMeanSD, 'DisplayName',Legend,'LineStyle',LS); ...
            title('Cumulative mean'); ylabel('F (AU)'); xlabel('t (min)'); legend('show');  hold on
        subplot(232); errorbar([1:length(Stats.CVar)]*TimeRes/60,Stats.CVar,Stats.CVarSD,Stats.CVarSD, 'DisplayName',Legend,'LineStyle',LS); ...
            title('Cumulative variance');ylabel('F (AU)'); xlabel('t (min)');legend('show'); hold on
        subplot(233); errorbar([1:length(Stats.FF)]*TimeRes/60,Stats.FF,Stats.FFSD,Stats.FFSD,'DisplayName',Legend,'LineStyle',LS); ...
            title('Cumulative Fano factor');ylabel('Fano factor'); xlabel('t (min)');legend('show'); hold on
        subplot(236); errorbar([1:length(ACMean)]*TimeRes/60,ACMean,BootsSD,BootsSD, 'DisplayName',Legend,'LineStyle',LS);...
            title('Autocorrelated fluorescence');ylabel('Autocorrelation'); xlabel('t (min)');legend('show'); hold on
    end
    %Fig = gcf;
end