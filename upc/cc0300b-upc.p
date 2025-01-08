/*------------------------------------------------------------------------
    File        : CC0300B-UPC.P
    Purpose     : Manutená∆o das Ordens de Compra dos Pedidos de Compra.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Gustavo Eduardo Tamanini (Exponencial TI)
    Created     : Maráo de 2011
    Notes       : 001 (22/03/2011 - Gustavo Eduardo Tamanini) -
                  2011/00026476 - Validaá∆o de item ativo ao criar ordem
                  de compra.
                  002 (09/08/2012 - Fabiano Sakae Ribeiro) - CR27847 -
                  Parametrizaá∆o de diversos MOQs para mesmo item / An†-
                  lise Autom†tica no Pedido.
                  003 (03/01/2013 - Fabiano Sakae Ribeiro) - IR54921 -
                  Bloquear alteraá∆o de OC embarcada.
                  004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 -
                  coment†rios em Pedidos Nacionais por parcela.
                  005 (28/06/2022 - iDBA)
                  Data Necessidade
                  006 (29/09/2022 - iDBA)
                  Endereáo de Entrega
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* Include Definitions ---                                              */

{method/dbotterr.i} /* Definiá∆o da Temp-Table "RowErrors" */

/* Local Temp-Table Definitions ---                                     */

/* Temp-Table usada na procedure "procuraEmbarqueCompras" da BO "bocx225"
   para apresentar os embarques das Ordens de Compra */
DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHARACTER FORMAT "x(16)":U.

/* Local Variable Definitions ---                                       */
DEF BUFFER b-ordem-compra FOR ordem-compra.
DEFINE VARIABLE c-objeto   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE hShowMsg   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
define variable c-question as character   no-undo.
DEFINE VARIABLE i-cont     AS INTEGER     NO-UNDO.

DEFINE VARIABLE wgh-parcela          AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-qtd-sal-forn     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-data-entrega     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-boin356vl          AS HANDLE        NO-UNDO.
DEFINE VARIABLE de-indice            AS DECIMAL       NO-UNDO.
DEFINE VARIABLE h-bocx225            AS HANDLE        NO-UNDO.
DEFINE VARIABLE wgh-BROWSE-1         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-parcela-BROWSE-1 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i-linha              AS INTEGER       NO-UNDO.
define variable wh-dt-necessidade    as widget-handle no-undo.
define variable wh-ordem-aux-cc0300b as widget-handle no-undo.

DEFINE VARIABLE wgh-objeto           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-fPage3           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-btAddSon1        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-estab-entrega    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgh-btNotaFiscal     AS WIDGET-HANDLE NO-UNDO.

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE wgh-fPage1                 AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cc0300b-upc              AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-numero-ordem-cc0300b   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-num-pedido-cc0300b     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-emitente-cc0300b   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-ct-codigo-cc0300b      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-sc-codigo-cc0300b      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-unid-negoc-cc0300b AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-item-cc0300b           AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wgh-obj-aux            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-objeto              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fPage-new           AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-end-entrega-cc0300b AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-btSave-cc0300b      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-btSaveEsp-cc0300b   AS WIDGET-HANDLE NO-UNDO.


def new global shared temp-table tt-cc0300b-upc no-undo
    field wh-container     as handle
    field wh-editor        as widget-handle
    field wh-frame         as widget-handle
    field wh-btSave        as widget-handle
    FIELD wh-btSaveEsp     AS WIDGET-HANDLE
    field wh-end-entrega   as widget-handle
    field wh-estab-entrega as widget-handle
    field lg-save          as logical.

DEF TEMP-TABLE tt-ordem-compra-aux NO-UNDO LIKE ordem-compra
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-raw FIELD rTarget AS RAW.

DEF VAR c-cep-aux AS CHAR NO-UNDO.

/* Preprocessors Definitions ---                                        */

/* Deseja gerar arquivo de log com os pontos UPCÔs? (YES/NO)*/
&GLOBAL-DEFINE LogPontoUpc  NO

/* Deseja apresentar mensagem com os pontos UPCÔs?  (YES/NO)*/
&GLOBAL-DEFINE MsgPontoUpc  NO


/* ***************************  Main Block  *************************** */

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

&IF DEFINED(LogPontoUpc) <> 0       AND
    "{&LogPontoUpc}":U    = "YES":U &THEN
OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "log-cc0300b-upc.txt":U) APPEND CONVERT TARGET "iso8859-1":U.
PUT UNFORMATTED FILL("-":U, 80)                                  SKIP
                "        Data: ":U STRING(TODAY, "99/99/9999":U) SKIP
                "        Hora: ":U STRING(TIME, "hh:mm:ss":U)    SKIP(1)
                "      Evento: ":U p-ind-event                   SKIP
                "      Objeto: ":U p-ind-object                  SKIP
                " Nome Objeto: ":U c-objeto                      SKIP
                "       Frame: ":U p-wgh-frame:NAME              SKIP
                "      Tabela: ":U p-cod-table                   SKIP
                "       Rowid: ":U STRING(p-row-table)           SKIP
                FILL("-":U, 80)                                  SKIP(1).
OUTPUT CLOSE.
&ENDIF

&IF DEFINED(MsgPontoUpc) <> 0       AND
    "{&MsgPontoUpc}":U    = "YES":U &THEN
MESSAGE "Evento: ":U      p-ind-event      SKIP
        "Objeto: ":U      p-ind-object     SKIP
        "Nome Objeto: ":U c-objeto         SKIP
        "Frame: ":U       p-wgh-frame:NAME SKIP
        "Tabela: ":U      p-cod-table      SKIP
        "Rowid:  ":U      STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC":U.
