/***********************************************************************
**  Programa..: ESP/REP/ESREP033RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Relatorio de Titulos por Referencia
**  Vers∆o....: 001 06/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP003 2.04.00.005}

/****************************  Definitions  ****************************/
{esp/rep/esrep003tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-titulos NO-UNDO
    FIELD cod-fornec   LIKE tit_ap.cdn_fornecedor
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD cod-estab    LIKE tit_ap.cod_estab
    FIELD nr-docto     LIKE tit_ap.cod_tit_ap
    FIELD serie        LIKE tit_ap.cod_ser_docto
    FIELD cod-esp      LIKE tit_ap.cod_espec_docto
    FIELD dt-transacao LIKE tit_ap.dat_transacao
    FIELD parcela      LIKE tit_ap.cod_parcela
    FIELD pedido       LIKE movto_tit_ap.num_ped_compra
    FIELD vl-original  LIKE tit_ap.val_origin_tit_ap
    FIELD vl-imposto   LIKE tit-ap.vl-imposto 
    FIELD dt-vencimen  LIKE tit_ap.dat_vencto_tit_ap
    FIELD observacao   LIKE tit-ap.observacao
    FIELD hr-atualiza  LIKE docum-est.hr-atualiza
    FIELD ce-atual     LIKE docum-est.ce-atual
    FIELD ap-atual     LIKE docum-est.ap-atual
    FIELD of-atual     LIKE docum-est.of-atual
    FIELD cod-cond-pag LIKE pedido-compr.cod-cond-pag
    INDEX tt-titulos IS PRIMARY cod-fornec nome-emit nr-docto serie parcela
    INDEX chave nome-emit cod-fornec.

FIND FIRST tt-titulos NO-LOCK NO-ERROR.

DEF VAR c-cod-estabel      AS CHAR FORMAT "x(05)"      NO-UNDO.
DEF VAR c-nome-usuar       AS CHAR FORMAT "x(60)"      NO-UNDO.
DEF VAR c-ini-dt-transacao AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR c-fim-dt-transacao AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR c-usuario-doc      AS CHAR FORMAT "x(12)"      NO-UNDO.
DEF VAR da-data            AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR l-lib-autom        AS LOG  FORMAT "Sim/N∆o"    NO-UNDO.

DEF BUFFER b-ponto-programa    FOR ponto-programa.
DEF BUFFER b-conteudo-programa FOR conteudo-programa.

/* FORM tt-param.cod-estabel      FORMAT "x(03)":U      LABEL "Estabelecimento":U at 01 SKIP */
/*      tt-param.ini-dt-transacao FORMAT "99/99/9999":U LABEL "Dt Transaá∆o":U    at 01 */
/*      " |< >| ":U AT 59 */
/*      tt-param.fim-dt-transacao FORMAT "99/99/9999":U NO-LABEL SKIP */
/*      tt-param.usuario-doc      FORMAT "x(12)":U      LABEL "Usu†rio":U         at 01 */
/*      c-nome-usuar              FORMAT "x(60)":U      NO-LABEL SKIP(1) */
/*      WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao. */

DEF FRAME fPageTop HEADER
    'Estabelecimento: ' AT 01 c-cod-estabel       SKIP
    'Dt Trasaá∆o    : ' AT 01 c-ini-dt-transacao " |< >| ":U  AT 30 c-fim-dt-transacao SKIP
    'Usuario        : ' AT 01 c-usuario-doc      c-nome-usuar AT 31                    SKIP(1)          
    "   Fornec Documento    SÇrie Esp Dt Trans   /P Pedido          Vl Original Dt Vcto    CE  AP  OF  Lib Cond Pagto" AT 01 SKIP
    "--------- ------------ ----- --- ---------- -- ------------ -------------- ---------- --- --- --- --- ------------------------------" AT 01 SKIP
    WITH NO-BOX NO-LABELS WIDTH 132 PAGE-TOP STREAM-IO.

/**************************** Frames ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

DEF VAR h-acomp AS HANDLE NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "T°tulos por Referància"
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESREP003"
       c-versao       = "2.04"
       c-revisao      = "005".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    FIND FIRST tt-param NO-ERROR.

    RUN piParam.

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    VIEW FRAME fPageTop.
    
    RUN piMontaRelat.

    RUN pi-finalizar IN h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.


PROCEDURE piMontaRelat:

    FOR FIRST tt-param:

        IF  tt-param.origem THEN DO:
            RUN pi-inicializar in h-acomp (INPUT "Selecionando Documentos do Recebimento...").
            
            FOR EACH docum-est NO-LOCK 
                WHERE docum-est.cod-estabel   = tt-param.cod-estabel
                AND   docum-est.usuario       = tt-param.usuario-doc 
                AND   docum-est.dt-trans     >= tt-param.ini-dt-transacao 
                AND   docum-est.dt-trans     <= tt-param.fim-dt-transacao 
                AND   docum-est.cod-emitente >= tt-param.ini-cod-fornec 
                AND   docum-est.cod-emitente <= tt-param.fim-cod-fornec
                AND  (IF tt-param.observacao = "5" /*Todos*/ THEN YES 
                      ELSE docum-est.cod-observ = INT(tt-param.observacao))
                AND (NOT docum-est.nat-operacao BEGINS "3" 
                      OR( docum-est.nat-operacao = "394992" OR     
                          docum-est.nat-operacao = "394993" OR     
                          docum-est.nat-operacao = "394994")),
                FIRST emitente NO-LOCK WHERE
                      emitente.cod-emitente   = docum-est.cod-emitente,
                EACH dupli-apagar NO-LOCK OF docum-est:

                IF dupli-apagar.cod-esp < tt-param.cod-esp-ini OR 
                   dupli-apagar.cod-esp > tt-param.cod-esp-fim THEN NEXT.

                RUN pi-acompanhar IN h-acomp (INPUT docum-est.nro-docto).

                IF  CAN-FIND(FIRST tt-digita) THEN
                    IF NOT CAN-FIND(FIRST tt-digita NO-LOCK 
                                    WHERE tt-digita.nat-operacao = docum-est.nat-operacao) THEN NEXT.
                    
                CREATE tt-titulos.
                ASSIGN tt-titulos.cod-fornec   = docum-est.cod-emitente
                       tt-titulos.nome-emit    = emitente.nome-emit
                       tt-titulos.cod-estab    = docum-est.cod-estabel
                       tt-titulos.nr-docto     = docum-est.nro-docto
                       tt-titulos.serie        = docum-est.serie
                       tt-titulos.cod-esp      = dupli-apagar.cod-esp
                       tt-titulos.dt-transacao = dupli-apagar.dt-trans
                       tt-titulos.parcela      = dupli-apagar.parcela
                       tt-titulos.vl-original  = dupli-apagar.vl-a-pagar
                       tt-titulos.dt-vencimen  = dupli-apagar.dt-vencim
                       tt-titulos.observacao   = docum-est.observacao
                       tt-titulos.hr-atualiza  = docum-est.hr-atualiza
                       tt-titulos.ce-atual     = docum-est.ce-atual
                       tt-titulos.ap-atual     = docum-est.ap-atual
                       tt-titulos.of-atual     = docum-est.of-atual.

                FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
            
                IF  AVAIL item-doc-est THEN DO:
                    
                    IF  item-doc-est.num-pedido <> 0 THEN DO:
                        FIND FIRST pedido-compr
                            WHERE pedido-compr.num-pedido = item-doc-est.num-pedido NO-LOCK NO-ERROR.
                
                        IF  AVAIL pedido-compr THEN
                            ASSIGN tt-titulos.cod-cond-pag = pedido-compr.cod-cond-pag.
                    END.
                    ELSE DO:
                        FIND FIRST rat-ordem 
                            WHERE rat-ordem.serie-docto  = item-doc-est.serie-docto  
                            AND   rat-ordem.nro-docto    = item-doc-est.nro-docto    
                            AND   rat-ordem.cod-emitente = item-doc-est.cod-emitente 
                            AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                            AND   rat-ordem.sequencia    = item-doc-est.sequencia
                            AND   rat-ordem.num-pedido   > 0 NO-LOCK NO-ERROR.
                        
                        IF  AVAIL rat-ordem THEN DO:
                            FIND FIRST pedido-compr
                                WHERE pedido-compr.num-pedido = rat-ordem.num-pedido NO-LOCK NO-ERROR.
            
                            IF  AVAIL pedido-compr THEN
                                ASSIGN tt-titulos.cod-cond-pag = pedido-compr.cod-cond-pag.
                        END.
                    END.
                END.
            END.

            FOR EACH docum-est NO-LOCK
                WHERE docum-est.cod-estabel   = tt-param.cod-estabel
                AND   docum-est.usuario       = tt-param.usuario-doc 
                AND   docum-est.dt-trans     >= tt-param.ini-dt-transacao 
                AND   docum-est.dt-trans     <= tt-param.fim-dt-transacao 
                AND   docum-est.cod-emitente >= tt-param.ini-cod-fornec 
                AND   docum-est.cod-emitente <= tt-param.fim-cod-fornec
                AND (NOT docum-est.nat-operacao BEGINS "162" 
                AND  NOT docum-est.nat-operacao BEGINS "262"
                AND  NOT docum-est.nat-operacao BEGINS "194"
                AND  NOT docum-est.nat-operacao BEGINS "294"
                AND  (NOT docum-est.nat-operacao BEGINS "3" 
                      OR( docum-est.nat-operacao = "394992" OR     
                          docum-est.nat-operacao = "394993" OR     
                          docum-est.nat-operacao = "394994"))),
                EACH despesa-aces OF docum-est NO-LOCK,
                FIRST emitente NO-LOCK 
                WHERE emitente.cod-emitente = despesa-aces.cod-forn-ac:

                IF despesa-aces.cod-esp < tt-param.cod-esp-ini OR 
                   despesa-aces.cod-esp > tt-param.cod-esp-fim THEN NEXT.

                RUN pi-acompanhar IN h-acomp (INPUT despesa-aces.nro-docto-ac).

                IF  CAN-FIND(FIRST tt-digita) THEN
                    IF NOT CAN-FIND(FIRST tt-digita NO-LOCK 
                                    WHERE tt-digita.nat-operacao = docum-est.nat-operacao) THEN NEXT.

                CREATE tt-titulos.
                ASSIGN tt-titulos.cod-fornec   = despesa-aces.cod-forn-ac
                       tt-titulos.nome-emit    = emitente.nome-emit
                       tt-titulos.cod-estab    = docum-est.cod-estabel
                       tt-titulos.nr-docto     = despesa-aces.nro-docto-ac
                       tt-titulos.serie        = despesa-aces.ser-docto-ac
                       tt-titulos.cod-esp      = despesa-aces.cod-esp
                       tt-titulos.dt-transacao = despesa-aces.dt-emissao
                       tt-titulos.vl-original  = despesa-aces.valor
                       tt-titulos.dt-vencimen  = despesa-aces.dt-vencto
                       tt-titulos.hr-atualiza  = docum-est.hr-atualiza
                       tt-titulos.observacao   = docum-est.observacao
                       tt-titulos.ce-atual     = docum-est.ce-atual
                       tt-titulos.ap-atual     = docum-est.ap-atual
                       tt-titulos.of-atual     = docum-est.of-atual.
            END.
        END.
        ELSE DO:
            RUN pi-inicializar IN h-acomp (INPUT "Selecionando Documentos do Recebimento...").
            
            DO  da-data = tt-param.ini-dt-transacao TO tt-param.fim-dt-transacao:
                
                FOR EACH tit_ap NO-LOCK 
                    WHERE tit_ap.cod_estab       = tt-param.cod-estabel
                    AND   tit_ap.dat_transacao   = da-data:

                    IF  tit_ap.cdn_fornecedor < tt-param.ini-cod-fornec 
                    AND tit_ap.cdn_fornecedor > tt-param.fim-cod-fornec THEN NEXT.

                    IF  tit_ap.ind_origin_tit_ap <> "APB" THEN NEXT.

                    IF tit_ap.cod_espec_docto < tt-param.cod-esp-ini OR 
                       tit_ap.cod_espec_docto > tt-param.cod-esp-fim THEN NEXT.

                    FIND FIRST emitente NO-LOCK 
                        WHERE emitente.cod-emitente = tit_ap.cdn_fornecedor NO-ERROR.
    
                    FIND FIRST movto_tit_ap OF tit_ap
                        WHERE  movto_tit_ap.ind_trans_ap = "Implantaá∆o" NO-LOCK NO-ERROR.
    
                    IF  AVAIL movto_tit_ap
                    AND movto_tit_ap.cod_usuario = tt-param.usuario-doc THEN DO:
    
                        RUN pi-acompanhar IN h-acomp (INPUT tit_ap.cod_tit_ap).
        
                        IF  CAN-FIND(first tt-digita) then
                            IF NOT CAN-FIND(FIRST tt-digita NO-LOCK 
                                            WHERE tt-digita.nat-operacao = docum-est.nat-operacao) THEN NEXT.
                        CREATE tt-titulos.
                        ASSIGN tt-titulos.cod-fornec   = tit_ap.cdn_fornecedor
                               tt-titulos.nome-emit    = emitente.nome-emit WHEN AVAIL emitente
                               tt-titulos.cod-estab    = tit_ap.cod_estab
                               tt-titulos.nr-docto     = tit_ap.cod_tit_ap
                               tt-titulos.serie        = tit_ap.cod_ser_docto
                               tt-titulos.cod-esp      = tit_ap.cod_espec_docto
                               tt-titulos.dt-transacao = tit_ap.dat_transacao
                               tt-titulos.parcela      = tit_ap.cod_parcela
                               tt-titulos.pedido       = movto_tit_ap.num_ped_compra
                               tt-titulos.vl-original  = tit_ap.val_origin_tit_ap
                               tt-titulos.vl-imposto   = 0
                               tt-titulos.dt-vencimen  = tit_ap.dat_vencto_tit_ap
                               tt-titulos.observacao   = ""
                               tt-titulos.ce-atual     = ?
                               tt-titulos.ap-atual     = ?
                               tt-titulos.of-atual     = ?.
                    END.

                    FIND FIRST movto_tit_ap OF tit_ap
                         WHERE movto_tit_ap.ind_trans_ap = "Subst Nota por Duplicata" NO-LOCK NO-ERROR. 

                    IF  AVAIL movto_tit_ap
                    AND movto_tit_ap.cod_usuario = tt-param.usuario-doc THEN DO:
    
                        RUN pi-acompanhar IN h-acomp (INPUT tit_ap.cod_tit_ap).
        
                        IF  CAN-FIND(first tt-digita) then
                            IF NOT CAN-FIND(FIRST tt-digita NO-LOCK 
                                            WHERE tt-digita.nat-operacao = docum-est.nat-operacao) THEN NEXT.
                        CREATE tt-titulos.
                        ASSIGN tt-titulos.cod-fornec   = tit_ap.cdn_fornecedor
                               tt-titulos.nome-emit    = emitente.nome-emit WHEN AVAIL emitente
                               tt-titulos.cod-estab    = tit_ap.cod_estab
                               tt-titulos.nr-docto     = tit_ap.cod_tit_ap
                               tt-titulos.serie        = tit_ap.cod_ser_docto
                               tt-titulos.cod-esp      = tit_ap.cod_espec_docto
                               tt-titulos.dt-transacao = tit_ap.dat_transacao
                               tt-titulos.parcela      = tit_ap.cod_parcela
                               tt-titulos.pedido       = movto_tit_ap.num_ped_compra
                               tt-titulos.vl-original  = tit_ap.val_origin_tit_ap
                               tt-titulos.vl-imposto   = 0
                               tt-titulos.dt-vencimen  = tit_ap.dat_vencto_tit_ap
                               tt-titulos.observacao   = ""
                               tt-titulos.ce-atual     = ?
                               tt-titulos.ap-atual     = ?
                               tt-titulos.of-atual     = ?.
                    END.

                END.
            END.
        END.

        RUN pi-inicializar in h-acomp (input "Imprimindo...").
        
        FOR EACH tt-titulos BREAK BY tt-titulos.nome-emit BY tt-titulos.cod-fornec:

            IF  FIRST-OF(tt-titulos.nome-emit) THEN DO:
                PUT " " SKIP
                    "Fornecedor: " tt-titulos.nome-emit SKIP.
            END.

            RUN pi-acompanhar IN h-acomp (INPUT tt-titulos.nr-docto).

            PUT UNFORMATTED
                 tt-titulos.cod-fornec        TO 9
                 tt-titulos.nr-docto          AT 11
                 tt-titulos.serie             AT 24
                 tt-titulos.cod-esp           AT 30
                 tt-titulos.dt-transacao      AT 34
                 tt-titulos.parcela           AT 45
                 tt-titulos.pedido            AT 48
                 tt-titulos.vl-original       TO 74
                 tt-titulos.dt-vencimen       AT 76.

            ASSIGN l-lib-autom = NO.

            FIND FIRST tit_ap 
                 WHERE tit_ap.cod_estab       = tt-titulos.cod-estab
                 AND   tit_ap.cod_espec_docto = tt-titulos.cod-esp
                 AND   tit_ap.cod_ser_docto   = tt-titulos.serie
                 AND   tit_ap.cdn_fornecedor  = tt-titulos.cod-fornec
                 AND   tit_ap.cod_tit_ap      = tt-titulos.nr-docto
                 AND   tit_ap.cod_parcela     = tt-titulos.parcela NO-LOCK NO-ERROR.

            IF  AVAIL tit_ap
            AND tit_ap.ind_origin_tit_ap = "REC" THEN DO:

                FOR FIRST int_espec_fornec NO-LOCK
                    WHERE int_espec_fornec.cod_empresa     = tit_ap.cod_empresa
                    AND   int_espec_fornec.cdn_fornec      = tit_ap.cdn_fornecedor
                    AND   int_espec_fornec.cod_espec_docto = tit_ap.cod_espec_docto 
                    AND   int_espec_fornec.log_ativo       = YES:

                    FIND FIRST proces_pagto OF tit_ap NO-LOCK NO-ERROR.
    
                    IF  AVAIL proces_pagto THEN
                        ASSIGN l-lib-autom = YES.
                END.
            END.

            IF  tt-titulos.ce-atual = ? THEN
                PUT UNFORMATTED "":U AT 87.
            ELSE
                PUT UNFORMATTED STRING(tt-titulos.ce-atual, "Sim/N∆o":U) AT 87.

            IF  tt-titulos.ap-atual = ? THEN
                PUT UNFORMATTED "":U AT 91.
            ELSE
                PUT UNFORMATTED STRING(tt-titulos.ap-atual, "Sim/N∆o":U) AT 91.

            IF  tt-titulos.of-atual = ? THEN
                PUT UNFORMATTED "":U AT 95.
            ELSE
                PUT UNFORMATTED STRING(tt-titulos.of-atual, "Sim/N∆o":U) AT 95.

            IF  l-lib-autom = ? THEN
                PUT UNFORMATTED "":U AT 99.
            ELSE
                PUT UNFORMATTED STRING(l-lib-autom, "Sim/N∆o":U) AT 99.

            FIND FIRST cond-pagto
                WHERE cond-pagto.cod-cond-pag = tt-titulos.cod-cond-pag NO-LOCK NO-ERROR.

            IF  AVAIL cond-pagto THEN DO:
                PUT UNFORMATTED cond-pagto.descricao AT 103.
            END.
            
            PUT UNFORMATTED SKIP.
        END.
    END.
END.

PROCEDURE piParam:

    FIND FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = tt-param.usuario-doc NO-ERROR.
        
    IF  AVAIL usuar_mestre THEN
        ASSIGN c-nome-usuar = usuar_mestre.nom_usuario.
    ELSE  
        ASSIGN c-nome-usuar = ''. 
        
    IF  AVAIL tt-param THEN
        ASSIGN c-cod-estabel      = tt-param.cod-estabel
               c-ini-dt-transacao = tt-param.ini-dt-transacao
               c-fim-dt-transacao = tt-param.fim-dt-transacao
               c-usuario-doc      = tt-param.usuario-doc .             

END PROCEDURE.
