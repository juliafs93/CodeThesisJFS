function[Stats] = StatsMS2I(E, Plot)
    CumTraces = []; CumMean=[];CumVar=[];FF=[];
        %CumTraces = cumsum(E,1);
        CumMean = nanmean(E,2);
        CumVar = nansum((CumMean-E(:,:)).^2,2);
        FF = CumVar./CumMean;
        for i = 1:size(E,2)
            AutoCorr(:,i) = autocorr(E(:,i),50);
        end
        ACMean = nanmean(AutoCorr,2);
        ACMean(51:size(E,1)) = NaN
    Stats = table(CumMean,CumVar,FF,ACMean,'VariableNames',{'CMean','CVar','FF','AutoCorr'});
    
    if Plot==1
        subplot(221); plot(CumMean); hold on
        subplot(222); plot(CumVar);
        subplot(223); plot(FF);
        subplot(224); plot(ACMean); hold off
    end
end