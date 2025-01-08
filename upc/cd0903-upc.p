/*------------------------------------------------------------------------
    File        : CD0903-UPC.P
    Purpose     : UPC do programa CD0903.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Agosto de 2011
    Notes       : 2011/00033491 - Bloquear campo cd0903 - "Tipo apuraá∆o
                  de IPI".
                  2011/00034642 - Bloquear liberaá∆o de faturamento no
                  CD0903. (13/09/2011)
                  2011/00034791 - Alteraá∆o no CD0204 e CD0903.
                  (15/09/2011)
                  2011/00034965 - Alteraá∆o no CD0903. (21/09/2011)
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
DEFINE VARIABLE h-bodi538 AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-objeto  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-alterou AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-indice  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE wgh-frame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttItensUF-elim NO-UNDO
    FIELD it-codigo   AS CHAR FORMAT "X(16)"
    FIELD uf-orig     AS CHAR FORMAT "X(02)"
    FIELD uf-dest     AS CHAR FORMAT "X(02)"
    FIELD aliq-icms   AS DEC  FORMAT ">>>>9.99<<<"
    FIELD desc-item   AS CHAR FORMAT "X(100)"
    FIELD r-inf-compl AS ROWID
    FIELD r-Rowid     AS ROWID
    INDEX ch-ttItensUF IS PRIMARY UNIQUE it-codigo uf-orig uf-dest
    INDEX ch-UF uf-orig uf-dest.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE wgh-rs-apuracao-cd0903-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-it-codigo-cd0903-upc         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-fm-cod-com-cd0903-upc        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-c-desc-fam-coml-cd0903-upc   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-peso-bruto-cd0903-upc        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-peso-liquido-cd0903-upc      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-altura-cd0903-upc            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-largura-cd0903-upc           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-comprim-cd0903-upc           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-codigo-orig-cd0903-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-folder-cd0903-upc            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-lei-bem-cd0903             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tg-icms-subst-trib-antec-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-l-pis-cofins-subst-total-upc AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-c-cod-unid-negoc-cd0903-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-cod-unid-negoc-cd0903-upc      AS CHARACTER     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cd0903-upc                     AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-exporta-cd0903             AS HANDLE        NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE wh-button                        AS HANDLE        NO-UNDO. 

DEFINE NEW GLOBAL SHARED VARIABLE wgh-lote-mulven-cd0903-upc       AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hCD0903 AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-cod-ean-cd0903-upc           AS WIDGET-HANDLE NO-UNDO.

DEFINE VAR l-telaAberta    AS LOG  NO-UNDO.
DEFINE VAR l-habilita-lote AS LOG  NO-UNDO.

DEFINE VARIABLE c-estados AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont    AS INTEGER   NO-UNDO.

{esp/es0018.i}
{utp/ut-glob.i}

/* ***************************  Main Block  *************************** */
/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/* Mensagem para verificar o ponto UPC do programa */
/*MESSAGE "Evento: ":U   p-ind-event  SKIP
        "Objeto: ":U   p-ind-object SKIP
        "Nome Obj: ":U c-objeto     SKIP
        "Frame: ":U    p-wgh-frame  SKIP
        "Tabela: ":U   p-cod-table  SKIP
        "Rowid: ":U    STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do CD0903":U.   */

IF p-ind-object = 'container' THEN DO:

    IF p-ind-event = 'initialize' THEN DO:

       IF NOT VALID-HANDLE(hCD0903) THEN DO:
           ASSIGN hCD0903 = p-wgh-object.
           /*ASSIGN l-telaAberta = NO.*/
       END.
       ELSE DO:
           /*ASSIGN l-telaAberta = YES.*/
           APPLY "close" TO p-wgh-object.
           RETURN ERROR.
       END. 
    END.
    ELSE DO:
        IF p-ind-event = 'destroy' THEN DO:
            ASSIGN hCD0903 = ?.
            DELETE OBJECT hCD0903 NO-ERROR.
        END.
    END. 

END.




IF  c-objeto = "folder.w":U                 AND
    NOT VALID-HANDLE(wgh-folder-cd0903-upc) THEN DO:
    ASSIGN wgh-folder-cd0903-upc = p-wgh-object.
