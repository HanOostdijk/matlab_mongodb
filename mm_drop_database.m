function mm_drop_database( m,database_name )
% drop database 
% This software is distributed under the MIT License (MIT): see copyright.txt 

%{
m                   : handle to MongoDB client
database_nam        : name of database that is to be removed
%}

cur_db = m.listDatabaseNames().iterator() ;             % cursor for database names
while cur_db.hasNext()                                 	% while more database names are available
    dbname = cur_db.next() ;                          	% next (name of) database
    if strcmp(dbname,database_name)                     % found the one we want to drop
        m.dropDatabase(database_name) ;                 % drop it (we are now sure it will not be created first)
        break                                           % no need to look any more
    end
end

end

