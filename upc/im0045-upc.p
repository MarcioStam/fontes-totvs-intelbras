/***********************************************************************
**  Programa..: upc\im0045-upc.p
**  Autor.....: Osnir
**  Data......: Agosto/2008
**  Descricao.: 
**  VersÆo....: 001 - 00/00/
**                  Desenvolvimento Programa
************************************************************************/

//{utp/ut-glob.i}

DEFINE INPUT PARAMETER p-ind-event  as char          no-undo.
DEFINE INPUT PARAMETER p-ind-object as char          no-undo.
DEFINE INPUT PARAMETER p-wgh-object as handle        no-undo.
DEFINE INPUT PARAMETER p-wgh-frame  as widget-handle no-undo.
DEFINE INPUT PARAMETER p-cod-table  as char          no-undo.
DEFINE INPUT PARAMETER p-row-table  as rowid         no-undo.

DEFINE VARIABLE h-object AS HANDLE NO-UNDO.
DEFINE VARIABLE h-campo  AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-programa                   AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-window                   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage1-im0045             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-data-emb-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-emb-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-data-ent-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-ent-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-fpage2-im0045             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-declaracao-import-im0045  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-via-transp-im0045         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-incoterm-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estab-im0045          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-emb-im0045            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-cb-conteiner-im0045       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-conteiner-im0045       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-cb-finalidade-im0045      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-finalidade-im0045      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-qt-ctnr-im0045            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qt-ctnr-im0045            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-qt2-ctnr-im0045           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE tx-volume-ctnr-im0045        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-conhecto-house-im0045 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-im0045-upc                 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

