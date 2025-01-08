/* ----------------------------------------------------------------------------
   Programa..: upc/cc0531-upc.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: Gravacao dos dados adicionais do cliente.
               Grava: emitente.bonificacao
                      emitente.cod-suframa
               Com esta UPC, nao e necessario acessar os programas CD0705 e
               CD1510 apos o cadastro do cliente para que o mesmo possa ter
               notas faturadas.
               Utilizei o ponto UPC "criacao-Endereco-Padrao-Entrega" para 
               gravar o indicador de credito do cliente. Este evento so e
               chamado depois que o registro foi cridao (e so na criacao de 
               novo registro).
---------------------------------------------------------------------------- */


/* Parameter Definitions ****************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

DEF VAR c-objeto   AS CHAR     NO-UNDO.


/* Global Variable Definitions **********************************************/
DEF NEW GLOBAL SHARED VAR h-upc-cc0531           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fPage1-cc0531       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btDeleteSon1-cc0531 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btDadosForn-cc0531  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-it-codigo AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR r-rowid-item-fornec-estab-cc0531 AS ROWID NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/


IF p-ind-object = "CONTAINER" THEN DO:
    CASE p-ind-event:
        WHEN "BEFORE-INITIALIZE" THEN DO:

            RUN upc/cc0531-upc.p PERSISTENT SET h-upc-cc0531(INPUT "",            
                                                             INPUT "",            
                                                             INPUT p-wgh-object,  
                                                             INPUT p-wgh-frame,   
                                                             INPUT "",            
                                                             INPUT p-row-table).  
    
            /*fPage1*/
            RUN tela-upc (INPUT p-wgh-frame,
                          INPUT p-ind-Event,
                          INPUT "frame",       /*** Type ***/
                          INPUT "fPage1", /*** Name ***/
                          INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                          INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                          OUTPUT wh-fPage1-cc0531).
    
            /*DeleteSon1*/
            RUN tela-upc (INPUT wh-fPage1-cc0531,
                          INPUT p-ind-Event,
                          INPUT "button",       /*** Type ***/
                          INPUT "btDeleteSon1", /*** Name ***/
                          INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                          INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                          OUTPUT wh-btDeleteSon1-cc0531).
    
            IF VALID-HANDLE(wh-btDeleteSon1-cc0531) THEN DO:
                create button wh-btDadosForn-cc0531  
                assign frame     = wh-fPage1-cc0531
                       LABEL     = "Dados Fornecedor"
                       width     = 15.00        
                       height    = 1
                       row       = wh-btDeleteSon1-cc0531:ROW
                       col       = wh-btDeleteSon1-cc0531:COL + 20
                       visible   = yes
                       sensitive = yes
                       tooltip   = "Dados Fornecedor"
                       TRIGGERS:
                           ON CHOOSE PERSISTENT RUN pi-dados-fornecedor IN h-upc-cc0531.
                       END TRIGGERS.
            END.
        END.
        WHEN "after-value-changed" THEN DO:
            IF p-cod-table = "item-fornec-estab"  THEN DO:
                ASSIGN r-rowid-item-fornec-estab-cc0531 = p-row-table.

                FIND FIRST item-fornec-estab
                     WHERE ROWID(item-fornec-estab) = r-rowid-item-fornec-estab-cc0531 NO-LOCK NO-ERROR.
                IF AVAIL item-fornec-estab THEN DO:
                    ASSIGN c-it-codigo = item-fornec-estab.it-codigo.
                END.

            END.
        END.
        WHEN "destroy" THEN DO:
            IF VALID-HANDLE(h-upc-cc0531) THEN
                DELETE PROCEDURE h-upc-cc0531.
        END.
        WHEN "after-initialize" THEN DO:
            FIND FIRST item-uni-estab
                 WHERE ROWID(item-uni-estab) = p-row-table NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN DO:
                ASSIGN c-it-codigo = item-uni-estab.it-codigo.
            END.
        END.
        WHEN "AFTER-OPEN-QUERY"  THEN DO:
             ASSIGN r-rowid-item-fornec-estab-cc0531 = p-row-table.
        END.


    END CASE.
END.


PROCEDURE pi-dados-fornecedor:

    IF r-rowid-item-fornec-estab-cc0531 <> ? THEN DO:  
        run upc/cc0531b-upc.w (INPUT r-rowid-item-fornec-estab-cc0531).

        RUN openQueriesSon IN p-wgh-object /*(INPUT r-rowid-item-uni-estab-cc0531)*/ .
    END.
    ELSE DO:
        MESSAGE "Selecione algum fornecedor no browse!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.


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
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
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
