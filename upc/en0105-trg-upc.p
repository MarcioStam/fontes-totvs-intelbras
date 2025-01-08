
DEF NEW GLOBAL SHARED VAR wh-br-table-en0105-upc       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-inbrw-en0105   AS WIDGET-HANDLE NO-UNDO.

DEFINE BUFFER b-estrutura FOR estrutura.
DEFINE BUFFER b-est-aux   FOR estrutura.

DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE wh-query AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-buffer AS WIDGET-HANDLE      NO-UNDO.
/*DEFINE VARIABLE wh-campo AS WIDGET-HANDLE      NO-UNDO.*/




ASSIGN wh-query = wh-br-table-en0105-upc:QUERY
       wh-buffer = wh-query:GET-BUFFER-HANDLE("estrutura")
       /*wh-campo = wh-buffer:BUFFER-FIELD("es-codigo")*/
    .

/*MESSAGE wh-campo:BUFFER-VALUE SKIP
    string(wh-buffer:ROWID)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/


FOR FIRST b-estrutura
    WHERE rowid(b-estrutura) = wh-buffer:ROWID:

    /*MESSAGE 'depois' SKIP
            b-estrutura.es-codigo
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

    FOR LAST b-est-aux USE-INDEX codigo
        WHERE b-est-aux.it-codigo = b-estrutura.it-codigo:

        ASSIGN i-seq = b-est-aux.sequencia + 10.

    END.

    CREATE b-est-aux.
    BUFFER-COPY b-estrutura EXCEPT sequencia TO b-est-aux
    ASSIGN b-est-aux.sequencia = i-seq
           b-est-aux.data-inicio = TODAY
           b-est-aux.data-termino = 12/31/9999.

    RUN dispatch IN wh-inbrw-en0105 ('open-query':U).
    RUN dispatch IN wh-inbrw-en0105 ('display-fields':U).


    ASSIGN wh-query = wh-br-table-en0105-upc:QUERY.

    wh-query:REPOSITION-TO-ROWID(rowid(b-est-aux)).

END.
