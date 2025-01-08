/* ----------------------------------------------------------------------------
   Programa..: upc/pd1001-upc.p
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
DEFINE NEW GLOBAL SHARED VAR p-row-table-save-pd1001  AS ROWID       NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-pd1001           AS WIDGET-HANDLE NO-UNDO.
define new global shared variable h-programa         as handle        no-undo.
DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEF VAR l-ok       AS LOGICAL  NO-UNDO.
DEF VAR l-resp     AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR resp       AS INT     NO-UNDO .

DEF VAR h-fpage1   AS HANDLE   NO-UNDO.
DEF VAR h-frame1   AS HANDLE   NO-UNDO.
DEF VAR h-fpage2   AS HANDLE   NO-UNDO.
DEF VAR h-frame2   AS HANDLE   NO-UNDO.

DEFINE BUFFER b-emitente FOR emitente.

/* Global Variable Definitions **********************************************/
define new global shared var adm-broker-hdl as handle no-undo.
define new global shared var h-folder       as handle no-undo.
define new global shared var h-viewer       as handle no-undo.

define new global shared variable wgh-window         as widget-handle no-undo.
define new global shared var wb-btHistorico-pd1001 as widget-handle no-undo.
define new global shared var wh-bt-ativo-pd1001    as widget-handle no-undo.
define new global shared var wh-dt-apr-cred-pd1001 as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR h-upc-pd1001           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-ped-mp-pd1001     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-txt-corporativo-pd1001 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-corporativo-pd1001  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wb-dt-entrega-pd1001   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wb-dt-entorig-pd1001   AS WIDGET-HANDLE NO-UNDO.

/* Variable Definitions *****************************************************/
define var c-folder       as character no-undo.
define var c-objects      as character no-undo.
define var h-object       as handle    no-undo.
define var i-objects      as integer   no-undo.
define var l-record       as logical   no-undo initial no.
define var l-group-assign as logical   no-undo initial no.
define var l-state        as logical   no-undo initial no.
define var h-frame        as widget-handle no-undo. 
define var c-transp       as character no-undo.
define var c-rota         as character no-undo.
define var c-cidade-cif   as character no-undo.
define var l-assign       as logical   no-undo.

DEFINE VARIABLE c-cgc AS CHARACTER   NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/* IF p-ind-event = "display" OR p-ind-object = "VIEWER" THEN                   */
/* MESSAGE p-ind-event p-ind-object c-objeto VIEW-AS ALERT-BOX INFO BUTTONS OK. */


/* MESSAGE "Evento " p-ind-event  SKIP         */
/*         "Objeto " p-ind-object SKIP         */
/*         "Tabela " p-cod-table  SKIP         */
/*         "Rowid  " STRING(p-row-table) SKIP  */
/*         "Objeto " c-objeto     SKIP         */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.  */
IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/pd1001-upc.p PERSISTENT SET h-upc-pd1001(INPUT "",            
                                                     INPUT "",            
                                                     INPUT p-wgh-object,  
                                                     INPUT p-wgh-frame,   
                                                     INPUT "",            
                                                     INPUT p-row-table).  
END.

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.

    /*botao historico*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",       /*** Type ***/
                  INPUT "bt-historico", /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wb-btHistorico-pd1001).
END.

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "v33di159.w"  THEN DO:
      
   RUN tela-upc (INPUT p-wgh-frame,
                 INPUT p-ind-Event,
                 INPUT "fill-in",       /*** Type ***/
                 INPUT "dt-entrega", /*** Name ***/
                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                 INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                 OUTPUT wb-dt-entrega-pd1001).
                 
   RUN tela-upc (INPUT p-wgh-frame,
                 INPUT p-ind-Event,
                 INPUT "fill-in",       /*** Type ***/
                 INPUT "dt-entorig",    /*** Name ***/
                 INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                 INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                 OUTPUT wb-dt-entorig-pd1001).
                 
    IF p-ind-event = "DISPLAY" THEN  
        if  valid-handle(wb-dt-entrega-pd1001)
        and valid-handle(wb-dt-entorig-pd1001) then
            assign wb-dt-entrega-pd1001:label = "Prev.Fatur"
                   wb-dt-entorig-pd1001:label = "Prev.Fatur Orig".

