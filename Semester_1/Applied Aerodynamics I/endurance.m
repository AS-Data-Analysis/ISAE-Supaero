function matrix = endurance(X)

for i = 1:length(X(:,1))
    if X(i,2)<0
        matrix(i) = -abs(X(i,2))^(3/2)/X(i,3);
    else
        matrix(i) = X(i,2)^(3/2)/X(i,3);
    end
end