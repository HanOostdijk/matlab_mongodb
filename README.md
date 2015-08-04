# matlab_mongodb
This repository contains examples that show how to use MongoDB database in the MATLAB environment with the MongoDB java driver. 
To run the examples I used the following configuration on Windows 8.1 (64-bit) :
* MATLAB: the version used was the prerelease of MATLAB 8.6 R2015b (no toolboxes necessary)
* java driver: mongo-java-driver-3.0.2.jar 
* MongoDB: mongodb-win32-x86_64-2008plus-ssl-3.1.4-signed.msi

Examples of MATLAB functions that use the MongoDB java driver:
* mm_example_1a.m : read an xls-file into MongoDB collection
* mm_example_1b.m : generate some testdata and insert these in a MongoDB collection (for use in later examples)
* mm_readxls.m : function used in mm_example_1(a)(b) that does the actual insert of a document in the collection
* mm_example_2.m : list the collections and number of documents in the collections and the databases they belong to

Utility functions used:
* mm_drop_collection.m : drop (removes) a collection if it exists
* mm_drop_database.m : drop (removes) a database if it exists
* setOptArgs.m : handles optional arguments of a function

Todo:

insert examples for
* querying a collection 
* doing aggregation (grouping) of a collection
* mapreduce over a collection


