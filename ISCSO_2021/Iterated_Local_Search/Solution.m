classdef Solution
  properties
   StressV, DisV, W, X, model
   StressP=1, DisP=1; %% stress penalization, displacement penalization
   %%%%% problem definition, note that it might be apart
   dim=345;
   opt=37;
   lower= ones(1,345);
   upper=37*ones(1,345);
  end
  methods
     function res=restart(obj) %% I miss passing by reference!!! :'(
        obj.X = obj.lower + floor(rand(1,obj.dim).*(obj.upper-obj.lower));
	res=obj.evaluate();
     end
     function res=partialRestart(obj)
        idx = randi([1,obj.dim]);
        idxBar = randi([1,obj.opt]);
        obj.X(idx)= idxBar;
	res=obj.evaluate();
     end
     function res=evaluate(obj)
        res=obj;
	[res.model, res.W, res.StressV, res.DisV] = fitness(obj.X, obj.StressP, obj.DisP, obj.dim);
     end
     function cmp = isBest(obj1, obj2)
       if obj1.StressV < obj2.StressV
	  cmp = true;
       elseif obj1.StressV > obj2.StressV
	  cmp = false;
       else
	  if obj1.DisV < obj2.DisV
	     cmp = true;
          elseif obj1.DisV > obj2.DisV
	     cmp = false;
          else 
             if obj1.W < obj2.W
		cmp = true;
	     elseif obj1.W > obj2.W
		cmp = false;
	     else
		cmp = true;
	     end
	  end
       end 
     end %%%!end function
  end
end
