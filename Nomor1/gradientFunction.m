function grad = gradientFunction(h, C)
    grad = zeros(3, 1);

    for i = 1:size(C, 1)
        dx = h(1) - C(i, 1);
        dy = h(2) - C(i, 2);
        dz = h(3) - C(i, 3);

        r = (dx^4 + dy^4 + dz^4)^(1/4);

        % Untuk menghindari pembagian dengan nol
        if r < 1e-12
            r = 1e-12;
        endif

        grad_i = [
            dx^3 / r^3;
            dy^3 / r^3;
            dz^3 / r^3
        ];

        grad = grad + grad_i;
    endfor
endfunction