END.

if p-ind-event  = "BEFORE-INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    IF  VALID-HANDLE (wgh-fm-cod-com-cd0903-upc) THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atená∆o, j† existe uma Tela do CD0903 aberta em sua sess∆o EMS, favor fechar a tela recÇm aberta. ~~ " +
                                 "Por restriá‰es tÇcnicas, n∆o Ç poss°vel trabalhar com mais de uma tela do CD0903 na mesma sess∆o do EMS.").            
        
    END.
    
    IF  NOT VALID-HANDLE(wgh-fm-cod-com-cd0903-upc) THEN DO:
        RUN upc/cd0903-upc.p PERSISTENT SET h-cd0903-upc(INPUT "",            
                                                         INPUT "",            
                                                         INPUT p-wgh-object,  
                                                         INPUT p-wgh-frame,   
                                                         INPUT "",            
                                                         INPUT p-row-table).
    END.
    ELSE DO:
        /*ASSIGN l-telaaberta = YES.*/
        APPLY "close" TO p-wgh-object.
        RETURN ERROR.
    END.
    
END.

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-frame):
        IF wgh-frame:TYPE <> "field-group" THEN DO:
            IF wgh-frame:NAME = "bt-exp":U THEN DO:
                ASSIGN wh-bt-exporta-cd0903 = wgh-frame.
                LEAVE.
            END.
            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    create button wh-button  
    assign flat-button   = YES
           frame         = p-wgh-frame 
           width         = wh-bt-exporta-cd0903:WIDTH
           height        = wh-bt-exporta-cd0903:HEIGHT
           row           = wh-bt-exporta-cd0903:ROW
           col           = wh-bt-exporta-cd0903:COLUMN + wh-bt-exporta-cd0903:WIDTH
           visible       = yes
           sensitive     = yes
           tooltip       = "Importa/Exporta Planilha"
           triggers:
                on choose persistent run esp/cdp/escdp097.w.
           end triggers.

    if wh-button:load-image("image/gr-lay.bmp") then.
    if wh-button:load-image-down("image/gr-lay.bmp") then.
end.

IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v41in172.w":U THEN DO:

    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE wgh-frame <> ?:
        IF wgh-frame:TYPE <> "field-group":U THEN DO:
            IF wgh-frame:NAME = "it-codigo":U THEN DO:
                ASSIGN wgh-it-codigo-cd0903-upc = wgh-frame.
                LEAVE.
            END.

            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.
    END.
END.


IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v42in172.w":U THEN DO:
    RUN upc/cd0903-upc.p PERSISTENT SET h-cd0903-upc(INPUT "":U,
                                                     INPUT "":U,
                                                     INPUT p-wgh-object,
                                                     INPUT p-wgh-frame,
                                                     INPUT "":U,
                                                     INPUT p-row-table).

    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE wgh-frame <> ?:
        IF wgh-frame:TYPE <> "field-group":U THEN DO:
            IF wgh-frame:NAME = "fm-cod-com":U THEN
                ASSIGN wgh-fm-cod-com-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "c-desc-fam-coml":U THEN
                ASSIGN wgh-c-desc-fam-coml-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "c-cod-unid-negoc":U THEN
                ASSIGN wgh-c-cod-unid-negoc-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "lote-mulven":U THEN 
                ASSIGN wgh-lote-mulven-cd0903-upc = wgh-frame.

            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wgh-fm-cod-com-cd0903-upc) THEN
        ON "LEAVE":U OF wgh-fm-cod-com-cd0903-upc PERSISTENT RUN pi-leave-fm-cod-com IN h-cd0903-upc.

    IF VALID-HANDLE(wgh-c-cod-unid-negoc-cd0903-upc) THEN
        ASSIGN c-cod-unid-negoc-cd0903-upc = wgh-c-cod-unid-negoc-cd0903-upc:INPUT-VALUE.
END.


IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v44in172.w":U THEN DO:

    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE wgh-frame <> ?:
        IF wgh-frame:TYPE <> "field-group":U THEN DO:
            IF wgh-frame:NAME = "peso-bruto":U THEN
                ASSIGN wgh-peso-bruto-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "peso-liquido":U THEN
                ASSIGN wgh-peso-liquido-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "altura":U THEN
                ASSIGN wgh-altura-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "largura":U THEN
                ASSIGN wgh-largura-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "comprim":U THEN
                ASSIGN wgh-comprim-cd0903-upc = wgh-frame.
            IF wgh-frame:NAME = "codigo-orig":U THEN
                ASSIGN wgh-codigo-orig-cd0903-upc = wgh-frame.
            

            IF VALID-HANDLE(wgh-peso-bruto-cd0903-upc)   AND
               VALID-HANDLE(wgh-peso-liquido-cd0903-upc) AND
               VALID-HANDLE(wgh-altura-cd0903-upc)       AND
               VALID-HANDLE(wgh-largura-cd0903-upc)      AND
               VALID-HANDLE(wgh-codigo-orig-cd0903-upc)  AND
               VALID-HANDLE(wgh-comprim-cd0903-upc)      THEN LEAVE.

            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.
    END.
    ASSIGN wgh-altura-cd0903-upc:FORMAT  = ">>>,>>9.99999":U
           wgh-largura-cd0903-upc:FORMAT = ">>>,>>9.99999":U
           wgh-comprim-cd0903-upc:FORMAT = ">>>,>>9.99999":U.
END.


IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v46in172.w":U THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-cod-ean",
                     OUTPUT wgh-cod-ean-cd0903-upc).

    ASSIGN wgh-cod-ean-cd0903-upc:SENSITIVE = FALSE.

    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE wgh-frame <> ?:
        IF wgh-frame:TYPE <> "field-group":U THEN DO:
            IF wgh-frame:NAME = "rs-apuracao":U THEN DO:
                ASSIGN wgh-rs-apuracao-cd0903-upc = wgh-frame.
                LEAVE.
            END.

            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.
    END.
END.


IF  p-ind-event  = "INITIALIZE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "vb5in172.w":U THEN DO:
    ASSIGN wgh-frame = p-wgh-frame:FIRST-CHILD
           wgh-frame = wgh-frame:FIRST-CHILD.

    DO WHILE wgh-frame <> ?:
        IF wgh-frame:TYPE <> "field-group":U THEN DO:
            IF wgh-frame:NAME = "l-pis-cofins-subst-total":U THEN DO:
                ASSIGN wgh-l-pis-cofins-subst-total-upc = wgh-frame.
                LEAVE.
            END.

            ASSIGN wgh-frame = wgh-frame:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wgh-frame = wgh-frame:FIRST-CHILD.
    END.
    IF  VALID-HANDLE(wgh-l-pis-cofins-subst-total-upc) THEN
            ASSIGN wgh-l-pis-cofins-subst-total-upc:SENSITIVE = NO
                   wgh-l-pis-cofins-subst-total-upc:COLUMN = 05.

    /* Flag "Lei do Bem" - CR5403 */
    CREATE TOGGLE-BOX wh-tg-lei-bem-cd0903
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-tg-lei-bem-cd0903":U
           WIDTH     = 12
           HEIGHT    = 1
           COLUMN    = 42
           ROW       = 8.5
           LABEL     = "Lei do Bem":U
           HELP      = "Lei do Bem - Reduá∆o da al°quota do PIS/COFINS para zero, para uma lista de produtos espec°fica.":U
           SENSITIVE = NO
           VISIBLE   = YES.

               
    CREATE TOGGLE-BOX wh-tg-icms-subst-trib-antec-upc
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-tg-icms-subst-trib-antec-upc":U
           WIDTH     = 20
           HEIGHT    = 1
           COLUMN    = 60
           ROW       = 8.5
           LABEL     = "ICMS Subs.Trib.Antec":U
           HELP      = "ICMS Subs.Trib.Antec":U
           SENSITIVE = NO
           VISIBLE   = YES.

    IF  VALID-HANDLE(wgh-it-codigo-cd0903-upc) AND
        VALID-HANDLE(wh-tg-lei-bem-cd0903)     THEN DO:
        FIND FIRST int-item NO-LOCK
            WHERE  int-item.it-codigo = wgh-it-codigo-cd0903-upc:SCREEN-VALUE NO-ERROR.
        IF  AVAIL  int-item THEN
            ASSIGN wh-tg-lei-bem-cd0903:CHECKED = int-item.log2
                   wh-tg-icms-subst-trib-antec-upc:CHECKED = IF substring(int-item.char1,4,1) = "S" THEN YES ELSE NO.
    END.

