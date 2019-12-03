seed = 1
rand('seed', seed)
NSizing_variables = 260;
NShape_variables = 10;
lower = [ ones(1,NSizing_variables),  -25000*ones(1,NShape_variables)];
upper = [ 37*ones(1,NSizing_variables), 3500*ones(1,NShape_variables)];
Flag = 0;
maxeval = 200000;

dim = NSizing_variables + NShape_variables;
stress_penalization = 1000000000;
displacement_penalization = 1000000000;
N = 10; %%population size...
maxiteLS = 50;
population = zeros(N, dim);
fitness_parent = zeros(N, 4);
children= zeros(N, dim);
fitness_children= zeros(N, 4);

%%%Initialization
for i =1:N
   parent(i,:) = lower + floor(rand(1,dim).*(upper-lower));
   fitness_parent(i,:) = fitness(parent(i,:), stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
   fitness_parent(i,:)
   [parent(i,:), fitness_parent(i,:)] = ILS(parent(i,:), fitness_parent(i,:), NSizing_variables, NShape_variables, lower, upper, Flag, maxiteLS, maxiteLS, dim, stress_penalization, displacement_penalization);
   fitness_parent(i,:)
end

best_solution = parent(1,:);
f_best_solution = fitness_parent(1,:);


%%%start loop
maxeval/(N*maxiteLS)
for g =1:(maxeval/(N*maxiteLS))
	g
 for i =1:N
   p1 = 0;
   p2 = 0;
   %Parent selection binrary-tournament
   idx1 = randi([1,N]);
   idx2 = randi([1,N]);
   if fitness_parent(idx1, 1) < fitness_parent(idx2, 1)
	   p1 = idx1;
   else
	   p1 = idx2;
   end
   idx1 = randi([1,N]);
   idx2 = randi([1,N]);
   if fitness_parent(idx1, 1) < fitness_parent(idx2, 1)
	   p2 = idx1;
   else
	   p2 = idx2;
   end
   %%crossover..
   %%one-point crossover
   idx_cut = randi([1, dim]);
   for d =1:dim
      if d < idx_cut
        children(i, d) = parent(p1, d);
      else
        children(i, d) = parent(p2, d);
      end
   end
   %%%mutation
   idx = randi([1,dim]);
   children(i, idx) = randi([lower(idx), upper(idx)]);
   fitness_children(i,:) = fitness(children(i,:), stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
   fitness_children(i,:)
   [children(i,:), fitness_children(i,:)] = ILS(children(i,:), fitness_children(i,:), NSizing_variables, NShape_variables, lower, upper, Flag, maxiteLS, maxiteLS, dim, stress_penalization, displacement_penalization);

   fitness_children(i,:)
   %fitness_children(i,:)
 end %%end population
 %%elitism...
 for i=1:N
   if fitness_parent(i,1) < f_best_solution(1)
	   best_solution = parent(i,:);
	   f_best_solution = fitness_parent(i,:);
   end
   if fitness_children(i,1) < f_best_solution(1)
	   best_solution = children(i,:);
	   f_best_solution = fitness_children(i,:);
   end
 end %%end elitism
 f_best_solution
 parent = children;
 fitness_parent = fitness_children;
 parent(1,:) = best_solution;
 fitness_parent(1,:) = f_best_solution;
 save('GA_history', 'f_best_solution', '-ascii', '-append');
 %%
end %%end generaitons..

%name = strcat('Solution_', num2str(seed));;
%save(name, 'best_solution_global', '-ascii', '-append');
