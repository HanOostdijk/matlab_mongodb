%% example of map reduce
% This software is distributed under the MIT License (MIT): see copyright.txt 
javaaddpath('D:\data\magweg\MatLab\mongo-java-driver-3.0.2.jar')
% https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongodb-driver/3.0.2/
% downloaded 20jul2015

import com.mongodb.*

%% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
db  = m.getDB('matlab_mongodb');                    	% handle to database 'matlab_mongodb'
col = db.getCollection('transactions') ;             	% handle to collection 'transactions' 

%% define map and reduce function (in javascript)

mapper = [ ...
   ' function () {                                                              ' , ...
   '  var dc = ''C''  ;                                                         ' , ...
   '  if (this.TransactionAmount < 0) { dc = ''D'';}                            ' , ...
   '  emit( {AccountNumber : this.AccountNumber, Tag : this.Tag, DC : dc } ,    ' , ...
   '  {Value : this.TransactionAmount, Count : 1} );                            ' , ...
   ' }                                                                          ' , ...
         ] ;

reducer = [ ...
    ' function (key, values) {                      ' , ...
    ' var total = 0.0; var count = 0.0 ;        	' , ...
    ' for (var i = 0; i < values.length; i++) {     ' , ...
    ' total += values[i].Value;                   	' , ...                
    ' count += values[i].Count;                   	' , ...
    ' }                                             ' , ...
    ' return {Value : total, Count : count};     	' , ...
    ' }                                             ' , ...
             ] ;

REPLACE = javaMethod('valueOf', ...                     % pickup enumeration value
     'com.mongodb.MapReduceCommand$OutputType', ...
     'REPLACE');
mpc     = MapReduceCommand( ...                         % construct the map-reduce command
     col, ...                                           % input collection
     mapper, ...                                        % map - function
     reducer, ...                                       % reduce - function
     'temp', ...                                        % name of output collection
     REPLACE, ...                                       % overwrite (don't merge) output collection
     BasicDBObject()) ;                                 % input query (none so all documents) 
col2    = col.mapReduce(mpc ).getOutputCollection() ; 	% execute the map-reduce and point to 
                                                        % output collection (with name 'temp') 
cur1 = col2.find('') ;                                  % cursor to map-reduce results
%% alternative method when no new collection is needed
%{
INLINE = javaMethod('valueOf', ...                      % pickup enumeration value
     'com.mongodb.MapReduceCommand$OutputType', ...
     'INLINE');
mpc = MapReduceCommand(col,mapper,reducer,[], ...       % construct the map-reduce command (see above)
     INLINE,BasicDBObject()) ;                          % without saving the results in new collection 
cur1  =  col.mapReduce(mpc ).results().iterator();      % execute the map-reduce and retrieve cursor
%}
%% first method to retrieve values: 
%   use BasicDBObject methods
while cur1.hasNext()                                    % when more data is available
    x               = cur1.next() ;                  	% contents of  next document
    x0x5F_id        = x.get('_id') ;                 	% (composite) key field
    AccountNumber   = x0x5F_id.get('AccountNumber') ;   % unpack first key   
    Tag             = x0x5F_id.get('Tag') ;             % unpack second key
    DC              = x0x5F_id.get('DC') ;              % unpack last key
    if isa(Tag,'org.bson.BsonUndefined')                % when Tag was not filled
        Tag = '-' ;                                     %  indicate so with '-'
    else 
        Tag = Tag.get(0);                               % else get the first (!) value of the array field
    end
    Amount = x.get('value').get('Value') ;              % get Value from (composite) data field
    Count  = x.get('value').get('Count') ;              % get Count from (composite) data field
    fprintf(['AccountNumber %.0f  Tag %s DC %s ', ...   % contents of result document
        'Count %3.0f TransactionAmount %10.2f\n'], ...
        AccountNumber, Tag, DC, Count, Amount)
end
cur1.close()
%% second method to retrieve values:  
%   json -> struct method
addpath('D:\data\matlab\jsonlab')
% http://www.mathworks.com/matlabcentral/fileexchange/
% 33381-jsonlab--a-toolbox-to-encode-decode-json-files-in-matlab-octave
%  05 Jun 2015
cur2 = col2.find('') ;                                  % cursor to map-reduce results
while cur2.hasNext()                                    % when more data is available
    x               = cur2.next() ;                     % contents of  next document
    jres            = loadjson(char(x.toString()));  	% convert to structure (jsonlab)
    key             = jres.x0x5F_id ;                 	% structure with mapreduce key
    value           = jres.value ;                  	% structure with mapreduce value
    AccountNumber   = key.AccountNumber ;               % unpack AccountNumber 
    DC              = key.DC ;                          % unpack DC 
    if isstruct(key.Tag)                                % unpack Tag 
        Tag         = '-' ;
    else 
        Tag         = key.Tag{1};
    end
    Amount          = value.Value ;                  	% unpack Amount
    Count           = value.Count ;                   	% unpack Count
    fprintf(['AccountNumber %.0f  Tag %s DC %s ', ...   % contents of result document
        'Count %3.0f TransactionAmount %10.2f\n'], ...
        AccountNumber, Tag, DC, Count, Amount)
end
