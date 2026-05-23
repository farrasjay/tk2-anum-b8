function g = constraintFunction(h, cC)
    % g(h) = ||h - c_C||_4 - 2 = 0
    dx = h(1) - cC(1);
    dy = h(2) - cC(2);
    dz = h(3) - cC(3);

    r = (dx^4 + dy^4 + dz^4)^(1/4);
    g = r - 2;
end