END.


IF  p-ind-event  = "DISPLAY":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "vb5in172.w":U THEN DO:
    IF  VALID-HANDLE(wgh-it-codigo-cd0903-upc) AND
        VALID-HANDLE(wh-tg-lei-bem-cd0903)     THEN DO:
        FIND FIRST int-item NO-LOCK
            WHERE  int-item.it-codigo = wgh-it-codigo-cd0903-upc:SCREEN-VALUE NO-ERROR.
        IF  AVAIL  int-item THEN
            ASSIGN wh-tg-lei-bem-cd0903:CHECKED = int-item.log2
                   wh-tg-icms-subst-trib-antec-upc:CHECKED = IF substring(int-item.char1,4,1) = "S" THEN YES ELSE NO.
    END.
    IF  VALID-HANDLE(wgh-l-pis-cofins-subst-total-upc) THEN
        ASSIGN wgh-l-pis-cofins-subst-total-upc:SENSITIVE = NO
               wgh-l-pis-cofins-subst-total-upc:COLUMN = 05.


     IF VALID-HANDLE(wh-tg-icms-subst-trib-antec-upc) THEN
        ASSIGN wh-tg-icms-subst-trib-antec-upc:SENSITIVE = NO
                wgh-l-pis-cofins-subst-total-upc:COLUMN = 05.
    
END.


