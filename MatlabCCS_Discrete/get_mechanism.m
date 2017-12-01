function f = get_mechanism( data )
    % data is a struct that contains the following fields
    % - type_mechanism
    % - priorX
    % - DP
    % - DQ
    % - Qtarget
    % - Qmax
    
    
    switch lower(data.type_mechanism)
        case {'coin'}
            
            alpha = 1-min(data.Qtarget/data.Qmax,1); % Bias of the coin
            f = alpha*eye(length(data.priorX));
            [~,idx]=min(data.DQ*data.priorX); % Find the center of the map for the coin
            f(idx,:)=f(idx,:)+(1-alpha);
            
        case {'expost'}
            
            f = get_mechanism_expost( struct('priorX',data.priorX,'DQ',data.DQ,'Qtarget',data.Qtarget,'nIter',100) );
            
        case {'shokri-simplex'}
            
            f = get_optimal_mechanism_Shokri( struct('priorX',data.priorX,'DP',data.DP,'DQ',data.DQ,'Qtarget',data.Qtarget,'algorithm','dual-simplex'));
                
        case {'shokri-interior'}
            
            f = get_optimal_mechanism_Shokri( struct('priorX',data.priorX,'DP',data.DP,'DQ',data.DQ,'Qtarget',data.Qtarget,'algorithm','interior-point'));
               
        otherwise
            
            error('Wrong type of mechanism (%s) specified',data.type_mechanism)
    end
end