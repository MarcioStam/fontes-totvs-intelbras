/*************************************************************************
    Programa.:  UPC-re0701
    Objetivo.:  UPC do programa re0701 - Serie X Estabelecimento
    Data.....:  Julho de 2010
*************************************************************************/
{include/i-prgvrs.i UPC-RE0701 2.00.00.000}
{gtp/gati0000.i}

/*********************** Defini»’o de Par³metros *************************/
DEFINE INPUT PARAMETER p-ind-event                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object                 AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object                 AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                  AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                  AS ROWID          NO-UNDO.
                    
DEFINE NEW GLOBAL SHARED VAR wgh-bt-inf-adic-re0701 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-bt-cce-re0701      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-bt-mde-re0701      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-nro-docto-re0701    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-serie-docto-re0701  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nat-operacao-re0701 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-emitente-re0701 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-estabel-re0701  AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER b-docum-est FOR docum-est.

IF p-ind-event = "before-display" THEN DO:

	{INCLUDE/VER-HDLS.I &ATIVA-GERACAO-LISTA=NO
						&TELA-DISCO='D'
						&NOME-ARQUIVO='C:/temp/zzz.LST'
						&LISTA-FRAMES=''
						&LISTA-TIPOS-OBJS=''}

    /* Carrega campos da chave */
    IF NOT VALID-HANDLE(wh-nro-docto-re0701) THEN
        ASSIGN wh-nro-docto-re0701 = fc-all-hdl("f-main", "nro-docto", 000).

    IF NOT VALID-HANDLE(wh-serie-docto-re0701) THEN
        ASSIGN wh-serie-docto-re0701 = fc-all-hdl("f-main", "serie-docto", 000).

    IF NOT VALID-HANDLE(wh-nat-operacao-re0701) THEN
        ASSIGN wh-nat-operacao-re0701 = fc-all-hdl("f-main", "nat-operacao", 000).

    IF NOT VALID-HANDLE(wh-cod-emitente-re0701) THEN
        ASSIGN wh-cod-emitente-re0701 = fc-all-hdl("f-main", "cod-emitente", 000).

    IF NOT VALID-HANDLE(wh-cod-estabel-re0701) THEN
        ASSIGN wh-cod-estabel-re0701 = fc-all-hdl("f-main", "cod-estabel", 000).

    /* Carrega um botao da parte superior */
    IF NOT VALID-HANDLE(wgh-bt-inf-adic-RE0701) THEN
        ASSIGN wgh-bt-inf-adic-RE0701 = fc-all-hdl("f-cad", "bt-inf-adic", 000).

    /* Cria botao de CCe */
    IF NOT VALID-HANDLE(wgh-bt-cce-RE0701) THEN DO:
        CREATE BUTTON wgh-bt-cce-RE0701
        ASSIGN WIDTH     = 4.00
               ROW       = 1.11
               COL       = 30
               LABEL     = "CCE"
               FRAME     = wgh-bt-inf-adic-RE0701:FRAME
               HEIGHT    = 1.25
               VISIBLE   = YES
               SENSITIVE = YES.
    
        ON 'choose':U OF wgh-bt-cce-RE0701 PERSISTENT RUN gtp/gati0205.w /*(INPUT p-row-table)*/ .
    END.

    /* Cria botao de MDE */
    IF NOT VALID-HANDLE(wgh-bt-mde-RE0701) THEN DO:
        CREATE BUTTON wgh-bt-mde-RE0701
        ASSIGN WIDTH     = 4.00
               ROW       = 1.11
               COL       = 35
               LABEL     = "MDE"
               FRAME     = wgh-bt-inf-adic-RE0701:FRAME
               HEIGHT    = 1.25
               VISIBLE   = YES
               SENSITIVE = YES.

        ON 'choose':U OF wgh-bt-mde-RE0701 PERSISTENT RUN gtupc/upc-re0701.p(INPUT "cria-mde",
                                                                             INPUT p-ind-object,
                                                                             INPUT p-wgh-object,
                                                                             INPUT p-wgh-frame,
                                                                             INPUT p-cod-table,
                                                                             INPUT p-row-table).
    END.

    /* Quando nota feita no EMS, nao devo ter a funcionalidade do botao MDE, */
    /* pois ira ocasionar erro no portal, nao gerando informacoes.           */
    IF p-cod-table = "docum-est" THEN DO:


        /* *** Por solicitacao da Mannes, deixar sempre habilitado o botao  *** */
        &IF '{&pre-empresa}' <> "mannes" &THEN
    
            /* Procura o documento nas tabelas GATI */
            FOR FIRST b-docum-est WHERE ROWID(b-docum-est) = p-row-table NO-LOCK:
    
                /* Se nao tenho o documento, desabilitar o botao MDE */
                IF NOT CAN-FIND(FIRST gt-tt-docum-est 
                                WHERE gt-tt-docum-est.nro-docto    = b-docum-est.nro-docto    
                                  AND gt-tt-docum-est.serie        = b-docum-est.serie        
                                  AND gt-tt-docum-est.cod-emitente = b-docum-est.cod-emitente 
                                  AND gt-tt-docum-est.nat-oper     = b-docum-est.nat-operacao) THEN DO:
                    ASSIGN wgh-bt-mde-RE0701:SENSITIVE = NO.
                END.
                ELSE DO:
                    ASSIGN wgh-bt-mde-RE0701:SENSITIVE = YES.
                END.
            END.

        &ENDIF
    END.
END.

IF p-ind-event = "cria-mde" THEN
    RUN gtp/gati0206.w(INPUT wh-cod-estabel-re0701:SCREEN-VALUE,
                       INPUT wh-serie-docto-re0701:SCREEN-VALUE,
                       INPUT wh-nro-docto-re0701:SCREEN-VALUE,
                       INPUT INT(wh-cod-emitente-re0701:SCREEN-VALUE)).

IF p-ind-event = "DESTROY" THEN
    ASSIGN wgh-bt-inf-adic-re0701 = ?
           wgh-bt-cce-re0701      = ?
           wgh-bt-mde-re0701      = ?
           wh-nro-docto-re0701    = ?
           wh-serie-docto-re0701  = ?
           wh-nat-operacao-re0701 = ?
           wh-cod-emitente-re0701 = ?
           wh-cod-estabel-re0701  = ?.

RETURN "OK".
