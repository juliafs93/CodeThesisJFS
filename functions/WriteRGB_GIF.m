function[] = WriteRGB_GIF(im, PathToSave, Suffix,Delay)
[A,map] = rgb2ind(im{1},256);
imwrite(A,map, [PathToSave, Suffix],'gif','LoopCount',Inf,'DelayTime',Delay)
for f = 2:size(im,2)
    [A,map] = rgb2ind(im{f},256);
    imwrite(A,map, [PathToSave, Suffix],'gif','WriteMode','append','DelayTime',Delay)
end
end