&ENDIF

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)SKIP  */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF p-ind-event  = "AFTER-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U        THEN DO:
    ASSIGN h-cc0300b-upc = ?.

    RUN piTelaUPC (INPUT  p-wgh-frame, /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FRAME":U,   /*** Type ***/
                   INPUT  "fPage1":U,  /*** Name ***/
                   INPUT  NO,          /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,           /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-fPage1).

    RUN piTelaUPC (INPUT  p-wgh-frame,        /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,        /*** Type ***/
                   INPUT  "numero-ordem":U,   /*** Name ***/
                   INPUT  NO,                 /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wh-ordem-aux-cc0300b).

    IF NOT VALID-HANDLE (wgh-numero-ordem-cc0300b) then
        RUN piTelaUPC (INPUT  p-wgh-frame:PARENT, /* fPage0 */
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,        /*** Type ***/
                       INPUT  "numero-ordem":U,   /*** Name ***/
                       INPUT  NO,                 /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-numero-ordem-cc0300b).

    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - In°cio */
    RUN piTelaUPC (INPUT  p-wgh-frame,
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,      /*** Type ***/
                   INPUT  "cod-emitente":U, /*** Name ***/
                   INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-cod-emitente-cc0300b).

    RUN piTelaUPC (INPUT  p-wgh-frame, /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FRAME":U,   /*** Type ***/
                   INPUT  "fPage3":U,  /*** Name ***/
                   INPUT  NO,          /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,           /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-fPage3).

    if valid-handle(wgh-fPage3) 
    then RUN piTelaUPC (INPUT  wgh-fPage3,  /* fPage3 */
                        INPUT  p-ind-event,
                        INPUT  "BROWSE":U,   /*** Type ***/
                        INPUT  "BROWSE-1":U, /*** Name ***/
                        INPUT  no,           /*** Apresenta Mensagem dos Objetos ***/
                        INPUT  1,            /*** Quando existir mais de um objeto com o mesmo nome ***/
                        OUTPUT wgh-BROWSE-1).

    IF VALID-HANDLE(wgh-fPage1)
    THEN RUN piTelaUPC (INPUT  wgh-fPage1,       /* fPage1 */
                        INPUT  p-ind-event,
                        INPUT  "FILL-IN":U,      /*** Type ***/
                        INPUT  "cod-estabel":U, /*** Name ***/
                        INPUT  NO,              /*** Apresenta Mensagem dos Objetos ***/
                        INPUT  1,               /*** Quando existir mais de um objeto com o mesmo nome ***/
                        OUTPUT wgh-estab-entrega).

    FIND FIRST emitente
        WHERE emitente.cod-emitente = wgh-cod-emitente-cc0300b:INPUT-VALUE NO-LOCK NO-ERROR.

    ASSIGN wgh-cod-emitente-cc0300b = ?.

    IF  AVAILABLE emitente     AND
       (emitente.natureza = 1  OR
        emitente.natureza = 2) THEN DO: /* Fornecedor Nacional */
        RUN upc/cc0300b-upc.p PERSISTENT SET h-cc0300b-upc (INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT p-wgh-object,
                                                            INPUT p-wgh-frame,
                                                            INPUT "":U,
                                                            INPUT p-row-table).