end.

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "v32di159.w"  THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
          IF h-frame:TYPE <> "field-group" THEN DO:  
             CASE h-frame:NAME:

             END CASE.
             ASSIGN h-frame = h-frame:NEXT-SIBLING.
          END.
          ELSE DO:
             ASSIGN h-frame = h-frame:FIRST-CHILD.
          END.
    END.

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "nr-pedrep",         /*** Name ***/
                      INPUT no,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-c-ped-mp-pd1001).

        CREATE TEXT wh-txt-corporativo-pd1001
        ASSIGN FRAME        = wh-c-ped-mp-pd1001:FRAME
               FORMAT       = "x(12)"   
               WIDTH        = 12
               SCREEN-VALUE = "Corporativo:"
               ROW          = wh-c-ped-mp-pd1001:ROW + 1.0
               COL          = wh-c-ped-mp-pd1001:COL + 15.5
               VISIBLE      = YES.

        CREATE FILL-IN wh-corporativo-pd1001
        ASSIGN FRAME             = wh-c-ped-mp-pd1001:FRAME
               DATA-TYPE         = "character"
               FORMAT            = "x(03)"
               WIDTH             = 4
               HEIGHT            = wh-c-ped-mp-pd1001:HEIGHT
               ROW               = wh-c-ped-mp-pd1001:ROW + 0.9
               COL               = wh-c-ped-mp-pd1001:COL + 24
               VISIBLE           = YES
               SENSITIVE         = NO.
    END.
END.

IF p-ind-event = "display" AND
   c-objeto     = "v32di159.w"  THEN DO:

       FIND ped-venda
           WHERE rowid(ped-venda) = p-row-table NO-LOCK NO-ERROR.
       IF AVAIL ped-venda THEN DO:
           FIND int-ped-venda
               WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                 AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
               NO-LOCK NO-ERROR.
           IF AVAIL INT-ped-venda THEN DO:
               IF substring(int-ped-venda.char-1,10,1) = "S" THEN 
                   ASSIGN wh-corporativo-pd1001:SCREEN-VALUE = "Sim".
               ELSE
                   ASSIGN wh-corporativo-pd1001:SCREEN-VALUE = "NÆo".
           END.
           ELSE DO:
               ASSIGN wh-corporativo-pd1001:SCREEN-VALUE = "NÆo".
           END.
       END.


END.

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "v37di159.w"  THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
          IF h-frame:TYPE <> "field-group" THEN DO:  
             CASE h-frame:NAME:

             END CASE.
             ASSIGN h-frame = h-frame:NEXT-SIBLING.
          END.
          ELSE DO:
             ASSIGN h-frame = h-frame:FIRST-CHILD.
          END.
    END.
    IF p-ind-event = "BEFORE-display" THEN DO:
        ASSIGN p-row-table-save-pd1001 = p-row-table.
    END.
    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "dt-apr-cred",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-dt-apr-cred-pd1001).

        create button wh-bt-ativo-pd1001  
        assign frame     = wh-dt-apr-cred-pd1001:FRAME 
               width     = 4.00        
               height    = 1
               row       = wh-dt-apr-cred-pd1001:ROW 
               col       = wh-dt-apr-cred-pd1001:COL + 20
               visible   = yes
               sensitive = yes
               tooltip   = "Hist¢rico Ativa‡Æo/Desativa‡Æo"
               TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-botao-historico IN h-upc-pd1001.
               END TRIGGERS.                        

        if wh-bt-ativo-pd1001:load-image("image/im-livro.bmp") then.
    END.
END.

PROCEDURE pi-botao-historico:
    FIND ped-venda
        WHERE ROWID(ped-venda) = p-row-table-save-pd1001
        NO-LOCK NO-ERROR.

    IF AVAIL ped-venda THEN DO:
       FIND FIRST historico-credito NO-LOCK
         WHERE historico-credito.nome-abrev = ped-venda.nome-abrev
           AND historico-credito.nr-pedcli  = ped-venda.nr-pedcli
         NO-ERROR.
       IF AVAIL historico-credito THEN
         RUN esp/cdp/escdp008.w (INPUT 1, INPUT ped-venda.nr-pedido).
       ELSE
           MESSAGE "NÆo existe Historico de Avalia‡Æo de Cr‚dito para este Pedido"
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
