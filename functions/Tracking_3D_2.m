function [] = Tracking_3D_2(FTL, Stats_table, cmap, distance,N,merge,show)
    Stats_new = Stats_table;
    %RFP_FTL_tracked = zeros(size(RFP_FTL));
    FTL_tracked_RGB = zeros(size(FTL,1),size(FTL,2),3,size(FTL,3));

    %RFP_FTL_tracked(:,:,:,1) = RFP_FTL(:,:,:,1);
    F0_t_RGB = label2rgb(max(FTL(:,:,:,1),[],3), cmap, 'k', 'noshuffle');
    FTL_tracked_RGB(:,:,:,1) = F0_t_RGB(:,:,:);
    newLabel=max(max(max(max(FTL(:,:,:,:)))))+1;

    for f=2:size(FTL,4)

        disp(['frame ',num2str(f-1),' to ',num2str(f)])
        %F0 = 1
        %F1 = 2
        F0_t = FTL(:,:,:,f-1);
        F1_0 = FTL(:,:,:,f);
        F1_t = zeros(size(FTL(:,:,:,f)));

        Stats0 = Stats_new{f-1,1};
        Stats1 = Stats_new{f,1};

        Stats0.Label = (1:size(Stats0,1))';
        toremove = table2array(Stats0(:,'Area'))>50000;
        Stats0(toremove,:)= [];

        Stats1.Label = (1:size(Stats1,1))';
        toremove = table2array(Stats1(:,'Area'))>50000;
        Stats1(toremove,:)= [];

        %x=1
        %[F1_t F1_t_RGB Stats1t] = Tracknextframe(Stats0, Stats1,F1_0,F1_t, cmap_shuffled,f,10);     
        %[F1_t F1_t_RGB Stats1t newLabel] = Tracknextframe2(Stats0, Stats1,F0_t,F1_0,F1_t, cmap_shuffled,f,30,newLabel);     
        %[F1_t F1_t_RGB Stats1t newLabel] = Tracknextframe3(Stats_new, Stats0, Stats1,F0_t,F1_0,F1_t, cmap_shuffled,f,30,newLabel);     
        %[F1_t F1_t_RGB Stats1t newLabel] = Tracknextframe4(Stats_new, Stats0, Stats1,F0_t,F1_0,F1_t, cmap_shuffled,f,20,newLabel,8); % for movie1    
        [F1_t F1_t_RGB Stats1t newLabel] = Tracknextframe4_3D(Stats_new, Stats0, Stats1,F0_t,F1_0,F1_t, cmap,f,distance,newLabel,N);  %for others   
        %FTL(:,:,:,f) = F1_t(:,:,:);
        Write16b(F1_t, '~/Temp/Tracked_',[num2str(f),'.tif'], 'none')
        FTL_tracked_RGB(:,:,:,f) = F1_t_RGB(:,:,:);
        Stats_new{f,1} = Stats1t;

    end
    if strcmp(merge,'on') == 1;
        [FTL FTL_tracked_RGB ] = MergeTracking_3D(FTL, Stats_new, cmap);
    end  
    if strcmp(show,'on')==1;
        FTL_tracked_max = MAX_proj_3D(FTL);
        D=zeros(size(FTL_tracked_max,1),size(FTL_tracked_max,2),1,size(FTL_tracked_max,3));
        D(:,:,1,:)=FTL_tracked_max(:,:,:);
        montage(D, [0 1]);
        D(:,:,1,:)=FTL_tracked_max(:,:,:)+1;
        mov = immovie(FTL_tracked_RGB);
        implay(mov)
    end

end