function [TL TL_RGB Stats_table] = ThresLabNBs(toThreshold,parameters)
        [remove1 diskSize WatershedParameter remove2 Thicken] = parameters{:};
        %T=im2bw(toThreshold(:,:,f),0.7);
        T = imregionalmax(toThreshold,4);
        %Tf = imfill(T, 'holes');
        Tfar = bwareaopen(T,remove1,4);
        %se = strel('disk',10); %movie1
        %se = strel('disk',5); %movie2
        se = strel('disk',diskSize); %movie3=3
        TfarO = imopen(Tfar, se);
        %[dummy L] = bwboundaries(TfarO, 4, 'noholes');
        %L=bwlabel(TfarT,4);
        %Le = imdilate(L,se);
        D = bwdist(~TfarO);
        D = -D;
        %D(~L) = -Inf;
        D2 = imhmin(D,WatershedParameter);
        %D2=D;
        D2(~TfarO) = -Inf;
        L2=watershed(D2, 4);
        L3 = bwareaopen(L2-1,remove2,4);
        L4 = bwmorph(L3,'thicken',Thicken);
        L5 = bwlabel(L4,4);
        TL = L5;
        TL_RGB=label2rgb(TL,'jet', 'k', 'shuffle');
        %Stats{f,1} = regionprops(RFP_FTL(:,:,f),'Area','Centroid','Perimeter','Image','SubarrayIdx');
        Stats_table = regionprops('table',TL,'Area','Centroid','Perimeter','Image','SubarrayIdx');

end