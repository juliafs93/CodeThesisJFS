function[F1_t F1_t_RGB Stats_new newLabel] = Tracknextframe4_3D(Stats_new,F1_0,F1_t,cmap,f,distance,newLabel,N,XYRes, ZRes) 
        N = size(Stats_new,1)-1;
        Stats0 = Stats_new{N,1};
        Stats1 = Stats_new{N+1,1};

        Stats0.Label = (1:size(Stats0,1))';
        toremove = table2array(Stats0(:,'Area'))>50000;
        Stats0(toremove,:)= [];

        Stats1.Label = (1:size(Stats1,1))';
        toremove = table2array(Stats1(:,'Area'))>50000;
        Stats1(toremove,:)= [];
%newLabel=max(Stats1.Label);
    for x=[Stats1.Label]'
        %disp(['frame ',num2str(f-1),' to ',num2str(f),': nuclei #',num2str(x)])
        %[r, c] = find(F0_0==x);
        %subs = find(F0_0==x);
        %F0_t(sub2ind(size(F0_t),r,c))=x;
        %F0_t(subs)=x;
        try
            index = find(Stats1.Label==x);
            eucledian = sqrt(((Stats0.Centroid(:,1)-Stats1.Centroid(index,1)).*XYRes).^2.+((Stats0.Centroid(:,2)-Stats1.Centroid(index,2)).*XYRes).^2.+((Stats0.Centroid(:,3)-Stats1.Centroid(index,3)).*ZRes).^2);
            closest_index = find(eucledian==min(eucledian));
            closest = Stats0.Label(closest_index);
        catch
            eucledian = 100;
            disp(['Frame ',num2str(f-1),' has no objects'])
        end
        %prueba1(x,:)
        %prueba2(closest,:)
        %min(eucledian)
        %closest
        newNuc=zeros(size(F1_t));
        if min(eucledian)<distance % 5?
            %[r, c] = find(F1_0==closest);
            subs = find(F1_0==x);
            %F1_t(sub2ind(size(F1_t),r,c))=x;
            F1_t(subs)=closest;
        else
            n = 2;
            skip = false;
            while n <= N & skip == false;
                try
                    disp(['trying N',num2str(n)])
                    %Stats_1 = Stats_new{f-n,1};
                    Stats_1 = Stats_new{N-n+1,1};
                    Stats_1.Label = (1:size(Stats_1,1))';
                    toremove = table2array(Stats_1(:,'Area'))>5000;
                    Stats_1(toremove,:)= [];
                    eucledian = sqrt(((Stats_1.Centroid(:,1)-Stats1.Centroid(index,1)).*XYRes).^2.+((Stats_1.Centroid(:,2)-Stats1.Centroid(index,2)).*XYRes).^2.+((Stats_1.Centroid(:,3)-Stats1.Centroid(index,3)).*ZRes).^2);
                    closest_index = find(eucledian==min(eucledian));
                    closest = Stats_1.Label(closest_index);
                    subs = find(F1_0==x);
                end
                if min(eucledian)<distance % 5?
                    subs = find(F1_0==x);
                    F1_t(subs)=closest;
                    skip = true;
                    break
                else
                    n=n+1;
                end
            end
            if newLabel ~= NaN & skip == false;
                subs = find(F1_0==x);
                newLabel = newLabel+1;
                F1_t(subs)=newLabel;
                disp(['newLabel because min = ',num2str(min(eucledian)), 'in f',num2str(f),', nuc',num2str(x)]);
            end
        end
    end
    %F1_t = bwmorph(F1_t,'bridge',1);
    Stats_new{N+1,1} = regionprops('table',F1_t,'Area','Centroid','Image','SubarrayIdx');
    %F1_t_RGB = label2rgb(F1_t, cmap, 'k', 'noshuffle');
    F1_t_RGB = label2rgb(max(F1_t(:,:,:),[],3), cmap, 'k', 'noshuffle');
    %Stats_new{size(Stats_new,1),1} = Stats1t;
end