function phi = meritObjectiveFunctionCW(x, C, w, cC)
    % Merit function: Phi(x) = 1/2 * ||grad L(x)||_2^2.
    % Dipakai untuk line search dan CG karena L(h,lambda) bersifat saddle.
    residual = lagrangeGradientFunction(x, C, w, cC);
    phi = 0.5 * sum(residual.^2);
end
