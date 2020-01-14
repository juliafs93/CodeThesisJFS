function [Stats_GFP maxF minF] = getStatsF_mask(RFP_FTL_tracked, F_max)
    Stats_GFP = cell(size(F_max,3),1);
    maxF=0;
    minF=255;

    for f = 1:size(F_max,3)
        Stats_GFP{f,1} = regionprops('table',RFP_FTL_tracked,F_max(:,:,f),'PixelIdxList','Centroid','MaxIntensity','MeanIntensity','PixelValues','Area','Perimeter');
        maxF = max([maxF,Stats_GFP{f,1}.MeanIntensity']);
        minF = min([minF,Stats_GFP{f,1}.MeanIntensity']);
    end
end