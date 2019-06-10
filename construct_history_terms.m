function X = construct_history_terms(x,maxlag)
    X = zeros(length(x)-maxlag,maxlag);
    for i=1:(length(x)-maxlag+1)
        X(i,:) = x(i:i+maxlag-1);
    end
    X = fliplr(X);
end