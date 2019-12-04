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

%%%create a random solution...

best_solution_global = lower + floor(rand(1,dim).*(upper-lower));
[f_best_global, w_best_global, s_best_global, d_best_global ] = fitness(best_solution_global, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);

best_local = best_solution_global;
f_best_local = f_best_global;
w_best_local = w_best_global;
s_best_local = s_best_global;
d_best_local = d_best_global;

feval = 1;
maxIteNoUpdate = 100;
cont = 0;
check = false;
%H_fwsd = zeros(maxeval, 4)
	      disp('pp');
prev = f_best_local;
prev_value = best_local;

hi = sparse(15000, dim);

while feval < maxeval
   current = best_local;
   %%%take one variable randomly
   idx = randi([1,dim]);
   %%%mutate variable
   current(idx) = randi([lower(idx), upper(idx)]);
   [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);


   if f_current < f_best_local
      hi(floor(f_current),:) = current;
      if prev-f_current > 10000
	   prev = f_current;
	   prev_value = current;
      end

      best_local = current;
      f_best_local = f_current;
      w_best_local = w;
      s_best_local = s;
      d_best_local = d;
      if check && s == 0 && d == 0
	      feasible_solution = current;
	      f_feasible = f_current;
	      check = false;
	      disp('pp');
      end
      cont = 0;
   else
     cont = cont+1;
      if cont > maxIteNoUpdate
	rr = [best_local, best_solution_global];
        save('ILS_history_local_best', 'rr', '-ascii', '-append');
       % best_local= lower + floor(rand(1,dim).*(upper-lower));
       best_local = hi(floor(f_best_global)-10000, :);%prev_value;
        [f_best_local, w_best_local, s_best_local, d_best_local ] = fitness(best_local, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
	feval = feval +1;
	cont = 0;
      end
   end
   

   if f_best_local < f_best_global
      best_solution_global = best_local;
      f_best_global = f_best_local;
      w_best_global = w_best_local;
      s_best_global = s_best_local;
      d_best_global = d_best_local;
   end
      if mod(feval, 10)==0
    row_v = [feval, f_best_global, w_best_global, s_best_global, d_best_global, f_best_local, w_best_local, s_best_local, d_best_local];
    save('ILS_history_6', 'row_v', '-ascii', '-append');
   end
   feval = feval+1;
end
name = strcat('Solution_', num2str(seed));;
save(name, 'best_solution_global', '-ascii', '-append');
