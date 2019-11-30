NSizing_variables = 314;
NShape_variables = 14;
Sizing_Variables = randi(37,1, NSizing_variables);
Shape_variables = 9000 + randi(11000,1, NShape_variables);
lower = [ ones(1,NSizing_variables),  9000*ones(1,NShape_variables)];
upper = [ 37*ones(1,NSizing_variables), 20000*ones(1,NShape_variables)];
Flag = 10;
maxeval = 200000;

dim = NSizing_variables + NShape_variables;
stress_penalization = 1000000000;
displacement_penalization = 1000000000;

%%%create a random solution...

best_solution = lower + floor(rand(1,dim).*(upper-lower));
[f_best, w_best, s_best, d_best ] = fitness(best_solution, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
feval = 1;
%H_fwsd = zeros(maxeval, 4)
while feval < maxeval
   current = best_solution;
   %%%take one variable randomly
   idx = randi([1,dim]);
   %%%mutate variable
   current(idx) = randi([lower(idx), upper(idx)]);
   [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);

   if f_current < f_best
      best_solution = current;
      f_best = f_current;
      w_best = w;
      s_best = s;
      d_best = d;
   end
%   H_fwsd(feval, 1) = f_best;
%   H_fwsd(feval, 2) = w_best;
%   H_fwsd(feval, 3) = s_best;
%   H_fwsd(feval, 4) = d_best;
   row_v = [feval, f_best, w_best, s_best, d_best];
   save('ILS_history', 'row_v', '-ascii', '-append');
   feval = feval+1;
end

