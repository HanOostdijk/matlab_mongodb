%% insert some test transaction data in a MongoDB collection
% This software is distributed under the MIT License (MIT): see copyright.txt 

mm_java_driver                                          % ensure that MongoDB routines can be found

import com.mongodb.*

% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
wc  = WriteConcern(1);                               	% indicate WriteConcern to use:    % com.mongodb.WriteConcern(1)
                    % 'Wait for acknowledgement, but don't wait for secondaries to replicate'
db  = m.getDB('matlab_mongodb');                    	% handle to a database (create if non-existing)
mm_drop_collection( db,'transactions' )              	% drop collection from this database
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' (create if non-existing)

% generate test mutations
mm_readxls(col,wc,[],[],true) ;                         % generate testdata 

%% read some documents to check if all went well
% (precise extraction of fields will be shown later)

cur = col.find('').skip(18).limit(5) ;                  % list 5 documents after skipping the first 18
fprintf('cursor contains %.0f documents\n',cur.size())
mm_cursor_showcontents( cur ) ;                         % show contents (later examples will extract document fields)
%% close connection
m.close() ;                                             % close connection