%% example of aggregation pipeline
% This software is distributed under the MIT License (MIT): see copyright.txt 

mm_java_driver                                          % ensure that MongoDB routines can be found

import com.mongodb.*

%% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
db  = m.getDB('matlab_mongodb');                    	% handle to database 'matlab_mongodb'
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' 

%{
this (example) pipeline will consist of a
match: 
    we select some documents 
project:
    we indicate which fields we want to keep
    and create a new calculated field
group:
    we indicate which grouping we want to do
    and calculate statistics on these groups
match:
    we select only some of the groups 
sort:
    we indicate which sorting we want to use
out: 
    we write the resulting documents to a new collection
%}

%% match
mtch1a = BasicDBObject('Description', ...               % first match:
    BasicDBObject('$ne','typeB')) ;                     % description different from 'typeB'
mtch1  = BasicDBObject('$match',  mtch1a) ;             % pipe-line command match
%% projection
prj1a = BasicDBObject() ;                               % start specifying projection
prj1a.put('_id',0) ;                                    % do not keep id
prj1a.put('Description',1) ;                            % keep 'Description'
prj1a.put('AccountNumber',1) ;                          % keep 'AccountNumber'
prj1a.put('TransactionAmount',1) ;                      % keep 'TransactionAmount'
%                                                       % start specifying new field
cnd1 = BasicDBObject() ;                                % start specifying condition
cnd2 = BasicDBList();                                   % start specifying comparison
cnd2.add('$TransactionAmount');                         % first element comparison
cnd2.add(0);                                            % second element comparison
cnd1.put('if', BasicDBObject('$lte',cnd2));             % condition 'if TransactionAmount <= 0'
cnd1.put('then', 'DB');                                 % then part ' then "DB'
cnd1.put('else', 'CR');                                 % else part ' then "CR'
prj1a.put('DC',  BasicDBObject('$cond', cnd1)) ;        % end specification of new field 'DC' 
prj1  = BasicDBObject('$project',  prj1a) ;            	% pipe-line command project
%% group
grp1a  = BasicDBObject() ;                            	% start specifying grouping
ids = BasicDBObject() ;                                 % start specifying keys
ids.put('AccountNumber','$AccountNumber');              % first key : (name to use, fieldname) 
ids.put('Description','$Description');                  % second key  
ids.put('DC','$DC');                                    % third key 
grp1a.put('_id',ids) ;                                  % add keys to grouping specification
grp1a.put('total', ...                                  % add operation to do on group:
    BasicDBObject('$sum','$TransactionAmount')) ;       %  result name, operator, fieldname
grp1a.put('count',BasicDBObject('$sum',1)) ;            % same
grp1a.put('avg', ...
    BasicDBObject('$avg','$TransactionAmount')) ;       % same
grp1a.put('max', ...
    BasicDBObject('$max','$TransactionAmount')) ;       % same
grp1 = BasicDBObject('$group',  grp1a) ;                % pipe-line command group
%% match
mtch2a = BasicDBObject('count',BasicDBObject('$gt',2)); % second match: count(group) > 2
mtch2  = BasicDBObject('$match',  mtch2a) ;             % pipe-line command match
%% sort
srt1a = BasicDBObject() ;                            	% start specifying sorting
srt1a.put('count',-1) ;                              	% sort on descending count (of group)
srt1a.put('max',1) ;                                 	% and within count on ascending max
srt1 = BasicDBObject('$sort',  srt1a) ;              	% pipe-line command sort
%% define pipeline
aggr_list = BasicDBList();                              % start specifying pipeline list                         
aggr_list.add(mtch1);                                   % add first match 
aggr_list.add(prj1);                                    % add projection
aggr_list.add(grp1);                                    % add grouping
aggr_list.add(mtch2);                                   % add second match
aggr_list.add(srt1);                                    % add sorting
%% do the actual aggregation according pipeline
ao  = col.aggregate(aggr_list);                         % create aggregation output
cur = ao.results().iterator();                          % cursor to results of the aggregation
fprintf('show aggregation results\n')
mm_cursor_showcontents( cur ) ; 
%% alternatively store the aggregation output in collection
out = BasicDBObject('$out',  'aggr_test') ;             % indicate name of collection to use           
aggr_list.add(out);                                     % add output handling to pipeline
col.aggregate(aggr_list);                               % do the aggregation (again)
% and check results
cur = db.getCollection('aggr_test').find() ;            % cursor to newly created collection
fprintf('output should be identical:\n')
mm_cursor_showcontents( cur ) ;                         % and show the contents of the collection
%% close connection
m.close() ;                                             % close connection