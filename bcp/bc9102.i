def temp-table tt-erro{&Ext} no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
    
Define temp-table tt-erro-after-GenerateDC NO-UNDO like tt-erro{&Ext}.

