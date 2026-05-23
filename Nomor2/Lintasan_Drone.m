clear; clc; close all;
format long;

%% --------------------- DATA PENERBANGAN PERTAMA -----------------------
% 10 titik data yang berhasil diterima stasiun bumi (Tabel 2)
t = (1:10)';                                                          % detik
x = [1.3133; 2.1269; 3.0486; 4.0181; 5.0067; ...
     6.0025; 7.0009; 8.0003; 9.0001; 10.0000];                        % meter
y = [2.9389; 4.7553; 4.7553; 2.9389; 0.0000; ...
    -2.9389; -4.7553; -4.7553; -2.9389; 0.0000];                      % meter
z = [2.8824; 3.5000; 5.0000; 9.5000; 17.0000; ...
     9.5000; 5.0000; 3.5000; 2.8824; 2.5769];                         % meter
n = length(t);

%% =====================================================================
%% BAGIAN i) INTERPOLASI BASIS NEWTON
%% =====================================================================
% Polinomial Newton derajat n-1 = 9:
%   p(t) = a0 + a1(t-t1) + a2(t-t1)(t-t2) + ... + a9 Π(t-ti)
% dengan a_k = f[t0,...,tk] (divided differences).

ax = newtonDividedDiff(t, x);
ay = newtonDividedDiff(t, y);
az = newtonDividedDiff(t, z);

fprintf('============================================================\n');
fprintf('  i) KOEFISIEN INTERPOLASI BASIS NEWTON (a_0 ... a_9)\n');
fprintf('============================================================\n');
fprintf('  k       a_k (x)            a_k (y)            a_k (z)\n');
for k = 1:n
    fprintf('  %d  %18.10f %18.10f %18.10f\n', k-1, ax(k), ay(k), az(k));
end

%% =====================================================================
%% BAGIAN ii) NATURAL CUBIC SPLINE
%% =====================================================================
% Pada tiap segmen [t_i, t_{i+1}]:
%   S_i(t) = a_i + b_i (t-t_i) + c_i (t-t_i)^2 + d_i (t-t_i)^3
% Kondisi natural: S''(t_1) = S''(t_n) = 0.

[asx, bsx, csx, dsx] = naturalCubicSpline(t, x);
[asy, bsy, csy, dsy] = naturalCubicSpline(t, y);
[asz, bsz, csz, dsz] = naturalCubicSpline(t, z);

fprintf('\n============================================================\n');
fprintf('  ii) KOEFISIEN NATURAL CUBIC SPLINE  S_i(t) per segmen\n');
fprintf('============================================================\n');
printSplineTable('x(t)', t, asx, bsx, csx, dsx);
printSplineTable('y(t)', t, asy, bsy, csy, dsy);
printSplineTable('z(t)', t, asz, bsz, csz, dsz);

%% =====================================================================
%% BAGIAN iii) VISUALISASI
%% =====================================================================
tt = linspace(t(1), t(end), 600)';
xN = evalNewton(tt, t, ax); yN = evalNewton(tt, t, ay); zN = evalNewton(tt, t, az);
xS = evalSpline(tt, t, asx, bsx, csx, dsx);
yS = evalSpline(tt, t, asy, bsy, csy, dsy);
zS = evalSpline(tt, t, asz, bsz, csz, dsz);

% Plot 3D
figure('Name','Lintasan 3D Drone','Color','w','Position',[100 100 900 700]);
plot3(xN, yN, zN, 'b-',  'LineWidth', 1.8); hold on; grid on;
plot3(xS, yS, zS, 'r--', 'LineWidth', 1.8);
plot3(x,  y,  z,  'ko', 'MarkerFaceColor','k','MarkerSize',7);
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
title('Lintasan 3D Drone: Newton vs Natural Cubic Spline');
legend('Newton','Natural Cubic Spline','Data Asli','Location','best');
view(45,25);

% Plot komponen x(t), y(t), z(t)
figure('Name','Perbandingan Komponen','Color','w','Position',[100 100 900 900]);
labels = {'x(t)','y(t)','z(t)'};
N = {xN,yN,zN}; S = {xS,yS,zS}; D = {x,y,z};
for k = 1:3
    subplot(3,1,k);
    plot(tt, N{k}, 'b-',  'LineWidth', 1.6); hold on;
    plot(tt, S{k}, 'r--', 'LineWidth', 1.6);
    plot(t,  D{k}, 'ko', 'MarkerFaceColor','k','MarkerSize',7);
    grid on; xlabel('t (detik)'); ylabel([labels{k} ' (m)']);
    title(['Komponen ' labels{k}]);
    legend('Newton','Natural Cubic Spline','Data Asli','Location','best');
end

%% =====================================================================
%% BAGIAN iv) PENERBANGAN KEDUA & ERROR NORM L-2
%% =====================================================================
% Data baru (5 titik acak) -- Tabel 3
t2 = [1.1; 3.2; 5.5; 7.8; 9.9];
x2 = [1.3873; 3.2400; 5.5041; 7.8004; 9.9001];
y2 = [3.1871; 4.5241; -1.5451; -4.9114; -0.3140];
z2 = [2.9254; 5.5377; 14.0000; 3.6968; 2.5998];

% Evaluasi dengan kedua metode
xN2 = evalNewton(t2, t, ax);  yN2 = evalNewton(t2, t, ay);  zN2 = evalNewton(t2, t, az);
xS2 = evalSpline(t2, t, asx,bsx,csx,dsx);
yS2 = evalSpline(t2, t, asy,bsy,csy,dsy);
zS2 = evalSpline(t2, t, asz,bsz,csz,dsz);