/*         RUN piTelaUPC (INPUT  p-wgh-frame, /* fPage0 */                                                */
/*                        INPUT  p-ind-event,                                                             */
/*                        INPUT  "FRAME":U,   /*** Type ***/                                              */
/*                        INPUT  "fPage3":U,  /*** Name ***/                                              */
/*                        INPUT  NO,          /*** Apresenta Mensagem dos Objetos ***/                    */
/*                        INPUT  1,           /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                        OUTPUT wgh-fPage3).                                                             */

        RUN piTelaUPC (INPUT  wgh-fPage3,    /* fPage3 */
                       INPUT  p-ind-event,
                       INPUT  "BUTTON":U,    /*** Type ***/
                       INPUT  "btAddSon1":U, /*** Name ***/
                       INPUT  NO,            /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-btAddSon1).

        CREATE BUTTON wgh-btNotaFiscal
        ASSIGN NAME      = "wgh-btNotaFiscal":U
               FRAME     = wgh-fPage3
               WIDTH     = 10.00
               HEIGHT    =  1.00
               COLUMN    = wgh-btAddSon1:COLUMN
               ROW       = wgh-btAddSon1:ROW + 2
               LABEL     = "Nota Fiscal":U
               TOOLTIP   = "Inclus∆o da informaá∆o da Nota Fiscal":U
               HELP      = "Inclus∆o da informaá∆o da Nota Fiscal":U
               VISIBLE   = YES
               SENSITIVE = YES
               TRIGGERS:
                    ON "CHOOSE":U PERSISTENT RUN piNotaFiscal IN h-cc0300b-upc.
               END TRIGGERS.

        ASSIGN wgh-objeto = p-wgh-object.

        DO WHILE VALID-HANDLE(wgh-objeto):
            IF wgh-objeto:FILE-NAME = "utp/thinfolder.w":U THEN
                LEAVE.

            ASSIGN wgh-objeto = wgh-objeto:NEXT-SIBLING.
        END.

        RUN setFolder IN wgh-objeto (INPUT 1).

        ASSIGN wgh-objeto       = ?
               wgh-fPage3       = ?
               wgh-btAddSon1    = ?
               wgh-btNotaFiscal = ?.
    END.
    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - Final */

    if  valid-handle(wgh-BROWSE-1)
    and valid-handle(wh-ordem-aux-cc0300b)
    then do:
         assign wh-dt-necessidade           = wgh-BROWSE-1:add-calc-column("DATE","99/99/9999","","Necessidade",5)
                wh-dt-necessidade:read-only = true.

         on row-display of wgh-BROWSE-1 persistent run upc/cc0300b-upca.p (input wgh-BROWSE-1:query,
                                                                           input wh-ordem-aux-cc0300b,
                                                                           input wh-dt-necessidade).
    end. /* if valid-handle(wgh-BROWSE-1) */

    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            if wh-objeto:name = "fPage1":U
            then leave.

            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.

    if valid-handle(wh-objeto)
    then do:
         RUN piTelaUPC (INPUT  p-wgh-frame,   /* fPage0 */
                        INPUT  p-ind-event,
                        INPUT  "BUTTON":U,    /*** Type ***/
                        INPUT  "btSave":U, /*** Name ***/
                        INPUT  NO,            /*** Apresenta Mensagem dos Objetos ***/
                        INPUT  1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                        OUTPUT wh-btSave-cc0300b).

         IF NOT VALID-HANDLE(h-cc0300b-upc)
         THEN RUN upc/cc0300b-upc.p PERSISTENT SET h-cc0300b-upc (INPUT "":U,
                                                                  INPUT "":U,
                                                                  INPUT p-wgh-object,
                                                                  INPUT p-wgh-frame,
                                                                  INPUT "":U,
                                                                  INPUT p-row-table).

         CREATE BUTTON wh-btSaveEsp-cc0300b
         ASSIGN NAME      = "wh-btSaveEsp-cc0300b":U
                FRAME     = p-wgh-frame
                WIDTH     = wh-btSave-cc0300b:width
                HEIGHT    = wh-btSave-cc0300b:height
                COLUMN    = wh-btSave-cc0300b:column
                ROW       = wh-btSave-cc0300b:row
                LABEL     = "Save":U
                VISIBLE   = YES
                SENSITIVE = yes
                TRIGGERS:
                     ON "CHOOSE":U PERSISTENT RUN pibtSaveEsp IN h-cc0300b-upc (input wh-btSave-cc0300b:handle).
                END TRIGGERS.

         assign wh-btSaveEsp-cc0300b:SENSITIVE = wh-btSave-cc0300b:sensitive
                wh-btSave-cc0300b:SENSITIVE    = no.

         CREATE FRAME wh-fPage-new
         ASSIGN FRAME       = p-wgh-frame
                COL         = wh-objeto:COL
                ROW         = wh-objeto:ROW
                WIDTH       = wh-objeto:WIDTH
                HEIGHT      = wh-objeto:HEIGHT
                NAME        = "fPage9"
                SIDE-LABELS = YES
                SENSITIVE   = YES
                OVERLAY     = YES
                BGCOLOR     = wh-objeto:BGCOLOR
                BOX         = NO
                THREE-D     = YES
                font        = wh-objeto:font.

         ASSIGN wgh-obj-aux = p-wgh-object.
         do  while valid-handle(wgh-obj-aux):     
             if  wgh-obj-aux:FILE-NAME = "utp/thinFolder.w" THEN LEAVE.
             assign wgh-obj-aux = wgh-obj-aux:NEXT-SIBLING.     
         end.     
    
         IF valid-handle(wgh-obj-aux) THEN RUN insertFolder IN wgh-obj-aux (INPUT ?,
                                                                            INPUT p-wgh-frame,
                                                                            INPUT wh-fPage-new,
                                                                            INPUT "End Entrega").

         CREATE EDITOR wh-end-entrega-cc0300b
         ASSIGN FRAME              = wh-fPage-new
                DATA-TYPE          = "character"
                INNER-CHARS        = 110
                INNER-LINES        = 16
                ROW                = 1.5
                COL                = 2
                SCROLLBAR-VERTICAL = YES
                MAX-CHARS          = 1999
                VISIBLE            = YES
                SENSITIVE          = yes.

         FOR FIRST b-ordem-compra
             WHERE ROWID(b-ordem-compra) = p-row-table
                   NO-LOCK: END.

         IF AVAIL b-ordem-compra
         THEN FOR FIRST int-ordem-compra NO-LOCK
                  WHERE int-ordem-compra.numero-ordem = b-ordem-compra.numero-ordem:
                  ASSIGN wh-end-entrega-cc0300b:SCREEN-VALUE = TRIM(int-ordem-compra.end-entrega).
              END. /* FOR FIRST int-ordem-compra */
         ELSE FOR FIRST estabelec NO-LOCK
                  WHERE estabelec.cod-estabel = wgh-estab-entrega:SCREEN-VALUE:
                  ASSIGN c-cep-aux = STRING(estabelec.cep,"99999-999") NO-ERROR.

                  IF ERROR-STATUS:ERROR
                  THEN ASSIGN c-cep-aux = STRING(estabelec.cep).

                  ASSIGN wh-end-entrega-cc0300b:SCREEN-VALUE = "Nome: "     + trim(estabelec.nome)
                                                             + chr(10)
                                                             + "Endereáo: " + trim(estabelec.endereco)
                                                             + chr(10)
                                                             + "Bairro: "   + trim(estabelec.bairro)
                                                             + chr(10)
                                                             + "Cidade: "   + trim(estabelec.cidade)
                                                             + chr(10)
                                                             + "CEP: "      + c-cep-aux
                                                             + chr(10)
                                                             + "UF: "       + trim(estabelec.estado)
                                                             + chr(10)
                                                             + "Pa°s: "     + trim(estabelec.pais)
                                                             + chr(10).
              END. /* FOR FIRST estabelec */

         IF valid-handle(wgh-obj-aux) THEN RUN setFolder IN wgh-obj-aux (INPUT 1) .

         create tt-cc0300b-upc.
         assign tt-cc0300b-upc.wh-editor        = wh-end-entrega-cc0300b:handle
                tt-cc0300b-upc.wh-frame         = p-wgh-frame:handle
                tt-cc0300b-upc.wh-btSave        = wh-btSave-cc0300b:handle
                tt-cc0300b-upc.wh-btSaveEsp     = wh-btSaveEsp-cc0300b:HANDLE
                tt-cc0300b-upc.wh-end-entrega   = wh-end-entrega-cc0300b:handle
                tt-cc0300b-upc.wh-estab-entrega = wgh-estab-entrega:handle
                tt-cc0300b-upc.wh-container     = p-wgh-object:handle.
         find current tt-cc0300b-upc no-error.
    end. /* if valid-handle(wh-objeto) */

    assign wgh-BROWSE-1 = ?.
END.

