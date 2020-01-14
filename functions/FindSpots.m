function [RFPtoThreshold, RFP_FTL_RGB, Stats_table] = FindSpots(varargin)
    RFPtoThreshold = varargin{1};
    Function= varargin{2}; 
    parameters= varargin{3};
    Bits= varargin{4};
    show= varargin{5};
    Split=0;
    try
    Split= varargin{6};
    end
    %RFP_FTL = zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),size(RFPtoThreshold,3));
    RFP_FTL_RGB = zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),3,size(RFPtoThreshold,3));
    Stats_table = cell(size(RFPtoThreshold,3),1);
    [LoGradius level areaopen Thicken]=parameters{:};
    h=-fspecial('log',round(10*1),LoGradius);
    for f=1:size(RFPtoThreshold,3)
        RFPtoThreshold(:,:,f) = fourierFilterWithSymmetricBoundaryConditions(RFPtoThreshold(:,:,f),h);
    end
    if Split == 0
    RFPtoThreshold(:,:,:)=RFPtoThreshold(:,:,:)./max(max(max(RFPtoThreshold(:,:,:))));
    else
        RFPtoThreshold(:,:,1:Split)=RFPtoThreshold(:,:,1:Split)./max(max(max(RFPtoThreshold(:,:,1:Split))));
        RFPtoThreshold(:,:,(Split+1):size(RFPtoThreshold,3))=RFPtoThreshold(:,:,(Split+1):size(RFPtoThreshold,3))./max(max(max(RFPtoThreshold(:,:,(Split+1):size(RFPtoThreshold,3)))));
    end
    for f=1:size(RFPtoThreshold,3)
        [RFPtoThreshold(:,:,f), RFP_FTL_RGB(:,:,:,f), Stats_table{f,1}] = Function(RFPtoThreshold(:,:,f),parameters, Bits);
    end
    %
    if strcmp(show,'on')==1;
        D=zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),1,size(RFPtoThreshold,3));
        D(:,:,1,:)=RFPtoThreshold(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=RFPtoThreshold(:,:,:)+1;
        mov = immovie(RFP_FTL_RGB);
        implay(mov)
    end
end