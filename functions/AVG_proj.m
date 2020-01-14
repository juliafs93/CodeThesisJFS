function [avg_proj]= AVG_proj(A, StartF, EndF, StartZ,EndZ,Channel)
    %avg_proj = double(zeros(size(A,1), size(A,2),size(A,5)));
    for f = StartF:EndF;
        %for z = StartZ:EndZ
        %avg_proj(:,:,f) = avg_proj(:,:,f) + A(:,:,Channel, z, f);
        avg_proj(:,:,f) = sum(A(:,:,Channel,StartZ:EndZ,f),4)./(EndZ-StartZ);
        %end
        %avg_proj(:,:,f) = avg_proj(:,:,f)./(EndZ-StartZ);
    end
    avg_proj = avg_proj(:,:,StartF:EndF);
end