IF p-ind-event  = "valida-pend-aprovacao-qtd-forn":U AND
   p-ind-object = "CONTAINER":U                      THEN DO:

    /* 003 (03/01/2013 - Fabiano Sakae Ribeiro) - IR54921 - Bloquear alteraá∆o
       de OC embarcada. - In°cio */
    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - In°cio */
    IF NOT VALID-HANDLE (wgh-numero-ordem-cc0300b) THEN
        RUN piTelaUPC (INPUT  p-wgh-frame:PARENT, /* fPage0 */
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,        /*** Type ***/
                       INPUT  "numero-ordem":U,   /*** Name ***/
                       INPUT  NO,                 /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-numero-ordem-cc0300b).

    RUN piTelaUPC (INPUT  p-wgh-frame, /* fPage3 */
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U, /*** Type ***/
                   INPUT  "parcela":U, /*** Name ***/
                   INPUT  NO,          /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,           /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-parcela).

    IF VALID-HANDLE(wgh-numero-ordem-cc0300b) AND
       VALID-HANDLE(wgh-parcela)      THEN DO:

        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = wgh-numero-ordem-cc0300b:INPUT-VALUE
              AND prazo-compra.parcela      = wgh-parcela:INPUT-VALUE NO-LOCK NO-ERROR.

        IF AVAILABLE prazo-compra THEN DO:
            FIND FIRST int-prazo-compra
                WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                  AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

            IF AVAILABLE int-prazo-compra             AND
               (int-prazo-compra.nro-docto   <> "":U  OR
                int-prazo-compra.serie-docto <> "":U) THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Esta parcela tem ~"NF informativa~" relacionada a ela.":U +
                                         "~~":U +
                                         "Verifique se Ç esta parcela que deve ser altrada, se sim v† a tela de ~"NF~" e remova a informaá∆o de NF e sÇrie.":U).

                ASSIGN wgh-numero-ordem-cc0300b = ?
                       wgh-parcela      = ?.

                RETURN ERROR.
            END.

            FIND FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.

            IF AVAILABLE ordem-compra THEN DO:
                
                IF NOT VALID-HANDLE(h-boin356vl) THEN
                    RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.

                ASSIGN de-indice = 1.0.

                IF VALID-HANDLE(h-boin356vl) THEN
                    RUN pi-indice IN h-boin356vl (INPUT  ordem-compra.it-codigo,
                                                  INPUT  ordem-compra.cod-emitente,
                                                  INPUT  ordem-compra.numero-ordem,
                                                  OUTPUT de-indice).

                IF VALID-HANDLE(h-boin356vl) THEN
                    DELETE PROCEDURE h-boin356vl.

                ASSIGN h-boin356vl = ?.

                RUN piTelaUPC (INPUT  p-wgh-frame,      /* fPage3 */
                               INPUT  p-ind-event,
                               INPUT  "FILL-IN":U,      /*** Type ***/
                               INPUT  "qtd-sal-forn":U, /*** Name ***/
                               INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                               INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                               OUTPUT wgh-qtd-sal-forn).

                RUN piTelaUPC (INPUT  p-wgh-frame,      /* fPage3 */
                               INPUT  p-ind-event,
                               INPUT  "FILL-IN":U,      /*** Type ***/
                               INPUT  "data-entrega":U, /*** Name ***/
                               INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                               INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                               OUTPUT wgh-data-entrega).

                IF prazo-compra.quantidade   <> (wgh-qtd-sal-forn:INPUT-VALUE / de-indice) OR
                   prazo-compra.data-entrega <>  wgh-data-entrega:INPUT-VALUE              THEN DO:
                    FIND FIRST param-global NO-LOCK NO-ERROR.

                    FIND FIRST emitente
                        WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

                    IF AVAILABLE param-global AND
                       AVAILABLE emitente     AND
                       param-global.modulo-07 AND
                       emitente.natureza > 2  THEN DO:

                        FIND FIRST pedido-compr
                            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

                        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

                        RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                                 INPUT  ordem-compra.numero-ordem,
                                                                 INPUT  prazo-compra.parcela,
                                                                 OUTPUT TABLE tt-embarque).

                        DELETE PROCEDURE h-bocx225.

                        ASSIGN h-bocx225 = ?.

                        ASSIGN i-cont     = 0
                               c-mensagem = "":U.

                        FOR EACH tt-embarque:
                            ASSIGN i-cont = i-cont + 1.

                            IF i-cont = 1 THEN
                                ASSIGN c-mensagem = tt-embarque.embarque.
                            ELSE
                                ASSIGN c-mensagem = c-mensagem + ", ":U + tt-embarque.embarque.
                        END. /* FOR EACH tt-embarque: */

                        IF i-cont >= 1 THEN DO:
                            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                               INPUT 17006,
                                               INPUT "Atená∆o: Vocà pode ter alterado uma parcela vinculada a um embarque.":U +
                                                     "~~":U +
                                                     "Esta ordem de compra est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                     "Para fazer alteraá∆o, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a alteraá∆o.":U).

                            IF prazo-compra.quantidade <> (wgh-qtd-sal-forn:INPUT-VALUE / de-indice) THEN
                                APPLY "ENTRY":U TO wgh-qtd-sal-forn.
                            ELSE IF prazo-compra.data-entrega <> wgh-data-entrega:INPUT-VALUE THEN
                                APPLY "ENTRY":U TO wgh-data-entrega.

                            ASSIGN wgh-numero-ordem-cc0300b = ?
                                   wgh-parcela      = ?
                                   wgh-qtd-sal-forn = ?
                                   wgh-data-entrega = ?.

                            RETURN ERROR.

                        END. /* IF i-cont >= 1 THEN DO: */

                    END. /* IF AVAILABLE param-global AND
                               AVAILABLE emitente     AND
                               param-global.modulo-07 AND
                               emitente.natureza > 2  THEN DO: */
                END. /* IF prazo-compra.quantidade <> (wgh-qtd-sal-forn:INPUT-VALUE / de-indice) THEN DO: */
            END. /* IF AVAILABLE ordem-compra THEN DO: */
        END. /* IF AVAILABLE prazo-compra THEN DO: */
    END. /* IF VALID-HANDLE(wgh-numero-ordem-cc0300b) AND
               VALID-HANDLE(wgh-parcela)      THEN DO: */

    ASSIGN wgh-numero-ordem-cc0300b = ?
           wgh-parcela      = ?
           wgh-qtd-sal-forn = ?
           wgh-data-entrega = ?.
    /* 003 (03/01/2013 - Fabiano Sakae Ribeiro) - IR54921 - Bloquear alteraá∆o
       de OC embarcada. - Final */
    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - Final */