DEFINE BUFFER bf-embarque-imp FOR embarque-imp.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) skip
        "c-char " c-char 
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

    /*fPage1*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage1",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage1-im0045).

    /*fPage2*/
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",       /*** Type ***/
                  INPUT "fPage2",      /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-fpage2-im0045).

    /*Declaracao import*/
    RUN tela-upc (INPUT wh-fpage2-im0045,
                  INPUT p-ind-Event,
                  INPUT "fill-in",              /*** Type ***/
                  INPUT "declaracao-import",    /*** Name ***/
                  INPUT NO,                      /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                     /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-declaracao-import-im0045).

    /*Conhecimento House*/
    RUN tela-upc (INPUT wh-fpage1-im0045,
                  INPUT p-ind-Event,
                  INPUT "fill-in",             /*** Type ***/
                  INPUT "cod-conhecto-house",  /*** Name ***/
                  INPUT NO,                    /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                     /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-conhecto-house-im0045).

    IF NOT VALID-HANDLE(h-im0045-upc) THEN
       RUN upc/im0045-upc.p PERSISTENT SET h-im0045-upc(INPUT "",
                                                        INPUT "",
                                                        INPUT p-wgh-object,
                                                        INPUT p-wgh-frame,
                                                        INPUT "",
                                                        INPUT p-row-table).
    IF VALID-HANDLE(wh-fpage1-im0045) THEN DO:
        CREATE TEXT tx-data-emb-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(12)"
               WIDTH        = 12
               SCREEN-VALUE = "Dt.Embarque:"
               ROW          = 5.42
               COL          = 65.5
               VISIBLE      = YES.

        CREATE FILL-IN wh-data-emb-im0045
        ASSIGN FRAME             = wh-fpage1-im0045
               DATA-TYPE         = "Character"
               FORMAT            = "x(10)" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 5.22
               COL               = 75.3
               VISIBLE           = YES
               SENSITIVE         = NO.

        CREATE TEXT tx-data-ent-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(11)"
               WIDTH        = 12
               SCREEN-VALUE = "Dt.Entrada:"
               ROW          = 6.42
               COL          = 67.2
               VISIBLE      = YES.

        CREATE FILL-IN wh-data-ent-im0045
        ASSIGN FRAME             = wh-fpage1-im0045
               DATA-TYPE         = "Character"
               FORMAT            = "x(10)" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 6.22
               COL               = 75.3
               VISIBLE           = YES
               SENSITIVE         = NO.

        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        CREATE TEXT tx-cb-conteiner-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(05)"
               WIDTH        = 10.57
               SCREEN-VALUE = "Tipo:"
               HEIGHT       = 0.88
               ROW          = 7.25
               COL          = 1.00
               VISIBLE      = YES.
        
        CREATE COMBO-BOX wh-cb-conteiner-im0045
        ASSIGN FRAME           = wh-fpage1-im0045
               FORMAT          = "x(18)":U
               WIDTH           = 17
               ROW             = 7.25
               COL             = 4.57
               FONT            = 1
               LIST-ITEM-PAIRS = ",0,Contˆiner de 20,Contˆiner de 20,Contˆiner de 40,Contˆiner de 40,Contˆiner de 20/40,Contˆiner de 20/40,NOR 20,NOR 20,NOR 40,NOR 40,Carga Solta,Carga Solta"
               VISIBLE         = YES
           TRIGGERS:
                ON VALUE-CHANGED PERSISTENT RUN pi-habilita-campo IN h-im0045-upc.
           END TRIGGERS.

        wh-cb-conteiner-im0045:MOVE-AFTER-TAB-ITEM(wh-cod-conhecto-house-im0045).

        CREATE TEXT tx-qt-ctnr-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(15)"
               WIDTH        = 10.57
               SCREEN-VALUE = "Qt.Contˆiner:"
               HEIGHT       = 0.88
               ROW          = 7.25
               COL          = 22.86
               VISIBLE      = YES.

        CREATE FILL-IN wh-qt-ctnr-im0045
        ASSIGN FRAME       = wh-fpage1-im0045
               DATA-TYPE   = "INTEGER"
               FORMAT      = ">,>>>,>>9" 
               WIDTH       = 8.86
               HEIGHT      = 0.88
               ROW         = 7.25
               COL         = 31.86
               VISIBLE     = YES
               SENSITIVE   = NO.

        CREATE FILL-IN wh-qt2-ctnr-im0045
        ASSIGN FRAME       = wh-fpage1-im0045
               DATA-TYPE   = "INTEGER"
               FORMAT      = ">,>>>,>>9" 
               WIDTH       = 8.86
               HEIGHT      = 0.88
               ROW         = 7.25
               COL         = 41.86
               VISIBLE     = NO
               SENSITIVE   = NO.

        
        CREATE TEXT tx-volume-ctnr-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(8)"
               WIDTH        = 9
               SCREEN-VALUE = "VOLUMES"
               HEIGHT       = 0.88
               ROW          = 7.25
               COL          = 41.86
               VISIBLE      = NO.
        
        CREATE TEXT tx-cb-finalidade-im0045
        ASSIGN FRAME        = wh-fpage1-im0045
               FORMAT       = "x(16)"
               WIDTH        = 16
               SCREEN-VALUE = "Finalid.Courier:"
               HEIGHT       = 0.88
               ROW          = 7.25
               COL          = 52.00
               VISIBLE      = NO.
        
        CREATE COMBO-BOX wh-cb-finalidade-im0045
        ASSIGN FRAME           = wh-fpage1-im0045
               FORMAT          = "x(22)":U
               WIDTH           = 22
               ROW             = 7.25
               COL             = 63
               FONT            = 1
               LIST-ITEM-PAIRS = ",0,Amostra,1,Industrializa‡Æo/Revenda,2,Documento,3"
               SCREEN-VALUE    = "1"
               VISIBLE         = NO.

        wh-qt-ctnr-im0045:MOVE-AFTER-TAB-ITEM(wh-cb-conteiner-im0045).

        wh-qt2-ctnr-im0045:MOVE-AFTER-TAB-ITEM(wh-qt-ctnr-im0045).
    /*----------------------------------------------[ Referente chamado 26630 ]---*/
    END.
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-INITIALIZE" 
THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "cod-estabel",  /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-estab-im0045).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "embarque",     /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-cod-emb-im0045).

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",        /*** Type ***/
                  INPUT "fpage1",       /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-via-transp-im0045).

    /*fPage1*/
    RUN tela-upc (INPUT wh-via-transp-im0045,
                  INPUT p-ind-Event,
                  INPUT "COMBO-BOX",          /*** Type ***/
                  INPUT "cx-via-transporte",  /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                    /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-via-transp-im0045).

    ON VALUE-CHANGED OF wh-via-transp-im0045
        PERSISTENT RUN pi-habilita-via-transp IN h-im0045-upc.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "frame",        /*** Type ***/
                  INPUT "fpage1",       /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-incoterm-im0045).

    /*fPage1*/
    RUN tela-upc (INPUT wh-incoterm-im0045,
                  INPUT p-ind-Event,
                  INPUT "fill-in",            /*** Type ***/
                  INPUT "cod-incoterm",       /*** Name ***/
                  INPUT NO,                   /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                    /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-incoterm-im0045).

    wh-incoterm-im0045:COL = wh-incoterm-im0045:COL - 5.
    wh-incoterm-im0045     = wh-incoterm-im0045:SIDE-LABEL-HANDLE.
    wh-incoterm-im0045:COL = wh-incoterm-im0045:COL - 5.

