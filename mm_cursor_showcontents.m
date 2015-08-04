function mm_cursor_showcontents( cur )

while cur.hasNext()                                     % when more documents in cursor
    x = cur.next() ;                                   	% set cursor to next document and retrieve it
    disp(x) ;                                           % show contents 
end

end

