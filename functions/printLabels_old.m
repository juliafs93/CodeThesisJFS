function[RFP_FTL_tracked_RGB_info F] = printLabels(ToShowRGB,Stats_new, show)
    %RFP_FTL can be labelled in colors (RGB), 8/16 bits or mod with F
    %levels (RFP_FTL_tracked_meanF)
    RFP_FTL_tracked_RGB_info = zeros(size(ToShowRGB,1)*2,size(ToShowRGB,2)*2,size(ToShowRGB,3),size(ToShowRGB,4));
    F(size(ToShowRGB,4)) = struct('cdata',[],'colormap',[]);
    set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse','XTickLabel','','YTickLabel','');
    set(gcf,'units','pixels','Resize','off','visible','off','position',[0 0 size(ToShowRGB(:,:,1),2) size(ToShowRGB(:,:,1),1)],'Renderer', 'Zbuffer');
    for f=1:size(ToShowRGB,4)
    %for f=1:10
        disp(['frame ',num2str(f)])
        %Stats_new{f,1}.Label = (1:size(Stats_new{f,1},1))';
        fig1=gcf; axis([0 size(ToShowRGB(:,:,1),2) 0 size(ToShowRGB(:,:,1),1)]);hold off;
        I = mat2gray(ToShowRGB(:,:,:,f));
        [X,map] = gray2ind(I,256);
        h=imshow(X,map); hold on;
        try
            h=plot(Stats_new{f,1}.Centroid(:,1),Stats_new{f,1}.Centroid(:,2),'.'); 
            h=text(Stats_new{f,1}.Centroid(:,1),Stats_new{f,1}.Centroid(:,2),num2str(Stats_new{f,1}.Label), 'FontSize',6,'color','white'); 
        end
        set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse','XTickLabel','','YTickLabel','');
        set(gcf,'units','pixels','Resize','off','visible','off','position',[0 0 size(ToShowRGB(:,:,1),2) size(ToShowRGB(:,:,1),1)]);
        F(f)=getframe(fig1);
        RFP_FTL_tracked_RGB_info(:,:,:,f) = frame2im(F(f)); 
    end
    close all
    if strcmp(show,'on')==1;
        fig=figure; axis off;
        set(gcf,'units','pixels')
        movie(F);
    end
end