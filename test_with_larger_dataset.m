% Generate synthetic 1D data with 3 clusters
rng(42);  % For reproducibility
X1 = randn(1, 100) * 2 + 10;   % Cluster around 10
X2 = randn(1, 100) * 1 + 30;   % Cluster around 30
X3 = randn(1, 100) * 1.5 + 50; % Cluster around 50
X = [X1, X2, X3];
X = sort(X);  % Sorting is important for 1D K-means

k = 3;  % Number of clusters

% Run the clustering algorithm
[D, T] = Kmeans1D_optimised(X, k);

% Reconstruct cluster boundaries
boundaries = zeros(1, k);
m = length(X);
for i = k:-1:2
    boundaries(i) = T(i, m); 
    m = boundaries(i);   
end
boundaries(1) = 1;

% Display boundaries
disp('Cluster boundaries (indices):');
disp(boundaries);

% Plot the data and cluster boundaries
figure;
plot(X, 'bo');
hold on;
for b = boundaries(2:end)
    xline(b, '--r', 'LineWidth', 1.5);
end
title('1D K-means Clustering with k=3');
xlabel('Index');
ylabel('Value');
legend('Data Points', 'Cluster Boundaries');
grid on;
