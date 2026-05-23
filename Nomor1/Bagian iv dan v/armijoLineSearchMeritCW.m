function alpha = armijoLineSearchMeritCW(x, direction, gradPhi, C, w, cC)
    alpha = 1.0;
    rho = 0.5;
    c1 = 1e-4;

    phi0 = meritObjectiveFunctionCW(x, C, w, cC);
    directionalDerivative = sum(gradPhi .* direction);

    while meritObjectiveFunctionCW(x + alpha * direction, C, w, cC) > phi0 + c1 * alpha * directionalDerivative
        alpha = rho * alpha;
        if alpha < 1e-12
            break;
        end
    end
end
