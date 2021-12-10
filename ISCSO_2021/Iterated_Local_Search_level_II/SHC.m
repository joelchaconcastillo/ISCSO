function [lBest, feval] = SHC(obj, feval)
   lBest=obj;
   file=obj.file;
   while feval < obj.maxeval
   for idxBar=1:obj.opt
%    idxBar = randi([1,obj.opt]);
    for k=1:obj.NeighbourSize
      idx = randi([1,obj.dim]);
      obj.X(idx)=idxBar;
    end
      obj = obj.evaluate();
      feval = feval+1;
      if obj.isBest(lBest)
         lBest=obj;
         %disp([lBest.StressV, lBest.DisV, lBest.W, feval])
         row=[lBest.StressV, lBest.DisV, lBest.W, feval];
	 save(file, 'row', '-ascii', '-append')
	 name = strcat(file, '_var');
	 X=obj.X;
	 save(name, 'X', '-ascii', '-append')
       else
         obj=lBest;
       end
    end%for
     end
end
