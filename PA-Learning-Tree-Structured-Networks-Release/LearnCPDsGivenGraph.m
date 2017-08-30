function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: M x 10 x 3, M poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(dataset, 1);      % the number of samples
N = size(dataset, 2);      % the number of variables (e.g., the body parts)
D = size(dataset, 3);      % the dimension of each variable (e.g., the pose of each body part)
K = size(labels,2);        % the number of classes (e.g., human and alien)

loglikelihood = 0;
P.c = zeros(1,K);          % one of the parameters to learn, i.e., the prior of classes

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE

% the empirical prior distribution over labels (i.e., classes)
P.c = sum(labels)/size(labels,1); 

% Now we compute the parameters that are stored in structure P
% P.c is the prior of class distribution
% Other parameters are stored in P.clg, in which for Bayes Model:
%     P.clg(n).mu_y(k) is the mean of y of the nth variable that belongs to class k
%     P.clg(n).mu_x(k) is the mean of x of the nth variable that belongs to class k
%     P.clg(n).mu_angle(k) is the mean of angle of the nth variable that belongs to class k
%     P.clg(n).sigma_y(k) is the variance of y of the nth variable that belongs to class k
%     P.clg(n).sigma_x(k) is the variance of x of the nth variable that belongs to class k
%     P.clg(n).sigma_angle(k) is the variance of angle of the nth variable that belongs to class k
% and for CLG model:
%     The parameters of combinational linear Gaussian (i.e., the coefficients theta) are P.clg(n).theta(k),
%     which are used to compute the mean.
%     The variances are the same as in Bayes model.

for n = 1:N              % for every variable, dataset(:, n, k)
    for k = 1:K          % for every class
        if size(G,3) > 1                   % if G is of size 10x2x2, i.e., different graph structure for each class
            Gk = reshape(G(:,:,k), N, K);  % take the graph for the kth class
        else                               % if G is of size 10x2
            Gk = G;  
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