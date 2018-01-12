clear
close all;

%%%% Create the synthetic map.
[matX, matY] = meshgrid(1:5,1:5);
X = [matX(:), matY(:)]; % X contains the locations (each row is a location, each column a coordinate).
N = size(X,1); % Number of locations
priorX = ones(N,1)/N; % Prior of locations: uniform.
semanticmap=[1 1 1 1 1;
            3 2 4 4 1;
            1 4 2 2 3;
            1 3 2 2 1;
            1 1 1 1 3]; % Label of each location in the map, in matricial form.


%%% Select the experiment you want to make: 1 or 2
% DP: NxN matrix that contains the distance between any pair of locations to measure Privacy.
% DQ: NxN matrix that contains the distance between any pair of locations to measure Quality Loss.
DP = get_distance_matrix('semantic',X,X,semanticmap(:)); % Store a matrix with distances between locations, Semantic distance
DQ = get_distance_matrix('lp2',X,X); % Quality Loss always measured as Euclidean distance.

% Compute the maximum average quality loss of any optimal mechanism and build a list of target quality losses (Qlist).
distortion_single_location=DQ*priorX;
Qmax=min(distortion_single_location);
Qlist=linspace(0,Qmax,100);

% Struct to pass down to get_mechanism
data = struct();
data.priorX = priorX;
data.DP = DP;
data.DQ = DQ;
data.Qmax = Qmax;

type_mechanism_list = {'shokri-simplex','shokri-interior','expost','coin'}; % Mechanisms we are going to evaluate.

QL2_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average loss measured as Euclidean distance (L2 norm)
QL1_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average loss measured as Manhattan distance (L1 norm)
PAEl2_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average error measured as Euclidean distance (L2 norm)
PAEMSE_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average error measured as Mean Squared Error
PAEs_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average error measured as average semantic distance
PCE_measures = zeros(length(type_mechanism_list),length(Qlist)); % To store the average error measured as conditional entropy

for imech = 1:length(type_mechanism_list)
    
    data.type_mechanism = type_mechanism_list{imech};
    
    for iq = 1:length(Qlist)
        
        data.Qtarget = Qlist(iq);
        
        % Get the mechanism
        f = get_mechanism( data );
        
        % Compute the metrics and store them
        metrics = compute_metrics( struct('priorX',priorX,'f',f,'X',X,'semanticmap',semanticmap) );
        QL2_measures(imech,iq) = metrics.QavgL2;
        QL1_measures(imech,iq) = metrics.QavgL1;
        PAEs_measures(imech,iq) = metrics.PAEs;
        PCE_measures(imech,iq) = metrics.PCE;
        PAEl2_measures(imech,iq) = metrics.PAEl2;
        PAEMSE_measures(imech,iq) = metrics.PAEMSE;
        
        fprintf('Done for %s, rep %d/%d\n',data.type_mechanism,iq,length(Qlist));
    end
end

save('RESULTS_EVALUATE.mat');



