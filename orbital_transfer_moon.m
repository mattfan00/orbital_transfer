clear; 
num_body = 3; 
inc_vel = false;
dec_vel = false;
G = 0.05;
M = [1000, 25, 1]; 
X = [0 0; 5 0; 1 0];
init_pos = X(2,1);
V = [0 0; 0 sqrt(G*M(1)/X(2,1)); 0 sqrt(G*M(1)/X(3,1))]; 
T = 20;
dt = 0.005; 
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
    plot (X(1,1), X(1,2), 'bo', 'MarkerSize', 10);
    hold on 
    plot (X(2,1), X(2,2), 'ko');
    hold on
    plot (X(3,1), X(3,2), 'ro');
    axis ([-7 7 -7 7]);
    daspect([1 1 1]);
    drawnow;
%     hold off;
    
    if ~inc_vel && X(3,2) > -0.05 && X(3,2) < 0.05 && num_frame > 100 
        inc_vel = true;
        old_vel = V(3,2);
        V(3,:) = [0, 9.045];
        fprintf("Increase velocity from %d to %d. Time is %d\n", old_vel, V(3,2), t);
    elseif inc_vel && ~dec_vel && X(3,2) > -0.01 && X(3,2) < 0.01 && X(3,1) < 0
        dec_vel = true;
        old_vel = abs(V(3,2));
        V(3,:) = [0 -sqrt(G*M(1)/abs(X(3,1)))];
        fprintf("Decrease velocity from %d to: %d\nRadius is now %d. Time is %d\n", old_vel, V(3,2), abs(X(3,1)), t);
    end
end