IF  p-ind-event  = "ENABLE":U AND
    p-ind-object = "VIEWER":U THEN DO:
    IF VALID-HANDLE(wgh-c-cod-unid-negoc-cd0903-upc) THEN DO:
        ASSIGN c-cod-unid-negoc-cd0903-upc = wgh-c-cod-unid-negoc-cd0903-upc:INPUT-VALUE.

        APPLY "LEAVE":U TO wgh-fm-cod-com-cd0903-upc.
    END.

    IF VALID-HANDLE(wgh-cod-ean-cd0903-upc) THEN
        ASSIGN wgh-cod-ean-cd0903-upc:SENSITIVE = FALSE.

    IF VALID-HANDLE(wgh-lote-mulven-cd0903-upc) THEN DO:

        ASSIGN l-habilita-lote = NO.

        RUN esp/es0018p.p (INPUT "CD0903":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
            
        FOR EACH tt-prog-ponto:
            IF CAN-FIND (FIRST usuar_grp_usuar
                         WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                           AND usuar_grp_usuar.cod_usuar     = c-seg-usuario) THEN DO:
           
                ASSIGN l-habilita-lote = YES.
                LEAVE.
            END.
        END.

        IF l-habilita-lote THEN
           ASSIGN wgh-lote-mulven-cd0903-upc:SENSITIVE = TRUE.
        ELSE
           ASSIGN wgh-lote-mulven-cd0903-upc:SENSITIVE = FALSE.

    END.

END.


IF  p-ind-event  = "AFTER-ENABLE":U AND
    p-ind-object = "VIEWER":U       THEN DO:

    /* Foi utilizado o ponto UPC da viewer "v42in172.w" (1ß Folder) pois
       Ç o £ltimo ponto UPC utilizado na habilitaá∆o dos campos para
       alteraá∆o. - Fabiano Sakae Ribeiro (Exponencial TI) - Agosto 2011 */
    IF c-objeto = "v42in172.w":U OR
       c-objeto = "v46in172.w":U THEN DO:
        IF VALID-HANDLE(wgh-rs-apuracao-cd0903-upc) THEN
            ASSIGN wgh-rs-apuracao-cd0903-upc:SENSITIVE = NO.
    END.

    IF c-objeto = "vb5in172.w":U THEN DO:
        IF  VALID-HANDLE(wh-tg-lei-bem-cd0903) THEN
            ASSIGN wh-tg-lei-bem-cd0903:SENSITIVE = YES
                   wh-tg-icms-subst-trib-antec-upc:SENSITIVE = YES.
    END.

    IF VALID-HANDLE(wgh-l-pis-cofins-subst-total-upc) THEN
        ASSIGN wgh-l-pis-cofins-subst-total-upc:SENSITIVE = NO
               wgh-l-pis-cofins-subst-total-upc:COLUMN = 05.


    IF VALID-HANDLE(wgh-c-cod-unid-negoc-cd0903-upc) THEN DO:
        ASSIGN c-cod-unid-negoc-cd0903-upc = wgh-c-cod-unid-negoc-cd0903-upc:INPUT-VALUE.

        APPLY "LEAVE":U TO wgh-fm-cod-com-cd0903-upc.
    END.

    IF VALID-HANDLE(wgh-cod-ean-cd0903-upc) THEN DO:
        ASSIGN wgh-cod-ean-cd0903-upc:SENSITIVE = FALSE.
    END.


END.


IF  p-ind-event  = "AFTER-DISABLE":U AND
    p-ind-object = "VIEWER":U        AND
    c-objeto     = "vb5in172.w":U    THEN DO:

    IF  VALID-HANDLE(wh-tg-lei-bem-cd0903) THEN
        ASSIGN wh-tg-lei-bem-cd0903:SENSITIVE = NO.
    IF  VALID-HANDLE(wh-tg-icms-subst-trib-antec-upc) THEN
        ASSIGN wh-tg-icms-subst-trib-antec-upc:SENSITIVE = NO.
    IF  VALID-HANDLE(wgh-l-pis-cofins-subst-total-upc) THEN
        ASSIGN wgh-l-pis-cofins-subst-total-upc:SENSITIVE = NO
               wgh-l-pis-cofins-subst-total-upc:COLUMN = 05.


END.


IF  p-ind-event  = "VALIDATE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v42in172.w":U THEN DO:

    IF p-cod-table = "item":U THEN DO:
        FIND FIRST item
            WHERE ROWID(item) = p-row-table NO-LOCK NO-ERROR.

        IF AVAILABLE item THEN DO:
            FIND FIRST fam-com-item
                WHERE fam-com-item.fm-cod-com = wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE NO-LOCK NO-ERROR.

            IF NOT AVAILABLE fam-com-item THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Fam°lia Comercial inv†lida":U +
                                         "~~":U +
                                         "Fam°lia Comercial inv†lida. Essa Fam°lia n∆o pode ser utilizada":U).

                RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 1).

                APPLY "ENTRY":U TO wgh-fm-cod-com-cd0903-upc.

                RETURN "NOK":U.
            END.
        END.
    END.
END.


IF  p-ind-event  = "VALIDATE":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v44in172.w":U THEN DO:

    IF DECIMAL(wgh-peso-bruto-cd0903-upc:SCREEN-VALUE) = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "O campo ~"Peso Bruto~" deve ser preenchido":U).

        RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 2).

        APPLY "ENTRY":U TO wgh-peso-bruto-cd0903-upc.

        RETURN "NOK":U.
    END.

    IF DECIMAL(wgh-peso-liquido-cd0903-upc:SCREEN-VALUE) = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "O campo ~"Peso L°quido~" deve ser preenchido":U).

        RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 2).

        APPLY "ENTRY":U TO wgh-peso-liquido-cd0903-upc.

        RETURN "NOK":U.
    END.

    IF wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE = "31000016" OR
       wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE = "31181010" OR
       wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE = "15510001" OR
       wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE = "31191016" OR
       wgh-fm-cod-com-cd0903-upc:SCREEN-VALUE = "31192016" THEN .
    ELSE
        IF wgh-it-codigo-cd0903-upc:SCREEN-VALUE BEGINS "4":U THEN DO: /* Apenas os itens acabados */
            IF DECIMAL(wgh-altura-cd0903-upc:SCREEN-VALUE) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "O campo ~"Altura~" deve ser preenchida":U).
    
                RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 2).
    
                APPLY "ENTRY":U TO wgh-altura-cd0903-upc.
    
                RETURN "NOK":U.
            END.
    
            IF DECIMAL(wgh-largura-cd0903-upc:SCREEN-VALUE) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "O campo ~"Largura~" deve ser preenchida":U).
    
                RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 2).
    
                APPLY "ENTRY":U TO wgh-largura-cd0903-upc.
    
                RETURN "NOK":U.
            END.
    
            IF DECIMAL(wgh-comprim-cd0903-upc:SCREEN-VALUE) = 0 THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "O campo ~"Comprimento~" deve ser preenchido":U).
    
                RUN label-trigger IN wgh-folder-cd0903-upc (INPUT 2).
    
                APPLY "ENTRY":U TO wgh-comprim-cd0903-upc.
    
                RETURN "NOK":U.
            END.
        END. /* IF wgh-it-codigo-cd0903-upc:SCREEN-VALUE BEGINS "4":U THEN DO: /* Apenas os itens acabados */ */
