function mm_cursor_showcontents( cur )
% Show the contents of a cursor
% This software is distributed under the MIT License (MIT): see copyright.txt 

while cur.hasNext()                                     % when more documents in cursor
    x = cur.next() ;                                   	% set cursor to next document and retrieve it
    disp(x) ;                                           % show contents 
end

end