END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-ENABLE" 
THEN DO:
    IF  VALID-HANDLE(wh-via-transp-im0045) AND
        VALID-HANDLE(wh-cod-estab-im0045)  AND 
        VALID-HANDLE(wh-cod-emb-im0045)    AND
        VALID-HANDLE(wh-incoterm-im0045)   AND
        wh-cod-estab-im0045:SENSITIVE = NO AND
        wh-cod-emb-im0045:SENSITIVE   = NO
    THEN DO:
        FIND FIRST ordens-embarque NO-LOCK
            WHERE  ordens-embarque.cod-estabel = wh-cod-estab-im0045:SCREEN-VALUE
              AND  ordens-embarque.embarque    = wh-cod-emb-im0045:SCREEN-VALUE NO-ERROR.

        IF  AVAIL ordens-embarque
        THEN
            ASSIGN wh-via-transp-im0045:SENSITIVE = NO
                   wh-incoterm-im0045:SENSITIVE   = NO.
    END.

    RUN pi-habilita-via-transp.

    /*---[ Referente chamado 26630 ]----------------------------------------------*/
    IF  VALID-HANDLE(wh-cod-conhecto-house-im0045)
    AND VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
        ASSIGN wh-cb-conteiner-im0045:SENSITIVE = wh-cod-conhecto-house-im0045:SENSITIVE.

        FIND FIRST embarque-imp
             WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
        IF  AVAIL embarque-imp THEN DO:
            /*---[ Referente chamado 26630 ]----------------------------------------------*/
            FIND FIRST ext-embarque-imp NO-LOCK
                WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
            IF  AVAIL  ext-embarque-imp THEN DO:
                IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
                    ASSIGN wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0,Contˆiner de 20,Contˆiner de 20,Contˆiner de 40,Contˆiner de 40,Contˆiner de 20/40,Contˆiner de 20/40,NOR 20,NOR 20,NOR 40,NOR 40,Carga Solta,Carga Solta".
    
                    CASE ext-embarque-imp.conteiner:
                        WHEN 1 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20":U.
                        WHEN 2 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 40":U.
                        WHEN 3 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20/40":U.
                        WHEN 4 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 20":U.
                        WHEN 5 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 40":U.
                        WHEN 6 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Carga Solta":U.
                        OTHERWISE ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "":U.
                    END CASE.                                                                        .
                END.

                IF  VALID-HANDLE(wh-qt-ctnr-im0045) THEN DO:
                    ASSIGN wh-qt-ctnr-im0045:SCREEN-VALUE = STRING(ext-embarque-imp.qtd-conteiner).
                END.

                IF  ext-embarque-imp.conteiner = 3 /* Contˆiner de 20/40 */ THEN DO:
                    IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                        ASSIGN wh-qt2-ctnr-im0045:VISIBLE      = TRUE.
                               wh-qt2-ctnr-im0045:SCREEN-VALUE = STRING(ext-embarque-imp.qtd2-conteiner).
                    END.
                END.
                ELSE DO:
                    IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                        ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
                    END.
                END.

                IF  ext-embarque-imp.conteiner = 6 /* Carga Solta */ THEN DO:
                    IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                        ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
                    END.
                    IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                        ASSIGN tx-volume-ctnr-im0045:VISIBLE = TRUE.
                    END.
                END.
                ELSE DO:
                    IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                        ASSIGN tx-volume-ctnr-im0045:VISIBLE = FALSE.
                    END.
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN ASSIGN wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0".
                IF  VALID-HANDLE(wh-qt-ctnr-im0045)      THEN ASSIGN wh-qt-ctnr-im0045:SCREEN-VALUE    = "0"
                                                                     wh-qt-ctnr-im0045:SENSITIVE       = FALSE.
                
                ASSIGN wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0,Contˆiner de 20,Contˆiner de 20,Contˆiner de 40,Contˆiner de 40,Contˆiner de 20/40,Contˆiner de 20/40,NOR 20,NOR 20,NOR 40,NOR 40,Carga Solta,Carga Solta".
                IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                    ASSIGN tx-volume-ctnr-im0045:VISIBLE = FALSE.
                END.

                IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
                END.
            END.
            /*----------------------------------------------[ Referente chamado 26630 ]---*/
        END.

        APPLY "VALUE-CHANGED":U TO wh-cb-conteiner-im0045.
    END.