END.

IF  p-ind-event  = "ASSIGN":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "v44in172.w":U THEN DO:


    IF NOT VALID-HANDLE(h-bodi538) THEN
        RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
    
    IF wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "1" 
    OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "2" 
    OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "3" 
    OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "8" THEN DO:
        
        ASSIGN l-alterou = NO.

        RUN esp/es0018p.p (INPUT "CD0903":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN c-estados = ''.

        FOR EACH tt-prog-ponto:
            ASSIGN c-estados = IF c-estados = '' THEN tt-prog-ponto.conteudo ELSE c-estados + ',' + tt-prog-ponto.conteudo.
        END.                                 

        FOR EACH unid-feder
            WHERE unid-feder.estado <> "EX"
              AND unid-feder.estado <> "FL"
              AND unid-feder.estado <> "KY" NO-LOCK:

            DO i-cont = 1 TO NUM-ENTRIES(c-estados):
               IF unid-feder.estado <> ENTRY(i-cont,c-estados) THEN DO:
                  ASSIGN c-indice = "":U
                         c-indice = (TRIM(wgh-it-codigo-cd0903-upc:SCREEN-VALUE) + CHR(2) +
                                     TRIM(ENTRY(i-cont,c-estados)) + CHR(2) +
                                     TRIM(unid-feder.estado)) NO-ERROR.
            
                  FIND FIRST inf-compl NO-LOCK
                       WHERE inf-compl.cdn-identif = 5
                         AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
                 
                  IF NOT AVAIL inf-compl THEN DO:
                      ASSIGN l-alterou = YES.
                      RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                                                 INPUT ENTRY(i-cont,c-estados),
                                                                 INPUT unid-feder.estado,
                                                                 INPUT 4).        
                  END. 
               END.    
            END.
            

            /*
            IF unid-feder.estado <> "AM" THEN DO:
                ASSIGN c-indice = "":U
                       c-indice = (TRIM(wgh-it-codigo-cd0903-upc:SCREEN-VALUE) + CHR(2) +
                                   TRIM("AM") + CHR(2) +
                                   TRIM(unid-feder.estado)) NO-ERROR.
            
                FIND FIRST inf-compl NO-LOCK
                     WHERE inf-compl.cdn-identif = 5
                       AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/

                IF NOT AVAIL inf-compl THEN DO:
                    ASSIGN l-alterou = YES.
                    RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                                               INPUT "AM",
                                                               INPUT unid-feder.estado,
                                                               INPUT 4).        
                END.
            END.
                
            IF unid-feder.estado <> "MG" THEN DO:
                ASSIGN c-indice = "":U
                       c-indice = (TRIM(wgh-it-codigo-cd0903-upc:SCREEN-VALUE) + CHR(2) +
                                   TRIM("MG") + CHR(2) +
                                   TRIM(unid-feder.estado)) NO-ERROR.
            
                FIND FIRST inf-compl NO-LOCK
                     WHERE inf-compl.cdn-identif = 5
                       AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/

                IF NOT AVAIL inf-compl THEN DO:
                    ASSIGN l-alterou = YES.
                    RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                                               INPUT "MG",
                                                               INPUT unid-feder.estado,
                                                               INPUT 4).
                END.
            END.

            IF unid-feder.estado <> "SC" THEN DO:
                ASSIGN c-indice = "":U
                       c-indice = (TRIM(wgh-it-codigo-cd0903-upc:SCREEN-VALUE) + CHR(2) +
                                   TRIM("SC") + CHR(2) +
                                   TRIM(unid-feder.estado)) NO-ERROR.
            
                FIND FIRST inf-compl NO-LOCK
                     WHERE inf-compl.cdn-identif = 5
                       AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/

                IF NOT AVAIL inf-compl THEN DO:
                    ASSIGN l-alterou = YES.
                    RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                                               INPUT "SC",
                                                               INPUT unid-feder.estado,
                                                               INPUT 4).
                END.
            END.
	    
            IF unid-feder.estado <> "RS" THEN DO:
                ASSIGN c-indice = "":U
                       c-indice = (TRIM(wgh-it-codigo-cd0903-upc:SCREEN-VALUE) + CHR(2) +
                                   TRIM("RS") + CHR(2) +
                                   TRIM(unid-feder.estado)) NO-ERROR.
            
                FIND FIRST inf-compl NO-LOCK
                     WHERE inf-compl.cdn-identif = 5
                       AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/

                IF NOT AVAIL inf-compl THEN DO:
                    ASSIGN l-alterou = YES.
                    RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                                               INPUT "RS",
                                                               INPUT unid-feder.estado,
                                                               INPUT 4).
                END.
            END.*/
            

        END.
        IF l-alterou THEN
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 15825,
                               INPUT "Gerado cadastro de ICMS Diferenciado em Operaá‰es Interestaduais para " + c-estados).
    END.
    ELSE IF wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "0" 
         OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "4" 
         OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "5" 
         OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "6" 
         OR wgh-codigo-orig-cd0903-upc:SCREEN-VALUE = "7" THEN DO:

        RUN pi-Elimina-ItensUF IN h-bodi538 (INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                             INPUT wgh-it-codigo-cd0903-upc:SCREEN-VALUE,
                                             INPUT "",
                                             INPUT "ZZZZ",
                                             INPUT "",
                                             INPUT "ZZZZ",
                                             OUTPUT TABLE ttItensUF-elim).

        IF CAN-FIND (FIRST ttItensUF-elim) THEN
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 15825,
                               INPUT "Excluido cadastro de ICMS Diferenciado em Operaá‰es Interestaduais para o item: " + wgh-it-codigo-cd0903-upc:SCREEN-VALUE).
    END.

    IF VALID-HANDLE(h-bodi538) THEN
        DELETE PROCEDURE h-bodi538.

