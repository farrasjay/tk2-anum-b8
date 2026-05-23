function [h, lambda, f_value, L_value, constraintValue, kktNorm, iter, runtime] = newtonMethodCW(x0, C, w, cC, tol, maxIter)
    % Newton untuk sistem KKT grad L(h,lambda) = 0.
    % Line search dilakukan pada Phi = 1/2 ||grad L||^2 agar lebih stabil.

    x = x0;
    iter = 0;
    tic;

    while iter < maxIter
        residual = lagrangeGradientFunction(x, C, w, cC);
        kktNorm = sqrt(sum(residual.^2));

        if kktNorm < tol
            break;
        end

        H = lagrangeHessianFunction(x, C, w, cC);
        [p, success] = solveLinearSystem(H, -residual);

        gradPhi = meritGradientFunctionCW(x, C, w, cC);

        % Jika arah Newton bukan arah turun untuk merit function,
        % gunakan regularized least-squares Newton: (H'H + mu I)p = -gradPhi.
        if (~success) || sum(gradPhi .* p) >= 0
            mu = 1e-6;
            successLS = false;

            while mu <= 1e6
                A = H' * H + mu * identityMatrix(4);
                [pLS, successLS] = solveLinearSystem(A, -gradPhi);

                if successLS && sum(gradPhi .* pLS) < 0
                    p = pLS;
                    break;
                end

                mu = mu * 10;
            end

            if (~successLS) || sum(gradPhi .* p) >= 0
                p = -gradPhi;
            end
        end

        alpha = armijoLineSearchMeritCW(x, p, gradPhi, C, w, cC);
        x = x + alpha * p;
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
