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
f_best_local_G = f_best_global;
w_best_local = w_best_global;
s_best_local = s_best_global;
d_best_local = d_best_global;

P = sparse(28500, dim);

feval = 1;
maxIteNoUpdate = 1000;
cont = 0;
G = 0;
%H_fwsd = zeros(maxeval, 4)
while feval < maxeval
   current = best_local;
   %%%take one variable randomly
   for i=1:randi(3)
   idx = randi([1,dim]);
   current(idx) = randi([lower(idx), upper(idx)]);
   end
   [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
   G = 0;
   for j = 1:dim
	   i = int32(best_local(j)-lower(j)+1);
	   G = G+(1.0/(1.0+P(i, j)));
   end
   f_current_G = f_current + 100000*G;

   if f_current_G < f_best_local_G
      best_local = current;
      f_best_local_G = f_current_G;
      f_best_local = f_current;
      w_best_local = w;
      s_best_local = s;
      d_best_local = d;
      cont = 0;
   else
     cont = cont+1;
      if cont > maxIteNoUpdate %%%%%%%%%%%%%local optimum....
	for j = 1:dim
	   i = int32(best_local(j)-lower(j)+1);
	   P(i,j) = P(i,j) + 1.0;
	end
	rr = [best_local, best_solution_global];
        save('ILS_history_local_best_2', 'rr', '-ascii', '-append');
        %best_local= lower + floor(rand(1,dim).*(upper-lower));
        %[f_best_local, w_best_local, s_best_local, d_best_local ] = fitness(best_local, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
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
    save('ILS_history_2', 'row_v', '-ascii', '-append');
   end
   feval = feval+1;
end
name = strcat('Solution_', num2str(seed));;
save(name, 'best_solution_global', '-ascii', '-append');
