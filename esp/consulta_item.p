
def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoItem'
    field it-codigo            LIKE ITEM.it-codigo
    field descricao            LIKE item.desc-item.    

DEF INPUT PARAM p_cod-unit  AS CHAR NO-UNDO.
def input-output parameter table for tt-item.

FOR EACH ITEM NO-LOCK WHERE SUBSTRING(ITEM.fm-cod-com,1,2) = STRING(p_cod-unit)
                        AND ITEM.cod-obsoleto              = 1
                        AND (ITEM.ge-codigo = 40
                         OR ITEM.ge-codigo = 42 
                         OR ITEM.GE-codigo = 45):
    FIND item-mat OF ITEM NO-LOCK NO-ERROR. 
    IF ITEM.it-codigo BEGINS "9" AND ITEM.fm-codigo   <> "99400004"   THEN NEXT. /*
    IF ITEM.it-codigo BEGINS "583" AND ITEM.fm-codigo <> "58300000" THEN NEXT. 
    IF ITEM.it-codigo BEGINS "584" AND ITEM.fm-codigo = "199999999" THEN NEXT.  */
    IF AVAIL item-mat THEN DO:
          create tt-item.
          assign tt-item.it-codigo  = ITEM.it-codigo
                 tt-item.descricao = ITEM.desc-item.
    END.
END.
