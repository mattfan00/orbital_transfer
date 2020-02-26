clear; 
num_body = 2; 
inc_vel = false;
dec_vel = false;
G = 0.1;
M = [1000, 100]; 
X = [0 0; 2 0];
init_pos = X(2,1);
V = [0 0; 0 sqrt(G*M(1)/X(2,1))]; 
T = 20;
dt = 0.01; 
clockmax = ceil(T/dt);

for num_frame = 1:clockmax
    t = num_frame * dt; 
    A = zeros(num_body, 2);
    for i = 1:num_body
        for j = 1:num_body
            if i ~= j
                DX = X(i,:) - X(j,:);
                R = sqrt(sum(DX.^2));
                acc = -G*M(j)/(R^3) * DX;
                A(i,:) = A(i,:) + acc; 
            end
        end
    end
    V = V + dt * A;
    X = X + dt * V;
    X(1,:) = [0 0];
    plot (X(1,1), X(1,2), 'bo', 'MarkerSize', 30);
    hold on 
    plot (X(2,1), X(2,2), 'ko');
    hold on
%     plot (X(3,1), X(3,2), 'ro');
    axis ([-7 7 -7 7]);
    drawnow;
%     hold off;
    
    if ~inc_vel && X(2,1) >= init_pos && num_frame > 50 
        inc_vel = true;
        fprintf("Increase velocity: %d\n", inc_vel);
        V(2,:) = V(2,:) + [0, 1];
    elseif inc_vel && ~dec_vel && X(2,2) > -0.1 && X(2,2) < 0.1 && X(2,1) < 0
        dec_vel = true;
        fprintf("Decrease velocity: %d\n", dec_vel);
        V(2,:) = [0 -sqrt(G*M(1)/abs(X(2,1)))];
    end
end
