%% example of adding an array field 
javaaddpath('D:\data\magweg\MatLab\mongo-java-driver-3.0.2.jar')
% https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongodb-driver/3.0.2/
% downloaded 20jul2015

import com.mongodb.*

%% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
db  = m.getDB('matlab_mongodb');                    	% handle to database 'matlab_mongodb'
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' 

%% classification rules
% The field 'Description' will be used to classify the documents
% in various types according to the cell array 'classification'.
% The classification will be saved in the document in array field 'Tag'
% Because 'Tag' is an array it could hold more than one value, 
% but the '$slice' parameter will ensure that only the latest rule
% in 'classification' will be saved.
classification = { ...                                  % classification used 
    'peA', 'typeA'                                      % contains  'peA' => typeA
    'typeB', 'typeX'                                    % contains  'typeB' => typeX
    'typeC', 'typeX'                                    % contains  'typeC' => typeX
} ;
%% apply the classification
for  i=1:size(classification,1)                         % for each of the rules an update command is generated
                                                        % that (re-) defines a tag-field
% generate the query for the update                                                           
    reg = BasicDBObject() ;                             % empty object                  % com.mongodb.BasicDBObject                                          
    reg.put('$regex',classification{i,1}) ;             % indicate $regex operator with argument
    reg.put('$options','si') ;                          % indicate $regex options (i for case insensitive)
    query = BasicDBObject('Description', reg);          % complete query (on the field Description)
% generate the update command ($push)    
    tag   = classification{i,2} ;                       % tag field will get this value  
    keep_last   = BasicDBObject();                  	% parameters for $push
    ml          =  BasicDBList() ;                    	% empty list
    ml.add(tag) ;                                       % (only) add the contents for tag
    keep_last.put('$each',ml);                       	% indicate the values to insert (only one)
    keep_last.put('$slice',-1);                         % keep the last one only   
    pushcommand = BasicDBObject('$push', ...         	% push command for the field tag
        BasicDBObject('Tag', keep_last)) ;   
    x= col.update(query,pushcommand,0,1) ;              % update documents that satify the query with the push command
end
%% check if this went well (see mm_example_5.m)
aggr_list = BasicDBList();                              % start specifying pipeline list  
grp1a  = BasicDBObject() ;                            	% start specifying grouping
ids = BasicDBObject() ;                                 % start specifying keys
ids.put('Tag','$Tag');                                  % first key : (name to use, fieldname) 
grp1a.put('_id',ids) ;                                  % add keys to grouping specification
grp1a.put('count',BasicDBObject('$sum',1)) ;            % same
grp1 = BasicDBObject('$group',  grp1a) ;                % pipe-line command group                     
aggr_list.add(grp1);                                    % add grouping to pipeline list
cur = col.aggregate(aggr_list).results().iterator();  	% cursor to results of the aggregation
mm_cursor_showcontents( cur ) ; 


