%% examples of queries on a collection
% This software is distributed under the MIT License (MIT): see copyright.txt 

mm_java_driver                                          % ensure that MongoDB routines can be found

import com.mongodb.*
import org.bson.types.*

%% origin of the testdata
% # from the "Getting started with MongoDB in R" vignette for the mongolite R-package 
% #   https://cran.r-project.org/web/packages/mongolite/vignettes/intro.html (2016-03-21)
% # writer of the jsonlite and mongolite packages: Jeroen Ooms
% #   https://github.com/jeroenooms/mongolite.git
% library(jsonlite)
% library(mongolite)
% 
% # Stream from url into mongo
% m <- mongo("zips",  db='test', verbose = F)
% stream_in(url("http://media.mongodb.org/zips.json"), handler = function(df){
%   m$insert(df)
% })

%% connect to Mongo client
m       = MongoClient('localhost', 27017);              % connect to local MongoDB client % com.mongodb.MongoClient
db      = m.getDB('test');                             	% handle to database 'test'
col     = db.getCollection('zips') ;                 	% handle to collection 'zips' 
nrdoc   = col.count() ;                               	% number of documents in collection
%% retrieve documents (include all fields)
cur = col.find([]).limit(20);                           % cursor to first 2 documents
mm_cursor_showcontents( cur ) ;                         % show these
%% retrieve  documents (include all fields with projection)
proj = BasicDBObject();                                 % create projection
proj.put('_id', 1);                                     % include document id
proj.put('city', 1);                                    % include city
proj.put('loc', 1);                    	                % include loc
proj.put('pop', 1);                                     % include pop
proj.put('state', 1);                    	         	% include state
cur = col.find([],proj).limit(2);                    	% cursor to first 2 documents (only fields in projection: i.e all)
mm_cursor_showcontents( cur ) ;                         % show these
%% retrieve  documents (exclude _id with projection)
proj = BasicDBObject();                                 % create projection
proj.put('_id', 0);                                     % exclude document id
proj.put('city', 1);                                    % include city
proj.put('loc', 1);                    	                % include loc
proj.put('pop', 1);                                     % include pop
proj.put('state', 1);                    	         	% include state
cur = col.find([],proj).limit(2);                    	% cursor to first 2 documents (only fields in projection: i.e no _id)
mm_cursor_showcontents( cur ) ;                         % show these
%% retrieve  documents (with projection)
proj = BasicDBObject();                                 % create projection
proj.put('_id', 0);                                     % exclude document id
proj.put('city', 1);                                    % include city
% proj.put('loc', 1);                    	            % include loc
proj.put('pop', 1);                                     % include pop
% proj.put('state', 1);                    	         	% include state
cur = col.find([],proj).limit(2);                    	% cursor to first 2 documents (only fields in projection: i.e no _id)
mm_cursor_showcontents( cur ) ;                         % show these
%% retrieve document met object id  01005
query =  BasicDBObject('_id', '01005') ;
cur = col.find(query)  ;   	                            % cursor to selected oid
mm_cursor_showcontents( cur ) ; 
%% when the object id shows as long hex string 
% use { "_id": ObjectId("4ecbe7f9e8c1c9092c000027") } 
%% close connection
m.close() ;                                             % close connection