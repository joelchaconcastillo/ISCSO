function [out_solution, out_params ] = ILS(best_solution_global, params_best_global, NSizing_variables, NShape_variables, lower, upper, Flag, maxeval, maxIteNoUpdate, dim, stress_penalization, displacement_penalization)

best_local = best_solution_global;
params_best_local = params_best_global;

feval = 1;
cont = 0;
%H_fwsd = zeros(maxeval, 4)
while feval < maxeval
   current = best_local;
   for i = 1:randi(4)
      idx = randi([1,dim]);
      current(idx) = randi([lower(idx), upper(idx)]);
   end
   params_current = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
   if params_current(1) < params_best_local(1)
      best_local = current;
      params_best_local = params_current;
      cont = 0;
   else
     cont = cont+1;
      if cont > maxIteNoUpdate
	rr = [best_local, best_solution_global];
        save('ILS_history_local_best', 'rr', '-ascii', '-append');
        best_local= lower + floor(rand(1,dim).*(upper-lower));
        params_best_local = fitness(best_local, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
	feval = feval +1;
	cont = 0;
      end
   end
   

   if params_best_local(1)< params_best_global(1)
      params_best_global= params_best_local;
      best_solution_global = best_local;
   end
   %   if mod(feval, 10)==0
%    row_v = [feval, f_best_global, w_best_global, s_best_global, d_best_global, f_best_local, w_best_local, s_best_local, d_best_local];
 %   save('ILS_history', 'row_v', '-ascii', '-append');
  % end
   feval = feval+1;
end
%name = strcat('Solution_', num2str(seed));;
%save(name, 'best_solution_global', '-ascii', '-append');
 out_solution = best_solution_global;
 out_params = params_best_global;
end
