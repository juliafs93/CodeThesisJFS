function[F1_t F1_t_RGB Stats1t newLabel] = Tracknextframe3(Stats_new, Stats0, Stats1,F0_t,F1_0,F1_t,cmap,f,distance,newLabel)   
    %newLabel=max(Stats1.Label);
    try
                Stats_1 = struct2table(Stats_new{f-2});
                Stats_1.Label = (1:length(Stats_1.Area))';
                %toremove = table2array(Stats_1(:,'Area'))>500;
                %Stats_1(toremove,:)= [];
    end
    for x=[Stats1.Label]'
        %disp(['frame ',num2str(f-1),' to ',num2str(f),': nuclei #',num2str(x)])
        %[r, c] = find(F0_0==x);
        %subs = find(F0_0==x);
        %F0_t(sub2ind(size(F0_t),r,c))=x;
        %F0_t(subs)=x;
        %try
        index = find(Stats1.Label==x);
        eucledian = sqrt((Stats0.Centroid(:,1)-Stats1.Centroid(index,1)).^2.+(Stats0.Centroid(:,2)-Stats1.Centroid(index,2)).^2);
        closest_index = find(eucledian==min(eucledian));
        closest = Stats0.Label(closest_index);
        %catch
         %   eucledian = 20;
          %  disp(['Deleted object in frame ',num2str(f),'and nuclei #',num2str(x)])
        %end
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
            try
                eucledian = sqrt((Stats_1.Centroid(:,1)-Stats1.Centroid(index,1)).^2.+(Stats_1.Centroid(:,2)-Stats1.Centroid(index,2)).^2);
                closest_index = find(eucledian==min(eucledian));
                closest = Stats_1.Label(closest_index);
                subs = find(F1_0==x);
            end
            if min(eucledian)<distance % 5?
                subs = find(F1_0==x);
                F1_t(subs)=closest;
            else
                if newLabel ~= NaN;
                    subs = find(F1_0==x);
                    newLabel = newLabel+1;
                    F1_t(subs)=newLabel;
                end
            end
        end
    end
    %F1_t = bwmorph(F1_t,'bridge',1);
    Stats1t = regionprops(F1_t,'Area','Centroid','Perimeter','Image','SubarrayIdx');
    F1_t_RGB = label2rgb(F1_t, cmap, 'k', 'noshuffle');

end