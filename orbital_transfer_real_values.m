clear; 
num_body = 2; 
inc_vel = false;
dec_vel = false;
G = 6.67408 * 10^-11;
M_earth = 5.972 * 10^24;
M_spaceship = 721.9; % mass of Voyager 1
M = [M_earth, M_spaceship]; 
X = [0 0 0; 500000 0 0];
init_pos = X(2,1);
V = [0 0 0; 0 sqrt(G*M(1)/X(2,1)) 0]; 
T = 4000;
dt = 2; 
clockmax = ceil(T/dt);

% desired specifications to get to another orbital radius 
r2 = 3000000;
% r2 = 384472282; %moon
r1 = X(2,1);
v1 = sqrt((2*G*M_earth*r2)/(r2*r1 + r1^2));


for num_frame = 1:clockmax
    t = num_frame * dt; 
    A = zeros(num_body, 3);
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
    X(1,:) = [0 0 0];
    plot3 (X(1,1), X(1,2), X(1,3), 'bo', 'MarkerSize', 30);
    hold on 
    plot3 (X(2,1), X(2,2), X(2,3), 'ko');
    hold on
%     plot (X(3,1), X(3,2), 'ro');
    axis ([-3100000 3100000 -3100000 3100000]);
%     axis equal;
%     daspect([1 1 1]);
    drawnow;
%     hold off;
    
    if ~inc_vel && X(2,2) > -20000 && X(2,2) < 20000 && X(2,1) > 0 && num_frame > 20 
        inc_vel = true;
        old_vel = V(2,2);
        V(2,:) = [0 v1 0];
        fprintf("Changed velocity from %d to : %d.\n", old_vel, V(2,2));
    elseif inc_vel && ~dec_vel && X(2,2) > -20000 && X(2,2) < 20000 && X(2,1) < 0
        dec_vel = true;
        old_vel = abs(V(2,2));
        V(2,:) = [0 -sqrt(G*M(1)/abs(X(2,1))) 0];
        fprintf("Changed velocity from %d to: %d\nRadius is now %d\n", old_vel, V(2,2), abs(X(2,1)));
    end
end