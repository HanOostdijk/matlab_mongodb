function mm_drop_collection( db,collection_name )
% This software is distributed under the MIT License (MIT): see copyright.txt 
% drop collection from database

%{
db                  : MongoDB database object
collection_name     : name of collection that is to be removed
%}

if db.collectionExists(collection_name)                 % if database contains collection mutations       
   db.getCollection(collection_name).drop;          	%  then remove it from database
end

end

