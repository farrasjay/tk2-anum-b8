function [x, success] = solveLinearSystem(A, b)
    % Menyelesaikan A*x = b dengan Gaussian Elimination + partial pivoting.
    % Tidak memakai inv() dan tidak memakai operator backslash.

    n = length(b);
    Aug = [A, b];
    success = true;

    for k = 1:n-1
        maxRow = k;
        maxVal = abs(Aug(k, k));

        for i = k+1:n
            if abs(Aug(i, k)) > maxVal
                maxVal = abs(Aug(i, k));
                maxRow = i;
            end
        end

        if maxVal < 1e-14
            x = zeros(n, 1);
            success = false;
            return;
        end

        if maxRow ~= k
            temp = Aug(k, :);
            Aug(k, :) = Aug(maxRow, :);
            Aug(maxRow, :) = temp;
        end

        for i = k+1:n
            factor = Aug(i, k) / Aug(k, k);
            for j = k:n+1
                Aug(i, j) = Aug(i, j) - factor * Aug(k, j);
            end
        end
    end

    if abs(Aug(n, n)) < 1e-14
        x = zeros(n, 1);
        success = false;
        return;
    end

    x = zeros(n, 1);
    for i = n:-1:1
        total = 0;
        for j = i+1:n
            total = total + Aug(i, j) * x(j);
        end
        x(i) = (Aug(i, n+1) - total) / Aug(i, i);
    end
end
