function [RFPtoThreshold3] = Contrast(RFPtoThreshold, inputLow, inputHigh,sigmaFilt,Bits, show)
    RFPtoThreshold2 = RFPtoThreshold;
    RFPtoThreshold3 = RFPtoThreshold;
    for f=1:size(RFPtoThreshold,3)
        %RFPtoThreshold2(:,:,f) = RFPtoThreshold(:,:,f)./max(max(RFPtoThreshold(:,:,f)));
        RFPtoThreshold2(:,:,f) = RFPtoThreshold(:,:,f)./(2^Bits);
        if sigmaFilt ~= 0;
            RFPtoThreshold3(:,:,f) = imadjust(imgaussfilt(RFPtoThreshold2(:,:,f),sigmaFilt),[inputLow; inputHigh],[0; 1]);
        else
            RFPtoThreshold3(:,:,f) = imadjust(RFPtoThreshold2(:,:,f),[inputLow; inputHigh],[0; 1]);
        end
    end

    if strcmp(show,'on')==1;
        D=zeros(size(RFPtoThreshold,1),size(RFPtoThreshold,2),1,size(RFPtoThreshold,3));
        D(:,:,1,:)=RFPtoThreshold3(:,:,:);
        montage(D, [0 1]);
    end
end