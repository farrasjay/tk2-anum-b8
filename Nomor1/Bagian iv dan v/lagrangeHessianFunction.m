function H = lagrangeHessianFunction(x, C, w, cC)
    % Hessian penuh L terhadap variabel x = [h; lambda].
    % Bentuk blok:
    % [ Hessian_hh(L)      grad g(h) ]
    % [ grad g(h)^T        0         ]
    h = x(1:3);
    lambda = x(4);

    H_hh = weightedHessianFunction(h, C, w) + lambda * constraintHessianFunction(h, cC);
    grad_g = constraintGradientFunction(h, cC);

    H = zeros(4, 4);
    H(1:3, 1:3) = H_hh;
    H(1:3, 4) = grad_g;
    H(4, 1:3) = grad_g';
    H(4, 4) = 0;
end
