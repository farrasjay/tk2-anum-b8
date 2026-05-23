function f = objectiveFunction(h, C)
    f = 0;

    for i = 1:size(C, 1)
        dx = h(1) - C(i, 1);
        dy = h(2) - C(i, 2);
        dz = h(3) - C(i, 3);

        distance = (dx^4 + dy^4 + dz^4)^(1/4);

        f = f + distance;
    endfor
endfunction
