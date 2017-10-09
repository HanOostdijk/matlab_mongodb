%% examples handling the result of the query
% This software is distributed under the MIT License (MIT): see copyright.txt 

mm_java_driver                                          % ensure that MongoDB routines can be found

import com.mongodb.*

%% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
db  = m.getDB('matlab_mongodb');                    	% handle to database 'matlab_mongodb'
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' 
%% retrieve some of the documents and extract fields
cur = col.find();                                       % cursor to all documents
cur = cur.skip(5).limit(4) ;                            % restrict this to documents 6, 7, 8 and 9
fmt = ['AccountNumber %.0f Currency %s ', ...           % format string
        'TransactionDate %.0f  InterestDate %.0f ', ...
      	'StartAmount %10.2f  ClosingAmount %10.2f ', ...
        'TransactionAmount %10.2f Description %s\n'] ;
while cur.hasNext()                                     % when more documents in cursor
    x = cur.next() ;                                   	% set cursor to next document and retrieve it 
    fprintf( fmt, ...                                   % print line with results
        x.get('AccountNumber') , ...                    % retrieving the fields of the document
    	x.get('Currency') , ...
 		x.get('TransactionDate') , ... 
    	x.get('InterestDate') , ...
    	x.get('StartAmount') , ...
    	x.get('ClosingAmount') , ...
    	x.get('TransactionAmount') , ...  
    	x.get('Description') ) ;       
end
%% retrieve some of the documents and extract fields
% alternative way using jsonlab
addpath('D:\data\matlab\jsonlab')
% http://www.mathworks.com/matlabcentral/fileexchange/
% 33381-jsonlab--a-toolbox-to-encode-decode-json-files-in-matlab-octave
%  05 Jun 2015

cur = col.find();                                       % cursor to all documents
cur = cur.skip(5).limit(4) ;                            % restrict this to documents 6, 7, 8 and 9
while cur.hasNext()                                     % when more documents in cursor
    x = cur.next() ;                                   	% set cursor to next document and retrieve it 
    x = loadjson(char(x.toString())) ;                  % convert BasicDBObject to structure (function from jsonlab)
    fprintf( fmt, ...                                   % print line with results
        x.AccountNumber , ...                           % retrieving the fields of the document
    	x.Currency , ...
 		x.TransactionDate , ... 
    	x.InterestDate , ...
    	x.StartAmount , ...
    	x.ClosingAmount , ...
    	x.TransactionAmount , ...  
    	x.Description ) ; 
end   
%% close connection
m.close() ;                                             % close connection
