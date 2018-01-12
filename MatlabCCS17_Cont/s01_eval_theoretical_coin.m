clear

% Initialize
addpath('auxiliary_functions/');
name_dataset = 'Gowalla'; 
% name_dataset = 'Brightkite';
rng('Shuffle');
rng_params=rng;


% Set parameters
param_list = 0:.5:2; % Average loss list

% Load dataset
load(sprintf('DATA_SF_%s_parsed.mat',name_dataset),'X','priorX','user_location_pairs');


% Initialize variables
QnoR_measures=zeros(length(param_list),1); % Average loss without remapping
QminL2_measures=zeros(length(param_list),1); % Average loss, Euclidean with remapping
PAEl2_measures=zeros(length(param_list),1); % Average adversary error, Euclidean
PAEH_measures=zeros(length(param_list),1); % Average adversary error, Hamming
PAEMSE_measures=zeros(length(param_list),1); % Average adversary error, MSE
PCE_measures=zeros(length(param_list),1); % Conditional entropy


center_l2 = compute_geometric_median( priorX, X ); % Center of the map according to l2 norm
QLmax = get_distance_matrix('lp2',X,center_l2)*priorX; % Average distance to the center of the map

tic;
for i_param=1:length(param_list)
    
    alpha = min(param_list(i_param)/QLmax,1); % Bias of the coin
    
    f = [(1-alpha)*eye(size(X,1)); alpha*ones(1,size(X,1))]; % The coin mechanism in matrix format
    Z = [X; center_l2]; % The output alphabet of the coin mechanism
    
    % Structure to evaluate discrete mechanisms theoretically
    dataEval = struct(); 
    dataEval.priorX = priorX; % Input prior
    dataEval.X = X; % Input alphabet
    dataEval.Z = Z; % Output alphabet
    dataEval.f = f; % Matrix describing the mechanism
    
    % Compute average loss (no remapping needed for the coin)
    dataEval.metricQ = 'averageloss'; % Quality loss metric
    dataEval.type_distQ = 'lp2'; % Distance metric    
    QnoR_measures(i_param) = evaluate_theo_quality_loss( dataEval );
    QminL2_measures(i_param) = QnoR_measures(i_param);
        
    % Average error, Euclidean
    dataEval.metricP = 'averageerror';
    dataEval.type_distP = 'lp2';
    PAEl2_measures(i_param) = evaluate_theo_privacy( dataEval );
    
    % Average error, MSE    
    dataEval.type_distP = 'mse';
    PAEMSE_measures(i_param) = evaluate_theo_privacy( dataEval );
    
    % Average error, Hamming
    dataEval.type_distP = 'hamming';
    PAEH_measures(i_param) = evaluate_theo_privacy( dataEval );
    
    % Conditional entropy
    dataEval.metricP = 'condent';
    dataEval.type_distP = '';
    PCE_measures(i_param) = evaluate_theo_privacy( dataEval );
    
    
    fprintf('Coin, avgQL=%1.3f, avgQnoR=%1.3f, PAEl2=%1.3f, PAEH=%1.3f, PAEmse=%1.3f, PCE=%1.3f (%1.0f secs).\n',...
        QminL2_measures(i_param),QnoR_measures(i_param),PAEl2_measures(i_param),PAEH_measures(i_param),...
        PAEMSE_measures(i_param),PCE_measures(i_param),toc);
    
end


save(sprintf('RESULTS/RES_SF_coin_%s.mat',name_dataset),'QminL2_measures','QnoR_measures',...
    'PAEl2_measures','PAEMSE_measures','PAEH_measures','PCE_measures');





