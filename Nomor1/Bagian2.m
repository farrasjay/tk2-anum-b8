function Bagian2()
    clc;
    format long;

    C = [
         3.2  -1.5   0.8;   % Aeldari
        -2.5   4.1  -1.2;   % Boreans
         1.0   0.5  -0.3;   % Cygnian
        -3.8  -3.0   2.5;   % Drakari
         0.2  -2.7  -3.1    % Elyrians
    ];

    % 5 initial points berbeda
    initialPoints = [
         0    0    0;
         5    5    5;
        -5   -5   -5;
         4   -4    2;
        -3    3   -2
    ];

    tol = 1e-8;
    maxIter = 1000;

    fprintf('PENYELESAIAN UNCONSTRAINED DAN UNWEIGHTED\n');
    fprintf('Objective: minimize total L-4 distance\n');
    fprintf('Stopping criterion: norm(grad f(h)) < %.1e\n\n', tol);

    for k = 1:size(initialPoints, 1)
        h0 = initialPoints(k, :)';

        fprintf('============================================================\n');
        fprintf('Initial Point %d: [%.4f, %.4f, %.4f]\n', k, h0(1), h0(2), h0(3));
        fprintf('------------------------------------------------------------\n');

        % Newton's Method
        [hNewton, fNewton, gradNewton, iterNewton, runtimeNewton] = newtonMethod(h0, C, tol, maxIter);

        fprintf('Newton Method\n');
        fprintf('h*        = [%.10f, %.10f, %.10f]\n', hNewton(1), hNewton(2), hNewton(3));
        fprintf('f(h*)     = %.10f\n', fNewton);
        fprintf('grad norm = %.3e\n', gradNewton);
        fprintf('iteration = %d\n', iterNewton);
        fprintf('runtime   = %.6f seconds\n\n', runtimeNewton);

        % Conjugate Gradient Method
        [hCG, fCG, gradCG, iterCG, runtimeCG] = conjugateGradientMethod(h0, C, tol, maxIter);

        fprintf('Conjugate Gradient Method\n');
        fprintf('h*        = [%.10f, %.10f, %.10f]\n', hCG(1), hCG(2), hCG(3));
        fprintf('f(h*)     = %.10f\n', fCG);
        fprintf('grad norm = %.3e\n', gradCG);
        fprintf('iteration = %d\n', iterCG);
        fprintf('runtime   = %.6f seconds\n', runtimeCG);
    endfor

    fprintf('============================================================\n');
endfunction
