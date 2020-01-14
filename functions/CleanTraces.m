function[E,L,todel] = CleanTraces(E,L,MinN,ToSave, Plot)
        A = vertcat(E,L);
        todel = [];
        for i = 1:size(A,2)
            if sum(A(:,i)~=0 & isnan(A(:,i)) ==0) <= MinN % sum of frames different than NA or 0. at least 50
                todel = [todel,i];
            end
        end
        A(:,todel) = [];
        if Plot
            All = figure('PaperSize',[35 20],'PaperUnits','inches','resize','on','visible','off');
            for i = 1:size(A,2)
                subplot(round(size(A,2)/10)+1,10,i)
                plot(A(:,i)); xlim([0,size(A,1)]); ylim([0,4095]);axis off
            end
            Split = strsplit(ToSave,'/'); 
            %figure(All); 
            suptitle(Split(end));
            %plot(A); hold on; plot(nanmean(A,2),'*r');
            print(All,[ToSave,'_selected.pdf'],'-fillpage', '-dpdf');
        end
        E = A(1:size(E,1),:);
        L = A((1:size(L,1))+size(E,1),:);
end