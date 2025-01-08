/*************************************************************************
    Programa.:  UPC-FT0114
    Objetivo.:  UPC do programa ft0114 - Serie X Estabelecimento
    Data.....:  Julho de 2010
*************************************************************************/

/*********************** Defini»’o de Par³metros *************************/
DEFINE INPUT PARAMETER p-ind-event                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object                 AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object                 AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                  AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                  AS ROWID          NO-UNDO.
{INCLUDE/VER-HDLS.I &ATIVA-GERACAO-LISTA=NO
                    &TELA-DISCO='D'
                    &NOME-ARQUIVO='C:\temp\zzz.LST'
                    &LISTA-FRAMES=''
                    &LISTA-TIPOS-OBJS=''}
                    
DEFINE NEW GLOBAL SHARED VAR wgh-bt-inf-adic-ft0904          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-bt-cce-ft0904          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-char AS CHARACTER   NO-UNDO.

ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME, "~/") NO-ERROR.

IF p-ind-event = "initialize" AND
   c-char = "ft0904.w" THEN DO:

    ASSIGN wgh-bt-inf-adic-ft0904     = fc-all-hdl("f-cad", "bt-inf-adic", 000).

    CREATE BUTTON wgh-bt-cce-ft0904
        ASSIGN WIDTH     = 4.00
               ROW       = 1.17
               COL       = 61
               LABEL     = "CCE"
               FRAME     = wgh-bt-inf-adic-ft0904:FRAME
               HEIGHT    = 1.25
               VISIBLE   = YES
               SENSITIVE = YES.

    ON 'choose':U OF wgh-bt-cce-ft0904 PERSISTENT RUN gtp/gati0203.w.

END.
