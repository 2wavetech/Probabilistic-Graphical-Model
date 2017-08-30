function [P G loglikelihood] = LearnGraphAndCPDs(dataset, labels)

% dataset: M x 10 x 3, M poses represented by 10 parts in (y, x, alpha) 
% labels: M x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(dataset, 1);    % number of samples
N = size(dataset, 2);    % number of variables
D = size(dataset, 3);    % number of dimensions of each variable
K = size(labels,2);      % number of classes

G = zeros(10,2,K);       % graph structures to learn

% initialization
for k=1:K
    G(2:end,:,k) = ones(9,2);
end

% estimate graph structure for each class
for k=1:K
    % fill in G(:,:,k)
    % use ConvertAtoG to convert a maximum spanning tree to a graph G
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%
    data_of_class = dataset(find(labels(:, k) == 1), :, :);   % dataset for class k
    [A W] = LearnGraphStructure(data_of_class);               % tree structure of class k
    G(:, :, k) = ConvertAtoG(A);                              % convert max spanning tree to G structure
end

% estimate parameters

P.c = zeros(1,K);
% compute P.c
P.c = sum(labels)/size(labels,1); 

% the following code can be copied from LearnCPDsGivenGraph.m
% with little or no modification
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
U = G;
for n = 1:N              % for every variable, dataset(:, n, k)
    for k = 1:K          % for every class
        if size(U,3) > 1                   % if G is of size 10x2x2, i.e., different graph structure for each class
            Gk = reshape(U(:,:,k), N, K);   % take the graph for the kth class
        else                               % if G is of size 10x2
            Gk = U;  
        end
        data_of_class = dataset(find(labels(:, k) == 1), :, :);   % dataset for class k
        num_data = size(data_of_class, 1);                        % the size of the dataset for class k
        if Gk(n, 1) == 0  % if the nth variable does not have parent nodes, go with Naive Bayes Model
            [P.clg(n).mu_y(k), P.clg(n).sigma_y(k)] = FitGaussianParameters(data_of_class(:, n, 1)); % the y dimension of a pose
            [P.clg(n).mu_x(k), P.clg(n).sigma_x(k)] = FitGaussianParameters(data_of_class(:, n, 2)); % the x dimension of a pose
            [P.clg(n).mu_angle(k), P.clg(n).sigma_angle(k)] = FitGaussianParameters(data_of_class(:, n, 3)); % the alpha dimension of a pose
        else     % go with CLG Model if G(n, 1) == 1. Note that G(n, 2) has the parent node of variable n. We should squeeze parent U from 10x1x3 to 10x3
            [theta_y, P.clg(n).sigma_y(k)] = FitLinearGaussianParameters(data_of_class(:, n, 1), reshape(data_of_class(:, Gk(n, 2), :), num_data, D));
            [theta_x, P.clg(n).sigma_x(k)] = FitLinearGaussianParameters(data_of_class(:, n, 2), reshape(data_of_class(:, Gk(n, 2), :), num_data, D));
            [theta_angle, P.clg(n).sigma_angle(k)] = FitLinearGaussianParameters(data_of_class(:, n, 3), reshape(data_of_class(:, Gk(n, 2), :), num_data, D));
            
            % move beta(n+1) to beta(0) because it seems that FitLinearGaussianPatameters() returns beta in a different order
            P.clg(n).theta(k, 1:4) = [theta_y(end), theta_y(1:end-1)'];
            P.clg(n).theta(k, 5:8) = [theta_x(end), theta_x(1:end-1)'];
            P.clg(n).theta(k, 9:12) = [theta_angle(end), theta_angle(1:end-1)'];
        end
    end
end

loglikelihood = ComputeLogLikelihood(P, G, dataset);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('log likelihood: %f\n', loglikelihood);

end