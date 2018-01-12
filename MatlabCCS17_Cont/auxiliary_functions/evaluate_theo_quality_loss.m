function Q = evaluate_theo_quality_loss( data )
    % Returns a metric of quality loss. Fields of data are:
    % - metricQ: type of privacy metric
    % - type_distQ: type of distance for the AL metric (optional)
    % - priorX
    % - X: input alphabet
    % - Z: output alphabet
    % - f: the mechanism
    
    switch lower(data.metricQ)
        case {'al','averageloss','alwc'}
            
            DQ=get_distance_matrix( data.type_distQ, data.X, data.Z );        
            Q=sum( (data.f.*DQ)*data.priorX );
        
        otherwise
            error('The quality loss metric "%s" is not programmed\n',data.metricQ);
    end
    
    
end