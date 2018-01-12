function f = get_optimal_mechanism_Shokri( data )
    % Shokri's optimal mechanism, valid for Average Error and Avgerage Loss as metrics.
    % It sets up a linear program and solves it.
    % It needs the following data:
    % - priorX
    % - DP
    % - DQ
    % - Qtarget
    % - algorithm
    
    %%%%%%%%%%%%%%%%%%%%
    priorX=data.priorX;
    DP=data.DP;
    DQ=data.DQ;
    Qtarget=data.Qtarget;
    algorithm=data.algorithm;
    %%%%%%%%%%%%%%%%%%%%
    
    nIN=size(DQ,2);
    nOUT=size(DQ,1);
    nEST=size(DP,1);
    sizeX=nOUT*(nIN+1);
    
    % Linear objective function.
    af = -1*[ones(1,nOUT),zeros(1,nOUT*nIN)]'; % minus becase we're going to maximize
    
    % Matrix for linear inequality constraints.
    A=[kron([ones(nEST,1),repmat(-priorX',[nEST,1]).*DP],eye(nOUT));
        zeros(1,nOUT),reshape(repmat(priorX',[nOUT,1]).*DQ,[1,nOUT*nIN])];
    b=[zeros(nOUT*nEST,1); Qtarget];
    
    % Matrix for linear equality constraints.
    Aeq=[zeros(nIN,nOUT), kron(eye(nIN),ones(1,nOUT))];
    beq=ones(nIN,1);
    
    % Lower and upper bounds.
    LB=zeros(sizeX,1);
    UB=Inf(sizeX,1);    
    
    % Solve the LP
    options = optimoptions(@linprog,'Display','none','Algorithm',algorithm);
    x = linprog(af,A,b,Aeq,beq,LB,UB,[],options);
    f = reshape(x(nOUT+1:end),[nOUT, nIN]); % Remove the auxiliary variables and reshape as a mechanism matrix.
    
end