END.

IF p-ind-object = "CONTAINER" AND
   p-ind-event = "AFTER-DISABLE"
THEN DO:
    /*---[ Referente chamado 26630 ]----------------------------------------------*/
    IF  VALID-HANDLE(wh-cod-conhecto-house-im0045)
    AND VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
        ASSIGN wh-cb-conteiner-im0045:SENSITIVE = wh-cod-conhecto-house-im0045:SENSITIVE
               wh-qt-ctnr-im0045:SENSITIVE      = wh-cod-conhecto-house-im0045:SENSITIVE.

        IF VALID-HANDLE(wh-qt2-ctnr-im0045) THEN wh-qt2-ctnr-im0045:SENSITIVE = wh-cod-conhecto-house-im0045:SENSITIVE.

    END.

    IF VALID-HANDLE(wh-cb-finalidade-im0045)
    THEN wh-cb-finalidade-im0045:SENSITIVE = NO.

    /*----------------------------------------------[ Referente chamado 26630 ]---*/
END.

IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DISPLAY" THEN DO:

    IF VALID-HANDLE(tx-cb-finalidade-im0045) 
    THEN ASSIGN
       tx-cb-finalidade-im0045:VISIBLE   = NO
       wh-cb-finalidade-im0045:VISIBLE   = NO.

    IF VALID-HANDLE(wh-data-emb-im0045) AND VALID-HANDLE(wh-data-ent-im0045) THEN DO:
        ASSIGN wh-data-emb-im0045:SCREEN-VALUE = ""
               wh-data-ent-im0045:SCREEN-VALUE = "".

        FIND FIRST embarque-imp 
             WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
        IF  AVAIL embarque-imp THEN DO:
            FOR EACH historico-embarque NO-LOCK
               WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                 AND historico-embarque.embarque    = embarque-imp.embarque,
               FIRST itinerario NO-LOCK                                    
               WHERE itinerario.cod-itiner = historico-embarque.cod-itiner:

                /*data embrarque*/
                IF itinerario.pto-embarque = historico-embarque.cod-pto-contr THEN DO:
                    ASSIGN wh-data-emb-im0045:SCREEN-VALUE = IF historico-embarque.dt-efetiva <> ? THEN STRING(historico-embarque.dt-efetiva,"99/99/9999") ELSE "".
                END.

                /*data entrada intelbras*/
                IF itinerario.pto-chegada = historico-embarque.cod-pto-contr THEN DO:
                    ASSIGN wh-data-ent-im0045:SCREEN-VALUE = IF historico-embarque.dt-efetiva <> ? THEN STRING(historico-embarque.dt-efetiva,"99/99/9999") ELSE "".
                END.
            END.
        END.
    END.

    FIND FIRST embarque-imp 
         WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
    IF  AVAIL embarque-imp THEN DO:
        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        FIND FIRST ext-embarque-imp NO-LOCK
            WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
            AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  AVAIL  ext-embarque-imp THEN DO:
            IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
                ASSIGN wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0,Contˆiner de 20,Contˆiner de 20,Contˆiner de 40,Contˆiner de 40,Contˆiner de 20/40,Contˆiner de 20/40,NOR 20,NOR 20,NOR 40,NOR 40,Carga Solta,Carga Solta".
                CASE ext-embarque-imp.conteiner:
                    WHEN 1 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20":U.   
                    WHEN 2 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 40":U.   
                    WHEN 3 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20/40":U.
                    WHEN 4 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 20":U.
                    WHEN 5 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 40":U.
                    WHEN 6 THEN ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "Carga Solta":U.
                    OTHERWISE ASSIGN wh-cb-conteiner-im0045:SCREEN-VALUE = "":U.
                END CASE.                                                                        .
            END.

            IF VALID-HANDLE(tx-cb-finalidade-im0045) 
            THEN DO:
               wh-cb-finalidade-im0045:LIST-ITEM-PAIRS = ",0,Amostra,1,Industrializa‡Æo/Revenda,2,Documento,3".
               wh-cb-finalidade-im0045:SCREEN-VALUE    = STRING(ext-embarque-imp.finalidade-currier).
            END.

            IF  VALID-HANDLE(wh-qt-ctnr-im0045) THEN DO:
                ASSIGN wh-qt-ctnr-im0045:SCREEN-VALUE = STRING(ext-embarque-imp.qtd-conteiner).
            END.

            IF  ext-embarque-imp.conteiner = 3 /* Contˆiner de 20/40 */ THEN DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0045:VISIBLE      = TRUE.
                           wh-qt2-ctnr-im0045:SCREEN-VALUE = STRING(ext-embarque-imp.qtd2-conteiner).
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
                END.
            END.

            IF  ext-embarque-imp.conteiner = 6 /* Carga Solta */ THEN DO:
                IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                    ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
                END.
                IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                    ASSIGN tx-volume-ctnr-im0045:VISIBLE = TRUE.
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                    ASSIGN tx-volume-ctnr-im0045:HIDDEN = TRUE.
                END.
            END.
            IF  VALID-HANDLE(wh-cb-finalidade-im0045) 
            THEN DO:
               IF embarque-imp.cod-via-transp = 8
               THEN ASSIGN 
                  tx-cb-finalidade-im0045:VISIBLE   = YES
                  wh-cb-finalidade-im0045:VISIBLE   = YES.
            END.

        END.
        ELSE DO:
            IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN ASSIGN wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0".
            IF  VALID-HANDLE(wh-qt-ctnr-im0045)      THEN ASSIGN wh-qt-ctnr-im0045:SCREEN-VALUE    = "0"
                                                                 wh-qt-ctnr-im0045:SENSITIVE       = FALSE.
            
            ASSIGN 
               wh-cb-conteiner-im0045:LIST-ITEM-PAIRS = ",0,Contˆiner de 20,Contˆiner de 20,Contˆiner de 40,Contˆiner de 40,Contˆiner de 20/40,Contˆiner de 20/40,NOR 20,NOR 20,NOR 40,NOR 40,Carga Solta,Carga Solta".

            IF  VALID-HANDLE(tx-volume-ctnr-im0045) THEN DO:
                ASSIGN tx-volume-ctnr-im0045:VISIBLE = FALSE.
            END.

            IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:
                ASSIGN wh-qt2-ctnr-im0045:HIDDEN = TRUE.
            END.
        END.
        /*----------------------------------------------[ Referente chamado 26630 ]---*/
    END.

