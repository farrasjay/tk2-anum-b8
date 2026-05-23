function grad = weightedGradientFunction(h, C, w)
    % Gradien dari F(h) = sum_i w_i * ||h - c_i||_4
    grad = zeros(3, 1);

    for i = 1:size(C, 1)
        dx = h(1) - C(i, 1);
        dy = h(2) - C(i, 2);
        dz = h(3) - C(i, 3);

        r = (dx^4 + dy^4 + dz^4)^(1/4);
        if r < 1e-12
            r = 1e-12;
        end

        grad_i = [
            dx^3 / r^3;
            dy^3 / r^3;
            dz^3 / r^3
        ];

        grad = grad + w(i) * grad_i;
    end
end
