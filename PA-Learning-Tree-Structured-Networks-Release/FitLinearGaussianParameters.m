function [Beta sigma] = FitLinearGaussianParameters(X, U)

% Estimate parameters of the linear Gaussian model:
% X|U ~ N(Beta(1)*U(1) + ... + Beta(n)*U(n) + Beta(n+1), sigma^2);

% Note that Matlab/Octave index from 1, we can't write Beta(0).
% So Beta(n+1) is essentially Beta(0) in the text book.

% X: (M x 1), the child variable, M examples. It is just one of the 3 dimensions of a pose.
% U: (M x N), N parent variables, M examples, assuming each child has only one parent variable.
% Beta: (N+1) x 1
% sigma: a scalar
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(U,1);
N = size(U,2);

Beta = zeros(N+1,1);
sigma = 1;

% collect expectations and solve the linear system
% A = [ E[U(1)],      E[U(2)],      ... , E[U(n)],      1     ; 
%       E[U(1)*U(1)], E[U(2)*U(1)], ... , E[U(n)*U(1)], E[U(1)];
%       ...         , ...         , ... , ...         , ...   ;
%       E[U(1)*U(n)], E[U(2)*U(n)], ... , E[U(n)*U(n)], E[U(n)] ]

% construct A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = zeros(N+1, N+1);
[E_U, sigmaU] =FitGaussianParameters(U);    % E_U is the mean of Ui of size 1xN
A(1,:) = [E_U, 1];          % the 1st row of A
A(:, end) = [1; E_U'];      % the last column of A

%       E[U(1)*U(1)], E[U(2)*U(1)], ... , E[U(n)*U(1]];
%       ...         , ...         , ... , ...         ;
%       E[U(1)*U(n)], E[U(2)*U(n)], ... , E[U(n)*U(n)]
crossproductU = zeros(N, N);  
for i = 1:M
   crossproductU = crossproductU + U(i, :)' .* U(i, :);  % U(i)*U(j)
end
A(2:end, 1:N) = crossproductU'/M;    % note that the index of elements of A is the transpose of normal matrix relative to U
%  A(2:N+1, 1:N) = mean(U .* U');

% B = [ E[X]; E[X*U(1)]; ... ; E[X*U(n)] ]

% construct B = x * U
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_XU = (X' * U)/M;  % E[x*U], 1xN
B = zeros(N+1, 1);  % (N+1)x1
B(1) = sum(X)/M;    % Equation (9): E[X] = Beta' * E[U]'
B(2:end) = E_XU';   % Equation (10): E[X *U(i)] = Beta' * E[U(i)*U(j)]

% solve A*Beta = B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Beta = A\B;         % Beta: (N+1)x1

% then compute sigma according to eq. (11) in PA description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_X2 = sum(X .* X)/M;   % E[X^2], a real number
E2_X = (sum(X)/M) ^2;   % (E[X])^2, a real number
CovX = E_X2 - E2_X;     % Cov[X], a real number

Cov_UiUj = crossproductU/M - E_U' * E_U;    % Cov[Ui;Uj]=E[Ui*Uj] - E[Ui]E[Uj], NxN
crossproductBeta = Beta(1:N) * (Beta(1:N))';  % NxN
sigma = sqrt(CovX - sum(sum(crossproductBeta .* Cov_UiUj)));  % Equation (11)

end