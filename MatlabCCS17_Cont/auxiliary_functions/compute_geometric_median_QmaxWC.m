function x_opt = compute_geometric_median_QmaxWC( posterior, Xvals, QmaxWC )
    % Finds the optimal remapping of a value given the posterior over Xvals, and a maximum Quality Loss constraint QmaxWC. Uses the Euclidean norm.
    
    meanX = (posterior'*Xvals)';
    N = length(posterior);
    
    function [y,grady] = quadobj(x)
        y = x'*x - 2*meanX'*x;
        if nargout > 1
            grady = 2*x + 2*meanX;
        end
    end
    
    function [y,yeq,grady,gradyeq] = quadconstr(x)
        y = zeros(1,N);
        for i = 1:N
            y(i) = x'*x - 2*Xvals(i,:)*x + sum(Xvals(i,:).^2) - QmaxWC^2;
        end
        yeq = [];
        
        if nargout > 2
            grady = zeros(length(x),N);
            for i = 1:N
                grady(:,i) = 2*x -2*Xvals(i,:)';
            end
        end
        gradyeq = [];
    end
    
    function hess = quadhess(x,lambda)
        hess = 2*eye(2);
        for i = 1:N
            hess = hess + lambda.ineqnonlin(i)*2*eye(2);
        end
    end
    
    
    
    options = optimoptions(@fmincon,'Algorithm','interior-point',...
        'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,...
        'HessianFcn',@(x,lambda)quadhess(x,lambda),'Display','off');
            
    fun = @(x)quadobj(x);
    nonlconstr = @(x)quadconstr(x);
    x0 = meanX; % column vector    
    [x_opt,fval,eflag,output,lambda] = fmincon(fun,x0,[],[],[],[],[],[],nonlconstr,options);
    x_opt=x_opt';
        
end
    
    