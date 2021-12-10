function [value, Weight, Const_Vio_Stress, Const_Vio_Disp] = fitness(X, stress_penalization, displ_penalization, NSizing_variables)
   Sizing_variables = X(1:NSizing_variables);
   [Weight,  Const_Vio_Stress,  Const_Vio_Disp] = ISCSO_2021(Sizing_variables,  0);
   value = Weight + stress_penalization*Const_Vio_Stress*Const_Vio_Stress + displ_penalization*Const_Vio_Disp*Const_Vio_Disp;
end
