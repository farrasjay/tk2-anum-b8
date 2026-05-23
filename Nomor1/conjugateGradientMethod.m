function [h, f_value, gradNorm, iter, runtime] = conjugateGradientMethod(h0, C, tol, maxIter)
    h = h0;
    grad = gradientFunction(h, C);
    direction = -grad;
    iter = 0;

    tic;

    while iter < maxIter
        gradNorm = sqrt(sum(grad.^2));

        if gradNorm < tol
            break;
        endif

        % Jika arah bukan arah turun, restart ke negatif gradien.
        if sum(grad .* direction) >= 0
            direction = -grad;
        endif

        % Untuk CG, golden section line search lebih stabil di Octave.
        alpha = goldenSectionLineSearch(h, direction, C);

        h_new = h + alpha * direction;
        grad_new = gradientFunction(h_new, C);

        denominator = sum(grad.^2);

        if denominator < 1e-20
            beta = 0;
        else
            % Formula Polak-Ribiere+
            beta = sum(grad_new .* (grad_new - grad)) / denominator;
            beta = max(beta, 0);
        endif

        direction = -grad_new + beta * direction;

        h = h_new;
        grad = grad_new;
        iter = iter + 1;
    endwhile

    runtime = toc;
    f_value = objectiveFunction(h, C);
    gradNorm = sqrt(sum(grad.^2));
endfunction
