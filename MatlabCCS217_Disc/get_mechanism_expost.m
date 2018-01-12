function [f, beta1] = get_mechanism_expost( data )
    % Exponential Posterior Mechanism using Blahut-Arimoto. It needs the following data:
    % - priorX
    % - DQ
    % - Qtarget
    % Optional:
    % - nIter
    % - nMaxIterBA
    % - beta1
    
    %%%%%%%%%%%%%%%%%%%%
    nINoriginal=length(data.priorX);
    valid_inputs=data.priorX>0;
    priorX=data.priorX(valid_inputs); % We only take possible inputs, to reduce computational cost.
    DQ=data.DQ(:,valid_inputs);
    Qtarget=data.Qtarget;
    if isfield(data,'nIter')
        nIter=data.nIter;
    else
        nIter=30;
    end
    if isfield(data,'nMaxIterBA')
        nMaxIterBA=data.nMaxIterBA;
    else
        nMaxIterBA=200;
    end
    if isfield(data,'beta1')
        beta1=data.beta1;        
    else
        beta1=10;
    end
    %%%%%%%%%%%%%%%%%%%%
    
    % Compute if the QL constraints are feasible (in case input and output alphabets are different).    
    minimumQavg=min(DQ,[],1)*priorX;
    if minimumQavg>Qtarget
        f=[];
        return
    end
        
    nIN=size(DQ,2); % Size of input alphabet
    nOUT=size(DQ,1); % Size of output alphabet
        
    function [pZX, Q]=do_blahut_arimoto( pX, pZX0, beta, Dmatrix, nIter )
        % This function runs Blahut-Arimoto algorithm and returns ExPost mechanism given a particular beta.        
        pZX=pZX0;
        for i=1:nIter
            pZ=pZX*pX;
            pZX=exp(-beta*Dmatrix).*repmat(pZ,[1,nIN]);
            pZX=pZX./repmat(sum(pZX,1),[nOUT,1]);
        end
        Q=sum((pZX.*Dmatrix)*pX);
    end
    
    pZX0=ones(nOUT,nIN)/nOUT; % start with uniform mapping
    
    % Beta determines the quality loss of ExPost, but we don't know the beta that gives us Qtarget.
    % We look for this beta using the bisection method.
    % More beta means less quality loss
    beta0=0; % beta1 is initialized earlier to a large value.
    [f0, Q0]=do_blahut_arimoto( priorX, pZX0, beta0, DQ, nIter ); % Maximum quality loss
    [~, Q1]=do_blahut_arimoto( priorX, pZX0, beta1, DQ, nIter ); % Very low quality loss
    if Qtarget>=Q0 % We cannot have more quality loss than this.
        f=[ones(1,nINoriginal); zeros(nOUT-1,nINoriginal)]; % Every location maps to the first output
        f(:,valid_inputs)=f0;
        beta1 = beta0;
        return;
    elseif Qtarget==0 % Zero target loss. Lazy approach: we raise error if we don't have the same alphabet.
        if nIN~=nOUT
            error('Qis zero but nIN neq nOUT: this is not considered by blahut arimoto');
        else
            f=eye(nIN);
            return
        end
    elseif Qtarget<=Q1-1e-20 % If our target loss is even smaller than Q1, we increase beta1 to get a smaller Q1.
        while Qtarget<=Q1
            beta1=beta1*2;
            [~, Q1]=do_blahut_arimoto( priorX, pZX0, beta1, DQ, nIter );
        end
    end
    
    % Now the Qtarget is achieved between beta0 and beta1. Bisection method.
    nIterBA=0; % Count of interations.
    beta_int=(beta0+beta1)/2; % Beta in the middle.
    [f_int, Q_int]=do_blahut_arimoto( priorX, pZX0, beta_int, DQ, nIter );
    while (Q_int>Qtarget || Q_int+1e-6<Qtarget) && nIterBA<nMaxIterBA % Our tolerance for beta is 1e-6
        
        if Q_int<Qtarget
            beta1=beta_int;
        else
            beta0=beta_int;
        end
        
        beta_int=(beta0+beta1)/2;
        
        [f_int, Q_int]=do_blahut_arimoto( priorX, pZX0, beta_int, DQ, nIter );
        nIterBA=nIterBA+1;
        
    end
        
    f=[ones(1,nINoriginal); zeros(nOUT-1,nINoriginal)]; % Every location maps to the first output
    f(:,valid_inputs)=f_int;
    beta1=2*beta_int;
    
end