function[] = PlotMiniFFAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes)
    ax1 = gca; % current axes
    errorbar(ax1,[1:length(FF)].*TimeRes./60,FF,FFSD,FFSD,'CapSize',0,'Color',[0.6980,0.0941,0.1686]);hold on
    %errorbar(ax1,[1:length(Out.FFL)].*TimeRes./60,Out.FFL,Out.FFLSD,Out.FFLSD,'CapSize',0,'Color',[209,28,71]./255);hold on
    plot(ax1,[1:length(FF)].*TimeRes./60,ones(1,length(FF)),'--','Color',[0.6980,0.0941,0.1686])
    %plot(ax1,[1:length(Out.FFL)].*TimeRes./60,ones(1,length(Out.FFL)),'--','Color',[209,28,71]./255)
    ax1.Units = 'normalized';
    ax1.XColor = [0.6980,0.0941,0.1686];
    ax1.YColor = [0.6980,0.0941,0.1686];
    ylim([-5,10])
    xlim([0,length(FF).*TimeRes./60])
    %xlim([0,length(Out.FFL).*TimeRes./60])
    ylabel('FFRatio')
    xlabel('t (min)')
    set(get(ax1, 'XLabel'), 'Units', 'Normalized','Position', [0.5,0.15,0],'Rotation',0,'FontSize',12);
    %set(get(ax1, 'XLabel'), 'Position', [length(Out.FFL).*TimeRes./60,-6.5,0],'Rotation',0,'FontSize',12);
    set(get(ax1, 'YLabel'), 'Units', 'Normalized','Position', [0.05,1.1,0],'Rotation',0,'FontSize',12);
    box off
    
    ax1_pos = ax1.Position; % position of first axes
    ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none','Units','normalized');hold on
    ax2.XColor = [0.3,0.3,0.3];
    ax2.YColor = [0.3,0.3,0.3];
    errorbar(ax2,[1:length(AC1.ACMean)].*TimeRes./60,AC1.ACMean,AC1.ACSD,AC1.ACSD,'CapSize',0,'Color',[0.2,0.2,0.2],'DisplayName',Names{1}); 
    %errorbar(ax2,[1:length(Out.ACL{1}.ACMean)].*TimeRes./60,Out.ACL{1}.ACMean,Out.ACL{1}.ACSD,Out.ACL{1}.ACSD,'CapSize',0,'Color',[0.5,0.5,0.5])
    errorbar(ax2,[1:length(AC2.ACMean)].*TimeRes./60,AC2.ACMean,AC2.ACSD,AC2.ACSD,'CapSize',0,'Color',[0.5,0.5,0.5],'DisplayName',Names{2}); 
    %errorbar(ax2,[1:length(Out.ACL{2}.ACMean)].*TimeRes./60,Out.ACL{2}.ACMean,Out.ACL{2}.ACSD,Out.ACL{2}.ACSD,'CapSize',0,'Color',[0.5,0.5,0.5])
    set(gcf,'defaultLegendAutoUpdate','off')
    legend('Location','North')
    legend boxoff
    %plot(ax2,[1:length(AC1.ACMean)].*TimeRes./60,zeros(1,length(AC1.ACMean)),'--','Color',[0.3,0.3,0.3])
    ylim([-0.5,1])
    xlim([0,ACLag.*TimeRes./60])
    ylabel('ACF')
    xlabel('t (min)')
    box off
    PlotColormapOverlap(AC1,AC2,TimeRes,-0.25,0.1)
    set(get(ax2, 'XLabel'), 'Units', 'Normalized','Position', [0.95,1.1,0],'Rotation',0,'FontSize',12);
    set(get(ax2, 'YLabel'), 'Units', 'Normalized','Position', [1.15,1.1,0],'Rotation',0,'FontSize',12);
      title(Exp,'FontSize',12);
end