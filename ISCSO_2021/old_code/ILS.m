seed = 1
rand('seed', seed)
NSizing_variables = 345;
lower = [ ones(1,NSizing_variables)];
upper = [ 37*ones(1,NSizing_variables)];
Flag = 0;
maxeval = 200000;

dim = NSizing_variables
stress_penalization = 1000000000;
displacement_penalization = 1000000000;

%%%create a random solution...

best_solution_global = lower + floor(rand(1,dim).*(upper-lower));
[f_best_global, w_best_global, s_best_global, d_best_global ] = fitness(best_solution_global, stress_penalization, displacement_penalization, NSizing_variables);

best_local = best_solution_global;
f_best_local = f_best_global;
w_best_local = w_best_global;
s_best_local = s_best_global;
d_best_local = d_best_global;

feval = 1;
maxIteNoUpdate = 500;
cont = 0;
%H_fwsd = zeros(maxeval, 4)
while feval < maxeval
   current = best_local;
   %%%take one variable randomly
   idx = randi([1,dim]);
   %%%mutate variable
   current(idx) =randi([lower(idx), upper(idx)]);% randi([max(lower(idx), current(idx)-5), min(upper(idx),current(idx)+5)]);
   [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables );
   if f_current < f_best_local
      best_local = current;
      f_best_local = f_current;
      w_best_local = w;
      s_best_local = s;
      d_best_local = d;
      cont = 0;
   else
     cont = cont+1;
      if cont > maxIteNoUpdate
	rr = [best_local, best_solution_global];
        save('ILS_history_local_best', 'rr', '-ascii', '-append');
   	best_local(idx) = randi([max(lower(idx), best_local(idx)-5), min(upper(idx),best_local(idx)+5)]);
        [f_best_local, w_best_local, s_best_local, d_best_local ] = fitness(best_local, stress_penalization, displacement_penalization, NSizing_variables);
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
    save('ILS_history', 'row_v', '-ascii', '-append');
   end
   feval = feval+1;
end
name = strcat('Solution_', num2str(seed));;
save(name, 'best_solution_global', '-ascii', '-append');
