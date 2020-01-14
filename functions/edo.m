prueba = load('/Users/julia/Downloads/20170301_aPKC_HASP_astig.mat')

%%
minD = 20;
XYT = prueba.handles.fitInfo(:,1:3);
XYT(:,1:2) = XYT(:,1:2)*97;
length(unique(XYT(:,3)))
%%
Unique = unique(XYT(:,3));
Cell3D = cell(max(Unique),2);
for f=1:length(Unique)
    new = XYT(XYT(:,3)==Unique(f),:);
    Cell3D{Unique(f),1}= new(:,1);
    Cell3D{Unique(f),2}= new(:,2);
end

%%
newCell3D = cell(size(Cell3D,1),2);
newCell3D(1,:) = Cell3D(1,:);
for f=2:size(Cell3D,1)
    Xs = Cell3D{f,1}';
    Ys = Cell3D{f,2}';
    Xs_1 = Cell3D{f-1,1}';
    Ys_1 = Cell3D{f-1,2}';
    newXs = []; newYs = [];
    for L=1:length(Xs)
        eucledian = sqrt((Xs_1-Xs(L)).^2.+(Ys_1-Ys(L)).^2);
        if isempty(eucledian);eucledian=100000;end
        if min(eucledian)>minD
            newXs = [newXs Xs(L)]; 
            newYs = [newYs Ys(L)];
        end
    end
    newCell3D{f,1} = newXs';
    newCell3D{f,2} = newYs';
end

%%
AllXs = cell2mat(newCell3D(:,1));
AllYs = cell2mat(newCell3D(:,2));
length(AllXs)/size(XYT,1);
writetable(table(AllXs, AllYs), '/Users/julia/Dropbox/pruebaEdo.txt','Delimiter',',')