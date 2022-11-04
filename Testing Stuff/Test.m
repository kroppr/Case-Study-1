x0 = [0 0 0 1 0 0 0];
t = 20;
data = [0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1;
        0 1 0 1];
f = @(x)siroutput(x,t,data);

A = [0 0 0 .99 .99 .99 .99];
b = 1;
Af = [0 0 0 1 1 1 1];
bf = 1;
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

x = fmincon(f,x0,A,b,Af,bf,lb,ub);