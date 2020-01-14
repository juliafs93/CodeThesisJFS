function[MaxHeight] = MeasureMembranes(RXZT,Bits)
    for f = 1:size(RXZT,3)
        disp(f)
        Width = size(RXZT,2);
        Height = size(RXZT,1);
        O = RXZT(:,round(max(1,Width*0)):round(Width*1),f);
        G = imgaussfilt(O,1)./(2^(Bits-1));
        Thres = graythresh(G);
        B = G>Thres;
        Bt = bwmorph(B,'thicken',3);
        Bo = bwmorph(Bt,'open',3);
        Bd = bwmorph(Bo,'bridge',3);
        Btod = imfill(Bd,'holes');
        Table = regionprops(Btod,'FilledImage','BoundingBox','Area'); 
        [~,Biggest] = max([Table.Area]);
        if isnan(Biggest)==0
            F = Table(Biggest).FilledImage;
            BB = Table(Biggest).BoundingBox;
        end
        figure('Position',[50,50,1500,250])
        subplot(131);imagesc(O);
        subplot(132);imagesc(Btod)
        subplot(133);imagesc(F)
                %pause(0.5)
         answer = 'No';
         while strcmp(answer,'Yes') ~= 1
            imagesc(O); hold on; plot([1:Width],BB(4),'.w');plot([1:Width],BB(2),'.w');
            answer = questdlg('OK? (No to draw, Cancel to set MembLengh = Height)');
            if strcmp(answer,'Yes') == 1
                break
            elseif strcmp(answer,'No') == 1
                [X,Y] = ginput(1);
                BB(4) = Y;
            elseif strcmp(answer,'Cancel') == 1
                BB(4) = Height;
                break
            end
         end
         MaxHeight(f) = BB(4)-BB(2);
         close all


    end
    plot(MaxHeight)


end