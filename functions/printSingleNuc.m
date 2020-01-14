function[MaxF MinD2 X Y] = printSingleNuc(NucNum, NucName,PathToSave,Width, Height, Frames,Stats_GFP,max_G,meanF,max_R,trackB,Midline,XYRes,TimeRes,TimeScale)
    disp(NucName)
    BW = zeros(25,25,Frames);
    mF = zeros(25,25,Frames);
    Red = zeros(25,25,Frames);
    Boundary = zeros(25,25,3,Frames);
    MergedAll = zeros(25,50,3,Frames);
    
    for f=1:Frames
        MidlineF(:) = Midline(:,f);
        for L = 1:size(MidlineF,2)
            try
                C = MidlineF{1,L};
                MidlineX(f,L) = C(2);
                MidlineY(f,L) = C(1);
            end
        end
        try
            Centroid = Stats_GFP{f,1}.Centroid(ismember(Stats_GFP{f,1}.Label,NucNum(:),'rows'),:);
            X(f) = round(Centroid(1));
            Y(f) = round(Centroid(2));
            ListX = [X(f)-12:X(f)+12];
            ListY = [Y(f)-12:Y(f)+12];
            BW(:,:,f) = max_G(ListY,ListX,f);
            mF(:,:,f) = meanF(ListY,ListX,f);
            Red(:,:,f) = max_R(ListY,ListX,f);
            Boundary(:,:,:,f) = trackB(ListY,ListX,:,f);
        end
        MidlineX(MidlineX == 0) = NaN;
        MidlineY(MidlineY == 0) = NaN;

    end
    
    
    %
    MaxF=[];
    MinD1=[];
    MinD2=[];
    Merged = (BW./16+mF);
    MergedH = Merge8bRGB(Red./16, Boundary,'off');
    RGB = zeros(size(Merged,1),size(Merged,2),3,size(Merged,3));
    
    figure; % new figure
    ax1 = subplot(3,1,1); % top subplot
    axis off
    ax2 = subplot(3,1,2); hold on;
    set(ax2,'xaxislocation','bottom','yaxislocation','left');
    ax3 = subplot(3,1,3); % bottom subplothold on;
    axis(ax3,[0 Width 0 Height]);
    set(ax3,'xaxislocation','top','yaxislocation','left','ydir','reverse','YTick',[],'XTick',[],'Yticklabel',[],'Xticklabel',[]);
    for f=1:size(Merged,3)
        RGB(:,:,1,f)=Merged(:,:,f);
        RGB(:,:,2,f)=Merged(:,:,f);
        RGB(:,:,3,f)=Merged(:,:,f);
        MergedAll(:,1:25,:,f) = RGB(:,:,:,f);
        MergedAll(:,26:50,:,f) = MergedH(:,:,:,f);
        I = mat2gray(MergedAll(:,:,:,f));
        [Im,map] = gray2ind(I,256);
        try
        subplot(3,1,1);imshow(Im,map);
        plot(ax3,MidlineY(f,:),MidlineX(f,:),'.k','MarkerSize',10);
        hold(ax3,'on')
        idx = isnan(MidlineX(f,:)') | isnan(MidlineY(f,:)');
        %fitobject1 = fit(MidlineY(f,~idx)',MidlineX(f,~idx)','poly1');
        fitobject2 = fit(MidlineY(f,~idx)',MidlineX(f,~idx)','poly2');
        %fplot(ax3,@(x) fitobject1.p1*x+fitobject1.p2,[0 800],'k');
        fplot(ax3,@(x) fitobject2.p1.*x.^2+fitobject2.p2.*x+fitobject2.p3,[0 800],'k');
        axis(ax3,[0 Width 0 Height]);
        set(ax3,'xaxislocation','top','yaxislocation','left','ydir','reverse','YTick',[],'XTick',[],'Yticklabel',[],'Xticklabel',[]);
        end
        try
        MaxF(f) = Stats_GFP{f,1}.Max(ismember(Stats_GFP{f,1}.Label,NucNum(:),'rows'),:);
        %MinD1(f) = (fitobject1.p1*Y(f) - X(f) + fitobject1.p2)/sqrt(fitobject1.p1^2+1);
        MinD2(f) = -Y(f) + (X(f)^2*fitobject2.p1+X(f)*fitobject2.p2+fitobject2.p3);
        yyaxis(ax2,'right')
        %plot(ax2,MinD1,'LineStyle','-','Marker','.','MarkerSize',2);
        plot(ax2,TimeScale(1:length(MinD2)),MinD2*XYRes,'LineStyle','-','Marker','.','MarkerSize',2);
        line(ax2,TimeScale,TimeScale*0,'LineStyle','--');
        ylim(ax2,[-20 20])
        xlim(ax2,[0 Frames].*TimeRes./60')
        ylabel(ax2,'Distance to midline (um)')
        xlabel(ax2,'Time (min)')
        %set(ax2,'Xticklabel',[0:Frames].*TimeRes./60);
        hold(ax2,'on')
        yyaxis(ax2,'left')
        plot(ax2,TimeScale(1:length(MaxF)),MaxF,'LineStyle','-','Marker','.','MarkerSize',5);
        ylim(ax2,[0 4095]);
        xlim(ax2,[0 Frames].*TimeRes./60');
        %set(ax2,'Xticklabel',[0:Frames].*TimeRes./60');
        ylabel(ax2,'Max Fluorescence (AU)')
        xlabel(ax2,'Time (min)')
        hold(ax2,'off')
        plot(ax3,X(f),Y(f),'.r','MarkerSize',10);
        axis(ax3,[0 Width 0 Height]);
        set(ax3,'xaxislocation','top','yaxislocation','left','ydir','reverse','YTick',[],'XTick',[],'Yticklabel',[],'Xticklabel',[]);
        end
        hold(ax3,'off');
        %set(gcf,'units','pixels','Resize','off','visible',Visible,'position',[0 0 1120*Factor 840*Factor]);
        F(f)=getframe(gcf);
        im{f}= frame2im(F(f)); 
    end
    MaxF = MaxF';
    MinD2 = MinD2';
    WriteRGB(MergedAll, PathToSave, [NucName,'.tiff'],'none')
    WriteRGB_GIF(im, PathToSave, [NucName,'_plot.gif'], 0.1)
    

end