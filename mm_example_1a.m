%% import xls-file in a MongoDB collection

javaaddpath('D:\data\magweg\MatLab\mongo-java-driver-3.0.2.jar')
% https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongodb-driver/3.0.2/
% downloaded 20jul2015

import com.mongodb.*

% connect to Mongo client
m   = MongoClient('localhost', 27017);              	% connect to local MongoDB client % com.mongodb.MongoClient
wc  = WriteConcern(1);                               	% indicate WriteConcern to use:    % com.mongodb.WriteConcern(1)
                    % 'Wait for acknowledgement, but don't wait for secondaries to replicate'
db  = m.getDB('matlab_mongodb');                    	% handle to a database (create if non-existing)
mm_drop_collection( db,'transactions' )              	% drop collection from this database
col = db.getCollection('transactions') ;             	% handle to collection 'transaction' (create if non-existing)
%% specify xls-file from which to read transactions
xls_file.name   = ...                                   % name of xls-file                           
    'T:\Administratie\Prints Internet\ABN AMRO betaalrekeningen\XLS150726180028.xls'; 
xls_file.sheet  =   'Sheet0';                           % sheet of transaction data
xls_file.range  =   '';                                 % range of transaction data  (empty whole sheet)  

xlate_table = { ...                                     % for header translation from Dutch to English
'Rekeningnummer' , 'AccountNumber' ;
'Muntsoort' , 'Currency' ;
'Transactiedatum' ,'TransactionDate';
'Rentedatum' , 'InterestDate';
'Beginsaldo' , 'StartAmount';
'Eindsaldo' , 'ClosingAmount';
'Transactiebedrag' , 'TransactionAmount' ;
'Omschrijving', 'Description' 
} ;

mm_readxls(col,wc,xls_file,xlate_table,false) ;     	% read the file (do not use testdata)

%% read some documents to check if all went well
% (precise extraction of fields will be shown later)

mycur = col.find('').skip(18).limit(5) ;
fprintf('cursor contains %.0f documents\n',mycur.size())
while mycur.hasNext()                                 	% when more data is available
    mycur.next() ;                                   	% cursor points to next document
    x               = mycur.curr()  ;                  	% contents of this document
    disp(x)                                             % and show it 
end
        
