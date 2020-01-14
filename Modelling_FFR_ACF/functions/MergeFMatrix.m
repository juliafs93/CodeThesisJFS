function[NormMerged,PropertiesMerged,TimeScaleMerged] = MergeFMatrix(Norm,NormMerged,Properties,PropertiesMerged,TimeScale,TimeScaleMerged,TimeRes)

try
TimeResMerged = [TimeScaleMerged(2) - TimeScaleMerged(1)].*60;
catch
   TimeResMerged = TimeRes;
end
if round(TimeResMerged,4) ~= round(TimeRes,4)

    NewTimeScale = [flip(0:-TimeResMerged:TimeScale(1).*60),TimeResMerged:TimeResMerged:TimeScale(end).*60]./60;
    NewNorm = zeros(length(NewTimeScale),size(Norm,2));
    for i = 1:size(Norm,2)
        NewNorm(:,i) = interp1(TimeScale,Norm(:,i),NewTimeScale);
    end
   TimeScale = NewTimeScale;
   Norm = NewNorm;
end
            % merge means, timescale and properties when which = 1
            % correct tables with distinct number of columns
            PMcolmissing = setdiff(Properties.Properties.VariableNames, PropertiesMerged.Properties.VariableNames);
            Pcolmissing = setdiff(PropertiesMerged.Properties.VariableNames, Properties.Properties.VariableNames);
            PropertiesMerged = [PropertiesMerged array2table(nan(height(PropertiesMerged), numel(PMcolmissing)), 'VariableNames', PMcolmissing)];
            Properties = [Properties array2table(nan(height(Properties), numel(Pcolmissing)), 'VariableNames', Pcolmissing)];
            PropertiesMerged = vertcat(PropertiesMerged, Properties);
            Length = floor((max([TimeScaleMerged, TimeScale])-min([TimeScaleMerged, TimeScale])).*60./TimeRes+1);
            NormtoFill = nan(Length,size(Norm,2));
            try  FDelay = (TimeScaleMerged(1)-TimeScale(1)).*60./TimeRes;
            catch FDelay=0;end
            if FDelay < 0; FDelay = 0; end
            FDelay = round(FDelay);
            NormtoFill((1:size(NormMerged,1))+FDelay,1:size(NormMerged,2)) = NormMerged;
            try FDelay = (TimeScale(1)-TimeScaleMerged(1)).*60./TimeRes;
            catch FDelay = 0; end
            if FDelay < 0; FDelay = 0; end
            FDelay = round(FDelay);
            NormtoFill((1:size(Norm,1))+FDelay,(1:size(Norm,2))+size(NormMerged,2)) = Norm;
            NormMerged = NormtoFill;
            TimeScaleMerged = [min([TimeScaleMerged, TimeScale]):TimeRes./60:max([TimeScaleMerged, TimeScale])];
            %end 


end