function [Stats,FFB] = StatsBoots(Traces,bootstrap,Cumulative)
    todel = [];
    for i = 1:size(Traces,2)
        if sum(Traces(:,i)~=0 & isnan(Traces(:,i)) == 0) == 0
            todel = [todel,i];
        end
    end
    Traces(:,todel) = [];
    %Traces(isnan(Traces)) = 0;
    %traces: array of traces with zeros preceeding and succeeding period of
    %        activity. Oriente column-wise
    if bootstrap ~=0
        n_boots = bootstrap;
    else
        n_boots = 1;
    end
    CumMean = zeros(size(Traces,1),n_boots); 
    CumVar = zeros(size(Traces,1),n_boots); 
    FF = zeros(size(Traces,1),n_boots); 
    for b = 1:n_boots
        if bootstrap ~= 0
            s_vec = 1:size(Traces,2);
            s = randsample(s_vec,length(s_vec),true);
            trace_sample = Traces(:,s);
        else
            trace_sample = Traces;
        end
            if Cumulative
                CumTraces = cumsum(trace_sample,1,'omitnan');
                CumTraces(isnan(trace_sample)) = NaN;
            else
                %only calculate cumulative when true, instant is eq to
                %using original traces
                CumTraces = trace_sample;
            end
            CumMean(:,b) = nanmean(CumTraces,2);
            %NnoNaN = sum(~isnan(CumTraces),2);
            %CumVar(:,b) = nanmean((CumMean(:,b)-CumTraces(:,:)).^2,2);
            CumVar(:,b) = nanvar(CumTraces,1,2);
            %CumVar(:,b) = nansum((CumMean(:,b)-CumTraces(:,:)).^2,2)./size(CumTraces,2);
            FFB(:,b) = CumVar(:,b)./CumMean(:,b);
    end
CumMeanSD = nanstd(CumMean')'; CumMean = nanmean(CumMean,2);
CumVarSD = nanstd(CumVar')'; CumVar = nanmean(CumVar,2);
FFSD = nanstd(FFB')'; FF = nanmean(FFB,2);

Stats = table(CumMean,CumVar,FF,CumMeanSD,CumVarSD,FFSD,'VariableNames',{'CMean','CVar','FF','CMeanSD','CVarSD','FFSD'});
end

