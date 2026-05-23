function H = constraintHessianFunction(h, cC)
    % Hessian dari g(h) = ||h - c_C||_4 - 2
    u = [
        h(1) - cC(1);
        h(2) - cC(2);
        h(3) - cC(3)
    ];

    r = (u(1)^4 + u(2)^4 + u(3)^4)^(1/4);
    if r < 1e-12
        r = 1e-12;
    end

    H = zeros(3, 3);
    for a = 1:3
        for b = 1:3
            if a == b
                term1 = 3 * u(a)^2 / r^3;
            else
                term1 = 0;
            end

            term2 = 3 * u(a)^3 * u(b)^3 / r^7;
            H(a, b) = term1 - term2;
        end
    end
end
