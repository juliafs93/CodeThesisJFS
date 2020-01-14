function[] = PlotSelected(Selected, TimeScale,Baseline,MaxF,MedFilt,OnOff,Properties,BurstPeak,TimeRes,Bits,nc14, Delay,Limits,FileOut)
    MaxFSelected = (MaxF(:,Selected)-Baseline').*Baseline(1)./Baseline'.*2^(12-Bits);
    MedFSelected = (MedFilt(:,Selected)-Baseline').*Baseline(1)./Baseline'.*2^(12-Bits);
    OnOffSelected = double(OnOff(:,Selected));
    OnOffSelected(OnOffSelected == 0) = NaN;
    PropertiesSelected = Properties(Selected,:);
    for n = 1:(floor(length(find(Selected))/30)+1)
    disp([num2str(n),'/',num2str((floor(length(find(Selected))/30)+1))])
    Fig = figure('PaperSize',[30 50],'PaperUnits','inches','resize','on', 'visible','off');
        for i=1:30
            try
            subplot(10,3,i); 
            plot(TimeScale,MaxFSelected(:,(n-1)*30+i)); hold on;
            plot(TimeScale,MedFSelected(:,(n-1)*30+i));
            plot(TimeScale,OnOffSelected(:,(n-1)*30+i).*(2^12-1),'.');
            %plot(TimeScale, Baseline); 
            %plot((BurstPeak{(n-1)*30+i}- nc14+Delay).*TimeRes./60, MaxFSelected(floor(BurstPeak{(n-1)*30+i}),(n-1)*30+i),'.r');  
            plot((BurstPeak{(n-1)*30+i}- nc14+Delay).*TimeRes./60, BurstPeak{(n-1)*30+i}.*0+(2^12-1),'.r');  
            ylim([-100, 2^12-1]);
            xlim(Limits);
            title(join(['#',num2str(PropertiesSelected.Label((n-1)*30+i)),' ',PropertiesSelected.Type((n-1)*30+i)]));
            hold off
            end
        end
     if n==1
          print(Fig,FileOut,'-fillpage', '-dpsc');
     else
          print(Fig,FileOut,'-fillpage', '-dpsc','-append');
     end
    end
end