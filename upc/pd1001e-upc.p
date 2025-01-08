/* ----------------------------------------------------------------------------
   Programa..: upc/pd1001e-upc.p
   Autor.....: Felipe Petry.
   Objetivo..: Trocar o Label das datas de Entrega e Orig. chamado 54199
---------------------------------------------------------------------------- */
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

/*Fim Parameter Definitions ****************************************************/


/* Global Variable Definitions **********************************************/
DEF NEW GLOBAL SHARED VAR wb-dt-entrega-pd1001e   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wb-dt-entorig-pd1001e   AS WIDGET-HANDLE NO-UNDO.

/* Variable Definitions *****************************************************/
DEF VAR c-objeto   AS CHAR     NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), 
                                    p-wgh-object:private-data, "~/").

/* MESSAGE "Evento " p-ind-event  SKIP */
/*         "Objeto " p-ind-object SKIP */
/*         "Tabela " p-cod-table  SKIP */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */ 

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "VIEWER"  then do:

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",              /*** Type ***/
                  INPUT "dt-entrega",           /*** Name ***/
                  INPUT NO,                     /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                      /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-dt-entrega-pd1001e).
                  
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",              /*** Type ***/
                  INPUT "dt-entorig",           /*** Name ***/
                  INPUT NO,                     /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                      /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-dt-entorig-pd1001e).
                  
END.

if valid-handle(wb-dt-entrega-pd1001e) then
    assign wb-dt-entrega-pd1001e:label = 'Prev.Fatur'.

if valid-handle(wb-dt-entorig-pd1001e) then
    assign wb-dt-entorig-pd1001e:label  = 'Prev.Fatur Orig'.


PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE
             "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.
