function Dmatrix=get_distance_matrix(type, locations_IN, locations_OUT, auxiliar )
    % Compute a matrix Dmatrix, whose (j,i)-th element is the distance between
    % the i-th input location and j-th output location.
    
    nIN=size(locations_IN,1);
    nOUT=size(locations_OUT,1);
    if size(locations_IN,2)~=2
        locations_IN=[locations_IN, zeros(size(locations_IN,1),1)];
    end
    if size(locations_OUT,2)~=2
        locations_OUT=[locations_OUT, zeros(size(locations_OUT,1),1)];
    end
    
    
    switch lower(type)
        case {'mse'}
            locations_IN_complex=locations_IN(:,1)+sqrt(-1)*locations_IN(:,2);
            locations_OUT_complex=locations_OUT(:,1)+sqrt(-1)*locations_OUT(:,2);
            Dmatrix=abs( repmat(locations_OUT_complex,[1,nIN])-repmat(locations_IN_complex.',[nOUT,1]) ).^2;
            
        case {'hamming'}            
            locations_IN_complex=locations_IN(:,1)+sqrt(-1)*locations_IN(:,2);
            locations_OUT_complex=locations_OUT(:,1)+sqrt(-1)*locations_OUT(:,2);
            Dmatrix=  ( repmat(locations_OUT_complex,[1,nIN])-repmat(locations_IN_complex.',[nOUT,1]) )~=0;
            
        case {'semantic'}            
            if nIN~=nOUT
                nIN
                nOUT
                error('nIN neq nOUT for semantic distance!');
            end
            Dmatrix=zeros(nIN,nIN);
            for i=1:nIN
                if auxiliar(i)~=0 % A zero in the map is a non-private state, we can map it anywhere with no cost
                    Dmatrix(:,i)=(auxiliar(i)~=auxiliar);
                end
            end
            
        otherwise
            % This is for all lp-norms (Euclidean, Manhattan, etc)
            if length(type)==3 && strcmpi(type(1:2),'lp')
                p=sscanf(lower(type),'lp%d');
                
                X_diff=abs(repmat(locations_IN(:,1)',[nOUT,1])-repmat(locations_OUT(:,1),[1,nIN]));
                Y_diff=abs(repmat(locations_IN(:,2)',[nOUT,1])-repmat(locations_OUT(:,2),[1,nIN]));
                Dmatrix=( X_diff.^p+Y_diff.^p ).^(1/p);
                
            else
                error('WRONG DISTANCE: %s',type);
            end
    end
end