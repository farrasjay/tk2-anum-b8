function gradL = lagrangeGradientFunction(x, C, w, cC)
    % Gradien penuh L terhadap [h; lambda].
    % Ini juga merupakan residual KKT yang harus dibuat mendekati nol.
    h = x(1:3);
    lambda = x(4);

    grad_h = weightedGradientFunction(h, C, w) + lambda * constraintGradientFunction(h, cC);
    grad_lambda = constraintFunction(h, cC);

    gradL = [grad_h; grad_lambda];
end
