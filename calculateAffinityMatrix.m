% Calculates affinity matrix (Linear kernel, RBF)
function [A] = calculateAffinityMatrix(X, affType, sigma)
    [D,N] = size(X);
    disp(sprintf('Calculating Distance Matrix'));
    
    A = zeros(N, N);
    
    if affType == 1
        disp(sprintf('Using Linear Kernel'));
        %A = X' * X; 
        A = cov(X);
    elseif affType == 2
        disp(sprintf('Using RBF Kernel'));
        A = zeros(N, N);
        R1 = X' * X;
        Z = diag(R1);
        R2 = ones(N, 1) * Z';
        R3 = Z * ones(N, 1)';
        A  = exp((1/sigma) * R1 - (1/(2*sigma)) * R2 - (1/(2*sigma)) * R3);
    end