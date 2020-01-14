function[Traces] = SimulateTraces(Ks,r,vpol,L, TotalTime,TimeRes,Nreps,PathToSave,ToSave)
Background = 0;
FRAP = 0;
show = 'off';
Traces = zeros (TotalTime*60/TimeRes, Nreps);
if strcmp(show,'on')==1;
    mkdir([PathToSave,ToSave,'/']);
end

for n = 1:Nreps
    time = []; time(1) = 0;
    mRNA = []; mRNA(1) = 0;
    State = []; State(1) = 0;
    timeInic = [];
    K0 = Ks(2,1); %starts
    s=1;
    p=1;
    Split = TotalTime*60/length(r);
    Periods = [1:Split:TotalTime*60, TotalTime*60];
    while time(s) < TotalTime*60
        s = s+1;
        p = floor(time(s-1)./Split)+1;
        dt = 1/K0*log(1/rand(1));
        time(s) = time(s-1) + dt;
        State(s) = ~State(s-1);
        if State(s)==0 % && time(s) < TotalTime*60
            cumtimeON = 0;
            % changed here so that it fills last ON period with initiation
            % events even if it goes over total time, clear cut at end,
            % helps with very slow Ks
            while cumtimeON < dt && (time(s-1)+cumtimeON < TotalTime*60)
                dtON = 1/r(p)*log(1/rand(1));
                cumtimeON = cumtimeON + dtON;
                if cumtimeON < dt
                    timeInic = [timeInic, time(s-1)+cumtimeON];
                end
            end
        end
        K0 = Ks(State(s)+1,p);
    end
    State(s+1) = State(s);
    time(s+1) = TotalTime*60;
    %
    % Count initiation events in a 1 second resolution timescale over the
    % whole elongation time for each
    TimeScale = [1:TotalTime*60+(L / (vpol(end)/60))];
    Counts = zeros(size(TimeScale))+Background;
    Bleach = cumsum(Periods)./(length(Periods)-1);
    for P = 1:(size(Periods,2)-1)
        elT = L / (vpol(P)/60);
        %for f = 2:round(timeInic(end))
        for f = Periods(P):(Periods(P+1)-1)
            Start = TimeScale(f);
            End = TimeScale(f+1);
            %Counts(f) = sum(timeInic>=Start & timeInic<End)
            if FRAP
                if f <= Bleach(P+1); Limit = min(f+elT,Bleach(P+1)); 
                Counts(f:Limit) = Counts(f:Limit) + sum(timeInic>=Start & timeInic<End);
                else
                Counts(f:(f+elT)) = Counts(f:(f+elT)) + sum(timeInic>=Start & timeInic<End);
                end
            else
            Counts(f:(f+elT)) = Counts(f:(f+elT)) + sum(timeInic>=Start & timeInic<End);
            end
        end
    end

    %Counts(1,end-elT/TimeRes:end) = [];
    %TimeRes = 10; % "
    TimeObserved = [1:TimeRes:TotalTime*60];
    CountsObserved = Counts(1:TimeRes:TotalTime*60);
    % add noise
    sigma = 1/10*Ks(1,1)/(Ks(1,1)+Ks(2,1))*r(1)*elT;
    noise = normrnd(0, sigma,[1,size(TimeObserved,2)]);
    TraceNoise = CountsObserved + noise;
    Traces(:,n) = TraceNoise';
    if strcmp(show,'on')==1
        stairs (time,State-2); hold on
        plot (timeInic, 1-2,'.r');
        plot(Periods,-3,'*k');  hold on
        plot(TimeScale, Counts,'--b'); hold on
        plot(TimeObserved, CountsObserved,'-b'); hold on
        plot(TimeObserved, TraceNoise); hold on
        hold off
        pause(0.05)
    saveas(gcf,[PathToSave,ToSave,'/',num2str(n),'.pdf'],'pdf')
    end
end
%Mean = figure;
%plot(Traces); hold on
%plot(mean(Traces,2),'.r')
%saveas(Mean,[PathToSave,ToSave,'_mean.pdf'],'pdf')
writetable(table(Traces),[PathToSave,ToSave,'_traces.txt'],'Delimiter','\t')


end