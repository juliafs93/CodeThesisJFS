function[Fig] = PlotMeans(MaxF,MeanNorm, OnOff,TimeScale,Selected,Properties,Bits,ColorArg,Fig,OnlyMeans,Legend, XLim, YLimits)
    set(0, 'DefaulttextInterpreter', 'none')
    PropertiesSelected = Properties(Selected,:);
    %ShortMid = PropertiesSelected.Type=='ShortMidline';
    %LongMid = PropertiesSelected.Type=='LongMidline';
    ShortMid = strcmp(PropertiesSelected.Type,'ShortMidline');
    LongMid = strcmp(PropertiesSelected.Type,'LongMidline');
    %Midline = PropertiesSelected.Type~='EarlyOnly' & PropertiesSelected.Type~='LateTrack';
    Midline = ~strcmp(PropertiesSelected.Type,'EarlyOnly') & ~strcmp(PropertiesSelected.Type,'LateTrack');

    MaxFSelected = MaxF(:,Selected);
      OnOffSelected = OnOff(:,Selected);
      

    figure(Fig);
    if OnlyMeans == 0;
    try;subplot(411); hold on
        
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('F (AU)')
        xlim([XLim]);title('All selected');
        legend('show');
        t1 = plot(TimeScale,MaxFSelected,'- .','Color',[0.7,0.7,0.7,0.2],...
            'MarkerEdgeColor',ColorArg(1,:),'HandleVisibility','off');
        m1 = plot(TimeScale,nanmean(MaxFSelected,2),'.','MarkerSize',12,...
            'MarkerEdgeColor',ColorArg(5,:),'DisplayName',Legend);
        uistack(m1, 'down');
        uistack(t1, 'bottom');
        legend('boxoff');
         end
    try;subplot(412); hold on
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('F (AU)')
        xlim([0,XLim(2)]);title('All midline'); 
        legend('show');
        t2=plot(TimeScale,MaxFSelected(:,Midline),'- .','Color',[0.7,0.7,0.7,0.2],...
            'MarkerEdgeColor',ColorArg(2,:),'HandleVisibility','off');
        m2=plot(TimeScale,nanmean(MaxFSelected(:,Midline),2),'.','MarkerSize',12,...
            'MarkerEdgeColor',ColorArg(6,:),'DisplayName',Legend);
        uistack(m2, 'down');
        uistack(t2, 'bottom');
        legend('boxoff');
        end
    try;subplot(413); hold on
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('F (AU)')
        xlim([0,XLim(2)]); title('Short Midline');
        legend('show');
        t3=plot(TimeScale,MaxFSelected(:,ShortMid),'- .','Color',[0.7,0.7,0.7,0.2],...
            'MarkerEdgeColor',ColorArg(3,:),'HandleVisibility','off');
        m3=plot(TimeScale,nanmean(MaxFSelected(:,ShortMid),2),'.','MarkerSize',12,...
            'MarkerEdgeColor',ColorArg(7,:),'DisplayName',Legend);
        uistack(m3, 'down');
        uistack(t3, 'bottom');
        legend('boxoff');
        end
    try; subplot(414); hold on
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('F (AU)')
        xlim([0,XLim(2)]); title('Long Midline');
        legend('show');
        t4=plot(TimeScale,MaxFSelected(:,LongMid),'- .','Color',[0.7,0.7,0.7,0.2],...
            'MarkerEdgeColor',ColorArg(4,:),'HandleVisibility','off');
        m4=plot(TimeScale,nanmean(MaxFSelected(:,LongMid),2),'.','MarkerSize',12,...
            'MarkerEdgeColor',ColorArg(8,:),'DisplayName',Legend);
        uistack(m4, 'down');
        uistack(t4, 'bottom');
        legend('boxoff');
    end
          
    end

    if OnlyMeans == 1
    %try; 
        subplot(411); hold on
        %title('All selected');
        legend('show');
        %plot(TimeScale,nanmean(MaxFSelected,2),'- .','MarkerSize',12,...
        %   'Color',ColorArg(5,:),'MarkerEdgeColor',ColorArg(5,:),'DisplayName',Legend);
        Mean = nanmean(MaxFSelected,2);
        SEM = nanstd(MaxFSelected,1,2)./sqrt(sum(~isnan(MaxFSelected),2));
        TimeScalePoly = TimeScale; 
        MeanPoly = Mean; SEMPoly = SEM; 
        TimeScalePoly(isnan(Mean)) = [];
        MeanPoly(isnan(Mean)) = [];
        SEMPoly(isnan(Mean)) = [];     
        %errorbar(TimeScale,Mean,SEM,'- .','MarkerSize',8,'Color',[ColorArg(6,:),0.5],'DisplayName',[Legend,' n = ',num2str(sum(Midline)),' cells, ',num2str(size(MeanNorm,2)),' embryos'],'CapSize',0,'LineWidth',0.25);
        Poly = polyshape([TimeScalePoly,flip(TimeScalePoly)]',[MeanPoly-SEMPoly;flip(MeanPoly+SEMPoly)]);
        plot(Poly,'LineStyle','none','FaceColor',[ColorArg(6,:),0.5],'HandleVisibility','off');hold on
        plot(TimeScale,Mean,'-','MarkerSize',8,'Color',[ColorArg(6,:),1],'DisplayName',[Legend,' n = ',num2str(sum(Midline)),' cells, ',num2str(size(MeanNorm,2)),' embryos'],'LineWidth',0.5);

        legend boxoff
        legend('Location','NorthWest')
       ax = gca;
        ax.YAxisLocation = 'origin';
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('Mean Fluorescence (AU)')
        xlim(XLim); %yticks([0:500:YLimits(2)]);
        set(get(gca, 'XLabel'), 'Position', [XLim(2)*0.9,-0.1*YLimits(2),0]);
        set(get(gca, 'YLabel'), 'Position', [-XLim(2)*0.05,YLimits(2)*1.1,0]);
        
    %     end
    %try;
        subplot(412); hold on
        title('Mean + SEM merged movies');
        legend('show');
        %plot(TimeScale,nanmean(MaxFSelected(:,Midline),2),'- .','MarkerSize',12,...
        %    'Color',ColorArg(6,:),'MarkerEdgeColor',ColorArg(6,:),'DisplayName',Legend); 
        Mean = nanmean(MaxFSelected(:,Midline),2);
        SEM = nanstd(MaxFSelected(:,Midline),1,2)./sqrt(sum(~isnan(MaxFSelected(:,Midline)),2));
        TimeScalePoly = TimeScale; 
        MeanPoly = Mean; SEMPoly = SEM; 
        TimeScalePoly(isnan(Mean)) = [];
        MeanPoly(isnan(Mean)) = [];
        SEMPoly(isnan(Mean)) = [];
        %errorbar(TimeScale,Mean,SEM,'- .','MarkerSize',8,'Color',[ColorArg(6,:),0.5],'DisplayName',[Legend,' n = ',num2str(sum(Midline)),' cells, ',num2str(size(MeanNorm,2)),' embryos'],'CapSize',0,'LineWidth',0.25);
        Poly = polyshape([TimeScalePoly,flip(TimeScalePoly)]',[MeanPoly-SEMPoly;flip(MeanPoly+SEMPoly)]);
        plot(Poly,'LineStyle','none','FaceColor',[ColorArg(6,:),0.5],'HandleVisibility','off');hold on
        plot(TimeScale,Mean,'-','MarkerSize',8,'Color',[ColorArg(6,:),1],'DisplayName',[Legend,' n = ',num2str(sum(Midline)),' cells, ',num2str(size(MeanNorm,2)),' embryos'],'LineWidth',0.5);

        legend boxoff
        legend('Location','NorthWest')
        ax = gca;
        ax.YAxisLocation = 'origin';
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('Mean Fluorescence (AU)')
        xlim([-0.01,XLim(2)]); %yticks([0:500:YLimits(2)]);
        set(get(gca, 'XLabel'), 'Position', [XLim(2)*0.9,-0.1*YLimits(2),0]);
        set(get(gca, 'YLabel'), 'Position', [-XLim(2)*0.05,YLimits(2)*1.1,0]);
        
         %end
    %try;
        subplot(413); hold on
         title('Mean + SEM each movie');
        legend('show');
        %plot(TimeScale,nanmean(MaxFSelected(:,Midline),2),'- .','MarkerSize',12,...
        %    'Color',ColorArg(6,:),'MarkerEdgeColor',ColorArg(6,:),'DisplayName',Legend); 
        Mean = nanmean(MeanNorm,2);
        SEM = nanstd(MeanNorm,1,2)./sqrt(sum(~isnan(MeanNorm),2));
        %errorbar(TimeScale,Mean,SEM,'- .','MarkerSize',8,'Color',[ColorArg(6,:),0.5],'DisplayName',[Legend,' n = ',num2str(sum(Midline)),' cells, ',num2str(size(MeanNorm,2)),' embryos'],'CapSize',0,'LineWidth',0.25);
         TimeScalePoly = TimeScale; 
        MeanPoly = Mean; SEMPoly = SEM; 
        TimeScalePoly(isnan(Mean)) = [];
        MeanPoly(isnan(Mean)) = [];
        SEMPoly(isnan(Mean)) = [];
        Poly = polyshape([TimeScalePoly,flip(TimeScalePoly)]',[MeanPoly-SEMPoly;flip(MeanPoly+SEMPoly)]);
        plot(Poly,'LineStyle','none','FaceColor',[ColorArg(6,:),0.5],'HandleVisibility','off');hold on
        plot(TimeScale,Mean,'-','MarkerSize',8,'Color',[ColorArg(6,:),1],'DisplayName',[Legend,' n = ',num2str(size(MeanNorm,2)),' embryos'],'LineWidth',0.5);

        legend boxoff
        legend('Location','NorthWest')
        ax = gca;
        ax.YAxisLocation = 'origin';
        ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('Mean Fluorescence (AU)')
        xlim([-0.01,XLim(2)]); %yticks([0:500:YLimits(2)]);
        set(get(gca, 'XLabel'), 'Position', [XLim(2)*0.9,-0.1*YLimits(2),0]);
        set(get(gca, 'YLabel'), 'Position', [-XLim(2)*0.05,YLimits(2)*1.1,0]);
       
        
        subplot(414); hold on
        title('Proportion cells ON');
        legend('show');
%         plot(TimeScale,nanmean(MaxFSelected(:,ShortMid),2),'- .','MarkerSize',12,...
%             'Color',ColorArg(7,:),'MarkerEdgeColor',ColorArg(7,:),'DisplayName',Legend); 
%         plot(TimeScale,[nansum(OnOffSelected(:,Midline),2)./nansum(~isnan(OnOffSelected(:,Midline)),2)],...
%             'Color',[ColorArg(6,:),0.5],'DisplayName',Legend,'LineWidth',0.5);
        plot(TimeScale,[nansum(OnOffSelected(:,Midline),2)./nansum(~isnan(OnOffSelected(:,Midline)),2)],...
            '-','MarkerSize',8,...
             'Color',ColorArg(6,:),'MarkerEdgeColor',ColorArg(6,:),'LineWidth',1,'DisplayName',[Legend,' n = ',num2str(sum(Midline))]); 
        legend boxoff
        legend('Location','NorthWest')
         %end
%     try; subplot(414); hold on
%         ax = gca;
%         ax.YAxisLocation = 'origin';
%         ylim(YLimits); xlabel('time into nc14 (min)'); ylabel('MeanF (AU)')
%         xlim([-0.01,XLim(2)]); yticks([0:500:YLimits(2)]);
%         set(get(gca, 'XLabel'), 'Position', [XLim(2)*0.9,-0.1*YLimits(2),0]);
%         set(get(gca, 'YLabel'), 'Position', [-XLim(2)*0.05,YLimits(2)*1.1,0]);
%         %title('Long Midline');
%         legend('show');
% %         plot(TimeScale,nanmean(MaxFSelected(:,LongMid),2),'- .','MarkerSize',12,...
% %             'Color',ColorArg(8,:),'MarkerEdgeColor',ColorArg(8,:),'DisplayName',Legend);
%          plot(TimeScale,nanmean(MaxFSelected(:,Midline),2),'- .','MarkerSize',12,...
%              'Color',ColorArg(6,:),'MarkerEdgeColor',ColorArg(6,:),'DisplayName',Legend); 
%         legend boxoff
%         legend('Location','NorthWest')
%           end
        ax = gca;
        ax.YAxisLocation = 'origin';
        ylim([0,1]); xlabel('time into nc14 (min)'); ylabel('Fraction nuclei ON')
        xlim([-0.01,XLim(2)]); 
        %yticks([0:500:YLimits(2)]);
        set(get(gca, 'XLabel'), 'Position', [XLim(2)*0.9,-0.1*YLimits(2),0]);
        set(get(gca, 'YLabel'), 'Position', [-XLim(2)*0.05,YLimits(2)*1.1,0]);
        
    end
end