function [h, f_value, gradNorm, iter, runtime] = newtonMethod(h0, C, tol, maxIter)
    h = h0;
    iter = 0;

    tic;

    while iter < maxIter
        grad = gradientFunction(h, C);
        gradNorm = sqrt(sum(grad.^2));

        if gradNorm < tol
            break;
        endif

        H = hessianFunction(h, C);

        % Newton direction: H * p = -grad
        [p, success] = solveLinearSystem(H, -grad);

        % Jika Hessian bermasalah atau arah bukan descent, lakukan regularisasi.
        reg = 1e-8;

        while ((!success) || sum(grad .* p) >= 0) && reg <= 1e3
            H_reg = H + reg * identityMatrix(3);
            [p, success] = solveLinearSystem(H_reg, -grad);
            reg = reg * 10;
        endwhile

        % Jika tetap gagal, gunakan arah negatif gradien.
        if (!success) || sum(grad .* p) >= 0
            p = -grad;
        endif

        alpha = armijoLineSearch(h, p, grad, C);

        h = h + alpha * p;
        iter = iter + 1;
    endwhile

    runtime = toc;
    f_value = objectiveFunction(h, C);
    grad = gradientFunction(h, C);
    gradNorm = sqrt(sum(grad.^2));
endfunction