END. /* IF p-ind-event  = "valida-pend-aprovacao-qtd-forn":U AND
           p-ind-object = "CONTAINER":U                      THEN DO: */


IF p-ind-event  = "DELETE-PARCELA":U AND
   p-ind-object = "BTDELETESON1":U   THEN DO:

    /* 003 (03/01/2013 - Fabiano Sakae Ribeiro) - IR54921 - Bloquear alteraá∆o
       de OC embarcada. - In°cio */
    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - In°cio */
    RUN piTelaUPC (INPUT  p-wgh-frame:PARENT, /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,        /*** Type ***/
                   INPUT  "numero-ordem":U,   /*** Name ***/
                   INPUT  NO,                 /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-numero-ordem-cc0300b).

    RUN piTelaUPC (INPUT  p-wgh-frame,  /* fPage3 */
                   INPUT  p-ind-event,
                   INPUT  "BROWSE":U,   /*** Type ***/
                   INPUT  "BROWSE-1":U, /*** Name ***/
                   INPUT  NO,           /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,            /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-BROWSE-1).

    IF VALID-HANDLE(wgh-numero-ordem-cc0300b) AND
       VALID-HANDLE(wgh-BROWSE-1)     THEN DO:
        ASSIGN wgh-parcela-BROWSE-1 = wgh-BROWSE-1:QUERY:GET-BUFFER-HANDLE("tt-prazo-compra":U):BUFFER-FIELD("parcela":U) NO-ERROR.

        IF VALID-HANDLE(wgh-parcela-BROWSE-1) THEN DO:
            DO i-linha = 1 TO wgh-BROWSE-1:NUM-SELECTED-ROWS:
                wgh-BROWSE-1:FETCH-SELECTED-ROW(i-linha).

                FIND FIRST prazo-compra
                    WHERE prazo-compra.numero-ordem = wgh-numero-ordem-cc0300b:INPUT-VALUE
                      AND prazo-compra.parcela      = wgh-parcela-BROWSE-1:BUFFER-VALUE NO-LOCK NO-ERROR.

                IF AVAILABLE prazo-compra THEN DO:
                    FIND FIRST int-prazo-compra
                        WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                          AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

                    IF AVAILABLE int-prazo-compra             AND
                       (int-prazo-compra.nro-docto   <> "":U  OR
                        int-prazo-compra.serie-docto <> "":U) THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 17006,
                                           INPUT "Esta parcela tem ~"NF informativa~" relacionada a ela.":U +
                                                 "~~":U +
                                                 "Verifique se Ç esta parcela que deve ser altrada, se sim v† a tela de ~"NF~" e remova a informaá∆o de NF e sÇrie.":U).

                        ASSIGN wgh-numero-ordem-cc0300b = ?
                               wgh-parcela      = ?.

                        RETURN ERROR.
                    END.

                    FIND FIRST ordem-compra
                        WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.

                    IF AVAILABLE ordem-compra THEN DO:
                        IF NOT VALID-HANDLE(h-boin356vl) THEN
                            RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.

                        ASSIGN de-indice = 1.0.

                        IF VALID-HANDLE(h-boin356vl) THEN
                            RUN pi-indice IN h-boin356vl (INPUT  ordem-compra.it-codigo,
                                                          INPUT  ordem-compra.cod-emitente,
                                                          INPUT  ordem-compra.numero-ordem,
                                                          OUTPUT de-indice).

                        IF VALID-HANDLE(h-boin356vl) THEN
                            DELETE PROCEDURE h-boin356vl.

                        ASSIGN h-boin356vl = ?.

                        FIND FIRST param-global NO-LOCK NO-ERROR.

                        FIND FIRST emitente
                            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

                        IF AVAILABLE param-global AND
                           AVAILABLE emitente     AND
                           param-global.modulo-07 AND
                           emitente.natureza > 2  THEN DO:

                            FIND FIRST pedido-compr
                                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

                            RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

                            RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                                     INPUT  ordem-compra.numero-ordem,
                                                                     INPUT  prazo-compra.parcela,
                                                                     OUTPUT TABLE tt-embarque).

                            DELETE PROCEDURE h-bocx225.

                            ASSIGN h-bocx225 = ?.

                            ASSIGN i-cont     = 0
                                   c-mensagem = "":U.

                            FOR EACH tt-embarque:
                                ASSIGN i-cont = i-cont + 1.

                                IF i-cont = 1 THEN
                                    ASSIGN c-mensagem = tt-embarque.embarque.
                                ELSE
                                    ASSIGN c-mensagem = c-mensagem + ", ":U + tt-embarque.embarque.
                            END. /* FOR EACH tt-embarque: */

                            IF i-cont >= 1 THEN DO:
                                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                                   INPUT 17006,
                                                   INPUT "Atená∆o: Vocà pode ter tentado excluir uma parcela vinculada a um embarque.":U +
                                                         "~~":U +
                                                         "Esta ordem de compra est† vinculada ao(s) embarque(s) ":U + c-mensagem + ".":U + CHR(10) +
                                                         "Para exclu°-la, favor desvincular a(s) parcela(s) do(s) embarque(s) antes de efetuar a exclus∆o.":U).

                                ASSIGN wgh-numero-ordem-cc0300b     = ?
                                       wgh-BROWSE-1         = ?
                                       wgh-parcela-BROWSE-1 = ?.

                                RETURN ERROR.
                            END. /* IF i-cont >= 1 THEN DO: */
                        END. /* IF AVAILABLE param-global AND
                                   AVAILABLE emitente     AND
                                   param-global.modulo-07 AND
                                   emitente.natureza > 2  THEN DO: */
                    END. /* IF AVAILABLE ordem-compra THEN DO: */
                END. /* IF AVAILABLE prazo-compra THEN DO: */
            END. /* DO i-linha = 1 TO wgh-BROWSE-1:NUM-SELECTED-ROWS: */
        END. /* IF VALID-HANDLE(wgh-parcela-BROWSE-1) THEN DO: */
    END. /* IF VALID-HANDLE(wgh-numero-ordem-cc0300b) AND
               VALID-HANDLE(wgh-BROWSE-1)     THEN DO: */

    ASSIGN wgh-numero-ordem-cc0300b     = ?
           wgh-BROWSE-1         = ?
           wgh-parcela-BROWSE-1 = ?.
    /* 003 (03/01/2013 - Fabiano Sakae Ribeiro) - IR54921 - Bloquear alteraá∆o
       de OC embarcada. - Final */
    /* 004 (08/01/2013 - Fabiano Sakae Ribeiro) - IR55232 - coment†rios em
       Pedidos Nacionais por parcela - Final */

