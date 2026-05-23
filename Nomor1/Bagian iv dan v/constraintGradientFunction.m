function grad = constraintGradientFunction(h, cC)
    % Gradien dari g(h) = ||h - c_C||_4 - 2
    dx = h(1) - cC(1);
    dy = h(2) - cC(2);
    dz = h(3) - cC(3);

    r = (dx^4 + dy^4 + dz^4)^(1/4);
    if r < 1e-12
        r = 1e-12;
    end

    grad = [
        dx^3 / r^3;
        dy^3 / r^3;
        dz^3 / r^3
    ];
end
