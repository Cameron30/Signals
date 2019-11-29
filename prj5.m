%Assigning variables
Vm = 1;
T = 1;
t = -1*T:.001:3*T;
V = t;
V = V * 0;

%creating all non-zero terms
for i = -1 : 3
    for k = 1 : length(t)
        if t(k) < i - 2/3 && t(k) >= i - 1
            V(k) = Vm*sin(3*pi*t(k)/T);
        elseif t(k) >= i - 2/3 && t(k) < i - 1/3
            V(k) = -2*Vm*sin(3*pi*t(k)/T);
        elseif t(k) < i && t(k) >= i - 1/3
            V(k) = Vm*sin(3*pi*t(k)/T);
        end
    end
end

%force positive
for j = 1 : length(V)
    if V(j) < 0
        V(j) = V(j) * -1;
    end
end

%Plotting
plot(t, V);
xlabel({'Time (t)'});
ylabel({'Voltage (V(t))'});