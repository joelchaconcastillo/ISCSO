seed = 1
rand('seed', seed)
NSizing_variables = 345;
lower = [ ones(1,NSizing_variables)];
upper = [ 37*ones(1,NSizing_variables)];
Flag = 0;
maxeval = 200000;

dim = NSizing_variables ;
stress_penalization = 1000000000;
displacement_penalization = 1000000000;

%%%create a random solution...

best_solution_global = lower + floor(rand(1,dim).*(upper-lower));
[f_best_global, w_best_global, s_best_global, d_best_global ] = fitness(best_solution_global, stress_penalization, displacement_penalization, NSizing_variables);


for i=2:500
   candidate_solution_global = lower + floor(rand(1,dim).*(upper-lower));
   [f_candidate_global, w_candidate_global, s_candidate_global, d_candidate_global ] = fitness(candidate_solution_global, stress_penalization, displacement_penalization, NSizing_variables );
      if f_candidate_global < f_best_global 
	best_solution_global = candidate_solution_global;
      	f_best_global = f_candidate_global;
	w_best_global = w_candidate_global;
	s_best_global = s_candidate_global;
	d_best_global = s_candidate_global;
      end
end

current = best_solution_global;
f = f_best_global;
w = w_best_global;
s = s_best_global;
d = d_best_global;

feval = 500;
maxIteNoUpdate = 1000;
cont = 0;
%H_fwsd = zeros(maxeval, 4)
while 1%feval < maxeval
%   [feval, current, f, w, s, d ] = improvement_2(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, lower, upper, feval, dim, 1000);
   [feval, current, f, w, s, d ] = improvement_3(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, lower, upper, feval, dim, maxIteNoUpdate);
   [feval, current, f, w, s, d] = improvement_1(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, lower, upper, feval, dim, 10);

   if f < f_best_global
      best_solution_global = current;
      f_best_global = f;
      w_best_global = w;
      s_best_global = s;
      d_best_global = d;
   end
    row_v = [feval, f_best_global, w_best_global, s_best_global, d_best_global, f, w, s, d];
    save('ILS_history_5', 'row_v', '-ascii', '-append');

end
name = strcat('Solution_', num2str(seed));;
save(name, 'best_solution_global', '-ascii', '-append');
