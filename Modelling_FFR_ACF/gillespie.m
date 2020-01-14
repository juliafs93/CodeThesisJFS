
%%
clear all
A = [1,1,1,1,2,2,2,2,3,3,3,3,1,1,2,2,3,3];
B = [0.15,0.15,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.15,0.15,0.3,0.3,0.3,0.3];
C = [0.05,0.05,0.01,0.01,0.1,0.1,0.01,0.01,0.1,0.1,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];
D = [0.05,0.5,0.05,0.1,0.15,1,0.5,0.1,0.15,1,0.05,0.1,0.02,0.05,0.02,0.05,0.02,0.05];
show = 'off'
%% for alpha=3
A = [1,1,1,1,2,2,2,2,3,3,3,3,1,1,2,2,3,3];
B = [0.15,0.15,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.15,0.15,0.3,0.3,0.3,0.3];
C = [0.05,0.05,0.01,0.01,0.1,0.1,0.01,0.01,0.1,0.1,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];
D = [0.05,0.5,0.05,0.1,0.5,1,0.5,0.1,0.5,1,0.05,0.1,0.05,0.1,0.05,0.1,0.5,0.1];
show = 'off'
%% only alpha1, effect of gene length
clear all
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/CompLength/';
A = [1,1,1,1,1,1,1,1,1,1,1,1]*4;
B = [0.1,0.1,0.2,0.2,0.3,0.3,0.1,0.1,0.2,0.2,0.3,0.3];
C = [0.01,0.01,0.01,0.01,0.01,0.01,0.1,0.1,0.1,0.1,0.1,0.1];
D = [0.02,0.05,0.02,0.05,0.02,0.05,0.2,0.5,0.2,0.5,0.2,0.5];
Nreps = 200;
L = 3; %0.1,1,3,5 kb
show = 'off'
%%
clear all
A = [1,1,2,2,3,3];
B = [0.15,0.15,0.3,0.3,0.3,0.3];
C = [0.01,0.01,0.01,0.01,0.01,0.01];
D = [0.02,0.05,0.02,0.05,0.02,0.05,];

%%
clear all
A = [4,4,4,4,4,4,4,4]
B = [0.3, 0.3, 0.3, 0.3, 0.5,0.5,0.5,0.5]
C = [0.01,0.01,0.1,0.1,0.01,0.01,0.1,0.1]
D = [0.02,0.05,0.15,0.5,0.02,0.05,0.15,0.5]
show = 'off'
%%
SimulationAll = []; ExpectedAll = []; SimulationSDAll = [];
%%
%clear all
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/AllValues_Boots_Instant/';
mkdir(PathToSave)
%clear all
Background = 0; FRAP = 1;
show = 'off'
Nreps = 200;
L = 5; %0.1,1,3,5 kb
Alpha = 2;
Cumulative = 0;
Mod = 1
A = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1].*Mod;
B = [0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3,0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]
C = [0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]
D = [0.11,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,1]
%%
%% test background
%clear all
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/AllValues_BG-3/';
mkdir(PathToSave)
%clear all
show = 'off'
Nreps = 200;
L = 5; %0.1,1,3,5 kb
Alpha = 3;
Background = -3; FRAP = 0;
A = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1].*3;
B = [0.3,0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3,0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]
C = [0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]./2
D = [0.055,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.85,0.9,0.95,1]
%%
%% compare instant/cumulative
clear all
A = [1,2,3,4];
B = [0.3,0.3,0.3,0.3];
C = [0.01,0.01,0.01,0.01,];
D = [0.02, 0.02, 0.02, 0.02];
show = 'off'
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/CompIC/';
Nreps = 200;
L = 5; %0.1,1,3,5 kb
show = 'off'
Cumulative = 0
Background = 0;
FRAP = 0;
Alpha = 2;
%% compare elongR alpha
clear all
A = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1].*4;
B = [0.3,0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]
C = [0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]./10
D = [0.055,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5]./5
show = 'off'
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/CompElongR/';
Nreps = 200;
L = 5; %0.1,1,3,5 kb
show = 'off'
Cumulative = 0
Background = 0;
FRAP = 0;
Alpha = 4;
%% TEST FRAP
%clear all
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/FRAP_simulations/';
mkdir(PathToSave)
%clear all
show = 'off'
Nreps = 1000;
L = 5; %0.1,1,3,5 kb
Alpha = 2;
A = [1,1,2,2,3,3,4,4];
B = [0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3];
C = [0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];
D = [0.02, 0.05,0.02, 0.05,0.02, 0.05,0.02, 0.05];
FRAP = 1
%% TEST number reps
%clear all
PathToSave = '/Users/julia/Google Drive jf565/Gillespie/number_simulations/';
mkdir(PathToSave)
%clear all
show = 'off'
Nreps = 500;
L = 5; %0.1,1,3,5 kb
Alpha = 2;
A = [1,1,2,2,3,3,4,4];
B = [0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3];
C = [0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];
D = [0.02, 0.05,0.02, 0.05,0.02, 0.05,0.02, 0.05];
FRAP = 0
Cumulative = 1
Background = 0;


