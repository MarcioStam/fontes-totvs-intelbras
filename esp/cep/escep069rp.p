

/*-----------------------------------------------------------------------------
** Programa...: esp/cep/escep069rp.p
** Autor......: SENSUS Tecnologia
** VersÒo.....: 2.06.00.000 
** Finalidade.: ImpressÆo Lista de Itens
-------------------------------------------------------------------------------*/          
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep069 2.06.00.000}

/****************************  Definitions  ****************************/

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}
/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-param no-undo
    field destino       as integer
    FIELD arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    FIELD it-codigo-ini like ITEM.it-codigo
    FIELD it-codigo-fim like ITEM.it-codigo.

DEF TEMP-TABLE tt-movimentos-item NO-UNDO 
    FIELD cod-estabel LIKE movto-estoq.cod-estabel
    FIELD it-codigo   LIKE movto-estoq.it-codigo
    FIELD dt-trans    LIKE movto-estoq.dt-trans
    INDEX ITEM it-codigo
    INDEX data dt-trans.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    field ordem            AS INTEGER   FORMAT ">>>>9":U
    field exemplo          AS CHARACTER FORMAT "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-estab
    FIELD cod-estabel AS CHAR FORMAT "x(5)".
/****************************  Frames  ****************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

ASSIGN  c-programa 	    = "escep069"
        c-versao	    = "2.04"
	    c-revisao	    = "1.00.000"
        c-empresa       = if avail empresa then empresa.razao-social else ''
	    c-sistema	    = "ESTOQUE"
	    c-titulo-relat  = "Relat¢rio de Itens".

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/****************************  defini‡Æo de variaveis  ****************************/

DEFINE VARIABLE h-acomp            AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE de-qt-disp         LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE d-total-disponivel LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE chExcel            AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE chArquivo          AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE chPlanilhaMod      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE c-excel       AS CHARACTER NO-UNDO.
DEF VAR teste   AS DATE.
DEFINE VARIABLE c-sit-item-estab   AS CHAR FORMAT "x(400)" NO-UNDO.
DEFINE VARIABLE c-cabecalho        AS CHAR FORMAT "x(400)" NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "Itens_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","")) + "_" + STRING(TIME) + ".csv".
        
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "Itens_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","")) + "_" + STRING(TIME) + ".csv".
    END.

END.

PUT UNFORMATTED "Arquivo gerado em: "c-excel.
PAGE.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

FOR EACH estabelec NO-LOCK:
    ASSIGN c-cabecalho = c-cabecalho + "Situa‡Æo " + estabelec.cod-estab + ";".
    CREATE tt-estab.
    ASSIGN tt-estab.cod-estabel = estabelec.cod-estabel.
END.

ASSIGN c-cabecalho = "ITEM;Descri‡Æo;Fam¡lia;Situa‡Æo;Data Implanta‡Æo;éltimo Movimento;Saldo;Saldo Terc;" + c-cabecalho.

PUT STREAM str-excel c-cabecalho SKIP.

/*****************************  Main Block  *****************************/

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Buscando Itens ...").
    
    RUN piMontaRelat.

END.

PROCEDURE piMontaRelat:
    
    DEFINE VARIABLE v_quantidade AS DECIMAL NO-UNDO.

    FOR EACH  ITEM NO-LOCK
        WHERE ITEM.it-codigo >= tt-param.it-codigo-ini
          AND ITEM.it-codigo <= tt-param.it-codigo-fim:
        
        RUN pi-acompanhar IN h-acomp(INPUT "Item: " + ITEM.it-codigo).
        
        ASSIGN de-qt-disp       = 0
               c-sit-item-estab = ""
               v_quantidade     = 0.

        FOR EACH saldo-estoq NO-LOCK
            WHERE saldo-estoq.it-codigo = ITEM.it-codigo:
            
            ASSIGN de-qt-disp = de-qt-disp +
                                (saldo-estoq.qtidade-atu -
                                saldo-estoq.qt-alocada   -
                                saldo-estoq.qt-aloc-ped  -
                                saldo-estoq.qt-aloc-prod).
        
        END.
        
        EMPTY TEMP-TABLE tt-movimentos-item NO-ERROR.

        
        FOR EACH  estabelec NO-LOCK,
            LAST  movto-estoq  NO-LOCK
            WHERE movto-estoq.it-codigo   = ITEM.it-codigo
              AND movto-estoq.cod-estabel = estabelec.cod-estabel:
            
            CREATE tt-movimentos-item.
            ASSIGN tt-movimentos-item.cod-estabel = movto-estoq.cod-estabel
                   tt-movimentos-item.it-codigo   = movto-estoq.it-codigo
                   tt-movimentos-item.dt-trans    = movto-estoq.dt-trans.

        
        END.
        
        PUT STREAM str-excel UNFORMATTED
            ITEM.it-codigo                                ";"  
            ITEM.desc-item                                ";"
            ITEM.fm-codigo                                ";"  
            TRIM({ininc/i17in172.i 04 item.cod-obsoleto}) ";"  
            ITEM.data-implan                              ";".
        
        FOR LAST tt-movimentos-item USE-INDEX data:
            PUT STREAM str-excel UNFORMATTED tt-movimentos-item.dt-trans ";".
        END.

        IF NOT AVAIL tt-movimentos-item THEN
            PUT STREAM str-excel " " ";".

        /* Indicar a situa‡Æo dos itens para cada estabelecimento */
        FOR EACH tt-estab:
            FIND FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.cod-estabel = tt-estab.cod-estabel
                  AND item-uni-estab.it-codigo   = ITEM.it-codigo NO-ERROR.
                  
                ASSIGN c-sit-item-estab = c-sit-item-estab + 
                                          (IF  AVAIL item-uni-estab THEN 
                                              TRIM({ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}) 
                                          ELSE 
                                              "            -")
                                          + ";".
        END.

        FOR EACH saldo-terc NO-LOCK
              WHERE saldo-terc.it-codigo = ITEM.it-codigo:
              ASSIGN v_quantidade = v_quantidade + (saldo-terc.quantidade - saldo-terc.dec-1).
        END.

        PUT STREAM str-excel de-qt-disp ";" v_quantidade ";" c-sit-item-estab SKIP.
    
    END.

    RUN pi-finalizar IN h-acomp.
    OUTPUT STREAM str-excel CLOSE.
END PROCEDURE.






