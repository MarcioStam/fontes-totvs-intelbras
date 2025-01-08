/*------------------------------------------------------------------------
    File        : CD2510-UPC.P
    Purpose     : UPC do programa CD2510.
    Syntax      : <none>
    Description : Bloqueio campo Aliquota Importacao (origem Klassmatt)

    Author(s)   : Isac Abrahao 
    Created     : 14/06/2022
----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-objeto  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-alterou AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-indice  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE wgh-frame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE wgh-de-aliq-ii-cd2510        AS WIDGET-HANDLE NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wgh-fpage1-cd2510            AS WIDGET-HANDLE NO-UNDO. 


/* ***************************  Main Block  *************************** */
/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/* Mensagem para verificar o ponto UPC do programa */
/*
MESSAGE "Evento: ":U   p-ind-event  SKIP
        "Objeto: ":U   p-ind-object SKIP
        "Nome Obj: ":U c-objeto     SKIP
        "Frame: ":U    p-wgh-frame  SKIP
        "Tabela: ":U   p-cod-table  SKIP
        "Rowid: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do CD0903":U.  */


IF  p-ind-event  = "AFTER-INITIALIZE":U AND
    p-ind-object = "CONTAINER":U      THEN DO:
    
    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    RUN busca-folder(INPUT p-wgh-frame,
                     INPUT "fpage1",
                     OUTPUT wgh-fpage1-cd2510).


    IF VALID-HANDLE(wgh-fpage1-cd2510) THEN
        RUN busca-handle(INPUT wgh-fpage1-cd2510,
                         INPUT "de-aliq-ii",
                         OUTPUT wgh-de-aliq-ii-cd2510 ).
END.

IF VALID-HANDLE(wgh-de-aliq-ii-cd2510) THEN
   ASSIGN wgh-de-aliq-ii-cd2510:SENSITIVE = NO. 


RETURN "OK":U.

/* Final */

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.    
END.




PROCEDURE busca-folder:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.



