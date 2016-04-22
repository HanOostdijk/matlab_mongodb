%% list the database names and their collections
% This software is distributed under the MIT License (MIT): see copyright.txt 

mm_java_driver                                          % ensure that MongoDB routines can be found

import com.mongodb.*

%% make a connection with a local MongoDB client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client  % com.mongodb.MongoClient
wc  = WriteConcern(1);                               	% indicate WriteConcern to use:    % com.mongodb.WriteConcern 
                    % 'Wait for acknowledgement, but don't wait for secondaries to replicate'
                    
%% list for this client all database with collections and number of documents
cur_db = m.listDatabaseNames().iterator() ;             % cursor for database names
while cur_db.hasNext()                                 	% while more database names are available
    dbname = cur_db.next() ;                          	% next (name of) database
    db  = m.getDB(dbname);                              % handle to this database
    cur_coll = db.getCollectionNames().iterator();      % cursor for collection names for this database
    while cur_coll.hasNext()                        	% when more collection names are available
        colname = cur_coll.next() ;                   	% next (name of) collection
        col = db.getCollection(colname) ;             	% handle to collection
        cur_doc = col.find('') ;                        % cursor to all of its documents 
        fprintf(['database %-25s collection %-25s',...  % list database and collection name
            '# docs %.0f\n'], ...                       %   with number of documents
            dbname, colname, cur_doc.size());
    end
end
