function [FTL FTL_RGB Stats_table] = Segment2C(RFPtoThreshold,GFPtoThreshold, parameters,show)
    FTL = zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),size(RFPtoThreshold,3));
    FTL_RGB = zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),3,size(RFPtoThreshold,3));
    Stats_table = cell(size(RFPtoThreshold,3),1);
    [LoGradiusR LoGradiusG ThresLevelR ThresLevelG RemoveSizeR RemoveSizeG Thicken]=parameters{:};
    %F_R = FiltGlobalNorm(RFPtoThreshold,LoGradiusR);
    F_R = RFPtoThreshold;
    F_G = FiltGlobalNorm(GFPtoThreshold,LoGradiusG);
    for f=1:size(RFPtoThreshold,3)
        disp(['frame ',num2str(f)])
        [F_R(:,:,f)] = FiltThres(F_R(:,:,f),num2cell([LoGradiusR ThresLevelR RemoveSizeR]));
        [F_G(:,:,f)] = Thres(F_G(:,:,f),num2cell([ThresLevelG RemoveSizeG]));
        FTL(:,:,f) = F_R(:,:,f) | F_G(:,:,f);
        [FTL(:,:,f) FTL_RGB(:,:,:,f) Stats_table{f,1}] = Lab(FTL(:,:,f),Thicken);
    end
    %
    if strcmp(show,'on')==1;
        D=zeros(size(FTL,1),size(FTL,2),1,size(FTL,3));
        D(:,:,1,:)=FTL(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=FTL(:,:,:)+1;
        mov = immovie(FTL_RGB);
        implay(mov)
    end
end