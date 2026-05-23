function Bagian5()
    clc;
    format long;

    C = [
         3.2  -1.5   0.8;   % Aeldari
        -2.5   4.1  -1.2;   % Boreans
         1.0   0.5  -0.3;   % Cygnian
        -3.8  -3.0   2.5;   % Drakari
         0.2  -2.7  -3.1    % Elyrians
    ];

    w = [1.0; 1.5; 2.0; 0.8; 1.2];
    cC = C(3, :)';

    % Lima initial point berbeda. lambda0 sama untuk semua eksperimen.
    initialPoints = [
        -1.0   0.50  -0.30;
        -1.0   0.00  -0.30;
        -1.0   0.25  -0.30;
        -1.0   0.50  -0.80;
         0.0   0.00   0.00
    ];

    lambda0 = 0;
    tol = 1e-8;
    maxIterNewton = 1000;
    maxIterCG = 3000;

    fprintf('BAGIAN 1 - SOAL V: PENYELESAIAN CONSTRAINED DAN WEIGHTED\n');
    fprintf('Objective  : minimize sum_i w_i * ||h - c_i||_4\n');
    fprintf('Constraint : ||h - c_C||_4 = 2\n');
    fprintf('Stopping   : ||grad L(h,lambda)||_2 < %.1e\n', tol);
    fprintf('lambda0    : %.4f\n\n', lambda0);

    for k = 1:size(initialPoints, 1)
        h0 = initialPoints(k, :)';
        x0 = [h0; lambda0];

        fprintf('============================================================\n');
        fprintf('Initial Point %d: h0 = [%.4f, %.4f, %.4f], lambda0 = %.4f\n', ...
                k, h0(1), h0(2), h0(3), lambda0);
        fprintf('------------------------------------------------------------\n');

        [hNewton, lambdaNewton, fNewton, LNewton, gNewton, kktNewton, iterNewton, runtimeNewton] = ...
            newtonMethodCW(x0, C, w, cC, tol, maxIterNewton);

        fprintf('Newton Method (KKT)\n');
        fprintf('h*             = [%.10f, %.10f, %.10f]\n', hNewton(1), hNewton(2), hNewton(3));
        fprintf('lambda*        = %.10f\n', lambdaNewton);
        fprintf('F(h*)          = %.10f\n', fNewton);
        fprintf('L(h*,lambda*)  = %.10f\n', LNewton);
        fprintf('constraint g   = %.3e\n', gNewton);
        fprintf('KKT norm       = %.3e\n', kktNewton);
        fprintf('iteration      = %d\n', iterNewton);
        fprintf('runtime        = %.6f seconds\n\n', runtimeNewton);

        [hCG, lambdaCG, fCG, LCG, gCG, kktCG, iterCG, runtimeCG] = ...
            conjugateGradientMethodCW(x0, C, w, cC, tol, maxIterCG);

        fprintf('Conjugate Gradient Method on Merit Function\n');
        fprintf('h*             = [%.10f, %.10f, %.10f]\n', hCG(1), hCG(2), hCG(3));
        fprintf('lambda*        = %.10f\n', lambdaCG);
        fprintf('F(h*)          = %.10f\n', fCG);
        fprintf('L(h*,lambda*)  = %.10f\n', LCG);
        fprintf('constraint g   = %.3e\n', gCG);
        fprintf('KKT norm       = %.3e\n', kktCG);
        fprintf('iteration      = %d\n', iterCG);
        fprintf('runtime        = %.6f seconds\n', runtimeCG);
    end

    fprintf('============================================================\n');
end
