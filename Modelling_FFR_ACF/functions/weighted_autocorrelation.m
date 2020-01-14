%Create Weighted Average Autocorrelation
function [wt_autocorr,boots,ci95] = weighted_autocorrelation(Traces, lags,bootstrap)
    todel = [];
    for i = 1:size(Traces,2)
        if sum(Traces(:,i)~=0 & isnan(Traces(:,i)) ==0) == 0
            todel = [todel,i];
        end
    end
    Traces(:,todel) = [];
    %traces: array of traces with zeros preceeding and succeeding period of
    %        activity. Oriente column-wise
    %lags: num lags to use
    %bootstrap: binary var. If 1, returns array of bootstrap errors
    auto_array = zeros(lags+1,size(Traces,2));
    time_steps = zeros(lags+1,size(Traces,2));
    %Convert NaNs to zeros
    Traces(isnan(Traces)) = 0;
    if bootstrap ~=0
        n_boots = bootstrap;
    else
        n_boots = 1;
    end
    samples = zeros(lags+1,n_boots);
    for b = 1:n_boots
        if bootstrap ~= 0
            s_vec = 1:size(Traces,2);
            s = randsample(s_vec,length(s_vec),true);
            trace_sample = Traces(:,s);
        else
            trace_sample = Traces;
        end
        for col = 1:size(Traces,2)
            trace = trace_sample(:,col);
            if length(trace) < lags
                warning('Length of input trace insufficient for specified number of lags')
            end
            %Isolate active portion
            %trace_active = trace(find(trace,1):find(trace,1,'last'));
%             auto_array(:,col) = autocorr(trace_active,lags);
%             try
                auto_array(:,col) = autocorr(trace,lags);
%             catch
%                 auto_array(:,col) = acf(trace,lags+1,0);
%             end
            time_steps(:,col) = fliplr((length(trace)-lags):length(trace));
        end
        %Take weighted mean
        numerator = sum(auto_array.*time_steps,2);
        denominator = sum(time_steps,2);
        samples(:,b) = numerator ./ denominator;
    end
wt_autocorr = nanmean(samples,2);
boots = nanstd(samples')';
ci95 = 1.96 .* boots./sqrt(n_boots);
end