END.

IF p-ind-object = "CONTAINER"     AND
   p-ind-event = "before-assign" THEN DO:

    IF VALID-HANDLE(wh-declaracao-import-im0045) AND wh-declaracao-import-im0045:SCREEN-VALUE <> "" THEN DO:
        FIND FIRST embarque-imp 
             WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
        
        IF NOT AVAIL embarque-imp THEN RETURN "ok".
        FIND FIRST bf-embarque-imp 
             WHERE bf-embarque-imp.declaracao-import = wh-declaracao-import-im0045:SCREEN-VALUE 
               AND bf-embarque-imp.embarque <> embarque-imp.embarque NO-LOCK NO-ERROR.
        IF AVAIL bf-embarque-imp THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 15825,
                               INPUT "Existe outro embarque com mesmo numero de DI~~":U + 
                                     substitute("Existe outro embarque com mesmo numero de DI: Embarque &1. VERIFIQUE!", trim(bf-embarque-imp.embarque))).
        END.
    END.

    IF  VALID-HANDLE(wh-qt-ctnr-im0045) THEN DO:

        IF  wh-qt-ctnr-im0045:SENSITIVE AND wh-qt-ctnr-im0045:SCREEN-VALUE = "0" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "PROCESSO INTERROMPIDO. Deve ser informada a quantidade do Contˆiner.~~Quando marcado como Contˆiner, a quantidade deve ser informada.").
            APPLY 'ENTRY':U TO wh-qt-ctnr-im0045.
            RETURN ERROR.
        END.
    END.

    IF  VALID-HANDLE(wh-qt2-ctnr-im0045) THEN DO:

        IF  wh-qt2-ctnr-im0045:SENSITIVE AND wh-qt2-ctnr-im0045:SCREEN-VALUE = "0" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "PROCESSO INTERROMPIDO. Deve ser informada a segunda quantidade do Contˆiner.~~Quando marcado como Contˆiner 20/40, a segunda quantidade deve ser informada.").
            APPLY 'ENTRY':U TO wh-qt2-ctnr-im0045.
            RETURN ERROR.
        END.
    END.

