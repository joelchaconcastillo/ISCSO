X1=load('Final/h-improv-2-12')
%for i=450:500
X=X1(523,6:275);
NSizing_variables = 260;
NShape_variables = 10;
dim=270;
%X(1:NSizing_variables) = 37;
lower = [ ones(1,NSizing_variables),  -25000*ones(1,NShape_variables)];
upper = [ 37*ones(1,NSizing_variables), 3500*ones(1,NShape_variables)];
%pause(10);
E = zeros([1000, 3]);
%X = lower + floor(rand(1,dim).*(upper-lower));
%for i=1:1000
%X(261:270) = lower(261:270) + floor(rand(1,10).*(upper(261:270)-lower(261:270)));

Sizing_variables = X(1:NSizing_variables);
Shape_variables = X((NSizing_variables+1):(NSizing_variables+NShape_variables));

[Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2019(Sizing_variables, Shape_variables,  1);
%E(i, 1) = Const_Vio_Stress;
%E(i, 2) = Const_Vio_Disp;
%end

%plot(X(1:260));
%plot(X(261:270));

%pause(1);

%end