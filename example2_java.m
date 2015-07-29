% test for adding to GitHub
addpath('D:\data\matlab\yair')
% http://www.mathworks.com/matlabcentral/fileexchange/
% 26947-checkclass-inspect-a-java-matlab-class-object-name
%  14 Jul 2015
% http://www.mathworks.com/matlabcentral/fileexchange/
% 17935-uiinspect-display-methods--properties---callbacks-of-an-object
%  02 Mar 2015
addpath('D:\data\matlab\jsonlab')
% http://www.mathworks.com/matlabcentral/fileexchange/
% 33381-jsonlab--a-toolbox-to-encode-decode-json-files-in-matlab-octave
%  05 Jun 2015
javaaddpath('D:\data\magweg\MatLab\mongo-java-driver-3.0.2.jar')
% https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongodb-driver/3.0.2/

%{
import com.mongodb.Mongo;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.mongodb.DBCursor;

m = Mongo(); % connect to local db
db = m.getDB('test'); % get db object
colls = db.getCollectionNames(); % get collection names
coll = db.getCollection('things'); % get DBCollection object

doc = BasicDBObject();
doc.put('name', 'MongoDB');
doc.put('type', 'database');
doc.put('count', 1);
info = BasicDBObject();
info.put('x', 203);
info.put('y', 102);
doc.put('info', info);
coll.insert(doc);
%}

import com.mongodb.*
import org.bson.types.ObjectId

%m = MongoClient()                                       % connect to local db
m = MongoClient('localhost', 27017);                    % connect to local db
db = m.getDB('test1');                                	% get db object
colls = db.getCollectionNames();                        % get collection names

% search for system id ( we need import org.bson.types.ObjectId)
% ID = '55accf93f6a32d0210a5d66d' ;
% query = BasicDBObject('_id', ObjectId(ID));             % create simple query
proj = BasicDBObject('EAD', 1);                         % create simple projection include EAD
proj.put('LGD', 1);                                     % include LGD
clause1 = BasicDBObject('_id',  BasicDBObject('$gt', 102)) ;
clause2 = BasicDBObject('_id',  BasicDBObject('$lt', 107)) ;   
and = BasicDBList();
and.add(clause1);
and.add(clause2);
query = BasicDBObject('$and', and);    
%checkClass(proj)
cur = db.getCollection('coll1').find(query,proj);
cur.size()
cur.curr()

cur = db.getCollection('coll1').find('');
% coll1 = mongoConn.getCollection('coll1'); cur  = coll1.find(); % alternative

i= 0 ;
data = cell(0) ;
while cur.hasNext()
    x= cur.next() 
    i = i + 1;
   	% cur.curr().get('EAD') 
    data{i} = loadjson(char(x.toString())) ;
end
cur.close()
% obj = db.getCollection('coll1').find('').skip(1000).limit(100).toArray();
myar = db.getCollection('coll1').find('').skip(0).limit(100).toArray();
data2 = cell(0) ;
for i = 1:myar.size()
    data2{i} = loadjson(char(myar.get(i-1).toString())) ;
end
m.close()