END.

IF p-ind-object = "CONTAINER" AND
   p-ind-event  = "AFTER-ASSIGN" THEN DO:

    /*---[ Referente chamado 26630 ]----------------------------------------------*/

    FIND FIRST embarque-imp 
         WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
    IF  AVAIL embarque-imp THEN DO:

        FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
            WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
            AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  NOT AVAIL  ext-embarque-imp THEN DO:
            CREATE ext-embarque-imp.
            ASSIGN ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel 
                   ext-embarque-imp.embarque    = embarque-imp.embarque.
        END.
        IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
            
            ASSIGN ext-embarque-imp.conteiner = IF wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20":U
                                                THEN 1
                                                ELSE IF wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 40":U
                                                     THEN 2
                                                     ELSE IF wh-cb-conteiner-im0045:SCREEN-VALUE = "Contˆiner de 20/40":U
                                                          THEN 3
                                                          ELSE IF wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 20":U
                                                               THEN 4
                                                               ELSE IF wh-cb-conteiner-im0045:SCREEN-VALUE = "NOR 40":U
                                                                    THEN 5
                                                                    ELSE IF wh-cb-conteiner-im0045:SCREEN-VALUE = "Carga Solta":U
                                                                         THEN 6
                                                                         ELSE 0.

            IF VALID-HANDLE(tx-cb-finalidade-im0045) 
            THEN ASSIGN 
               ext-embarque-imp.finalidade-currier = INT(wh-cb-finalidade-im0045:SCREEN-VALUE).
        END.
        IF VALID-HANDLE(wh-qt-ctnr-im0045)  THEN ASSIGN ext-embarque-imp.qtd-conteiner  = integer(wh-qt-ctnr-im0045:SCREEN-VALUE).
        IF VALID-HANDLE(wh-qt2-ctnr-im0045) THEN ASSIGN ext-embarque-imp.qtd2-conteiner = integer(wh-qt2-ctnr-im0045:SCREEN-VALUE).
    END.
    /*----------------------------------------------[ Referente chamado 26630 ]---*/
