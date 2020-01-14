function[Out,Ratios] = CompFFACGillespie(Which, Alpha, r1, Kon1, Koff1, vpoldefault, TotalTime, L, TimeRes,Nreps,PathToSave,Cumulative,ACLagMin, Bootstrap)

FRAP = 0;

%vpoldefault = 2;
%TotalTime = 100; %min
%TimeRes = 10; % "


alpha = [1,1,1,1];
alpha(Which) = Alpha;
r2 = alpha(1)*r1
Kon2 = Koff1/((Koff1+Kon1)/(Kon1*alpha(2))-1)
Koff2 = (Koff1 + (1-alpha(3))*Kon1)/alpha(3)
vpol = [vpoldefault, 2./alpha(4)]; %kb/min

if Kon2 >= 0 && Koff2 >=0 && r2 >=0

ToSave = ['Mode',num2str(Which),'_alpha',num2str(Alpha),'_r',num2str(r1),'_Kon',num2str(Kon1),...
    '_Koff',num2str(Koff1),'_TT',num2str(TotalTime),'_N',num2str(Nreps),...
    '_TRes',num2str(TimeRes),'_vPol',num2str(vpol(1)),'_L',num2str(L),'_ACLag',num2str(ACLagMin),'_Boots',num2str(Bootstrap)]


r = [r1, r2];
Kon = [Kon1, Kon2];
Koff = [Koff1, Koff2];
Ks = [Kon; Koff];
%ExpFF = 1+2.*r.*Koff./((Kon+Koff).^2);
T = (L.*60)./vpol;
ExpFF = 1 + 2.*r.*Koff ./ ((Kon + Koff).^2) + 2.*r.*Koff./((Kon + Koff).^3).*(exp(-T.*(Kon+Koff))-1)./T
%ExpFF = 1+r.*(2+Kon)./(2.*(Kon+Koff));
ExpFFratio = ExpFF(2)/ExpFF(1);


[Early{1}] = SimulateTraces(Ks(:,1),r(1),vpol(1),L, TotalTime./2,TimeRes,Nreps,PathToSave,ToSave);
[Late{1}] = SimulateTraces(Ks(:,2),r(2),vpol(2),L, TotalTime./2,TimeRes,Nreps,PathToSave,ToSave);

%
        %ACLag = 50; Bootstrap = 50;
        ACLag = ACLagMin*60/TimeRes;
         Fig = figure('PaperSize',[35 20],'PaperUnits','inches','resize','on');
        [StatsE,ACE{1},FFE{1}, Fig] = StatsMS2(Early, 1, Fig, ACLag,TimeRes,'<m1>','-',Bootstrap,Cumulative);
        [StatsL,ACL{1},FFL{1}, Fig] = StatsMS2(Late, 1, Fig, ACLag,TimeRes,'<m2>','-',Bootstrap,Cumulative);
        figure(Fig); subplot(234); plot([1:size(Early{1},1)]*TimeRes/60,nanmean(Early{1},2),'DisplayName','<m1>'); hold on
        plot([1+size(Early{1},1):size(Late{1},1)+size(Early{1},1)]*TimeRes/60,nanmean(Late{1},2),'DisplayName','<m2>');
        set(Fig,'defaultLegendAutoUpdate','off')
        title('Mean');ylabel('F (AU)'); xlabel('t (min)'); 
        FFRatio = nanmean(FFL{1}./FFE{1},2); FFRatioSD = nanstd(FFL{1}./FFE{1},1,2);
        figure(Fig); subplot(235);errorbar([1:length(FFRatio)].*TimeRes./60',FFRatio,FFRatioSD,FFRatioSD); ...
            title('Fano factor ratio');ylabel('FF2 / FF1'); xlabel('t (min)'); hold on;
        line([1:length(FFRatio)].*TimeRes./60',[1:length(FFRatio)]*0+ExpFFratio,'LineStyle','--','Color','k');
        figure(Fig); subplot(236); hold on
        PlotColormapOverlap(ACE{1},ACL{1},TimeRes,-0.25,0.1)
        line([1:ACLag]*TimeRes/60,[1:ACLag]*0,'LineStyle','--','Color', 'k');legend('show');
        figure(Fig); suptitle(ToSave);
    
%     Smooth = 5;
%     if Cumulative
%        FFL = FFL{1};
%        FFE = FFE{1};
%     else
%         FFL = medfilt1(FFL{1},Smooth,[],1);
%         FFE = medfilt1(FFE{1},Smooth,[],1);
%     end
        
    %FFESD = nanstd(FFL ./ FFE,1,2);  
    %FFE = nanmean(FFL ./ FFE,2); 
    
    Ratios = [ExpFFratio, FFRatio(end), FFRatioSD(end)] ;
    %Ratios = [ExpFFratio, nanmean(FFRatio(length(FFRatio)/2:end)), nanstd(FFRatioSD(length(FFRatio)/2:end))] ;

    Out.FFE = FFRatio; 
    Out.FFESD = FFRatioSD;
    Out.ACE = ACE;
    Out.TimeRes = TimeRes;
    Out.ACL = ACL; 
    Out.Exp = ToSave;  
    Out.E = Early;
    Out.L = Late;
    Out.Ratios = Ratios;

        if FRAP 
            Mean = r.*Kon./(Kon + Koff).*(L./vpol.*60);
            figure(Fig); subplot(235); yyaxis right
            title('FF Ratio / FRAP recovery');
            plot([1:length(FFRatio)].*TimeRes./60',nanmean(Early,2)./Mean(1));
            plot([1:length(FFRatio)].*TimeRes./60',nanmean(Late,2)./Mean(2));
        end
        
        print(Fig,[PathToSave,ToSave,'_Stats.pdf'],'-fillpage', '-dpdf');
%Deg = [Deg, mean(nanmean(Early(20:end,:),2))/(r1*Kon1./(Kon1+Koff1))]
%Deg = [Deg, mean(nanmean(Late(20:end,:),2))/(r2*Kon2./(Kon2+Koff2))]
close all

else
    Ratios = [NaN, NaN, NaN] ;
    Out.FFE = NaN; 
    Out.FFESD = NaN;
    Out.ACE = NaN;
    Out.TimeRes = NaN;
    Out.ACL = NaN; 
    Out.Exp = NaN; 
    Out.E = NaN;
    Out.L = NaN;
    Out.Ratios = NaN;
end

end