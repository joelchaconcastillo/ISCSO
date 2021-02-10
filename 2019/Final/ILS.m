function ILS(seed)
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
   
   
   for i=2:500
      candidate_solution_global = lower + floor(rand(1,dim).*(upper-lower));
      [f_candidate_global, w_candidate_global, s_candidate_global, d_candidate_global ] = fitness(candidate_solution_global, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
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
   while feval < maxeval
   %   [feval, current, f, w, s, d ] = improvement_2(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables, lower, upper, feval, dim, 1000, seed);
      [feval, current, f, w, s, d ] = improvement_3(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables, lower, upper, feval, dim, maxIteNoUpdate, seed);
      [feval, current, f, w, s, d] = improvement_1(current, f, w, s, d, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables, lower, upper, feval, dim, 10, seed);
   
      if f < f_best_global
         best_solution_global = current;
         f_best_global = f;
         w_best_global = w;
         s_best_global = s;
         d_best_global = d;
      end
       row_v = [feval, f_best_global, w_best_global, s_best_global, d_best_global, f, w, s, d];
       name_h = strcat('main_hist_', num2str(seed));;

       save(name_h, 'row_v', '-ascii', '-append');
   
   end
   name = strcat('Solution_', num2str(seed));;
   save(name, 'best_solution_global', '-ascii', '-append');
end
