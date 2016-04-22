# matlab_mongodb
This repository contains examples that show how to use MongoDB databases in the MATLAB environment with the MongoDB java driver. 
To run the examples I used the following configuration on Windows 8.1 (64-bit) :
* MATLAB: the version used was the prerelease of MATLAB 8.6 R2015b (no toolboxes necessary)
* java driver: mongo-java-driver-3.0.2.jar (current version in mm_java_driver)
* MongoDB: mongodb-win32-x86_64-2008plus-ssl-3.1.4-signed.msi

More information about working with MongoDB can be found e.g [here](http://docs.mongodb.org/manual/core/crud-introduction/).

Examples of MATLAB functions that use the MongoDB java driver:
* mm_example_1a.m : reads an xls-file into MongoDB collection
* mm_example_1b.m : generates some testdata and insert these in a MongoDB collection (for use in later examples)
* mm_readxls.m    : function used in mm_example_1(a)(b) that does the actual insert of a document in the collection
* mm_example_2.m  : lists the collections and number of documents in the collections with the databases they belong to
* mm_example_3.m  : gives examples of queries in which certain documents and/or fields in documents are selected
* mm_example_3a.m : more examples of selection of fields (projection) and document with a given object id
* mm_example_4.m  : example of handling the results a query
* mm_example_5.m  : example of an aggregation pipeline
* mm_example_6.m  : example of adding a field by using a classification
* mm_example_7.m  : example of a mapreduce

mm_examples 2-6 use the testdata generated in mm_example_1b   
mm_example_7 uses the collection from mm_example_6

Utility functions used:
* mm_cursor_showcontents.m : shows the documents that a cursor points to
* mm_drop_collection.m : drops (removes) a collection if it exists
* mm_drop_database.m : drops (removes) a database if it exists
* mm_java_driver : indicate which driver to use
* setOptArgs.m : handles optional arguments of a function

Acknowledgements:
 * Guillaume A. for his MATLAB Central [article]  (http://uk.mathworks.com/matlabcentral/fileexchange/43171-use-of-mongodb-java-driver) that inspired this repository
 * Yair Altman for his [checkClass](http://uk.mathworks.com/matlabcentral/fileexchange/26947-checkclass-inspect-a-java-matlab-class-object-name) that helped debugging these functions
 
 This software is distributed under the MIT License (MIT): see copyright.txt 


 


