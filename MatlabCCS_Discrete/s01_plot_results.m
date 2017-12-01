clear;
close all;
load('RESULTS_EVALUATE.mat');

algorithms={'Optimal Shokri - Simplex','Optimal Shokri - InteriorPoint','ExPost','Coin'};
style={'-','--','-','-'};


f=figure; set(gcf,'color','white');
hold on;
for i=1:size(QL2_measures,1)
    plot(QL2_measures(i,:),PAEl2_measures(i,:),style{i},'LineWidth',2); 
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{AE}}$, Euclidean','Interpreter','Latex','Fontsize',15);
    h=legend('Opt Shokri - Simplex','Opt Shokri - Interior Point','$\texttt{ExPost}$','$\texttt{Coin}$','Location','NorthWest');
    set(h,'Interpreter','Latex','FontSize',12);
grid;
set(f, 'Position', [100, 100, 600, 300]);


f=figure; set(gcf,'color','white');
hold on;
for i=1:size(QL2_measures,1)
    plot(QL2_measures(i,:),PCE_measures(i,:),style{i},'LineWidth',2); 
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{CE}}$','Interpreter','Latex','Fontsize',15);
grid;
set(f, 'Position', [100, 100, 600, 300]);


f=figure; set(gcf,'color','white');
hold on;
for i=1:size(QL2_measures,1)
    plot(QL2_measures(i,:),PAEs_measures(i,:),style{i},'LineWidth',2); 
end
xlabel('$\overline{\mbox{Q}}$, Euclidean','Interpreter','Latex','Fontsize',15);
ylabel('$\mbox{P}_{\texttt{AE}}$, Semantic','Interpreter','Latex','Fontsize',15);
grid;
set(f, 'Position', [100, 100, 600, 300]);


