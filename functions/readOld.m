function[RFP_FTL_tracked max_GFP] = readOld(Path,File,Name)
RFP_FTL_tracked = Read3d([Path,File,Name,File,'_segmented_tracked_16.tiff']);
max_GFP = Read3d([Path,File,Name,File,'_max_GFP.tiff']);

end