END.


IF  p-ind-event  = "ASSIGN":U AND
    p-ind-object = "VIEWER":U     AND
    c-objeto     = "vb5in172.w":U THEN DO:
    IF  VALID-HANDLE(wgh-it-codigo-cd0903-upc) THEN DO:
        FIND FIRST int-item EXCLUSIVE-LOCK
            WHERE  int-item.it-codigo = wgh-it-codigo-cd0903-upc:SCREEN-VALUE NO-ERROR.
        IF  NOT AVAIL int-item THEN DO:
            CREATE int-item.
            ASSIGN int-item.it-codigo = wgh-it-codigo-cd0903-upc:SCREEN-VALUE.
        END.
    
        IF  VALID-HANDLE(wh-tg-lei-bem-cd0903) THEN
            ASSIGN int-item.log2 = wh-tg-lei-bem-cd0903:CHECKED.
        IF VALID-HANDLE(wh-tg-icms-subst-trib-antec-upc) THEN
            ASSIGN OVERLAY(int-item.char1,4,1) = IF wh-tg-icms-subst-trib-antec-upc:CHECKED THEN "S" ELSE "N". 
    END.
END.

               

IF  p-ind-event  = "DESTROY":U   AND
    p-ind-object = "CONTAINER":U AND
    c-objeto     = "cd0903.w":U  THEN DO:

    
    IF VALID-HANDLE(h-cd0903-upc) THEN DO:
        DELETE PROCEDURE h-cd0903-upc.
    END.
    
    IF VALID-HANDLE(hCD0903) THEN DO:
        DELETE PROCEDURE hcd0903.
    END.
    
    ASSIGN wgh-rs-apuracao-cd0903-upc       = ?
           wgh-it-codigo-cd0903-upc         = ?
           /*wgh-fm-cod-com-cd0903-upc        = ?*/
           wgh-c-desc-fam-coml-cd0903-upc   = ?
           wgh-peso-bruto-cd0903-upc        = ?
           wgh-peso-liquido-cd0903-upc      = ?
           wgh-altura-cd0903-upc            = ?
           wgh-largura-cd0903-upc           = ?
           wgh-comprim-cd0903-upc           = ?
           wgh-folder-cd0903-upc            = ?
           wh-tg-lei-bem-cd0903             = ?
           wh-tg-icms-subst-trib-antec-upc = ?

           wgh-l-pis-cofins-subst-total-upc = ?
           wgh-c-cod-unid-negoc-cd0903-upc  = ?
           h-cd0903-upc                     = ?.

