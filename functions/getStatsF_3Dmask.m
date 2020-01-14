function [Stats_GFP maxF minF] = getStatsF_3Dmask(Mask, F_max)
    Stats_GFP = cell(size(F_max,4),1);
    maxF=0;
    minF=255;
    Mask3D = repmat(Mask, [1,1,size(F_max,3)]);

    for f = 1:size(F_max,4)
        Stats_GFP{f,1} = regionprops('table',Mask3D,F_max,'PixelIdxList','PixelList','Centroid','MaxIntensity','MeanIntensity','PixelValues','Area');
        maxF = max([maxF,Stats_GFP{f,1}.MeanIntensity']);
        minF = min([minF,Stats_GFP{f,1}.MeanIntensity']);
    end
end