END.

IF p-ind-object = "CONTAINER"     AND
   p-ind-event = "BEFORE-DELETE" THEN DO:

    FIND FIRST embarque-imp 
         WHERE ROWID(embarque-imp) = p-row-table NO-LOCK NO-ERROR.
    IF AVAIL embarque-imp THEN DO:
        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
               AND historico-embarque.embarque    = embarque-imp.embarque
               AND historico-embarque.dt-efetiva  <> ? NO-ERROR.

        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.embarque = embarque-imp.embarque NO-ERROR.

        IF NOT AVAIL historico-embarque AND
           NOT AVAIL ordens-embarque   THEN DO:
            for each decl-hist-embarq-imp
                where decl-hist-embarq-imp.cod-estabel = embarque-imp.cod-estabel
                  and decl-hist-embarq-imp.embarque    = embarque-imp.embarque   exclusive-lock:
                delete decl-hist-embarq-imp.
            end.

            for each historico-embarque
                where historico-embarque.cod-estabel = embarque-imp.cod-estabel
                  and historico-embarque.embarque    = embarque-imp.embarque   exclusive-lock:
                delete historico-embarque.
            end.

            for each desp-embarque
                where desp-embarque.cod-estabel = embarque-imp.cod-estabel
                  and desp-embarque.embarque    = embarque-imp.embarque   exclusive-lock:
                delete desp-embarque.
            end.

            for each invoice-emb-imp
                where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
                  and invoice-emb-imp.embarque    = embarque-imp.embarque    exclusive-lock:
                delete invoice-emb-imp.
            end.
        END.

        /*---[ Referente chamado 26630 ]----------------------------------------------*/
        FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
            WHERE  ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
            AND    ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.
        IF  AVAIL  ext-embarque-imp THEN DO:
            DELETE ext-embarque-imp.
        END.
        /*----------------------------------------------[ Referente chamado 26630 ]---*/
    END.
END.


IF p-ind-object = "CONTAINER"       AND
   p-ind-event = "AFTER-COPY"       AND
   VALID-HANDLE(wh-data-emb-im0045) AND 
   VALID-HANDLE(wh-data-ent-im0045) THEN DO:

    ASSIGN wh-data-emb-im0045:SCREEN-VALUE = ""
           wh-data-ent-im0045:SCREEN-VALUE = "".
END.


IF p-ind-object = "CONTAINER"   AND
   p-ind-event = "AFTER-DESTROY-INTERFACE" 
THEN DO:
    ASSIGN wh-fpage1-im0045             = ?
           tx-data-emb-im0045           = ?
           wh-data-emb-im0045           = ?
           tx-data-ent-im0045           = ?
           wh-data-ent-im0045           = ?
           wh-fpage2-im0045             = ?
           wh-declaracao-import-im0045  = ?
           wh-via-transp-im0045         = ?
           wh-incoterm-im0045           = ?
           wh-cod-estab-im0045          = ?
           wh-cod-emb-im0045            = ?
           tx-qt-ctnr-im0045            = ?
           wh-qt-ctnr-im0045            = ?
           wh-qt2-ctnr-im0045           = ?
           tx-volume-ctnr-im0045        = ?
           wh-cod-conhecto-house-im0045 = ?
           h-im0045-upc                 = ?
           .