END. /* IF p-ind-event  = "DELETE-PARCELA":U AND
           p-ind-object = "BTDELETESON1":U   THEN DO: */


IF p-ind-event = "valida-pend-aprovacao":U THEN DO:
    IF NOT VALID-HANDLE (wgh-numero-ordem-cc0300b) THEN
        RUN piTelaUPC (INPUT  p-wgh-frame,        /* fPage0 */
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,        /*** Type ***/
                       INPUT  "numero-ordem":U,   /*** Name ***/
                       INPUT  NO,                 /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                  /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-numero-ordem-cc0300b).

    IF NOT VALID-HANDLE (wgh-ct-codigo-cc0300b) THEN
        RUN piTelaUPC (INPUT  wgh-fPage1,
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,      /*** Type ***/
                       INPUT  "ct-codigo":U,    /*** Name ***/
                       INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-ct-codigo-cc0300b).

    IF NOT VALID-HANDLE (wgh-sc-codigo-cc0300b) THEN
        RUN piTelaUPC (INPUT  wgh-fPage1,
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,      /*** Type ***/
                       INPUT  "sc-codigo":U,    /*** Name ***/
                       INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-sc-codigo-cc0300b).

    IF NOT VALID-HANDLE (wgh-cod-unid-negoc-cc0300b) THEN
        RUN piTelaUPC (INPUT  wgh-fPage1,
                       INPUT  p-ind-event,
                       INPUT  "FILL-IN":U,      /*** Type ***/
                       INPUT  "c-cod-unid-negoc":U, /*** Name ***/
                       INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                       INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                       OUTPUT wgh-cod-unid-negoc-cc0300b).

    FIND FIRST ordem-compra NO-LOCK
          WHERE ordem-compra.numero-ordem = wgh-numero-ordem-cc0300b:INPUT-VALUE NO-ERROR.

/*      IF AVAIL ordem-compra THEN DO:                                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                             */
/*          IF CAN-FIND (FIRST matriz-rat-ordem                                                                                                                                                                                                                */
/*                       WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem)                                                                                                                                                                      */
/*          AND (ordem-compra.ct-codigo      <> REPLACE(wgh-ct-codigo-cc0300b :SCREEN-VALUE,".","")                                                                                                                                                            */
/*          OR   ordem-compra.sc-codigo      <> REPLACE(wgh-sc-codigo-cc0300b :SCREEN-VALUE,".","")                                                                                                                                                            */
/*          OR   ordem-compra.cod-unid-negoc <> wgh-cod-unid-negoc-cc0300b    :SCREEN-VALUE) THEN DO:                                                                                                                                                          */
/*                                                                                                                                                                                                                                                             */
/*              RUN utp\ut-msgs.p (INPUT "show",                                                                                                                                                                                                               */
/*                                 INPUT 17006,                                                                                                                                                                                                                */
/*                                 INPUT "Atená∆o, alteraá∆o n∆o permitida!" + "~~" + "Para ordens com matriz de rateio, n∆o Ç permitida a alteraá∆o das informaá‰es de conta, centro de custo e unidade de neg¢cio, favor informar a Controladoria-Fiscal!"). */
/*              RETURN ERROR.                                                                                                                                                                                                                                  */
/*          END.                                                                                                                                                                                                                                               */
/*      END.                                                                                                                                                                                                                                                   */
END.

IF p-ind-event = "BEFORE-SAVE-RECORD":U THEN DO:

    /* 001 (22/03/2011 - Gustavo Eduardo Tamanini) - 2011/00026476 - Validaá∆o
       de item ativo ao criar ordem de compra. - In°cio */
    RUN piTelaUPC (INPUT  p-wgh-frame,
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,   /*** Type ***/
                   INPUT  "it-codigo":U, /*** Name ***/
                   INPUT  NO,            /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-item-cc0300b).

    IF CAN-FIND(FIRST item
                WHERE item.it-codigo     = wgh-item-cc0300b:SCREEN-VALUE
                  AND item.cod-obsoleto <> 1) THEN DO:

        EMPTY TEMP-TABLE RowErrors.

        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence      = 10
               RowErrors.ErrorNumber        = 17006
               RowErrors.ErrorSubType       = "WARNING":U
               RowErrors.ErrorType          = "EMS":U
               RowErrors.ErrorDescriptio    = "Item n∆o est† ativo.":U
               RowErrors.ErrorHelp          = "O Item informado n∆o est† ativo.":U.

        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END. 
    
    /* 001 (22/03/2011 - Gustavo Eduardo Tamanini) - 2011/00026476 - Validaá∆o
       de item ativo ao criar ordem de compra. - Final */
       
       
       
