function[] = Write16b(toWrite, PathToSave, Suffix,Compression)
imwrite(uint16(toWrite(:,:,1)), [PathToSave, Suffix],'Compression','none')
for f = 2:size(toWrite,3)
    imwrite(uint16(toWrite(:,:,f)), [PathToSave, Suffix],'WriteMode','append','Compression',Compression)
end
end