END.


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
END PROCEDURE. /* tela-upc */

PROCEDURE pi-habilita-campo:
    IF  VALID-HANDLE(wh-cb-conteiner-im0045) THEN DO:
        IF  wh-cb-conteiner-im0045:SCREEN-VALUE BEGINS "Cont":U 
        OR  wh-cb-conteiner-im0045:SCREEN-VALUE BEGINS "NOR":U 
        OR  wh-cb-conteiner-im0045:SCREEN-VALUE BEGINS "Car":U THEN DO:
            IF VALID-HANDLE(wh-qt-ctnr-im0045) THEN ASSIGN wh-qt-ctnr-im0045:SENSITIVE = TRUE.

            IF  wh-cb-conteiner-im0045:SCREEN-VALUE BEGINS "Contˆiner de 20/40":U THEN DO:
                 IF VALID-HANDLE(wh-qt2-ctnr-im0045) THEN ASSIGN wh-qt2-ctnr-im0045:VISIBLE      = TRUE
                                                                 wh-qt2-ctnr-im0045:SENSITIVE    = TRUE.
            END.
            ELSE DO:
                IF VALID-HANDLE(wh-qt2-ctnr-im0045) THEN ASSIGN wh-qt2-ctnr-im0045:SCREEN-VALUE = '0'
                                                                wh-qt2-ctnr-im0045:SENSITIVE    = FALSE
                                                                wh-qt2-ctnr-im0045:HIDDEN       = TRUE.

                IF  wh-cb-conteiner-im0045:SCREEN-VALUE BEGINS "Carga Solta":U THEN DO:
                    IF VALID-HANDLE(tx-volume-ctnr-im0045) THEN ASSIGN tx-volume-ctnr-im0045:VISIBLE = TRUE.
                END.
                ELSE DO:
                    IF VALID-HANDLE(tx-volume-ctnr-im0045) THEN ASSIGN tx-volume-ctnr-im0045:HIDDEN = TRUE.
                END.
            END.
        END.
        ELSE DO:
            IF VALID-HANDLE(tx-volume-ctnr-im0045) THEN ASSIGN tx-volume-ctnr-im0045:HIDDEN = TRUE.

            IF VALID-HANDLE(wh-qt-ctnr-im0045) THEN ASSIGN wh-qt-ctnr-im0045:SCREEN-VALUE = '0'
                                                           wh-qt-ctnr-im0045:SENSITIVE    = FALSE.

            IF VALID-HANDLE(wh-qt2-ctnr-im0045) THEN ASSIGN wh-qt2-ctnr-im0045:SCREEN-VALUE = '0'
                                                            wh-qt2-ctnr-im0045:SENSITIVE    = FALSE
                                                            wh-qt2-ctnr-im0045:HIDDEN       = TRUE.
        END.
    END.
END PROCEDURE. /* pi-habilita-campo */

PROCEDURE pi-habilita-via-transp:
    IF VALID-HANDLE(tx-cb-finalidade-im0045) 
    THEN DO:
       ASSIGN
          tx-cb-finalidade-im0045:VISIBLE   = NO
          wh-cb-finalidade-im0045:VISIBLE   = NO
          wh-cb-finalidade-im0045:SENSITIVE = NO.
       
       IF wh-via-transp-im0045:SCREEN-VALUE = "8"
       THEN ASSIGN 
          tx-cb-finalidade-im0045:VISIBLE   = YES
          wh-cb-finalidade-im0045:VISIBLE   = YES
          wh-cb-finalidade-im0045:SENSITIVE = YES.
    END.
END.
