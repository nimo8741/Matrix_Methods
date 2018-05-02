function IEN_Master = FixIEN(IEN,P2,P3,P4,P5,Pall)

% First need to find the similar nodes between 2 and 1
IEN_2 = checkNodes(P2,P3,P4,P5,Pall,IEN,IEN,2);
IEN_Master = [IEN,IEN_2];
% now need to find the similar nodes between 3 and 1 followed by 3 and 2
IEN_3 = checkNodes(P2,P3,P4,P5,Pall,IEN,IEN_Master,3);
IEN_Master = [IEN_Master,IEN_3];
IEN_4 = checkNodes(P2,P3,P4,P5,Pall,IEN,IEN_Master,4);
IEN_Master = [IEN_Master,IEN_4];
IEN_5 = checkNodes(P2,P3,P4,P5,Pall,IEN,IEN_Master,5);
IEN_Master = [IEN_Master,IEN_5];


end
