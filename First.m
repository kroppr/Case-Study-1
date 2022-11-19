load ("lightField.mat");

%% Sample Plot
d = 0.1;
M = [1 d 0 0;
     0 1 0 0;
     0 0 1 d;
     0 0 0 1];

rays_in0 = [0 0 0 0 0;
           10 5 0 -5 -10;
           0 0 0 0 0;
           10 5 0 -5 -10];
rays_out0 = M*rays_in0;
rays_in10 = [10 10 10 10 10;
           10 5 0 -5 -10;
           10 10 10 10 10;
           10 5 0 -5 -10];
rays_out10 = M*rays_in10;
ray_z = [zeros(1,size(rays_in0,2)); d*ones(1,size(rays_in0,2))];

figure(1)
plot(ray_z, [rays_in0(1,:); rays_out0(1,:)], Color="r");
hold on;
plot(ray_z, [rays_in10(1,:); rays_out10(1,:)], Color="b");
hold off;

%% Light Field
img = rays2img(rays(1,:),rays(3,:),0.008,200);
figure(2);
hold on;
image(img);
colormap ("gray")
hold off;

new = M*rays;
img = rays2img(new(1,:),new(3,:),0.008,200);
figure(3);
hold on;
image(img);
colormap ("gray")
hold off;


%% Focus

d1 = 0.1;
d2 = 0.2;
f = 0.15;

M1= [1 d1 0 0;
     0 1 0 0;
     0 0 1 d1;
     0 0 0 1];
M2= [1 d2 0 0;
     0 1 0 0;
     0 0 1 d2;
     0 0 0 1];
Mf= [1 0 0 0;
     (-1/f) 1 0 0;
     0 0 1 0;
     0 0 (-1/f) 1];

rays_in0 = [0 0 0 0 0;
           10 5 0 -5 -10;
           0 0 0 0 0;
           10 5 0 -5 -10];
rays_out0M1 = M1*rays_in0;

rays_out0Mf = Mf*rays_out0M1;

rays_out0M2= M2*rays_out0Mf;

rays_in1 = [10 10 10 10 10;
           10 5 0 -5 -10;
           10 10 10 10 10;
           10 5 0 -5 -10];
rays_out1M1 = M1*rays_in1;

rays_out1Mf = Mf*rays_out1M1;

rays_out1M2 = M2*rays_out1Mf;

ray_z1 = [zeros(1,size(rays_in0,2)); d1*ones(1,size(rays_in0,2))];
ray_z2 = [d1*ones(1,size(rays_in0,2)); d2*ones(1,size(rays_in0,2))];

figure(4)
hold on;

plot(ray_z1, [rays_in0(1,:); rays_out0M1(1,:)], Color="r");
plot(ray_z1, [rays_in1(1,:); rays_out1M1(1,:)], Color="b");

plot(ray_z2, [rays_out0M1(1,:); rays_out0M2(1,:)], Color="r");
plot(ray_z2, [rays_out1M1(1,:); rays_out1M2(1,:)], Color="b");
hold off;


% rays_out1 = cat(2,rays_out0M1, rays_out1M1);
% rays_out2 = cat(2,rays_out0Mf, rays_out1Mf);
% rays_out3 = cat(2,rays_out0M2, rays_out1Mf);
% ray_z1 = [zeros(1,size(rays_in0,2)); d1*ones(1,size(rays_in0,2))];
% 
% figure(4)
%  hold on;
% plot(ray_z, [rays_in0(1,:); rays_out0M1(1,:)], Color="r");
% plot(ray_z, [rays_out0M1(1,:); rays_out1M1(1,:)], Color="b");
% hold off;