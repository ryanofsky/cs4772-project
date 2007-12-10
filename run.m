%%
clear
load('words.mat', '-ascii');
load('issues.mat', '-ascii');
issues = char(issues);
load('candidates.mat', '-ascii');
candidates = char(candidates);
load('colors.mat', '-ascii');
load('markers.mat', '-ascii');
markers = char(markers);

words = words + 1;

%%
%viz = compute_mapping(words, 'PCA', 2);
%viz = compute_mapping(words, 'KPCA', 2);
%viz = compute_mapping(words, 'MVU', 2, 12);

%%

A = calculateAffinityMatrix(words', 2, 1000);
G = convertAffinityToDistance(A);
neighbors = calculateNeighborMatrix(G, 12, 1);

%%
[Ysde, K, sdeEigVals, sdeScore] = sde(A, neighbors, 2);

%%
[Y, K, eigVals, mveScore] = mve(A, neighbors, 0.99, 2);

%%
clf
scatter_plot(Ysde, markers, colors)

%%
plotEmbedding(Ysde, neighbors, 'SDE embedding' ,36)

%%
scatter_plot(viz, markers, colors)

%%
scatter((1:size(viz,1))', viz(:,1))