/****** Colocado na boin274-upc.p - chamado: 50209

    /* 002 (09/08/2012 - Fabiano Sakae Ribeiro) - CR27847 - Parametrizaá∆o de
       diversos MOQs para mesmo item / An†lise Autom†tica no Pedido. - In°cio */
    RUN piTelaUPC (INPUT  p-wgh-frame,
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,    /*** Type ***/
                   INPUT  "num-pedido":U, /*** Name ***/
                   INPUT  NO,             /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-num-pedido-cc0300b).

    FIND FIRST pedido-compr
        WHERE pedido-compr.num-pedido = INTEGER(TRIM(wgh-num-pedido-cc0300b:SCREEN-VALUE)) NO-LOCK NO-ERROR.

    IF AVAILABLE pedido-compr THEN DO:


        RUN piTelaUPC (INPUT  p-wgh-frame,
                      INPUT  p-ind-event,
                      INPUT  "FILL-IN":U,      /*** Type ***/
                      INPUT  "cod-emitente":U, /*** Name ***/
                      INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                      INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wgh-cod-emitente-cc0300b).

        ASSIGN c-mensagem = "":U
               i-cont     = 0.

        FOR FIRST tb-pr-cc NO-LOCK
            WHERE tb-pr-cc.cod-emitente = INTEGER(TRIM(wgh-cod-emitente-cc0300b:SCREEN-VALUE))
              AND tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag
              AND tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido
              AND tb-pr-cc.dt-termino  >= pedido-compr.data-pedido
              AND tb-pr-cc.situacao     = 1,
            EACH item-tab NO-LOCK
            WHERE item-tab.it-codigo    = TRIM(wgh-item-cc0300b:SCREEN-VALUE)
              AND item-tab.cod-emitente = tb-pr-cc.cod-emitente
              AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
              AND item-tab.nr-tab       = tb-pr-cc.nr-tab:

            FIND FIRST item-fornec USE-INDEX it-forn
                WHERE item-fornec.it-codigo    = item-tab.it-codigo
                  AND item-fornec.cod-emitente = item-tab.cod-emitente NO-LOCK NO-ERROR.

            FIND FIRST moeda
                WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo NO-LOCK NO-ERROR.

            ASSIGN c-mensagem = c-mensagem + STRING(item-tab.quant-min, ">>>>,>>9.9999":U) + " ":U + STRING((IF AVAILABLE item-fornec THEN item-fornec.unid-med-for ELSE "":U), "xx":U) + " - ":U + STRING((IF AVAILABLE moeda THEN moeda.sigla ELSE "":U), "x(04)":U) + " ":U + TRIM(STRING(item-tab.pr-item, ">>>>>,>>>,>>9.99999":U)) + CHR(10)
                   i-cont     = i-cont + 1.
        END. /* FOR FIRST tb-pr-cc NO-LOCK */

        IF i-cont > 1 THEN DO:
           
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 27100,
                               INPUT "Item ~"":U + TRIM(wgh-item-cc0300b:SCREEN-VALUE) + "~" tem variaá∆o de preáo MOQ. Deseja continuar?":U +
                                     "~~":U +
                                     "Item ~"":U + TRIM(wgh-item-cc0300b:SCREEN-VALUE) + "~" tem variaá∆o de preáo MOQ:":U + CHR(10) + CHR(10) + c-mensagem).
  
            IF RETURN-VALUE = "NO":U THEN
                RETURN "NOK":U.
        END. IF i-cont > 1 THEN DO:
    END. /* IF AVAILABLE pedido-compr THEN DO: */
    /* 002 (09/08/2012 - Fabiano Sakae Ribeiro) - CR27847 - Parametrizaá∆o de
       diversos MOQs para mesmo item / An†lise Autom†tica no Pedido. - Final */
       
*******************************/       


END. 

IF  p-ind-event  = "before-piSaveAndOk":U 
AND p-ind-object = "tt-ordem-compra":U               
THEN DO:
     EMPTY TEMP-TABLE tt-raw.
     EMPTY TEMP-TABLE tt-ordem-compra-aux.

     CREATE tt-raw.
     TEMP-TABLE tt-raw:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("rTarget"):BUFFER-VALUE = p-cod-table.
     FIND CURRENT tt-raw NO-ERROR.

     CREATE tt-ordem-compra-aux.
     raw-transfer tt-raw.rTarget to tt-ordem-compra-aux.
     FIND CURRENT tt-ordem-compra-aux NO-ERROR.

     IF  AVAIL tt-ordem-compra-aux
     AND CAN-FIND(FIRST b-ordem-compra WHERE
                        b-ordem-compra.numero-ordem = tt-ordem-compra-aux.numero-ordem
                        NO-LOCK)
     THEN for first tt-cc0300b-upc
              where tt-cc0300b-upc.wh-container = p-wgh-object: 
              for first int-ordem-compra
                  where int-ordem-compra.numero-ordem = tt-ordem-compra-aux.numero-ordem
                        exclusive-lock: end.
          
              if not avail int-ordem-compra
              then do:
                   create int-ordem-compra.
                   assign int-ordem-compra.numero-ordem   = tt-ordem-compra-aux.numero-ordem
                          int-ordem-compra.ind-origem-ext = 1. /* 1 - Outros; 2 - Ariba */
              end.
          
              if trim(int-ordem-compra.end-entrega) <> trim(tt-cc0300b-upc.wh-editor:screen-value)
              then assign int-ordem-compra.ind-origem-end = 1. /* 1 - Outros; 2 - Ariba */
          
              assign int-ordem-compra.end-entrega = trim(tt-cc0300b-upc.wh-editor:screen-value).
              find current int-ordem-compra no-lock no-error.
              release int-ordem-compra.

              if  valid-handle(tt-cc0300b-upc.wh-btSaveEsp)
              AND tt-cc0300b-upc.wh-btSaveEsp:sensitive
              and tt-cc0300b-upc.lg-save
              then FOR FIRST estabelec NO-LOCK
                       WHERE estabelec.cod-estabel = tt-cc0300b-upc.wh-estab-entrega:SCREEN-VALUE:
                       ASSIGN c-cep-aux = STRING(estabelec.cep,"99999-999") NO-ERROR.

                       IF ERROR-STATUS:ERROR
                       THEN ASSIGN c-cep-aux = STRING(estabelec.cep).

                       assign c-cep-aux = "Nome: "     + trim(estabelec.nome)
                                        + chr(10)
                                        + "Endereáo: " + trim(estabelec.endereco)
                                        + chr(10)
                                        + "Bairro: "   + trim(estabelec.bairro)
                                        + chr(10)
                                        + "Cidade: "   + trim(estabelec.cidade)
                                        + chr(10)
                                        + "CEP: "      + c-cep-aux
                                        + chr(10)
                                        + "UF: "       + trim(estabelec.estado)
                                        + chr(10)
                                        + "Pa°s: "     + trim(estabelec.pais)
                                        + chr(10).

                       if tt-cc0300b-upc.wh-end-entrega:screen-value <> c-cep-aux
                       then do:
                            assign c-question = "Deseja manter o endereáo atual para o pr¢ximo registro?~~Deseja manter o endereáo atual para o pr¢ximo registro? Caso a respesta seja negativa, o endereáo de entrega ser† atualizado para o default (estabelecimento)?".
                            
                            run utp/ut-msgs(input 'show',
                                            input 27100,
                                            input c-question).
                            
                            if return-value <> 'yes'
                            THEN ASSIGN tt-cc0300b-upc.wh-end-entrega:SCREEN-VALUE = c-cep-aux.
                       end.
                   END. /* FOR FIRST estabelec */

              assign tt-cc0300b-upc.lg-save = no.
          end. /* for first tt-cc0300b-upc */
