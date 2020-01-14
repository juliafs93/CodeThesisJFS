function [T_L T_L_RGB Stats] = ThresLab(norm,parameters, Bits)
    [LoGradius level areaopen Thicken]=parameters{:};
    T = im2bw(norm,level);
    Tf = imfill(T, 'holes');
    Tfar = bwareaopen(Tf,areaopen,4);
    %se = strel('disk',2);
    TfarO = bwmorph(Tfar, 'open',1);
    TfarT = bwmorph(TfarO, 'thicken',Thicken);
    %TT = bwmorph(Tf, 'thicken',5);
    %TfarT = bwareaopen(TT,areaopen,4);
    [T_L dummy]= bwlabel(TfarT,4); %from segmented to labeled image, assigns color to cell
    Stats = regionprops('table',T_L,'Area','Centroid','Perimeter');
    T_L_RGB = label2rgb(T_L, 'jet', 'k', 'shuffle');

    %figure;
    %subplot(131); imagesc(filteredImg); axis image;
    %subplot(132); imagesc(Tf); axis image;
    %subplot(133); imagesc(T_L_RGB); axis image;
%     toPrint = zeros(size(img,1),size(img,2), 9);
%     toPrint(:,:,1) = RFPtoThreshold(:,:,1);
%     toPrint(:,:,2) = img;
%     toPrint(:,:,3) = norm.*1000;
%     toPrint(:,:,4) = T;
%     toPrint(:,:,5) = Tf;
%     toPrint(:,:,6) = Tfar;
%     toPrint(:,:,7) = TfarO;
%     toPrint(:,:,8) = TfarT;
%     toPrint(:,:,9) = T_L;
% 
%     
%     imwrite(uint16(toPrint(:,:,1)), [Path,File,Name,File, '_FTL_f1.tiff'],'Compression','none')
%     for f = 2:size(toPrint,3)
%         imwrite(uint16(toPrint(:,:,f)), [Path,File,Name,File, '_FTL_f1.tiff'],'WriteMode','append','Compression','none')
%     end
%     imwrite(T_L_RGB,jet, [Path,File,Name,File, '_FTL_RGB.tiff'],'Compression','none')

end