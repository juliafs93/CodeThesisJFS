%% FIX TRACKING
Stats_toFix = Stats_GFP;
%Stats_spots = Stats_tracked;
Stats_spots = Stats_GFP_G;
%%
% for f = 1:size(Stats_spots,1);
%     Table = Stats_spots{f};
%     Table.Label = [1:size(Table,1)]';
%     Table(Table.Area==0,:) = [];
%     Stats_spots{f} = Table;
% end
%%
for f = 1:size(Stats_toFix,1);
    Table = Stats_toFix{f};
    Table(isnan(Table.Area),:) = [];
    Table.NewLabel = Table.Label;
    Stats_toFix{f} = Table;
end
%%
[AllF] = MergeAll(Stats_spots, TimeRes);
LabelsS = unique(AllF.Label);
[CentXS] = Reshape(AllF,Frames,LabelsS,'CentroidX','Label');
[CentYS] = Reshape(AllF,Frames,LabelsS,'CentroidY','Label');
[CentZS] = Reshape(AllF,Frames,LabelsS,'CentroidZ','Label');

%%
[AllF] = MergeAll(Stats_toFix, TimeRes);
Labels = unique(AllF.Label);
[CentX] = Reshape(AllF,Frames,Labels,'CentroidX','Label');
[CentY] = Reshape(AllF,Frames,Labels,'CentroidY','Label');
[CentZ] = Reshape(AllF,Frames,Labels,'CentroidZ','Label');

%% delete tracks of less than minNumb
minDistance = 3; % 4microns
minNumb = 10;
noNaNnum = sum(~isnan(CentXS),1);
LabelsS(noNaNnum <= minNumb) = [];
CentXS(:,noNaNnum <= minNumb) = [];
CentYS(:,noNaNnum <= minNumb) = [];
CentZS(:,noNaNnum <= minNumb) = [];
for L = 1:length(LabelsS)
    TrajectoryX = CentXS(:,L);
    TrajectoryY = CentYS(:,L);
    TrajectoryZ = CentZS(:,L);
    Label = LabelsS(L);
    Closest = sqrt(((TrajectoryX-CentX).*XYRes).^2 +...
        ((TrajectoryY-CentY).*XYRes).^2 +...
        ((TrajectoryZ-CentZ).*ZRes).^2);
    [Min, Index] = min(Closest,[],2,'omitnan');
    Min(Min>minDistance) = NaN;
    Index(isnan(Min)) = NaN;
    [Col, Row] = ind2sub([size(Closest,2),size(Closest,1)],Index);
    disp(num2str(length(unique(Col(~isnan(Col))))))
    if length(unique(Col(~isnan(Col)))) > 1
        toChange = find(~isnan(Col));
        for f=2:length(toChange)
            % delete old an change label in new
            if Labels(Col(toChange(f))) ~= min(Labels(Col(toChange)))
                Stats_toFix{toChange(f)}(Stats_toFix{toChange(f)}.Label==min(Labels(Col(toChange))),:) = [];
                Stats_toFix{toChange(f)}.NewLabel(Stats_toFix{toChange(f)}.Label==Labels(Col(toChange(f)))) = min(Labels(Col(toChange)));
                disp(['changed ',num2str(Labels(Col(toChange(f)))),...
                    ' for ',num2str(min(Labels(Col(toChange)))), ' in f', num2str(toChange(f))])
            end           
        end
    end
end
