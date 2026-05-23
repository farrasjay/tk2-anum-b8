function Bagian1()
    clc;
    format long;

    C = [
         3.2  -1.5   0.8;   % Aeldari
        -2.5   4.1  -1.2;   % Boreans
         1.0   0.5  -0.3;   % Cygnian
        -3.8  -3.0   2.5;   % Drakari
         0.2  -2.7  -3.1    % Elyrians
    ];

    h = [0; 0; 0];

    % Hitung fungsi objektif, gradien, dan Hessian
    f_value = objectiveFunction(h, C);
    grad_value = gradientFunction(h, C);
    hessian_value = hessianFunction(h, C);

    % Tampilkan hasil
    disp('Titik h:');
    disp(h);

    disp('Nilai fungsi objektif f(h):');
    disp(f_value);

    disp('Gradien f(h):');
    disp(grad_value);

    disp('Matriks Hessian f(h):');
    disp(hessian_value);
endfunction
