% Test script for Kmeans1D_optimised

clear all;

% Sample 1D data
X = [1, 2, 3, 10, 11, 12, 34, 35, 36, 100, 102, 104, 105];  %  obvious clusters
k = 4;                      % Number of clusters

% Call the function
[D, T] = Kmeans1D_optimised(X, k);

% Display results
disp('Cost matrix D:');
disp(D);

disp('Backtracking matrix T:');
disp(T);

% Optional: Reconstruct cluster boundaries
boundaries = zeros(1, k);
m = length(X);
for i = k:-1:2
    boundaries(i) = T(i, m);
    m = boundaries(i);
end
boundaries(1) = 1;

disp('Cluster boundaries:');
disp(boundaries);