END. /* IF  p-ind-event  = "before-piSaveAndOk":U */

IF p-ind-event  = "AFTER-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U               THEN DO:
    ASSIGN wgh-num-pedido-cc0300b   = ?
           wgh-cod-emitente-cc0300b = ?
           wgh-item-cc0300b         = ?
           wgh-numero-ordem-cc0300b         = ?
           wgh-parcela              = ?
           wgh-qtd-sal-forn         = ?
           wgh-data-entrega         = ?
           wgh-objeto               = ?.

    IF VALID-HANDLE(hShowMsg) THEN
        DELETE PROCEDURE hShowMsg.

    ASSIGN hShowMsg = ?.

    IF VALID-HANDLE(h-boin356vl) THEN
        DELETE PROCEDURE h-boin356vl.

    ASSIGN h-boin356vl = ?.

    IF VALID-HANDLE(h-bocx225) THEN
        DELETE PROCEDURE h-bocx225.

    ASSIGN h-bocx225 = ?.

    RUN piTelaUPC (INPUT  p-wgh-frame, /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FRAME":U,   /*** Type ***/
                   INPUT  "fPage3":U,  /*** Name ***/
                   INPUT  NO,          /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,           /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-fPage3).

    RUN piTelaUPC (INPUT  wgh-fPage3,           /* fPage3 */
                   INPUT  p-ind-event,
                   INPUT  "BUTTON":U,           /*** Type ***/
                   INPUT  "wgh-btNotaFiscal":U, /*** Name ***/
                   INPUT  NO,                   /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,                    /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-btNotaFiscal).

    ASSIGN wgh-fPage3 = ?.

    IF VALID-HANDLE(wgh-btNotaFiscal) THEN
        DELETE WIDGET wgh-btNotaFiscal.

    ASSIGN wgh-btNotaFiscal = ?.

    for first tt-cc0300b-upc
        where tt-cc0300b-upc.wh-container = p-wgh-object: 
        delete tt-cc0300b-upc.
    end.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE piNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     Chamar o programa ESCCP026 para incluir/alterar NFs das parcelas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piTelaUPC (INPUT  p-wgh-frame,      /* fPage0 */
                   INPUT  p-ind-event,
                   INPUT  "FILL-IN":U,      /*** Type ***/
                   INPUT  "numero-ordem":U, /*** Name ***/
                   INPUT  NO,               /*** Apresenta Mensagem dos Objetos ***/
                   INPUT  1,                /*** Quando existir mais de um objeto com o mesmo nome ***/
                   OUTPUT wgh-numero-ordem-cc0300b).

    RUN esp/ccp/esccp026.w (INPUT wgh-numero-ordem-cc0300b:INPUT-VALUE).

    ASSIGN wgh-numero-ordem-cc0300b = ?.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pibtSaveEsp :
    def input param p-handle as handle no-undo.

    for first tt-cc0300b-upc
        where tt-cc0300b-upc.wh-btSave = p-handle: 
        assign tt-cc0300b-upc.lg-save = yes.
        apply 'choose' to tt-cc0300b-upc.wh-btSave.
    end.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piTelaUPC :
/*------------------------------------------------------------------------------
  Purpose:     Buscar objetos na tela do produto padr∆o.
  Parameters:  pWghFrame (WIDGET-HANDLE),
               pIndEvent (CHARACTER),
               pObjType  (CHARACTER),
               pObjName  (CHARACTER),
               pApresMsg (LOGICAL),
               pAux      (INTEGER),
               phObj     (HANDLE).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pWghFrame AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER pIndEvent AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pObjType  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pObjName  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pApresMsg AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER pAux      AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER phObj     AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):
        IF pApresMsg THEN
            MESSAGE "Nome do Objeto: ":U wgh-obj:NAME SKIP
                    "Type do Objeto: ":U wgh-obj:TYPE SKIP
                    "Event: ":U          pIndEvent
                VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Tela UPC":U.

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.

        IF wgh-obj:TYPE = "FIELD-GROUP":U THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    ASSIGN wgh-obj = ?.

    RETURN "OK":U.

END PROCEDURE.

