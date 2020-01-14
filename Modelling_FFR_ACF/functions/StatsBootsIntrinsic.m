function [Stats,FFB] = StatsBootsIntrinsic(TracesA,TracesB,bootstrap,Cumulative)
size(TracesA)
size(TracesB)
    todel = [];
    for i = 1:size(TracesA,2)
        if sum(TracesA(:,i)~=0 & isnan(TracesA(:,i)) == 0) == 0
            todel = [todel,i];
        end
    end
    TracesA(:,todel) = [];
    TracesB(:,todel) = [];
    
    todel = [];
    for i = 1:size(TracesB,2)
        if sum(TracesB(:,i)~=0 & isnan(TracesB(:,i)) == 0) == 0
            todel = [todel,i];
        end
    end
    TracesA(:,todel) = [];
    TracesB(:,todel) = [];
    %Traces(isnan(Traces)) = 0;
    %traces: array of traces with zeros preceeding and succeeding period of
    %        activity. Oriente column-wise
    if bootstrap ~=0
        n_boots = bootstrap;
    else
        n_boots = 1;
    end
    CumMean = zeros(size(TracesA,1),n_boots); 
    CumVar = zeros(size(TracesA,1),n_boots); 
    CumCoVar = zeros(size(TracesA,1),n_boots); 
    FF = zeros(size(TracesA,1),n_boots); 
    for b = 1:n_boots
        if bootstrap ~= 0
            s_vec = 1:size(TracesA,2);
            s = randsample(s_vec,length(s_vec),true);
            trace_sampleA = TracesA(:,s);
            trace_sampleB = TracesB(:,s);
        else
            trace_sampleA = TracesA;
            trace_sampleB = TracesB;
        end
            if Cumulative
                CumTracesA = cumsum(trace_sampleA,1,'omitnan');
                CumTracesA(isnan(trace_sampleA)) = NaN;
                CumTracesB = cumsum(trace_sampleB,1,'omitnan');
                CumTracesB(isnan(trace_sampleB)) = NaN;
            else
                %only calculate cumulative when true, instant is eq to
                %using original traces
                CumTracesA = trace_sampleA;
                CumTracesB = trace_sampleB;
            end
            CumMean(:,b) = nanmean([CumTracesA,CumTracesB],2);
            %NnoNaN = sum(~isnan(CumTraces),2);
            %CumVar(:,b) = nanmean((CumMean(:,b)-CumTraces(:,:)).^2,2);
            CumVar(:,b) = nanvar([CumTracesA,CumTracesB],1,2);
            %CumVar(:,b) = nansum((CumMean(:,b)-CumTraces(:,:)).^2,2)./size(CumTraces,2);
            CumMeanA = nanmean(CumTracesA,2);
            CumMeanB = nanmean(CumTracesB,2);

            CumCoVar(:,b) = nanmean([(CumTracesA-CumMeanA).*(CumTracesB-CumMeanB)],2);
            
    end
FFBIntrinsic = (CumVar - CumCoVar)./CumMean;
FFB = CumVar./CumMean;
CumMeanSD = nanstd(CumMean')'; CumMean = nanmean(CumMean,2);
CumVarSD = nanstd(CumVar')'; CumVar = nanmean(CumVar,2);
CumCoVarSD = nanstd(CumCoVar')'; CumCoVar = nanmean(CumCoVar,2);
FFSD = nanstd(FFBIntrinsic')'; FF = nanmean(FFBIntrinsic,2);
FFTSD = nanstd(FFB')'; FFT = nanmean(FFB,2);
         
% figure;
% subplot(221);errorbar([1:length(CumMean)],CumVar,CumVarSD,CumVarSD,'DisplayName','var'); hold on
% subplot(222);errorbar([1:length(CumMean)],CumCoVar,CumCoVarSD,CumCoVarSD,'DisplayName','covar'); hold on
% subplot(223);errorbar([1:length(CumMean)],FF,FFSD,FFSD,'DisplayName','FFT-covar'); hold on
% subplot(224);errorbar([1:length(CumMean)],FFT,FFTSD,FFTSD,'DisplayName','FFT'); hold on
% legend boxoff

Stats = table(CumMean,CumVar,CumCoVar,FF,CumMeanSD,CumVarSD,CumCoVarSD,FFSD,'VariableNames',{'CMean','CVar','CCoVar','FF','CMeanSD','CVarSD','CCoVarSD','FFSD'});
end

