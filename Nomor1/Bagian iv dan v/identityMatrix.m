function I = identityMatrix(n)
    I = zeros(n, n);
    for i = 1:n
        I(i, i) = 1;
    end
end
