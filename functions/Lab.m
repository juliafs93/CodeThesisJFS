function [T_L T_L_RGB Stats] = Lab(TfarO,Thicken)
    TfarT = bwmorph(TfarO, 'thicken',Thicken);
    [T_L dummy]= bwlabel(TfarT,4); %from segmented to labeled image, assigns color to cell
    Stats = regionprops('table',T_L,'Area','Centroid','Perimeter');
    T_L_RGB = label2rgb(T_L, 'jet', 'k', 'shuffle');

end