fprintf('\n============================================================\n');
fprintf('  iv) EVALUASI PADA TITIK PENERBANGAN KEDUA\n');
fprintf('============================================================\n');
fprintf('  t''  | xAkt   xNwt    xSpl   | yAkt   yNwt    ySpl   | zAkt    zNwt     zSpl\n');
for k = 1:length(t2)
    fprintf(' %4.1f | %6.4f %7.4f %7.4f | %7.4f %7.4f %7.4f | %7.4f %8.4f %8.4f\n', ...
        t2(k), x2(k), xN2(k), xS2(k), y2(k), yN2(k), yS2(k), ...
        z2(k), zN2(k), zS2(k));
end

% Error norm L-2 per komponen
exN = norm(xN2-x2); eyN = norm(yN2-y2); ezN = norm(zN2-z2);
exS = norm(xS2-x2); eyS = norm(yS2-y2); ezS = norm(zS2-z2);
totN = sqrt(exN^2 + eyN^2 + ezN^2);
totS = sqrt(exS^2 + eyS^2 + ezS^2);

fprintf('\n  ERROR NORM L-2\n');
fprintf('  %-12s %12s %15s\n','Komponen','Newton','Natural Spline');
fprintf('  %-12s %12.6f %15.6f\n','||e_x||_2', exN, exS);
fprintf('  %-12s %12.6f %15.6f\n','||e_y||_2', eyN, eyS);
fprintf('  %-12s %12.6f %15.6f\n','||e_z||_2', ezN, ezS);
fprintf('  %-12s %12.6f %15.6f\n','TOTAL', totN, totS);

%% =====================================================================
%% BAGIAN v) ANALISIS (kualitatif, dicetak sebagai informasi)
%% =====================================================================
fprintf('\n============================================================\n');
fprintf('  v) RINGKASAN ANALISIS\n');
fprintf('============================================================\n');
fprintf(['  - Polinomial Newton derajat 9 menghasilkan fenomena Runge\n', ...
         '    pada z(t) (osilasi besar di ujung interval), sehingga\n', ...
         '    error prediksi z meledak hingga ~%.2f m.\n'], ezN);
fprintf(['  - Natural Cubic Spline jauh lebih stabil; total error\n', ...
         '    %.4f m << %.4f m (Newton).\n'], totS, totN);
fprintf(['  - Rekomendasi: gunakan Natural Cubic Spline untuk\n', ...
         '    rekonstruksi lintasan drone.\n\n']);

% =======================================================================
%  FUNGSI-FUNGSI PENDUKUNG
% =======================================================================

function a = newtonDividedDiff(t, f)
% Hitung koefisien a_k = f[t0,...,tk] (divided differences).
    n = length(t);
    F = zeros(n,n);
    F(:,1) = f(:);
    for j = 2:n
        for i = 1:(n-j+1)
            F(i,j) = (F(i+1,j-1) - F(i,j-1)) / (t(i+j-1) - t(i));
        end
    end
    a = F(1,:).';                         % vektor kolom panjang n
end

function p = evalNewton(tq, t, a)
% Evaluasi polinomial Newton dengan skema Horner-bersarang.
    n = length(a);
    p = a(n) * ones(size(tq));
    for k = n-1:-1:1
        p = p .* (tq - t(k)) + a(k);
    end
end

function [a,b,c,d] = naturalCubicSpline(t, f)
% Bangun natural cubic spline. Kembalikan koefisien per segmen.
% Pada segmen i (i=1..n-1):
%   S_i(t) = a_i + b_i (t-t_i) + c_i (t-t_i)^2 + d_i (t-t_i)^3
    n = length(t);                       % jumlah titik
    h = diff(t);                         % panjang segmen
    
    % Sistem tridiagonal untuk M_i (di sini disimbolkan c_full, k=1..n)
    A   = zeros(n,n);
    rhs = zeros(n,1);
    A(1,1) = 1;  A(n,n) = 1;             % kondisi natural
    for i = 2:n-1
        A(i,i-1) = h(i-1);
        A(i,i)   = 2*(h(i-1) + h(i));
        A(i,i+1) = h(i);
        rhs(i)   = 3*((f(i+1)-f(i))/h(i) - (f(i)-f(i-1))/h(i-1));
    end
    cFull = A \ rhs;                     % cFull(1)=cFull(n)=0
    
    a = f(1:n-1);
    b = zeros(n-1,1);  d = zeros(n-1,1);
    for i = 1:n-1
        b(i) = (f(i+1)-f(i))/h(i) - h(i)*(2*cFull(i) + cFull(i+1))/3;
        d(i) = (cFull(i+1) - cFull(i))/(3*h(i));
    end
    c = cFull(1:n-1);
end

function v = evalSpline(tq, t, a, b, c, d)
% Evaluasi natural cubic spline pada vektor titik tq.
    v = zeros(size(tq));
    for k = 1:numel(tq)
        i = find(tq(k) >= t, 1, 'last');
        if isempty(i), i = 1; end
        if i >= length(t), i = length(t)-1; end
        dx = tq(k) - t(i);
        v(k) = a(i) + b(i)*dx + c(i)*dx^2 + d(i)*dx^3;
    end
end

function printSplineTable(name, t, a, b, c, d)
    fprintf('\n  --- Koefisien S(t) untuk %s ---\n', name);
    fprintf('   i   t_i        a_i            b_i            c_i            d_i\n');
    for i = 1:length(a)
        fprintf('  %2d  [%g,%g] %13.6f %13.6f %13.6f %13.6f\n', ...
            i, t(i), t(i+1), a(i), b(i), c(i), d(i));
    end
end