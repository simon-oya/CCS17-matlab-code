function posteriorX = compute_posterior( type, aux )
    % Compute the posterior given:
    % - type: the type of noise added
    % - aux.param: the parameter of the noise added
    % - aux.priorX: the prior
    % - aux.X: the input alphabet
    % - aux.z_val: the output after adding noise
    % - aux.QmaxWC: worst-case loss constraint
    
    switch lower(type)
        
        case {'lap'} % Laplacian
            
            priorX = aux.priorX;
            epsilon = aux.param;
            X = aux.X;
            z_val = aux.z_val;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*exp(-epsilon*distance_current_z );
            posteriorX = posteriorX/sum(posteriorX);
            
        case {'lapt'} % Laplacian truncated
            
            priorX = aux.priorX;
            epsilon = aux.param;
            X = aux.X;
            z_val = aux.z_val;
            QmaxWC = aux.QmaxWC;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*exp(-epsilon*distance_current_z ).*(distance_current_z<=QmaxWC);
            posteriorX = posteriorX/sum(posteriorX);
            
            
        case {'nor'} % Gaussian
            
            priorX = aux.priorX;
            B = aux.param;
            X = aux.X;
            z_val = aux.z_val;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*exp(-distance_current_z.^2/(2*B^2));
            posteriorX = posteriorX/sum(posteriorX);
            
                        
        case {'nort'} % Gaussian truncated
            
            priorX = aux.priorX;
            B = aux.param;
            X = aux.X;
            z_val = aux.z_val;
            QmaxWC = aux.QmaxWC;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*exp(-distance_current_z.^2/(2*B^2)).*(distance_current_z<=QmaxWC);
            posteriorX = posteriorX/sum(posteriorX);
            
        case {'cir'} % Circular
            
            priorX = aux.priorX;
            radius = aux.param;
            X = aux.X;
            z_val = aux.z_val;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*(distance_current_z<=radius);
            posteriorX = posteriorX/sum(posteriorX);
            
            
        case {'cirt'} % Circular truncated
            
            priorX = aux.priorX;
            radius = aux.param;
            X = aux.X;
            z_val = aux.z_val;          
            QmaxWC = aux.QmaxWC;
            distance_current_z = get_distance_matrix('lp2',z_val,X);
            
            posteriorX = priorX.*(distance_current_z<=radius).*(distance_current_z<=QmaxWC);
            posteriorX = posteriorX/sum(posteriorX);
            
            
    end
end