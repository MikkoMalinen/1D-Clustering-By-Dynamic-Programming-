% Clustering 1-dimensional data by dynamic programming
% Time complexity T = O(kN^2)
% Original code by AndreyS, modified by Mikko Malinen, 2025.

function [D, T] = Kmeans1D_optimised(X, k)
    n = length(X);
    if k > n
        error("Number of clusters can't be higher than number of points!");
    end

    D = zeros(k, n);
    T = zeros(k, n);

    % Ensimmäinen rivi D:stä ja prefix-summien laskenta
    cc_prev = 0;
    mu_prev = 0;
    X_prefix_sum = zeros(1, n);
    X_sq_prefix_sum = zeros(1, n);
    X_prefix_sum(1) = X(1);
    X_sq_prefix_sum(1) = X(1)^2;

    for m = 1:n
        if m > 1
            cc = cc_prev + (X(m) - mu_prev)^2 * (m - 1)  / m;
            mu_prev = (X(m) + (m - 1) * mu_prev) / m;
            cc_prev = cc;
            X_prefix_sum(m) = X_prefix_sum(m - 1) + X(m);
            X_sq_prefix_sum(m) = X_sq_prefix_sum(m - 1) + X(m)^2;
        else
            cc = 0;
        end
        D(1, m) = cc;
    end

    % Loput rivit D:stä
    for i = 2:k
        for m = i:n
            %D_ms = [0, D(i - 1, 1:(m - 1))];
            D_ms =  D(i - 1, 1:(m - 1));
            CC_ms = zeros(1, m - 1);
            for j = 1:(m - 1)
                CC_ms(j) = CC_from_prefix(X_prefix_sum, X_sq_prefix_sum, j, m);
            end
            ms = D_ms + CC_ms;
            [D(i, m), idx] = min(ms);
            T(i, m) = idx+1;   % +1 lisätty
        end
    end

    T = int32(T);
end




function s = sum_from_prefix(prefix_sums, l, r)
    % Laskee summan indekseiltä l...r-1 käyttäen prefix-summia
    if l == 1  %  == 0
        s = prefix_sums(r);
    else
        s = prefix_sums(r) - prefix_sums(l);
    end
end

function cc = CC_from_prefix(X_sums, X_sq_sums, l, r)
    % Laskee klusterin kustannuksen käyttäen prefix-summia
    sum_X = sum_from_prefix(X_sums, l, r);
    sum_X_sq = sum_from_prefix(X_sq_sums, l, r);
    mu = sum_X / (r - l+1); % +1 lisätty
    mu_sq = mu^2;
    cc = (r - l +1) * mu_sq - 2 * mu * sum_X + sum_X_sq;   % +1 lisätty
end
