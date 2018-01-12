function P = evaluate_theo_privacy( data )
    % Returns a metric of privacy. Fields of data are:
    % - metricP: type of privacy metric
    % - type_distP: type of distance for the AE privacy (optional)
    % - priorX: prior of the input
    % - X: input alphabet
    % - Z: output alphabet
    % - f: the mechanism
    
    % For the average error, compute the optimal estimation alphabet
    function Xestimation = get_optimal_adversary_estimation( data )
        type_distP = data.type_distP;
        f = data.f;
        X = data.X;
        Z = data.Z;
        priorX = data.priorX;
        switch lower(type_distP)
            case {'mse'}
                % The adversary's optimal estimation is the mean.
                Xestimation = Z;
                prob_z = f*priorX;
                for j=1:size(Xestimation,1)
                    if prob_z(j)>0
                        posterior = f(j,:)'.*priorX;
                        posterior = posterior/sum(posterior);
                        Xestimation(j,:) = posterior'*X;
                    end
                end
            case {'lp2'}
                % The adversary's optimal estimation is the Geometric median. Weiszfield's algorithm.
                Xestimation = Z;
                prob_z = f*priorX;
                for j=1:size(Xestimation,1)
                    if prob_z(j)>0
                        posterior = f(j,:)'.*priorX;
                        posterior = posterior/sum(posterior);
                        Xestimation(j,:) = compute_geometric_median( posterior, X );
                    end
                end
            case {'hamming'}
                % The adversary's optimal estimation is the maximum of the posterior.
                pZandX = f*diag(priorX);
                [~,idx_max_input] = max(pZandX,[],2); % If a p(z)=0, it returns the first index, so that's fine
                Xestimation = X(idx_max_input,:);                
            otherwise
                error('The distance %s is not programmed for the free adversary!\n',data.type_distP);
        end        
    end
    
    
    switch lower(data.metricP)
        case {'ae','averageerror'}
            Xestimation = get_optimal_adversary_estimation( data );
            % The optimal attack is just using the optimal output alphabet
            DP = get_distance_matrix( data.type_distP, data.X, Xestimation );
            P = sum( (data.f.*DP)*data.priorX );
        case {'ce','condent'}            
            pZandX=data.f*diag(data.priorX);
            pZandX(sum(pZandX,2)<1e-10,:)=[]; % There might be values very close to zero that are not zero, but are Inf when inverted...
            aux=log2( diag(1./sum(pZandX,2))*pZandX );
            P=-sum(pZandX(pZandX>0).*aux(pZandX>0));
        otherwise
            error('The privacy metric "%s" is not programmed\n',data.metricP);
    end
    
end