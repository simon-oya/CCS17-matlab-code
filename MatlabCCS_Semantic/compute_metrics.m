function metrics = compute_metrics( data )
    
    priorX = data.priorX;
    f = data.f;
    X = data.X;
    semanticmap = data.semanticmap;    
    
    N = length(priorX);
    Dl2 = get_distance_matrix('lp2',X,X);
    Dl1 = get_distance_matrix('lp1',X,X);
    DMSE = get_distance_matrix('MSE',X,X);
    Ds = get_distance_matrix('semantic',X,X,semanticmap(:));
    DH = get_distance_matrix('hamming',X,X);
    
    % Qavg
    metrics.QavgL2 = sum( (Dl2.*f)*priorX );
    metrics.QavgL1 = sum( (Dl1.*f)*priorX );
    
    % PAEs
    metrics.PAEs =  sum( min(Ds*diag(priorX)*f',[],1));
    
    % PAEl2
    metrics.PAEl2 =  sum( min(Dl2*diag(priorX)*f',[],1));
    
    % PAEl1
    metrics.PAEl1 =  sum( min(Dl1*diag(priorX)*f',[],1));
   
    % PAEMSE
    metrics.PAEMSE =  sum( min(DMSE*diag(priorX)*f',[],1));

    % PAEH
    metrics.PAEH =  sum( min(DH*diag(priorX)*f',[],1));
    
    % PCE
    aux = diag(priorX)*f';
    pZ = sum(aux,1)';
    posteriors = aux(:,pZ>0)./repmat(pZ(pZ>0)',[N,1]);
    Hposteriors = cellfun(@(posteriorj) -sum(posteriorj(posteriorj>0).*log2(posteriorj(posteriorj>0))), num2cell(posteriors,1))';
    metrics.PCE = pZ(pZ>0)'*Hposteriors;                      

end