END.

RETURN "OK":U.


PROCEDURE pi-leave-fm-cod-com :
    DEFINE VARIABLE i-sequencia      LIKE conteudo-programa.sequencia NO-UNDO.
    DEFINE VARIABLE i_cdn_unid_negoc LIKE unid_negoc.cdn_unid_negoc     NO-UNDO.

    IF VALID-HANDLE(wgh-fm-cod-com-cd0903-upc)       AND
       VALID-HANDLE(wgh-c-desc-fam-coml-cd0903-upc)  AND
       VALID-HANDLE(wgh-c-cod-unid-negoc-cd0903-upc) THEN DO:
        FIND FIRST fam-comerc
            WHERE fam-comerc.fm-cod-com = wgh-fm-cod-com-cd0903-upc:INPUT-VALUE NO-LOCK NO-ERROR.

        IF AVAILABLE fam-comerc THEN
            ASSIGN wgh-c-desc-fam-coml-cd0903-upc:SCREEN-VALUE = fam-comerc.descricao.
        ELSE
            ASSIGN wgh-c-desc-fam-coml-cd0903-upc:SCREEN-VALUE = "":U.

        ASSIGN i-sequencia = INTEGER(SUBSTRING(wgh-fm-cod-com-cd0903-upc:INPUT-VALUE, 1, 2)) NO-ERROR.

        RELEASE unid_negoc.

        IF NOT ERROR-STATUS:ERROR THEN DO:
            FOR FIRST ponto-programa NO-LOCK
                WHERE ponto-programa.nome-programa = "boes513":U
                  AND ponto-programa.ponto         = 1,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = i-sequencia:
                ASSIGN i_cdn_unid_negoc = INTEGER(conteudo-programa.conteudo) NO-ERROR.

                IF NOT ERROR-STATUS:ERROR THEN DO:
                    FIND FIRST unid_negoc
                        WHERE unid_negoc.cdn_unid_negoc = i_cdn_unid_negoc NO-LOCK NO-ERROR.

                    IF AVAILABLE unid_negoc THEN
                        ASSIGN wgh-c-cod-unid-negoc-cd0903-upc:SCREEN-VALUE = unid_negoc.cod_unid_negoc
                               wgh-c-cod-unid-negoc-cd0903-upc:SENSITIVE    = NO.
                END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */
            END. /* FOR FIRST ponto-programa NO-LOCK
                        WHERE ponto-programa.nome-programa = "boes513":U
                          AND ponto-programa.ponto         = 1,
                        FIRST conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.sequencia    = i-sequencia: */
        END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */

        IF NOT AVAILABLE unid_negoc THEN
            ASSIGN wgh-c-cod-unid-negoc-cd0903-upc:SCREEN-VALUE = c-cod-unid-negoc-cd0903-upc
                   wgh-c-cod-unid-negoc-cd0903-upc:SENSITIVE    = YES.

        APPLY "LEAVE":U TO wgh-c-cod-unid-negoc-cd0903-upc.
    END.

    RETURN "OK":U.

END PROCEDURE.




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



