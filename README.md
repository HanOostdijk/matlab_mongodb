# matlab_mongodb
Examples of MATLAB functions that use the MongoDB java driver:
* mm_example_1a.m : read an xls-file into MongoDB collection
* mm_example_1b.m : generate some testdata and insert these in a MongoDB collection (for use in later examples)
* mm_readxls.m : function used in mm_example_1(a)(b) that does the actual insert of a document in the collection

Utility functions used:
* mm_drop_collection.m : drops (removes) a collection if it exists
* setOptArgs.m : handles optional arguments of a function

Todo:

insert examples for
* querying a collection 
* doing aggregation (grouping) of a collection
* mapreduce over a collection


