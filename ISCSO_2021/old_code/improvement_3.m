function [feval, original, f_original, w_original, s_original, d_original ] = improvement_3(original_in, f_original_in, w_original_in, s_original_in, d_original_in, stress_penalization, displacement_penalization, NSizing_variables, lower, upper, feval_in, dim, maxite)

  current = original_in;
  f_current = f_original_in;
  w = w_original_in;
  s = s_original_in;
  d = d_original_in;

  original= original_in;
  f_original = f_original_in;
  w_original = w_original_in;
  s_original = s_original_in;
  d_original = d_original_in;

  feval = feval_in;
  improved = true;
  cont = 0;
  while cont < maxite
  current = original;

     %%perturb
   for i =1:3
      idx = randi([1,dim]);
      current(idx) = randi([lower(idx), upper(idx)]);
   end
    [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables );
    feval = feval+1;
        if f_current < f_original
	    f_original = f_current;
            original = current;
            w_original = w;
            s_original = s;
            d_original = d;
	    cont =0;
            row_v = [feval, f_original, w_original, s_original, d_original];
            save('history_improvement_3', 'row_v', '-ascii', '-append');
	else
	   cont = cont +1;
	end
end %%!while
end %%end function
 
