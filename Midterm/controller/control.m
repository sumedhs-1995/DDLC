function [t_log, x_log] = control(controller)

A = controller.A;
B = controller.B;
C = controller.C;

Q = controller.Q;
R = controller.R;

x0 = controller.x0;
Ts = controller.simulation_time;





if strcmp(controller.type,'State_Feedback')
    [X,K,L,info] = idare(A,B,Q,R,[],[]);
    if strcmp(controller.Koopman,'true')
        basis = controller.basis;
        % Simulate Feedback Controller
        z0 = [x0';basis(x0)];
        x_log = x0;
        t_log = 0;
        for t = 0:Ts
            z1 = A*z0 - B*K*z0;
            x_log = [x_log; (C*z1)'];
            t_log = [t_log; 0.1*t];
            z0 =z1;
        end
    else
        x_log = x0;
        t_log = 0;
        x0 =x0';
        for t = 0:Ts
            x1 = A*x0 - B*K*x0;
            x_log = [x_log; x1'];
            t_log = [t_log; 0.1*t];
            x0 =x1;
        end
    end
elseif strcmp(controller.type,'Model_Predictive_Control')
    system.A = A;
    system.B = B;
    system.C = C;
    system.n = size(A,2); % state dimension (or lifted state dim for koopman)
    system.p = size(B,2); % control dimension
    system.m = size(C,2); % output dimension

    % MPC Parameters
    mpc.dT = 0.1; % Discretization and simulation timestep
    mpc.N = 10; % prediction horizon

    % define MPC cost
    % stage cost (running cost): x'*Q*X + u'*R*u 
    % terminal cost: x'*P'x
    
    % (replace with cost for lifted states if using EDMD)
    % For this, use x = Cz and to obtain the cost
    
    mpc.Q = eye(size(A));
    mpc.R = eye(1,1);
    mpc.P = eye(size(A));

    

    if strcmp(controller.Koopman,'true')
        % input bounds
        % bounds.u_min = -2; 
        % bounds.u_max = 2;
        bounds.u_min = []; 
        bounds.u_max = [];
        
        % output bounds
        % bounds.y_min = [[-2;-2];basis([-2,-2])];
        % bounds.y_max = [[2;2];basis([2,2])];
        bounds.y_min = [];
        bounds.y_max = [];

        [F, G, A_ineq, B_ineq] = get_QP(system,mpc,bounds);

        % initialize
        basis = controller.basis;
        z0 = [x0';basis(x0)];
        % x0 = [1;1;1];  
        t = 0;
        
        % unpack info
        p = system.p;
        dT = mpc.dT;
        
        % data logging
        x_log = x0;
        t_log = 0;
        
        % simulation loop
        max_iter = 1000;
        z = z0;
        for i = 1:max_iter
        
            % get MPC controller
            U = do_MPC(G,z'*F',A_ineq,B_ineq,z);
            u = U(1:p);
            
            % simulate discrete time system
            % (replace with underlying nonlinear system and ode45 for Koopman MPC)
            z = A*z + B*u;
        
            % log data
            x = C*z;
            x_log = [x_log; x']; 
        
            
            % update sim time
            t = i*dT;
            t_log = [t_log;t];
        end
    else
        % input bounds
        % bounds.u_min = -2; 
        % bounds.u_max = 2;
        bounds.u_min = []; 
        bounds.u_max = [];
        
        % output bounds
        % bounds.y_min = [[-2;-2];basis([-2,-2])];
        % bounds.y_max = [[2;2];basis([2,2])];
        bounds.y_min = [];
        bounds.y_max = [];

        [F, G, A_ineq, B_ineq] = get_QP(system,mpc,bounds);
        x = x0';
        t = 0;
        
        % unpack info
        p = system.p;
        dT = mpc.dT;
        
        % data logging
        x_log = x0;
        t_log = 0;
        
        % simulation loop
        max_iter = 1000;
        for i = 1:max_iter
        
            % get MPC controller
            U = do_MPC(G,x'*F',A_ineq,B_ineq,x);
            u = U(1:p);
            
            % simulate discrete time system
            % (replace with underlying nonlinear system and ode45 for Koopman MPC)
            x = A*x + B*u;
        
            % log data
            x_log = [x_log; x'];
            % U_log = [U_log, u]; 
        
            
            % update sim time
            t = i*dT;
            t_log = [t_log;t];
        end
    end
else
    error('Invalid Controller Type')
end
end