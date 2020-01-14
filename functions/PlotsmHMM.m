function[] = PlotsmHMM(OutPath,ExpLabels,Nicknames, hmm_results, glb_all,w,Tres,alpha,K,t_window,inference_times)
%%
id_string =  ['/w' num2str(w) '_t' num2str(Tres)...
    '_alpha' num2str(round(alpha*10)) '/K' num2str(K) '_tw' num2str(t_window/60) '/'];

TimeScale = [(inference_times - t_window./2):Tres:(inference_times + t_window./2)]/60;%

Ncol = 3;
Nrow = 8;
    Fig1 = figure('PaperSize',[20 40],'PaperUnits','inches','resize','on', 'visible','off');
    Fig1.Renderer='Painters';
    set(Fig1,'defaultAxesColorOrder',[0,0,0;0.7,0.7,0.7]);
    
% Make alpha correction kernel
alpha_kernel = [];
times = 0:Tres:w*Tres;
for n = 1:w
    t1 = times(n);
    t2 = times(n+1);
    alpha_kernel = [alpha_kernel ms2_loading_coeff_integral(alpha, w, Tres, t1, t2)];
end
alpha_kernel = fliplr(alpha_kernel)/Tres;
alpha_mat = repmat(alpha_kernel,K,1)';


for g = 1:length(glb_all)
    Source = glb_all(g).source; Split = strsplit(Source,'.'); Source = Split{1};
    TotalPlots = length(glb_all(g).fluo_data);
    PromoterPaths = glb_all(g).soft_struct.p_z_log_soft;
    Fluorescences = glb_all(g).fluo_data;
    ParticleIDs =  glb_all(g).particle_ids;
    for n = 1:(floor(TotalPlots/(Ncol*Nrow))+1)
        Fig1 = figure('PaperSize',[20 40],'PaperUnits','inches','resize','on', 'visible','off');
        Fig1.Renderer='Painters';
        set(Fig1,'defaultAxesColorOrder',[0,0,0;0.7,0.7,0.7]);
        disp([num2str(n),'/',num2str((floor(TotalPlots/(Ncol*Nrow))+1)),', ',num2str(g),'/',num2str(length(glb_all)),' boots'])
        i = 1;
        while i <= (Ncol*Nrow) & (n-1)*Ncol*Nrow + i <= TotalPlots
            p = (n-1)*Ncol*Nrow + i;
            promoter_path = exp(PromoterPaths{p})';
            fluo = Fluorescences{p}';
            f_ct = zeros(size(promoter_path,1),K);
             for j = w+1:size(promoter_path,1)
                  f_ct(j,:) = sum(promoter_path(max(1,j-w+1):j,:).*alpha_mat(max(1,w-j+1):end,:));
             end  
            subplot(Nrow,Ncol,i)
            yyaxis right
            stairs(TimeScale(1:length(promoter_path)),promoter_path(:,2)*(K-1),'-','LineWidth',0.75,'Color',[0.7,0.7,0.7]); hold on
            ylim([0,K-1])
            yyaxis left
            plot(TimeScale(1:length(fluo)),fluo,'-b','LineWidth',1);
            plot(TimeScale(1:length(f_ct)),f_ct(:,2).*300,'-r','LineWidth',1)
            title(['Particle #', num2str(ParticleIDs(p))])
            ylim([0,4095])
            hold off
            i = i+1;
        end
        if n==1
          print(Fig1,[OutPath,id_string,'out/',Source,'.ps'],'-fillpage', '-dpsc');
        else
          print(Fig1,[OutPath,id_string,'out/',Source,'.ps'],'-fillpage', '-dpsc','-append');
        end
    end
end
close all


%% split by time vector
% initiation rate
% subplot(231);errorbar(repmat([hmm_results.t_inf],2,1),[hmm_results.initiation_mean],[hmm_results.initiation_std],[hmm_results.initiation_std],'.')
% title('initiation rate')
% % noise
% %errorbar([hmm_results.t_inf],[hmm_results.noise_mean],[hmm_results.noise_std],[hmm_results.noise_std],'.')
% % occupancy
% subplot(232);errorbar(repmat([hmm_results.t_inf],2,1),[hmm_results.occupancy_mean],[hmm_results.occupancy_std],[hmm_results.occupancy_std],'.')
% title('occupancy')
% 
% % dwell
% subplot(233);errorbar(repmat([hmm_results.t_inf],2,1),[hmm_results.dwell_mean],[hmm_results.dwell_std],[hmm_results.dwell_std],'.')
% title('dwell time')

%
    Fig = figure('PaperSize',[20 20],'PaperUnits','inches','resize','on', 'visible','on');


% split by AP bins
% initiation rate
subplot(234);errorbar(repmat([hmm_results.binID],K,1),[hmm_results.initiation_mean],[hmm_results.initiation_std],[hmm_results.initiation_std],'.')
title('initiation rate')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)
% noise
%errorbar([hmm_results.t_inf],[hmm_results.noise_mean],[hmm_results.noise_std],[hmm_results.noise_std],'.')
% occupancy
subplot(235);errorbar(repmat([hmm_results.binID],K,1),[hmm_results.occupancy_mean],[hmm_results.occupancy_std],[hmm_results.occupancy_std],'.')
title('occupancy')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)

% dwell
subplot(236);errorbar(repmat([hmm_results.binID],K,1),[hmm_results.dwell_mean],[hmm_results.dwell_std],[hmm_results.dwell_std],'.')
title('dwell time')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)

% on ratio
subplot(232);errorbar([hmm_results.binID],[hmm_results.eff_on_rate],[hmm_results.eff_on_ste],[hmm_results.eff_on_ste],'.')
title('on rate')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)

subplot(233);errorbar([hmm_results.binID],[hmm_results.eff_off_rate],[hmm_results.eff_off_ste],[hmm_results.eff_off_ste],'.')
title('off rate')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)

subplot(231);errorbar([hmm_results.binID],[hmm_results.eff_init_rate],[hmm_results.eff_init_ste],[hmm_results.eff_init_ste],'.')
title('init rate')
xticks([1:1:length(Nicknames)])
xticklabels(ExpLabels)

print(Fig,[OutPath,id_string,cell2mat(join(ExpLabels,'_vs_')),'.pdf'],'-fillpage','-dpdf');

end