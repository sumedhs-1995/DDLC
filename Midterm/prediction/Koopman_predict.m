function [X_pred, X_actual] = Koopman_predict(test_data, n_val, EDMD, basis)
dim=2;
indices = 1:2*dim+1:size(test_data,2);
trajectories = randsample(indices, n_val);
X_pred = [];
X_actual = [];
for i=1:n_val
    k = trajectories(i);
    X1 = test_data(:,k:k+1);
    X2 = test_data(:,k+2:k+3);
    U = test_data(:,k+4);

    X0 = X1(1,:);
    Z0 = [X0';basis(X0)];

    x_pred = [];
    for i = 1:length(X1)
        Z1 = EDMD.A*Z0 + EDMD.B*U(i,:);
        X2_hat = EDMD.C*Z1;
        Z0 = Z1;
        x_pred = [x_pred;X2_hat'];
    end
    X_pred = [X_pred, x_pred];
    X_actual = [X_actual, X2];
end
