function alpha = goldenSectionLineSearch(h, direction, C)
    % Mencari alpha yang meminimalkan objectiveFunction(h + alpha * direction, C)
    % dengan metode golden section search.

    left = 0.0;
    right = 1.0;

    f_left = objectiveFunction(h + left * direction, C);
    f_right = objectiveFunction(h + right * direction, C);

    expandIter = 0;
    while f_right < f_left && expandIter < 20
        left = right;
        f_left = f_right;
        right = 2 * right;
        f_right = objectiveFunction(h + right * direction, C);
        expandIter = expandIter + 1;
    endwhile

    % Pakai interval [0, right] supaya minimum tetap tercakup.
    a = 0.0;
    b = right;
    phi = (sqrt(5) - 1) / 2;

    c = b - phi * (b - a);
    d = a + phi * (b - a);

    f_c = objectiveFunction(h + c * direction, C);
    f_d = objectiveFunction(h + d * direction, C);

    for iter = 1:60
        if f_c > f_d
            a = c;
            c = d;
            f_c = f_d;
            d = a + phi * (b - a);
            f_d = objectiveFunction(h + d * direction, C);
        else
            b = d;
            d = c;
            f_d = f_c;
            c = b - phi * (b - a);
            f_c = objectiveFunction(h + c * direction, C);
        endif
    endfor

    alpha = (a + b) / 2;
endfunction
