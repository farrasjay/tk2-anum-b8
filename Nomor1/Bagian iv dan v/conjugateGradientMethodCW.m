function [h, lambda, f_value, L_value, constraintValue, kktNorm, iter, runtime] = conjugateGradientMethodCW(x0, C, w, cC, tol, maxIter)
    % Nonlinear Conjugate Gradient pada merit function Phi = 1/2 ||grad L||^2.
    % Kriteria berhenti tetap memakai norm residual KKT: ||grad L||_2 < tol.

    x = x0;
    gradPhi = meritGradientFunctionCW(x, C, w, cC);
    direction = -gradPhi;
    iter = 0;
    tic;

    while iter < maxIter
        residual = lagrangeGradientFunction(x, C, w, cC);
        kktNorm = sqrt(sum(residual.^2));

        if kktNorm < tol
            break;
        end

        if sum(gradPhi .* direction) >= 0
            direction = -gradPhi;
        end

        alpha = goldenSectionLineSearchMeritCW(x, direction, C, w, cC);
        x_new = x + alpha * direction;
        gradPhi_new = meritGradientFunctionCW(x_new, C, w, cC);

        denominator = sum(gradPhi.^2);
        if denominator < 1e-20
            beta = 0;
        else
            beta = sum(gradPhi_new .* (gradPhi_new - gradPhi)) / denominator;
            beta = max(beta, 0);   % Polak-Ribiere+
        end

        direction = -gradPhi_new + beta * direction;
        x = x_new;
        gradPhi = gradPhi_new;
        iter = iter + 1;
    end

    runtime = toc;
    h = x(1:3);
    lambda = x(4);
    f_value = weightedObjectiveFunction(h, C, w);
    L_value = lagrangeFunction(x, C, w, cC);
    constraintValue = constraintFunction(h, cC);
    residual = lagrangeGradientFunction(x, C, w, cC);
    kktNorm = sqrt(sum(residual.^2));
end
