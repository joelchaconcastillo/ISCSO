function [lBest, feval] = SHC(obj, feval)
   lBest=obj;
   file=obj.file;
   sizes=[4, 4, 4, 4, 4, 4, 4, 9,10, 100];
   cont=0;
   while feval < obj.maxeval && cont < 1000
   for idxBar=1:obj.opt
%    idxBar = randi([1,obj.opt]);
    N = sizes(randi([1, 10]));
    for k=1:N
      idx = randi([1,obj.dim]);
      obj.X(idx)=idxBar;
    end
      obj = obj.evaluate();
      feval = feval+1;
      cont=cont+1;
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
