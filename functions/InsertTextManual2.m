function[Im,Fig] = InsertTextManual2(Fig,Im,PosXY,Text,FontSize,Grey)
    %PosXY = [50,10]; Text ='test'; FontSize = 14;Grey = 255;
    
    %Fig = figure('color','white','visible','off'); 
    Fig;image(ones(size(Im))); 
    set(gca,'units','pixels','position',[1 1 size(Im,2)./2 size(Im,1)./2])
    text('units','pixels','position',PosXY,'fontsize',FontSize,'string',Text) 
    Frame = getframe; 
    %close(Fig) 
    Frame = Frame.cdata;
    Mask = Frame==0; 
    Im(Mask) = uint8(Grey); 
    clf
end