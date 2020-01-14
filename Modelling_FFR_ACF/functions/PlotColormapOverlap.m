function[] = PlotColormapOverlap(ACE,ACL,TimeRes,YPos,Range)
        Overlap = ((ACL.ACMean + ACL.ACSD) - (ACE.ACMean - ACE.ACSD)).*((ACL.ACMean - ACL.ACSD) - (ACE.ACMean + ACE.ACSD)) > 0;
        Diff = [(ACL.ACMean + ACL.ACSD) - (ACE.ACMean - ACE.ACSD),(ACL.ACMean - ACL.ACSD) - (ACE.ACMean + ACE.ACSD)];
        Diff(~Overlap,:) = [];
        [Min, Inx] = min(abs(Diff),[],2);
        Overlap = find(Overlap);
        Steps = 100;
        Min = -Range;
        Max = Range;
        Scale =  Steps ./ (Max-Min);
        %CmapDiff = copper(Steps);
        CmapDiff = cbrewer('div','RdGy',Steps);
        %CmapDiff = cbrewer('div','RdBu',Steps);
        %CmapDiff = cbrewer('div','BrBG',Steps);

        if isempty(Overlap) == 0
            %set(0,'defaultAxesColorOrder',CmapDiff)
            for i = 1:length(Overlap)
                Diffi = round(Diff(i,Inx(i))*Scale)+Steps/2;
                if Diffi < 1; Diffi = 1; end
                if Diffi > Steps; Diffi = Steps; end
                Color = CmapDiff(Diffi,:);
                plot(Overlap(i).*TimeRes./60',YPos,'.','Color',Color);
            end
            ylim([-0.5,1])
        end
end
