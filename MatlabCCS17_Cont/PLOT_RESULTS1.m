clear
close all

name_dataset='Gowalla'; methods={'Lap','Nor','Cir','Exp','BA','coin'};
% name_dataset='Brightkite'; methods={'Lap','Nor','Cir','Exp','BA','coin'};

load(sprintf('DATA_SF_%s_parsed.mat',name_dataset),'priorX');

Q_cell=cell(length(methods),1);
PAEl2_cell=cell(length(methods),1);
PAEMSE_cell=cell(length(methods),1);
PAEH_cell=cell(length(methods),1);
PCE_cell=cell(length(methods),1);

for k=1:length(methods)
    method=methods{k};
    
    load(sprintf('RESULTS/RES_SF_%s_%s.mat',method,name_dataset),'QminL2_measures','QnoR_measures',...
            'PAEl2_measures','PAEMSE_measures','PAEH_measures','PCE_measures');
        
    if ismember(method,{'Cir','Lap','Nor'})
                
        Q_cell{k}=mean(QminL2_measures,1);        
        PAEl2_cell{k}=mean(PAEl2_measures,1);
        PAEMSE_cell{k}=mean(PAEMSE_measures,1);
        PAEH_cell{k}=mean(PAEH_measures,1);
        PCE_cell{k}=mean(PCE_measures,1);
                
    else
        
        Q_cell{k}=QminL2_measures';       
        PAEl2_cell{k}=PAEl2_measures';
        PAEMSE_cell{k}=PAEMSE_measures';
        PAEH_cell{k}=PAEH_measures';
        PCE_cell{k}=PCE_measures';
        
    end
        
end


%%%%% PLOT AVERAGE ERROR (EUCLIDEAN) VS AVERAGE LOSS
f=figure; set(gcf,'color','white');
hold on;
for k=1:length(methods)
    plot([0 mean(Q_cell{k},1)],[0 mean(PAEl2_cell{k},1)],'LineWidth',2);
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{AE}}$, Euclidean','Interpreter','Latex','Fontsize',15);
XLIM=xlim; YLIM=ylim; XLIM(2)=1;
maxval=max([XLIM,YLIM]);
plot([0 maxval],[0 maxval],'k-','DisplayName','Upper bound');
xlim(XLIM);
if strcmp(name_dataset,'Gowalla')    
    h=legend('$\texttt{Lap}$','$\texttt{Gau}$','$\texttt{Cir}$','$\texttt{Exp}$','$\texttt{ExPost}$','$\texttt{Coin}$','Location','NorthWest');
    set(h,'Interpreter','Latex','FontSize',12);
end
grid;
set(f, 'Position', [100, 100, 600, 300]);


%%%%% PLOT AVERAGE ERROR (MSE) VS AVERAGE LOSS
f=figure; set(gcf,'color','white');
hold on;
for k=1:length(methods)
    plot([0 mean(Q_cell{k},1)],[0 mean(PAEMSE_cell{k},1)],'LineWidth',2);
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{AE}}$, MSE','Interpreter','Latex','Fontsize',15);
XLIM=xlim; XLIM(2)=1;
xlim(XLIM);
if strcmp(name_dataset,'Gowalla')    
    h=legend('$\texttt{Lap}$','$\texttt{Gau}$','$\texttt{Cir}$','$\texttt{Exp}$','$\texttt{ExPost}$','$\texttt{Coin}$','Location','NorthWest');
    set(h,'Interpreter','Latex','FontSize',12);
end
grid;
set(f, 'Position', [800, 500, 600, 300]);


%%%%% PLOT AVERAGE ERROR (HAMMING) VS AVERAGE LOSS
f=figure; set(gcf,'color','white');
hold on;
for k=1:length(methods)
    plot([0 mean(Q_cell{k},1)],[0 mean(PAEH_cell{k},1)],'LineWidth',2);
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{AE}}$, Hamming','Interpreter','Latex','Fontsize',15);
XLIM=xlim; XLIM(2)=1;
xlim(XLIM);
if strcmp(name_dataset,'Gowalla')    
    h=legend('$\texttt{Lap}$','$\texttt{Gau}$','$\texttt{Cir}$','$\texttt{Exp}$','$\texttt{ExPost}$','$\texttt{Coin}$','Location','NorthWest');
    set(h,'Interpreter','Latex','FontSize',12);
end
grid;
set(f, 'Position', [800, 100, 600, 300]);


%%%%% PLOT CONDITIONAL ENTROPY VS AVERAGE ERROR
f=figure; set(gcf,'color','white');
hold on;
for k=1:length(methods)
    plot([0 mean(Q_cell{k},1)],[0 mean(PCE_cell{k},1)],'LineWidth',2);
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','FontSize',15);
ylabel('$\mbox{P}_{\texttt{CE}}$ (bits)','Interpreter','Latex','FontSize',15);
XLIM=xlim; XLIM(2)=1.14; xlim(XLIM);
maxCE=-sum(priorX.*log2(priorX));
plot(XLIM,[1 1]*maxCE,'k-');
if strcmp(name_dataset,'Gowalla')
    h=legend('$\texttt{Lap}$','$\texttt{Gau}$','$\texttt{Cir}$','$\texttt{Exp}$','$\texttt{ExPost}$','$\texttt{Coin}$','Max','Location','NorthWest');
    set(h,'Interpreter','Latex','FontSize',12);
end
grid;
set(f, 'Position', [100, 500, 600, 300]);


