function [x, success] = solveLinearSystem(A, b)
    % Menyelesaikan A*x = b dengan Gaussian Elimination
    % tanpa inv() dan tanpa operator backslash.

    n = length(b);
    Aug = [A, b];
    success = true;

    % Forward elimination dengan partial pivoting
    for k = 1:n-1
        maxRow = k;
        maxVal = abs(Aug(k, k));

        for i = k+1:n
            if abs(Aug(i, k)) > maxVal
                maxVal = abs(Aug(i, k));
                maxRow = i;
            endif
        endfor

        if maxVal < 1e-14
            x = zeros(n, 1);
            success = false;
            return;
        endif

        if maxRow ~= k
            temp = Aug(k, :);
            Aug(k, :) = Aug(maxRow, :);
            Aug(maxRow, :) = temp;
        endif

        for i = k+1:n
            factor = Aug(i, k) / Aug(k, k);

            for j = k:n+1
                Aug(i, j) = Aug(i, j) - factor * Aug(k, j);
            endfor
        endfor
    endfor

    if abs(Aug(n, n)) < 1e-14
        x = zeros(n, 1);
        success = false;
        return;
    endif

    % Back substitution
    x = zeros(n, 1);

    for i = n:-1:1
        total = 0;

        for j = i+1:n
            total = total + Aug(i, j) * x(j);
        endfor

        x(i) = (Aug(i, n+1) - total) / Aug(i, i);
    endfor
endfunction
