function EDMD = get_EDMD(X1, X2, U, basis)
% function to generate A B matrices using EDMD
% Inputs
% X1            : state trajecotries of n traj of length 1:m-1
% X2            : state trajecotries of n traj of length 2:m
% basis         : structure with properites of basis functions
% Outputs
% A             : n x N lifted Koopman operator
% C             : matrix to map lifted states z to original states x

X1_lift = [X1';basis(X1)];
X2_lift = [X2';basis(X2)];
N = size(X1_lift,1);
U = U';
EDMD.K = [X2_lift;U]*(pinv([X1_lift;U]));
EDMD.C = (X1')*pinv(X1_lift);
EDMD.A = EDMD.K(1:N,1:N);
EDMD.B = EDMD.K(1:N,N+1);

