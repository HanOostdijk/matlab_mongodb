function mm_readxls(col, wc, xls_s, varargin)
% read the contents of an xls file into a collection
% or alternatively create test_data to insert in collection

%{
coll                : collection to write to
wc                  : writecollect for the collection
xls_s               : structure with 'name', 'sheet' and range of xls-file to read
    optional arguments
xlate_table  		: translation table for headers (for example see subfunction gen_testdata)
testdata            : boolean indicating if testdata is requested
%}

import com.mongodb.BasicDBObject
%% handle arguments
defoptArgs      = {[], false};                        	% default valuess
optArgs         = setOptArgs(varargin,defoptArgs) ;   	% merge specified and default values
xlate_table  	= optArgs{1} ;                      	% translation table
testdata        = optArgs{2} ;                        	% testdata requested ?

%% determine is xls-file is read or testdata is generated
if testdata == true                                     % when 4 arguments are present, we will generate testdata
    [raw,xlate_table] = gen_testdata();                 % generate test data according to first column in 'translation'
else
    [~,~,raw]   = xlsread(xls_s.name, ...               % read contents of xls-file in cell array 'raw'
        xls_s.sheet, xls_s.range);   
end
%                                                       % raw should contain one header row, data rows and no trailer row
%% insert data in the collection
if numel(xlate_table) > 0                               % use translation table if specified
    [~,ix]     	 = ismember(raw(1,:),xlate_table(:,1));	% lookup column headers in translation table    
    raw(1,ix~=0) = xlate_table(ix(ix~=0),2) ;           % replace found headers
end
for i=2:size(raw,1)                                     % handle each data row
    doc = BasicDBObject();                              % create empty BasicDBObject
    for j=1:size(raw,2)                                 % handle each field of this row
        doc.put(raw{1,j},raw{i,j});                     % insert name-value pair for this field
    end
    col.insert(doc,wc);                                  % insert (the now filled) BasicDBObject in collection
end

end
%% subfunction to create testdata
function [testdata,xlate_table] = gen_testdata()	
%% translate table that contains header information
xlate_table = { ...                                     % for translation from Dutch to English
'Rekeningnummer' , 'AccountNumber' ;
'Muntsoort' , 'Currency' ;
'Transactiedatum' ,'TransactionDate';
'Rentedatum' , 'InterestDate';
'Beginsaldo' , 'StartAmount';
'Eindsaldo' , 'ClosingAmount';
'Transactiebedrag' , 'TransactionAmount' ;
'Omschrijving', 'Description' 
} ;
testdata    = xlate_table(:,1)' ;                       % header for testdata 
%% prepare for loop
N           = [20,20,10] ;                          	% generate data for 3 account number with resp. 20, 20 and 10 transactions
s           = RandStream('mt19937ar','Seed',2015);   	% create a random stream (for use in this function only)
prevstream  = RandStream.setGlobalStream(s) ;            % use it and save the status of the original stream
pdesc = { 'typeA1', 'typeA2', 'typeB', 'typeC'};        % four possibilities for 'description'
% loop for each of the accountnumbers
for acc_nr = 1:numel(N)                                 % for each account number draw transactions:
    n = N(acc_nr) ;                                 	% number of transactions
    m = datenum( '01-08-2015','dd-mm-yyyy') ;       	% reference date 01AUG2015
    m = m + randi([-100 100],1,n) ;                  	% generate dates around this date
    m = sort(m) ;                                   	% sorted ascending
    trdate = cellstr(datestr(m,'yyyymmdd')) ;           % formats dates in desired string format
    trdate = cellfun(@(x)str2num(x),trdate) ;           %#ok<ST2NM> convert from string to numeric
    rdate = trdate ;                                  	% assume interest data == transaction date
    tamount = 0.01 *ceil(1000000 * (rand(n,1)-0.5)) ; 	% generate transaction amounts between -5000 and +5000
    eamount = cumsum(tamount,1) ;                       % amount on account after transaction
    samount = [0;eamount(1:end-1)] ;                    % amount on account before transaction
    descr = pdesc(randi(numel(pdesc),n,1))';            % generate description
    f1 = num2cell([repmat(acc_nr,n,1), trdate, ...   	% numeric fields (Rekeningnummer, Transactiedatum,
            rdate, samount, eamount,tamount]) ;         % Rentedatum, BeginSaldo, EindSaldo, Transactiebedrag)    
                                                        % to cell array
    f2 = [ repmat({'EUR'},n,1), descr] ;                % other fields
    testdata = [ testdata ;                             % combine data for this account with header and
        [f1(:,1),f2(:,1),f1(:,2:end),f2(:,2)] ] ;       %#ok<AGROW> % previous accounts (if any)
end
%% reset stream
RandStream.setGlobalStream(prevstream) ;                % from now continue with the original stream

end
