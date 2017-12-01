function Dmatrix=get_distance_matrix(type, locations_IN, locations_OUT, auxiliar )
    
    nIN=size(locations_IN,1);
    nOUT=size(locations_OUT,1);
    if size(locations_IN,2)~=2
        locations_IN=[locations_IN, zeros(size(locations_IN,1),1)];
    end
    if size(locations_OUT,2)~=2
        locations_OUT=[locations_OUT, zeros(size(locations_OUT,1),1)];
    end
    
    
    if strcmpi(type,'mse')
        % Mean Squared Error distance
        
        locations_IN_complex=locations_IN(:,1)+sqrt(-1)*locations_IN(:,2);
        locations_OUT_complex=locations_OUT(:,1)+sqrt(-1)*locations_OUT(:,2);
        Dmatrix=abs( repmat(locations_OUT_complex,[1,nIN])-repmat(locations_IN_complex.',[nOUT,1]) ).^2;
        
        
    elseif strcmpi(type,'hamming')
        % Hamming distance
        
        locations_IN_complex=locations_IN(:,1)+sqrt(-1)*locations_IN(:,2);
        locations_OUT_complex=locations_OUT(:,1)+sqrt(-1)*locations_OUT(:,2);
        Dmatrix=  ( repmat(locations_OUT_complex,[1,nIN])-repmat(locations_IN_complex.',[nOUT,1]) )~=0;
        
        
    elseif length(type)==3 && strcmpi(type(1:2),'lp')
        % Lp norm distance
        
        p=sscanf(lower(type),'lp%d');
        
        X_diff=abs(repmat(locations_IN(:,1)',[nOUT,1])-repmat(locations_OUT(:,1),[1,nIN]));
        Y_diff=abs(repmat(locations_IN(:,2)',[nOUT,1])-repmat(locations_OUT(:,2),[1,nIN]));
        Dmatrix=( X_diff.^p+Y_diff.^p ).^(1/p);                
        
    elseif strcmpi(type,'semantic')
        % Semantic distance, only for nIN=nOUT
        
        if nIN~=nOUT
            error('nIN=%d neq nOUT=%d for semantic distance!',nIN,nOUT);
        end
        Dmatrix=zeros(nIN,nIN);
        for i=1:nIN            
            if auxiliar(i)~=0 % A zero in the map is a non-private state, we can map it anywhere with no cost                
                Dmatrix(:,i)=(auxiliar(i)~=auxiliar);
            end
        end
        
    elseif strcmpi(type,'earthdistance')
        % Haversine, when the coordinates are latitude and longitude (we don't use it for this experiment, earth_distance is not included)
        
        Dmatrix=zeros(nOUT,nIN);
        for i=1:nIN
            for j=1:nOUT
                Dmatrix(j,i)=earth_distance(locations_IN(i,1),locations_IN(i,2),locations_OUT(j,1),locations_OUT(j,2));
            end
        end        
        
    else
        
        error('WRONG DISTANCE: %s',type);        
        
    end
    
end