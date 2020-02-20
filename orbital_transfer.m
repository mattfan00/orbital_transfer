clear; 
num_body = 3; 
G = 0.1;
M = [1000, 1, 100]; 
X = [0 0; 1 0; 5 0];
V = [0 0; 0 10; 0 4]; 
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
    plot (X(3,1), X(3,2), 'ro');
    axis ([-7 7 -7 7]);
    drawnow;
    hold off;
end
