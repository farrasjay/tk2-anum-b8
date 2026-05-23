function L = lagrangeFunction(x, C, w, cC)
    % x = [h_x; h_y; h_z; lambda]
    h = x(1:3);
    lambda = x(4);

    L = weightedObjectiveFunction(h, C, w) + lambda * constraintFunction(h, cC);
end
