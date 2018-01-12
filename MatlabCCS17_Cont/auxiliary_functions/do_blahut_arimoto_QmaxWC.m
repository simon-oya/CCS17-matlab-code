function pZX=do_blahut_arimoto_QmaxWC( pX, pZX0, beta, Dmatrix, nIter, QmaxWC )
    pZX=pZX0;
    nIN=length(pX);
    nOUT=size(pZX0,1);
    for i=1:nIter
        pZ=pZX*pX;
        pZX=exp(-beta*Dmatrix).*repmat(pZ,[1,nIN]).*(Dmatrix<=QmaxWC);
        pZX=pZX./repmat(sum(pZX,1),[nOUT,1]);
    end
end