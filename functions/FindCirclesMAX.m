function [TL Stats_table] = FindCircles(T,parameters)
        [RadiusMin RadiusMax Sensitivity] = parameters{:};
        %level = graythresh(toThreshold);
        %T = MAX_proj_3D(toThreshold);
         [centers,radii] = imfindcircles(T,[RadiusMin,RadiusMax],'Sensitivity',Sensitivity);
         %subplot(133);imagesc(toThreshold); hold on
        %viscircles(centers, radii,'EdgeColor','k','EnhanceVisibility',true);
        
        for i = 1:length(centers)
        [x,y] = meshgrid(1:size(T,1),1:size(T,2));
        distance = (x-centers(i,1)).^2+(y-centers(i,2)).^2;
        mask(:,:,i) = (distance<radii(i)^2)*i;
        %imshow(mask)
        end
     TL = MAX_proj_3D(mask);
     %imagesc(Labelled)
        Stats_table = regionprops('table',TL,'Area','Centroid','SubarrayIdx');

end