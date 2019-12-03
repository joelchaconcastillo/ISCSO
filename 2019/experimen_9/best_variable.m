function [best, f_best, w_best, s_best, d_best ] = best_variable(original, f_original, w_original, s_original, d_original, idx, low_d, up_d, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables)
  best = original;
  f_best = f_original;
  w_best = w_original;
  s_best = s_original;
  d_best = d_original;
  for d = low_d:up_d
    current = original;
    current(idx) = d;
   [f_current, w_current, s_current, d_current ] = fitness(current, stress_penalization, displacement_penalization, NSizing_variables, NShape_variables);
    if f_current < f_best
        f_best = f_current;
        best = current;
        w_best = w_current;
        s_best = s_current;
        d_best = d_current;
    end
  end
end
