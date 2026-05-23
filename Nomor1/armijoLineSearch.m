function alpha = armijoLineSearch(h, direction, grad, C)
    alpha = 1.0;
    rho = 0.5;
    c1 = 1e-4;

    f0 = objectiveFunction(h, C);
    directionalDerivative = sum(grad .* direction);

    while objectiveFunction(h + alpha * direction, C) > f0 + c1 * alpha * directionalDerivative
        alpha = rho * alpha;

        if alpha < 1e-12
            break;
        endif
    endwhile
endfunction
