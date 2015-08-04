%% examples of queries on a collection

javaaddpath('D:\data\magweg\MatLab\mongo-java-driver-3.0.2.jar')
% https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongodb-driver/3.0.2/
% downloaded 20jul2015

import com.mongodb.*

%% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
db  = m.getDB('matlab_mongodb');                    	% handle to database 'matlab_mongodb'
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' 
%% retrieve all documents of 'transactions' in full
cur = col.find();                                       % cursor to all documents
% cur = cur.skip(5).limit(4) ;                       	% restrict this to documents 6, 7, 8 and 9
fprintf('number of documents %.0f\n',cur.size());       % number of documents the cursor points to
mm_cursor_showcontents( cur ) ;                         % show contents (later examples will extract document fields)
%% retrieve all documents (only TransactionDate and TransactionAmount)
proj = BasicDBObject();                                 % create projection
proj.put('TransactionDate', 1);                         % include Transactionate
proj.put('TransactionAmount', 1);                    	% include TransactionAmount
proj.put('_id', 0);                                     % exclude document id
cur = col.find([],proj);                                % cursor to all documents (only fields in projection)
%% same but sort by date and within date by amount
sort_spec = BasicDBObject();  
sort_spec.put('TransactionDate', 1);                    % TransactionDate ascending
sort_spec.put('TransactionAmount', -1);              	% TransactionAmount descending
cur = cur.sort(sort_spec) ;                             % elements in cursor now sorted
mm_cursor_showcontents( cur ) ;                         % show contents
%% retrieve documents with TransactionAmount > 4000
query = BasicDBObject('TransactionAmount',  ...         % create selection
    BasicDBObject('$gt', 4000)) ;
cur = col.find(query,proj);                             % cursor to result of selection and (previous) projection
mm_cursor_showcontents( cur ) ;                         % show contents
%% retrieve documents with 4000<TransactionAmount<4500
gt4000 = BasicDBObject('TransactionAmount',  ...     	% create first selection clause: TransactionAmount > 4000
                    BasicDBObject('$gt', 4000)) ;
lt4500 = BasicDBObject('TransactionAmount',  ...     	% create another selection clause: TransactionAmount < 4500
                    BasicDBObject('$lt', 4500)) ;    
list = BasicDBList();                                   % create empty list
list.add(gt4000);                                       % insert the first clause
list.add(lt4500);                                       % insert second clause
query = BasicDBObject('$and', list);                    % combine: (TransactionAmount > 4000) & (TransactionAmount < 4500)
cur = col.find(query,proj);                             % cursor to results of this query
mm_cursor_showcontents( cur ) ;                         % show contents
