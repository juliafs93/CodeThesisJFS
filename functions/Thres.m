function [TfarO] = Thres(norm,parameters)
    [level areaopen]=parameters{:};
    T = im2bw(norm,level);
    Tf = imfill(T, 'holes');
    Tfar = bwareaopen(Tf,areaopen,4);
    %se = strel('disk',2);
    TfarO = bwmorph(Tfar, 'open',1);
    %TfarT = bwmorph(TfarO, 'thicken',Thicken);
    %TT = bwmorph(Tf, 'thicken',5);
    %TfarT = bwareaopen(TT,areaopen,4);
    %[T_L dummy]= bwlabel(TfarT,4); %from segmented to labeled image, assigns color to cell
   
end