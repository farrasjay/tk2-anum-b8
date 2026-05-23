function gradPhi = meritGradientFunctionCW(x, C, w, cC)
    % Jika Phi(x) = 1/2 ||grad L(x)||^2, maka grad Phi = Hessian(L)^T * grad L.
    residual = lagrangeGradientFunction(x, C, w, cC);
    H = lagrangeHessianFunction(x, C, w, cC);
    gradPhi = H' * residual;
end
