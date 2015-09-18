function id = adddist;

global DistGlobals

if isempty(DistGlobals)
  DistGlobals = cell(1,1);
  id = 1;
else
  id = length(DistGlobals)+1;
  DistGlobals{id} = [];
end
