function Bagian4()
    clc;
    format long;

    C = [
         3.2  -1.5   0.8;   % Aeldari
        -2.5   4.1  -1.2;   % Boreans
         1.0   0.5  -0.3;   % Cygnian
        -3.8  -3.0   2.5;   % Drakari
         0.2  -2.7  -3.1    % Elyrians
    ];

    w = [1.0; 1.5; 2.0; 0.8; 1.2];
    cC = C(3, :)';

    % Titik evaluasi contoh untuk memverifikasi fungsi L, gradien, dan Hessian.
    h0 = [0; 0; 0];
    lambda0 = 0;
    x0 = [h0; lambda0];

    fprintf('BAGIAN 1 - SOAL IV: PEMODELAN CONSTRAINED DAN WEIGHTED\n');
    fprintf('F(h) = sum_i w_i * ||h - c_i||_4\n');
    fprintf('g(h) = ||h - c_C||_4 - 2 = 0\n');
    fprintf('L(h, lambda) = F(h) + lambda * g(h)\n\n');

    fprintf('Evaluasi pada h = [0,0,0]^T dan lambda = 0\n');
    fprintf('F(h)              = %.15f\n', weightedObjectiveFunction(h0, C, w));
    fprintf('g(h)              = %.15f\n', constraintFunction(h0, cC));
    fprintf('L(h,lambda)       = %.15f\n', lagrangeFunction(x0, C, w, cC));

    disp('grad L(h,lambda) =');
    disp(lagrangeGradientFunction(x0, C, w, cC));

    disp('Hessian penuh L(h,lambda) =');
    disp(lagrangeHessianFunction(x0, C, w, cC));
end
