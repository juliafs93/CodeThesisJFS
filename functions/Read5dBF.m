%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A]=  Read5dBF(LIF, Height,Width,Channels, Slices, Frames,From,To,Flip);
    num_images = Channels*Slices*Frames;   
    A = zeros(Height,Width,Channels,Slices,To-From);
    for f = From:To
        for z = 1:Slices
            for c = 1:Channels
                k = (f-1)*num_images/Frames + (z-1)*num_images/(Frames*Slices) + c;
                Im = double(LIF{k,1});
                if Flip(1) == 1
                    Im = flipud(Im);
                end 
                if Flip(2) == 1
                    Im = fliplr(Im);
                end
                A(:,:,c,z,f-From+1) = Im;  
            end
        end
    end
end