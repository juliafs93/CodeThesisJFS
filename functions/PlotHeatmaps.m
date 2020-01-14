function[FigH] = PlotHeatmaps(FigH,NormMerged,Selected,PropertiesMerged,TimeScaleMerged,SelectedN,TimeRes,XLim,i,Max)
        NormMerged(NormMerged < 0) = 1;
        %NormMerged(isnan(NormMerged)) = 0;
        NormMerged = NormMerged(:,Selected);
        PropertiesMerged = PropertiesMerged(Selected,:);
        nc14Merged = find(round(TimeScaleMerged,4) == 0);
        %if isempty(DelayMerged); DelayMerged = 0; end
        Bits = 12;
        CMAP = parula(2^Bits+1);
        %CMAP = gray(2^Bits+1);
        CMAP(1,:) = [0,0,0];
        Cases = {'AP','None','Onset'};
        figure(FigH);
        for n = 1:length(Cases)
            Sort = Cases{n};
            subplot(3,length(SelectedN),(n-1)*length(SelectedN)+i)
            switch Sort
                case 'None'
                    Sorted = NormMerged;
                    YLabel = [num2str(size(NormMerged,2)),' cells'];
                case 'AP'
                    [~,Order] = sort(PropertiesMerged.NormAP);
                    Sorted = NormMerged(:,Order);
                    YLabel = [num2str(size(NormMerged,2)),' cells sorted by AP position'];
                case 'Total'
                    [~,Order] = sort(PropertiesMerged.TotalmRNA);
                    Sorted = NormMerged(:,Order);
                    YLabel = [num2str(size(NormMerged,2)),' cells sorted by total mRNA production'];
                case 'Onset'
                    [~,Order] = sort(PropertiesMerged.Onset);
                    Sorted = NormMerged(:,Order);
                    YLabel = [num2str(size(NormMerged,2)),' cells sorted by onset time'];
                case 'DV'
                    [~,Order] = sort(PropertiesMerged.DMSE,'descend');
                    Sorted = NormMerged(:,Order);
                    YLabel = [num2str(size(NormMerged,2)),' cells sorted by DV position'];
            end
            imagesc(Sorted(nc14Merged:end,:)',[0,Max])
            xlim([0,XLim(2)*60/TimeRes])
            %XTickLabels = str2double(get(gca,'XTickLabels'));
            xticks([0:20:XLim(2)]*60/TimeRes)
            xticklabels(cellstr(num2str([0:20:XLim(2)]')))
            yticklabels('')
            xlabel('time into nc14 (min)')
            ylabel(YLabel)
            set(get(gca, 'YLabel'), 'Units', 'Normalized','Position', [-0.02,0.5,0],'Rotation',90);
            colormap(CMAP)
            title(SelectedN{i})
        end
end