%% same to compare autocorr
clear all
A = [1,1,1,1,2,2,2,2,3,3,3,3];
B = [0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3,0.3];
C = [0.001,0.005,0.01,0.1,0.001,0.005,0.01,0.1,0.001,0.005,0.01,0.1];
D = C*2;
show = 'off'
Test = 'CompAC_C0_miniAC'
PathToSave = ['/Users/julia/Google Drive jf565/Gillespie/',Test,'/'];
Nreps = 200;
L = 5; %0.1,1,3,5 kb
show = 'off'
Cumulative = 0
Background = 0;
FRAP = 0;
Alpha = 2;


%% compare all multiple Kon
clear all
Mode = 2;
C = [repmat(0.01,1,11),repmat(0.1,1,11),repmat(0.5,1,11)];
D = repmat([0.01:0.1:1.01],1,3); D(1) = 0.02
A = repmat(1,1,length(D)).*Mode;
B = repmat(0.3,1,length(D));
show = 'off'
Test = 'AllValues_C0_FFKondev'
PathToSave = ['/Users/julia/Google Drive jf565/Gillespie/',Test,'/'];
Nreps = 1000;
L = 5; %0.1,1,3,5 kb
show = 'off'
Cumulative = 0
Background = 0;
FRAP = 0;
Alpha = 2;
%%
mkdir(PathToSave)
set(0, 'DefaulttextInterpreter', 'none')
set(groot,'defaultAxesColorOrder','default')

Simulation = []; Expected = []; SimulationSD = [];
vpoldefault = 2;
TotalTime = 60;
TimeRes = 10;
ACLag = 5;
Bootstrap = 50;

for n = 1:size(A,2)
Which = A(n); 
Mode = Which;
r1 = B(n);
Kon1 = C(n);
Koff1 = D(n);

[OutAll{n},Ratios(:,n)] = CompFFACGillespie(Which, Alpha, r1, Kon1, Koff1, vpoldefault, TotalTime, L, TimeRes, Nreps,PathToSave, Cumulative, ACLag, Bootstrap)

end

FileOut = [PathToSave,Test,'_',num2str(Mode),'_alpha',num2str(Alpha),'_C',num2str(Cumulative),'_L',num2str(L),'_N',num2str(Nreps),'_Kon ',num2str(C(1))];
save([FileOut,'_OutAll.mat'],'OutAll')

for n = 1:floor(length(OutAll)./16)+1
    FigE = figure('PaperSize',[40 40],'PaperUnits','inches','resize','on','visible','on');
    set(0,'defaultAxesFontSize',12)
    set(gcf, 'InvertHardCopy', 'off');
    for i = (n-1)*16+1:(n)*16
        try
        subplot(4,4,i-(n-1)*16);
        Out = OutAll{i};
        TimeRes = Out.TimeRes;
        FF = Out.FFE;
        FFSD = Out.FFESD;
        AC1 = Out.ACE{1};
        AC2 = Out.ACL{1};
        Exp = Out.Exp;
        Names = {['<m1>'],['<m2>']};   
        PlotMiniAC(FF,FFSD,AC1,AC2,Exp,Names,ACLag,TimeRes) 
        end
    end
    if n==1
          print(FigE,[FileOut,'.ps'],'-fillpage', '-dpsc');
     else
          print(FigE,[FileOut,'.ps'],'-fillpage', '-dpsc','-append');
     end
end

close all

FFRatio = reshape(Ratios(2,:),length(Ratios(2,:))/3,3);
FFRatioSD = reshape(Ratios(3,:),length(Ratios(3,:))/3,3);
FFExpected = reshape(Ratios(1,:),length(Ratios(1,:))/3,3);
Koffs = reshape(D,length(D)/3,3)
All = figure('PaperSize',[10 10],'PaperUnits','inches','resize','on','visible','on');
set(gcf,'defaultAxesFontSize',8)
plot([0,1],[1,1],'LineWidth',1); hold on
E = errorbar(Koffs,FFRatio,FFRatioSD,FFRatioSD,'*--','LineWidth',0.5); hold on
set(gca, 'ColorOrder', circshift(get(gca, 'ColorOrder'), numel(E)))
plot(Koffs, FFExpected,'LineWidth',1)
xlim([0,1.01]); ylim([0,3]); hold on
xlabel('Koff'); ylabel('FF2/FF1');
print(All,[FileOut,'_exp_vs_sim.pdf'],'-fillpage', '-dpdf');
%%
ExpectedAll = [ExpectedAll,Expected];
SimulationAll = [SimulationAll, Simulation];
SimulationSDAll = [SimulationSDAll,SimulationSD];
%%
All = figure;
errorbar(ExpectedAll,SimulationAll,SimulationSDAll,SimulationSDAll,'*r'); hold on
%plot(D, Expected,'Color',[0.85,0.325,0.098])
xlim([0,2]); ylim([0,2]); hold on
plot([0,2],[0,2], 'k--')
saveas(All,[PathToSave,'expected_vs_simulated_L',num2str(L),'_N',num2str(Nreps),'_Kon ',num2str(B(1)),'.pdf'],'pdf')


