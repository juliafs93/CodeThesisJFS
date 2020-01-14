function[F1_t F1_t_RGB Stats1t] = Tracknextframe(Stats0, Stats1,F1_0,F1_t,cmap,f,distance)   
    for x=[Stats0.Label]'
        %disp(['frame ',num2str(f-1),' to ',num2str(f),': nuclei #',num2str(x)])
        %[r, c] = find(F0_0==x);
        %subs = find(F0_0==x);
        %F0_t(sub2ind(size(F0_t),r,c))=x;
        %F0_t(subs)=x;
        %try
        index = find(Stats0.Label==x);
        eucledian = sqrt((Stats0.Centroid(index,1)-Stats1.Centroid(:,1)).^2+(Stats0.Centroid(index,2)-Stats1.Centroid(:,2)).^2);
        closest_index = find(eucledian==min(eucledian));
        closest = Stats1.Label(closest_index);
        %disp(min(eucledian));
        %catch
         %   eucledian = 20;
          %  disp(['Deleted object in frame ',num2str(f),'and nuclei #',num2str(x)])
        %end
        %prueba1(x,:)
        %prueba2(closest,:)
        %min(eucledian)
        %closest
        if min(eucledian)<distance % 5?
            %[r, c] = find(F1_0==closest);
            subs = find(F1_0==closest);
            %F1_t(sub2ind(size(F1_t),r,c))=x;
            F1_t(subs)=x;
        else
            disp(['Too far distance in frame ',num2str(f),' and nuclei #',num2str(x)])
        end
    end
    Stats1t = regionprops(F1_t,'Area','Centroid','Perimeter');
    F1_t_RGB = label2rgb(F1_t, cmap, 'k', 'noshuffle');

end