clear

% Initialize
addpath('auxiliary_functions/');
name_dataset = 'Gowalla';
% name_dataset = 'Brightkite';
rng('Shuffle');
rng_params=rng;

% Set parameters
QmaxWC = 1.5;
param_list = 2./[0.05 0.1 0.3 0.5 0.75 1 1.25 1.5 1.75 2]; % This is the parameter that varies, in this case "epsilon";

% Load dataset
load(sprintf('DATA_SF_%s_parsed.mat',name_dataset),'X','priorX','user_location_pairs');

% Initialize variables with results
QnoR_measures=zeros(length(param_list),1); % Average loss without remapping
QminL2_measures=zeros(length(param_list),1); % Average loss, Euclidean with remapping
PAEl2_measures=zeros(length(param_list),1); % Average adversary error, Euclidean
PAEH_measures=zeros(length(param_list),1); % Average adversary error, Hamming
PAEMSE_measures=zeros(length(param_list),1); % Average adversary error, MSE
PCE_measures=zeros(length(param_list),1); % Conditional entropy


initial_time=tic;
Dmatrix = get_distance_matrix('lp2',X,X);


for i_param=1:length(param_list)
    
    param = param_list(i_param);
    
    % Compute the exponential mechanism with WC constraint
    fexp = exp(-param*Dmatrix).*(Dmatrix<QmaxWC);
    fexp = fexp./repmat(sum(fexp,1),[size(X,1),1]);
    f = fexp;
    
    % Structure to evaluate discrete mechanisms theoretically
    dataEval = struct();
    dataEval.priorX = priorX; % Input prior
    dataEval.X = X; % Input alphabet
    dataEval.Z = X; % Output alphabet
    dataEval.f = f; % Matrix describing the mechanism
    
    % Compute average loss without remapping
    dataEval.metricQ = 'averageloss';
    dataEval.type_distQ = 'lp2';
    QnoR_measures(i_param) = evaluate_theo_quality_loss( dataEval );
    
    % Compute the optimal remapping using the WC loss constraint
    Zremapped_l2 = dataEval.Z;
    prob_z = f*priorX; % output distribution
    for j=1:size(dataEval.Z,1) % for each output...
        if prob_z(j)>0 % if that's a possible output...
            posteriorX = f(j,:)'.*priorX; % get the posterior...
            % 1) Try if the mean meets the WC constraint
            Xmean = posteriorX'*priorX;
            if any(get_distance_matrix('lp2',X(posteriorX>0,:),Xmean)>QmaxWC)
                % 2) If there are a lot of points we ignore this output, if not, we try to remap it.
                if sum(posteriorX>0)<1000
                    aux_output = compute_geometric_median_QmaxWC( posteriorX(posteriorX>0), X(posteriorX>0,:), QmaxWC );
                    if get_distance_matrix('lp2',X(posteriorX>0,:),Zremapped_l2(j,:))*posteriorX(posteriorX>0,:)>get_distance_matrix('lp2',X(posteriorX>0,:),aux_output)*posteriorX(posteriorX>0,:)
                        % If the geometric median with constraints worked (does better than what we had), we use it
                        Zremapped_l2(j,:) = aux_output;
                    end
                end
            else
                Zremapped_l2(j,:)=Xmean;
            end
        end
    end
    % Average loss, Euclidean
    dataEval.Z = Zremapped_l2;
    QminL2_measures(i_param) = evaluate_theo_quality_loss( dataEval );
    
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
    
    % Conditional Entropy 
    dataEval.metricP = 'condent';
    dataEval.type_distP = '';
    PCE_measures(i_param) = evaluate_theo_privacy( dataEval );
    
    fprintf('Exp | avgQL=%1.3f, avgQnoR=%1.3f, PAEl2=%1.3f, PAEH=%1.3f, PAEmse=%1.3f, PCE=%1.3f (%1.0f secs).\n',...
        QminL2_measures(i_param),QnoR_measures(i_param),PAEl2_measures(i_param),PAEH_measures(i_param),...
        PAEMSE_measures(i_param),PCE_measures(i_param),toc(initial_time));
     
end

time_total=toc(initial_time);

save(sprintf('RESULTS/RES_SFQWC_Exp_%s.mat',name_dataset),'QminL2_measures','QnoR_measures',...
    'PAEl2_measures','PAEMSE_measures','PAEH_measures','PCE_measures',...
    'param_list','rng_params','time_total');

