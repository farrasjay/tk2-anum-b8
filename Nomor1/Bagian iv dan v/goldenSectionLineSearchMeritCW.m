function alpha = goldenSectionLineSearchMeritCW(x, direction, C, w, cC)
    % Golden section search untuk meminimalkan meritObjectiveFunctionCW(x + alpha*d).
    left = 0.0;
    right = 1.0;

    f_left = meritObjectiveFunctionCW(x + left * direction, C, w, cC);
    f_right = meritObjectiveFunctionCW(x + right * direction, C, w, cC);

    expandIter = 0;
    while f_right < f_left && expandIter < 10
        left = right;
        f_left = f_right;
        right = 2 * right;
        f_right = meritObjectiveFunctionCW(x + right * direction, C, w, cC);
        expandIter = expandIter + 1;
    end

    a = 0.0;
    b = right;
    phi = (sqrt(5) - 1) / 2;

    c = b - phi * (b - a);
    d = a + phi * (b - a);

    f_c = meritObjectiveFunctionCW(x + c * direction, C, w, cC);
    f_d = meritObjectiveFunctionCW(x + d * direction, C, w, cC);

    for iter = 1:60
        if f_c > f_d
            a = c;
            c = d;
            f_c = f_d;
            d = a + phi * (b - a);
            f_d = meritObjectiveFunctionCW(x + d * direction, C, w, cC);
        else
            b = d;
            d = c;
            f_d = f_c;
            c = b - phi * (b - a);
            f_c = meritObjectiveFunctionCW(x + c * direction, C, w, cC);
        end
    end

    alpha = (a + b) / 2;
end
