%% Load data
clear
load('words.mat', '-ascii');
load('colors.mat', '-ascii');
load('markers.mat', '-ascii');
load('legend_candidate_names.mat', '-ascii');
load('legend_candidate_colors.mat', '-ascii');
load('legend_issue_names.mat', '-ascii');
load('legend_issue_markers.mat', '-ascii');
markers = char(markers);
legend_candidate_names = char(legend_candidate_names);
legend_issue_names = char(legend_issue_names);
legend_issue_markers = char(legend_issue_markers);


%% Make vector representation
% compute document frequency for each word
IDF = log(size(words, 1) ./ sum(words > 0));
% normalize for document length
words = words ./ repmat(sum(words, 2), 1, size(words, 2));
% weight words by IDF
nwords = words .* repmat(IDF, size(words, 1), 1);


%% Do kernel PCA
viz = compute_mapping(words, 'KPCA', 2, 'gauss', 1);
scatter_plot(viz, markers, colors, 0, 0,...
             legend_candidate_names, legend_candidate_colors, ...
             legend_issue_names, legend_issue_markers);


%% Do SDE
A = calculateAffinityMatrix(words', 2, 1);
G = convertAffinityToDistance(A);
neighbors = calculateNeighborMatrix(G, 15, 1);
[viz, K, sdeEigVals, sdeScore] = sde(A, neighbors, 2);
%viz = compute_mapping(words, 'MVU', 2, 15);
scatter_plot(viz', markers, colors, 1, neighbors, ...
             legend_candidate_names, legend_candidate_colors, ...
             legend_issue_names, legend_issue_markers);


%% Do MVE
A = calculateAffinityMatrix(words', 2, 1);
G = convertAffinityToDistance(A);
neighbors = calculateNeighborMatrix(G, 15, 1);
[Y, K, eigVals, mveScore] = mve(A, neighbors, 0.99, 2);
scatter_plot(viz', markers, colors, 1, neighbors, ...
             legend_candidate_names, legend_candidate_colors, ...
             legend_issue_names, legend_issue_markers);