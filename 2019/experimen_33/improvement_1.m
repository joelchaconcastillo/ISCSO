function [feval, f_original, w_original, s_original, d_original ] = improvement_1(original, f_original, w_original, s_original, d_original, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables, lower, upper, feval_in, dim)
  current = original;
  f_current = f_original;
  w = w_original;
  s = s_original;
  d = d_original;
  feval = feval_in;
  delta = 1.0/37.0;
  for ite =1:1
     %perm = randperm(dim);
     for j=1:NSizing_variables
	     i=j%perm(j);
	     feval
      jump = 1;%floor((upper(i) - lower(i))*delta);
       f_original
       while current(i)-jump >= lower(i) 
        current(i) =  current(i)-jump;%max(lower(i), current(i)-1)
        [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
	feval = feval+1;
        if f_current< f_original 
            f_original = f_current;
            original = current;
            w_original = w;
            s_original = s;
            d_original = d;
        else
           current = original;
           f_current = f_original;
           break;
        end
       end

       while current(i)+jump <= upper(i) 
        current(i) =  current(i)+jump;%max(lower(i), current(i)-1)
        [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
	feval = feval+1;
        if f_current < f_original 
            f_original = f_current;
            original = current;
            w_original = w;
            s_original = s;
            d_original = d;
        else
           current = original;
           f_current = f_original;
           break;
	end %% end if
      end  %end while
    end %% end for dim
  end %%end for ite
end %%end function
 
