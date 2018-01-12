function geo_median = compute_geometric_median( probabilities, values )
    % Computes the geometric median. Weiszfeld's algorithm
    
    
    values = values(probabilities>0,:);
    probabilities = probabilities(probabilities>0);
    probabilities = probabilities(:);

    geo_median_old=[Inf Inf];
    geo_median=probabilities'*values; % Initial estimation is the mean
    nIter=1;
    while sum( (geo_median-geo_median_old).^2)>1e-3 && nIter<200
        
        Dmatrix=get_distance_matrix('lp2', geo_median, values);
        if any(Dmatrix==0)          
            return
        end
        
        geo_median_old = geo_median;
        geo_median=((probabilities ./ Dmatrix)'*values) ./ ((probabilities ./ Dmatrix)'*ones(size(values)));    
    end

end