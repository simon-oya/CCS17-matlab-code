function noise = compute_noise( type, variables )
    
    switch lower(type)
        case {'lap'} % Laplacian
            
            epsilon = variables.param;
            
            theta = rand*2*pi;
            r = -1/epsilon*(lambertw(-1,(rand-1)/exp(1))+1);
            noise = [r.*cos(theta), r.*sin(theta)];
            
        case {'lapt'} % Laplacian truncated
            
            epsilon = variables.param;
            QmaxWC = variables.QmaxWC;
            
            theta = rand*2*pi;
            r = -1/epsilon*(lambertw(-1,(rand-1)/exp(1))+1);
            while r>QmaxWC
                r = -1/epsilon*(lambertw(-1,(rand-1)/exp(1))+1);
            end
            noise = [r.*cos(theta), r.*sin(theta)];
            
        case {'nor'} % Gaussian
            
            B = variables.param;
            
            theta = rand*2*pi;
            r = raylrnd(B);
            noise = [r.*cos(theta), r.*sin(theta)];
            
            
        case {'nort'} % Gaussian truncated
            
            B = variables.param;
            QmaxWC = variables.QmaxWC;
            
            theta = rand*2*pi;
            r = raylrnd(B);
            while r>QmaxWC
                r = raylrnd(B);
            end
            noise = [r.*cos(theta), r.*sin(theta)];
            
            
        case {'cir'} % Circular
            
            radius = variables.param;
            
            theta = rand*2*pi;
            r = radius*sqrt(rand);
            noise = [r.*cos(theta), r.*sin(theta)];
            
        case {'cirt'} % Circular truncated
            
            radius = variables.param;
            QmaxWC = variables.QmaxWC;
            
            theta = rand*2*pi;
            r = min(radius,QmaxWC)*sqrt(rand);
            noise = [r.*cos(theta), r.*sin(theta)];
            
    end
end