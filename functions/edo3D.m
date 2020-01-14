[File, Path] = uigetfile('*.*')
prueba = load([Path, File])

%%
minD = 20;
XYZT = prueba.handles.fitInfo(:,[1 2 10 3]);
XYZT(:,1:2) = XYZT(:,1:2)*97;
length(unique(XYZT(:,3)))
%%
Unique = unique(XYZT(:,4));
Cell3D = cell(max(Unique),3);
for f=1:length(Unique)
    new = XYZT(XYZT(:,4)==Unique(f),:);
    Cell3D{Unique(f),1}= new(:,1);
    Cell3D{Unique(f),2}= new(:,2);
    Cell3D{Unique(f),3}= new(:,3);
end

%%
newCell3D = cell(size(Cell3D,1),3);
newCell3D(1,:) = Cell3D(1,:);
for f=2:size(Cell3D,1)
    Xs = Cell3D{f,1}';
    Ys = Cell3D{f,2}';
    Zs = Cell3D{f,3}';
    Xs_1 = Cell3D{f-1,1}';
    Ys_1 = Cell3D{f-1,2}';
    Zs_1 = Cell3D{f-1,3}';
    newXs = []; newYs = [];newZs = [];
    for L=1:length(Xs)
        eucledian = sqrt((Xs_1-Xs(L)).^2.+(Ys_1-Ys(L)).^2.+(Zs_1-Zs(L)).^2);
        if isempty(eucledian);eucledian=100000;end
        if min(eucledian)>minD
            newXs = [newXs Xs(L)]; 
            newYs = [newYs Ys(L)];
            newZs = [newZs Zs(L)];
        end
    end
    newCell3D{f,1} = newXs';
    newCell3D{f,2} = newYs';
    newCell3D{f,3} = newZs';
end

%%
AllXs = cell2mat(newCell3D(:,1));
AllYs = cell2mat(newCell3D(:,2));
AllZs = cell2mat(newCell3D(:,3));
length(AllXs)/size(XYT,1)
writetable(table(AllXs, AllYs,AllZs), [Path File '_blinkfiltered.txt'],'Delimiter',',')