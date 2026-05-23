function H = weightedHessianFunction(h, C, w)
    % Hessian dari F(h) = sum_i w_i * ||h - c_i||_4
    H = zeros(3, 3);

    for i = 1:size(C, 1)
        u = [
            h(1) - C(i, 1);
            h(2) - C(i, 2);
            h(3) - C(i, 3)
        ];

        r = (u(1)^4 + u(2)^4 + u(3)^4)^(1/4);
        if r < 1e-12
            r = 1e-12;
        end

        H_i = zeros(3, 3);
        for a = 1:3
            for b = 1:3
                if a == b
                    term1 = 3 * u(a)^2 / r^3;
                else
                    term1 = 0;
                end

                term2 = 3 * u(a)^3 * u(b)^3 / r^7;
                H_i(a, b) = term1 - term2;
            end
        end

        H = H + w(i) * H_i;
    end
end
