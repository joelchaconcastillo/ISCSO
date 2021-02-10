function [feval, original, f_original, w_original, s_original, d_original ] = improvement_1(original_in, f_original_in, w_original_in, s_original_in, d_original_in, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables, lower, upper, feval_in, dim, maxite, seed)
  
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


  delta = 1.0/37.0;
%  for ite =1:1
  improved = true;
  perm = dim:-1:1
  for k=1:maxite
  while improved
     improved = false;
        for j=1:dim%NSizing_variables
	 if improved
	   j = 1;	   
	   improved = false;
	 end

                i=perm(j)

                feval
         jump = 1;%floor((upper(i) - lower(i))*delta);
          f_original
              while current(i)-jump >= lower(i) 
               current(i) =  current(i)-jump;%max(lower(i), current(i)-1)
               [f_current, w, s, d ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
               feval = feval+1;
               if f_current< f_original
                   improved=true;
                   f_original = f_current;
                   original = current;
                   w_original = w;
                   s_original = s;
                   d_original = d;
                   row_v = [feval, f_original, w_original, s_original, d_original, original];
		   name = strcat('h-improv-1-', num2str(seed));
                   save(name, 'row_v', '-ascii', '-append');
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
                   improved=true;
                   f_original = f_current;
                   original = current;
                   w_original = w;
                   s_original = s;
                   d_original = d;
                   row_v = [feval, f_original, w_original, s_original, d_original, original];
		   name = strcat('h-improv-1-', num2str(seed));
                   save(name, 'row_v', '-ascii', '-append');
               else
                  current = original;
                  f_current = f_original;
                  break;
               end %% end if
             end  %end while
       end %% end for dim
  end %%end while
%    perm =  1:1:dim;
  end
end %%end function
 
