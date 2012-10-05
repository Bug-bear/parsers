function [ x_est ] = Kalman( RAW, Q, R )
% A simple one-dimensional kalman filter (as with the hardware implementation)
% output:  
    % x_est: generated estimation / forecast matrix
% input:
    % raw: newly obtained sample matrix (m samples * n channels)
    % Q and R: filter parameters
    

    % initiate vars
    [m,n] = size(RAW); % record matrix dimension
    x_est = zeros(m,n);

  for j = 1:n
    for i = 1:m
        % set initial estimate
        if i==1
            x_est_last = RAW(i,j); 
            P_last = 1;
            P_temp = 1;
        end
        
        % predicted
        P_temp = P_last + Q;
        K = P_temp /(P_temp + R);
        
        % correction
        x_est(i,j) = x_est_last + K * (RAW(i,j) - x_est_last); 
        P = (1- K) * P_temp;
        P_last = P;
        x_est_last = x_est(i,j);
    end
  end
    
end

