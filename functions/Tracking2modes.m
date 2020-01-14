function [RFP_FTL_tracked,RFP_FTL_tracked_RGB,Stats_new] = Tracking2modes(RFP_FTL, Stats_table,Function, cmap, distance1,distance2,N1,N2,From,To,merge,split,Fill,Divisions,XYRes,show)
    Stats_new = Stats_table;
    RFP_FTL_tracked = zeros(size(RFP_FTL));
    RFP_FTL_tracked_RGB = zeros(size(RFP_FTL_tracked,1),size(RFP_FTL_tracked,2),3,size(RFP_FTL_tracked,3));

    RFP_FTL_tracked(:,:,From) = RFP_FTL(:,:,From);
    F0_t_RGB = label2rgb(RFP_FTL(:,:,From), cmap, 'k', 'noshuffle');
    RFP_FTL_tracked_RGB(:,:,:,From) = F0_t_RGB(:,:,:);
    Stats0 = Stats_new{From,1};
    Stats0.Parent = zeros(size(Stats0,1),1);
    Stats0.Daughters = zeros(size(Stats0,1),2);
    Stats_new{1,1}=Stats0;
    newLabel=max(max(max(RFP_FTL(:,:,:))))+1;
    for f=(From+1):To
        disp(['frame ',num2str(f-1),' to ',num2str(f)])
        if f<=split
        [Stats_new,RFP_FTL,RFP_FTL_tracked, newLabel] = Function(Stats_new,RFP_FTL,RFP_FTL_tracked,f,distance1,newLabel,N1,false,Divisions, XYRes);  %for others   
        else
        [Stats_new,RFP_FTL,RFP_FTL_tracked, newLabel] = Function(Stats_new,RFP_FTL,RFP_FTL_tracked,f,distance2,newLabel,N2,Fill,Divisions,XYRes);  %for others   
        end
        
    end
    for f=2:size(RFP_FTL,3)
        RFP_FTL_tracked_RGB(:,:,:,f) = label2rgb(RFP_FTL_tracked(:,:,f), cmap, 'k', 'noshuffle');
    end
    if strcmp(merge,'on') == 1;
        [RFP_FTL_tracked RFP_FTL_tracked_RGB ] = MergeTracking(RFP_FTL_tracked, Stats_new, cmap);
    end  
    if strcmp(show,'on')==1;
        D=zeros(size(RFP_FTL_tracked,1),size(RFP_FTL_tracked,2),1,size(RFP_FTL_tracked,3));
        D(:,:,1,:)=RFP_FTL_tracked(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=RFP_FTL_tracked(:,:,:)+1;
        mov = immovie(RFP_FTL_tracked_RGB);
        implay(mov)
    end

end