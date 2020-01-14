function[Stats_new,RFP_FTL,RFP_FTL_tracked, newLabel] = TrackwDivisions(Stats_new,RFP_FTL,RFP_FTL_tracked,f,Distance,newLabel,N,Fill,Divisions)   
    %newLabel=max(Stats1.Label);
    F0_t = RFP_FTL_tracked(:,:,f-1);
    F1_0 = RFP_FTL(:,:,f);
    F1_t = zeros(size(RFP_FTL_tracked(:,:,f)));

    Stats0 = Stats_new{f-1,1};
    %Stats0.Parent = zeros(size(Stats0,1),1);
    %Stats0.Daughters = zeros(size(Stats0,1),2);
    Stats1 = Stats_new{f,1};
    Stats1t = Stats_new{f,1};
    Stats1t.Parent = zeros(size(Stats1t,1),1);
    Stats1t.Daughters = zeros(size(Stats1t,1),2);

    Stats0.Label = (1:size(Stats0,1))';
    Stats1t.Label = (1:size(Stats1t,1))';
    for x=[Stats1t.Label]'
    %for  x=[1:60]
        %disp(['frame ',num2str(f-1),' to ',num2str(f),': nuclei #',num2str(x)])
        %[r, c] = find(F0_0==x);
        %subs = find(F0_0==x);
        %F0_t(sub2ind(size(F0_t),r,c))=x;
        %F0_t(subs)=x;
        try
            index = find(Stats1t.Label==x);
            eucledian = sqrt((Stats0.Centroid(:,1)-Stats1t.Centroid(index,1)).^2.+(Stats0.Centroid(:,2)-Stats1t.Centroid(index,2)).^2);
            closest_index = find(eucledian==min(eucledian));
            closest = Stats0.Label(closest_index);
            if length(closest_index)>1
                    closest_index = closest_index(1);
                    closest = closest(1);
            end
        catch
            eucledian = 100;
            disp(['Frame ',num2str(f),' has no objects'])
        end
        %prueba1(x,:)
        %prueba2(closest,:)
        %min(eucledian)
        %closest
        %newNuc=zeros(size(F1_t));
        if min(eucledian)<Distance % 5?
            if Divisions==true
            [F1_t,Stats0,Stats1t,newLabel] = CheckSisters(F1_0,F1_t,x,closest,closest_index,Stats0,Stats1t,newLabel,f);
            else
                subs = find(F1_0==x);
                F1_t(subs)=closest;
            end
        else
            n = 2;
            skip = false;
            while n <= N & skip == false;
                try
                    disp(['trying N',num2str(n)])
                    Stats_1 = Stats_new{f-n,1};
                    Stats_1.Label = (1:size(Stats_1,1))';
                    eucledian = sqrt((Stats_1.Centroid(:,1)-Stats1t.Centroid(index,1)).^2.+(Stats_1.Centroid(:,2)-Stats1t.Centroid(index,2)).^2);
                    closest_index = find(eucledian==min(eucledian));
                    closest = Stats_1.Label(closest_index);
                    if length(closest_index)>1
                        closest_index = closest_index(1);
                        closest = closest(1);
                    end
                end
                if min(eucledian)<Distance % 5?
                    if Divisions==true
                        [F1_t,Stats_1,Stats1t,newLabel] = CheckSisters(F1_0,F1_t,x,closest,closest_index,Stats_1,Stats1t,newLabel,f);
                        Stats_new{f-n,1} = Stats_1;
                    else
                        subs = find(F1_0==x);
                        F1_t(subs)=closest;
                    end    
                    skip = true;
                    if Fill==true
                        for m = [1:(n-1)]
                            newsubs = find(RFP_FTL_tracked(:,:,f-n)==closest);
                            TemporaryF1_t = RFP_FTL_tracked(:,:,f-m);
                            TemporaryF1_t(newsubs)=closest;
                            RFP_FTL_tracked(:,:,f-m)=TemporaryF1_t(:,:);
                            TemporaryStats = Stats_new{f-m,1};
                            if isempty(TemporaryStats)==1
                                TemporaryStats = Stats_1(closest_index,1:(size(Stats_1,2)-1));
                                TemporaryStats(1,:)=table(0,[NaN,NaN],0);
                            end
                            TemporaryStats(closest_index,:)=Stats_1(closest_index,1:(size(Stats_1,2)-1));
                            Stats_new{f-m,1}=TemporaryStats(:,:);
                            %disp(['done replacing N',num2str(m), 'nuc',num2str(x),'/',num2str(closest)]);
                            %Stats_new{f-m,1} = regionprops('table',TemporaryF1_t,'Area','Centroid','Perimeter','Image','SubarrayIdx');
                        end
                    end    
                    %break
                else
                    n=n+1;
                end
            end
            if newLabel ~= NaN & skip == false;
                subs = find(F1_0==x);
                newLabel = newLabel+1;
                F1_t(subs)=newLabel;
                Temp=Stats1t(x,:);
                Stats1t{x,:}= NaN;
                Stats1t(newLabel,:)=Temp;
                Stats1t{newLabel,'Label'}=newLabel;
                disp(['newLabel because min = ',num2str(min(eucledian)), 'in f',num2str(f),', nuc',num2str(x)]);
            end
        end
    end
    %F1_t = bwmorph(F1_t,'bridge',1);
    if Divisions==true
        Stats_new{f-1,1} = Stats0;
        Stats_new{f,1} = Stats1t;
    else
        Stats_new{f,1} = regionprops('table',F1_t,'Area','Centroid','Perimeter');
    end
    RFP_FTL_tracked(:,:,f) = F1_t(:,:);
    %imagesc(F1_t);
    %RFP_FTL_tracked_RGB(:,:,:,f) = F1_t_RGB(:,:,:);

end