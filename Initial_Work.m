%% Case Study 2

%An array for an SIRD model. In this case 90% of uninfected stay
%uninfected, the rest become infected. 80% of infected stay infected, 15%
%recover, 5% die. All recovered peoples stay recovered, and no zombies
%are allowed. The dead stay dead
%Column 1 equals uninfected population change, Column 2 infected pop
%change, Column 3 recovered pop change, Column 4 dead pop change.
Basic_Model = ...
    [0.9, 0, 0, 0;
    0.1, 0.80, 0, 0;
    0, 0.15, 1, 0;
    0, 0.05, 0, 1];

X = 1;

S = [1];
I = [0];
R = [0];
D = [0];


while S(length(S)) >= 0.01
    %S calculation
    S(length(S) + 1) = S(length(S)) * Basic_Model(1, 1) + I(length(I))*Basic_Model(1, 2) + R(length(R))*Basic_Model(1, 3) + D(length(D))*Basic_Model(1, 4);
    %I calculation
    I(length(I) + 1) = S(length(S)) * Basic_Model(2, 1) + I(length(I))*Basic_Model(2, 2) + R(length(R))*Basic_Model(2, 3) + D(length(D))*Basic_Model(2, 4);
    %R calculation
    R(length(R) + 1) = S(length(S)) * Basic_Model(3, 1) + I(length(I))*Basic_Model(3, 2) + R(length(R))*Basic_Model(3, 3) + D(length(D))*Basic_Model(3, 4);
    %D calculation
    D(length(D) + 1) = S(length(S)) * Basic_Model(4, 1) + I(length(I))*Basic_Model(4, 2) + R(length(R))*Basic_Model(4, 3) + D(length(D))*Basic_Model(4, 4);
end

figure()
hold on
plot(S);
plot(I);
plot(R);
plot(D);
title("SIRD model")
axis tight
legend(["S", "I", "R", "D"])


%Modified Model, in this case infected have a higher chance to no longer be
%infected, but now there is a chance they can be reinfected
Modded_Model = ...
[0.9, 0, 0.1, 0;
0.1, 0.8, 0, 0;
0, 0.15, 0.9, 0;
0, 0.05, 0, 1];

S = [1];
I = [0];
R = [0];
D = [0];

while S(length(S)) >= 0.01
    %S calculation
    S(length(S) + 1) = S(length(S)) * Modded_Model(1, 1) + I(length(I))*Modded_Model(1, 2) + R(length(R))*Modded_Model(1, 3) + D(length(D))*Modded_Model(1, 4);
    %I calculation
    I(length(I) + 1) = S(length(S)) * Modded_Model(2, 1) + I(length(I))*Modded_Model(2, 2) + R(length(R))*Modded_Model(2, 3) + D(length(D))*Modded_Model(2, 4);
    %R calculation
    R(length(R) + 1) = S(length(S)) * Modded_Model(3, 1) + I(length(I))*Modded_Model(3, 2) + R(length(R))*Modded_Model(3, 3) + D(length(D))*Modded_Model(3, 4);
    %D calculation
    D(length(D) + 1) = S(length(S)) * Modded_Model(4, 1) + I(length(I))*Modded_Model(4, 2) + R(length(R))*Modded_Model(4, 3) + D(length(D))*Modded_Model(4, 4);
end

figure()
hold on
plot(S);
plot(I);
plot(R);
plot(D);
axis tight
title("SIRD model with reinfections")
legend(["S", "I", "R", "D"])
