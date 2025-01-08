/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP092RP 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: ESCPP092RP
**  Objetivo: Gera‡Æo massiva de Pedido/Ordem de Compra
**  Autor...: Maicon Roberto Correa
**  Data....: Fev/2015
*******************************************************************************/
{include/i-rpvar.i}
{include/i-freeac.i}

{esp/cpp/escpp092.i}  /* tt-param / tt-digita */

{upc/btb910za-upc.i}
def shared var s-it-codigo like item.it-codigo no-undo.
def shared var s-l-ok as logi no-undo.
{cdp/cdcfgmat.i}
{ccp/ccapi202.i}



{ccp/ccapi207.i}   

FOR FIRST tt-cotacao-item:
END.

{cdp/cdapi300.i1} 
{cdp/cd4300.i3}

{esbo/boes705.i tt-industr}


    /* defini?’o das temp-tables para recebimento de par?metros */
{cdp/cdcfgman.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cpp/cpapi301.i}
{cdp/cd0666.i}

DEFINE VARIABLE h-cpapi301  AS HANDLE       NO-UNDO.


DEFINE TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
       field r-rowid as rowid
       field rownum as int.

DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
       field r-rowid as rowid.

DEFINE TEMP-TABLE ttcotacao-imp NO-UNDO
    FIELD numero-ordem   like cotacao-item.numero-ordem
    FIELD cod-emitente   like cotacao-item.cod-emitente 
    FIELD it-codigo      like cotacao-item.it-codigo
    FIELD seq-cotac      like cotacao-item.seq-cotac
    FIELD mapa-cotacao   like cotacao-item-cex.mapa-cotacao
    FIELD cod-incoterm   like inco-cx.cod-incoterm
    FIELD cod-pto-contr  like pto-contr.cod-pto-contr
    FIELD cod-fabricante like emitente.cod-emitente
    FIELD regime-import  like pais-aliquota.regime-import
    FIELD class-fiscal   like classif-fisc.class-fiscal
    FIELD aliq-ii        as   decimal format ">>9.99"
    FIELD aliq-ipi       as   decimal format ">>9.99"
    FIELD cod-itiner     like itinerario.cod-itiner
    FIELD i-informa      AS   INTEGER
    FIELD da-entrega-embarque AS DATE
    FIELD r-Rowid AS ROWID.

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boin295   AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boes705 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin274sd AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-onfind    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hShowMsg              AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin082sd AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin356ca  AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082ca  AS HANDLE      NO-UNDO.

/* Vari veis para valores fixos */
DEFINE VARIABLE i-moeda         AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-requisitante  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-comprador     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-tp-despesa    AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-ped-emerg     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-impr-ped      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-unid-negoc    AS CHARACTER   NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.

def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.

FORM 
    'Item: ' tt-digita.it-codigo SKIP(1)
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX NO-LABELS WIDTH 132 DOWN FRAME f-item.


FORM
    RowErrors.errorNumber       FORMAT ">>>,>>9"    COLUMN-LABEL "Erro"       
    RowErrors.errorDescription  FORMAT "X(80)"      COLUMN-LABEL "Descri‡Æo"    
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-erros.

FORM tt-erro.cd-erro    
     tt-erro.mensagem FORMAT "X(90)" 
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-erros-op.




FORM
    tt-ordem-compra.num-pedido      COLUMN-LABEL "Pedido"
    tt-ordem-compra.numero-ordem    COLUMN-LABEL "Ordem Compra"
    ord-prod.nr-ord-produ           COLUMN-LABEL "Ordem Produ‡Æo"
    tt-ordem-compra.it-codigo       COLUMN-LABEL "Item"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-ordem.


FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

EMPTY TEMP-TABLE tt-digita.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

assign c-programa     = "ESCPP092"
       c-sistema      = "ESP"
       c-titulo-relat = "Gera‡Æo de Pedidos por Item"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
{include/i-rpcab.i}

FORM item-rast.it-codigo
     ITEM.desc-item             FORMAT "X(50)"
     item-rast.data-ini
     item-rast.data-fim
     item-rast.usuario
     usuar_mestre.nom_usuario
    WITH FRAME f-dados STREAM-IO DOWN WIDTH 132.     


/* para nÊo visualizar cabe¯alho/rodapý em saðda RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilit˜rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Gera‡Æo_de_Pedido_de_Compra *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).


ASSIGN i-moeda        = 0  /* Real */                       
       c-requisitante = v_cod_usuar_corren      .
       c-comprador    = v_cod_usuar_corren      .
       i-tp-despesa   = 1                       .
       l-ped-emerg    = TRUE                    .
       l-impr-ped     = TRUE                    .
       c-unid-negoc   = "ADM".

RUN pi-processa.


PAGE.


disp skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     /*tt-param.it-codigo-ini LABEL "Item"                      AT 04    "|<    >|" AT 22  tt-param.it-codigo-fim NO-LABEL                     AT 32*/
     with frame f-selec width 132 stream-io side-labels.


disp skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 4
     " - " tt-param.arquivo FORMAT "X(60)" 
     skip
     "Usuÿrio:" at 4
     tt-param.usuario 
     with frame f-impressao width 132 stream-io no-labels.

/*fechamento do output do relat«rio*/

{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
ASSIGN h-acomp = ?.
RETURN "OK":U.



PROCEDURE pi-processa:

    DEFINE VARIABLE i-num-pedido            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-formato-cgc           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-modulo-ge             AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-end-cobranca-aux      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-end-entrega-aux       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-mensagem          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-seg-usuario           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cond-pagto            AS INTEGER     NO-UNDO.

    

    RUN inbo/boin295.p PERSISTENT SET h-boin295.
    run emptyRowErrors in h-boin295.

    run inbo/boin274sd.p persistent set h-boin274sd.
    run openQueryStatic in h-boin274sd ( input "Main":U ).

    RUN esbo/boes705.p PERSISTENT SET h-boes705.


    EMPTY TEMP-TABLE tt-pedido-compr.

    FOR EACH tt-digita:


        EMPTY TEMP-TABLE tt-pedido-compr.

        RUN geraNumeroPedidoCompra IN h-boin295 (output i-num-pedido).

        FIND param_seg_estab WHERE param_seg_estab.cdn_param = 1 NO-LOCK NO-ERROR.
        
        /*
        IF  AVAIL param_seg_estab
            AND param_seg_estab.des_valor = "SIM":U
            AND NOT VALID-HANDLE(h-onfind) THEN DO:
        
            RUN cdp/cdapi3000.p PERSISTENT SET h-onfind.
        
        end.
        */

        RUN preparaPedidoCompra IN h-boin295 (output c-formato-cgc,
                                              output l-modulo-ge,
                                              output c-end-cobranca-aux,
                                              output c-end-entrega-aux,
                                              output i-cod-mensagem,
                                              output c-seg-usuario,
                                              output i-cond-pagto).

        CREATE tt-pedido-compr.
        assign tt-pedido-compr.num-pedido       = i-num-pedido
               tt-pedido-compr.cod-emitente     = tt-param.cod-fornec         
               tt-pedido-compr.cod-emit-ter     = tt-param.cod-emitente       
               tt-pedido-compr.natureza         = tt-param.natureza
               tt-pedido-compr.impr-pedido      = tt-param.imprime-ped        
               tt-pedido-compr.nr-processo      = tt-param.processo           
               tt-pedido-compr.frete            = tt-param.frete              
               tt-pedido-compr.cod-transp       = tt-param.cod-transp         
               tt-pedido-compr.via-transp       = tt-param.via-transp
               tt-pedido-compr.end-entrega      = tt-param.cod-estab-entrega
               tt-pedido-compr.end-cobranca     = tt-param.cod-estab-cobranca
               tt-pedido-compr.cod-cond-pag     = tt-param.cod-cond-pag       
               tt-pedido-compr.responsavel      = tt-param.responsavel        
               tt-pedido-compr.cod-mensagem     = tt-param.cod-mensagem       
               tt-pedido-compr.cod-estab-gestor = tt-param.cod-estab-gestor   
               /*tt-pedido-compr.       tt-param.nr-lin-prod        
               tt-pedido-compr.       tt-param.cod-depos          */
               tt-pedido-compr.emergencial      = l-ped-emerg
                   .

        RUN pi-valida.

        IF RETURN-VALUE = "OK" THEN DO:

            RUN pi-save.

        END.
        
    END.

    run emptyRowErrors in h-boin295.
    delete procedure h-boin295.
    ASSIGN h-boin295 = ?.

    run emptyRowErrors in h-boin274sd.
    delete procedure h-boin274sd.
    ASSIGN h-boin274sd = ?.

    run emptyRowErrors in h-boes705.
    delete procedure h-boes705.
    ASSIGN h-boes705 = ?.


END PROCEDURE.





PROCEDURE pi-valida:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var l-inform-cond-especif as logi no-undo.
    def var iNumNewPedido as int no-undo.

    run emptyRowErrors in h-boin295.
    EMPTY TEMP-TABLE RowErrors.

    /*
    if  tt-pedido-compr.cod-cond-pag = 0 then do:

        run emptyRowErrors in h-boin295.
        run validaCondicaoEspecifica in h-boin295 (input  no, /* parƒmetro usado na WEB */
                                                   input  tt-pedido-compr.num-pedido,
                                                   input  tt-pedido-compr.cod-cond-pag,
                                                   input  yes, /* carregou cond-especif */
                                                   output l-inform-cond-especif).

        /*--- Mostra os erros ocorridos nas validacoes acima ---*/
        run getRowErrors in h-boin295 ( output table RowErrors ).
        run ShowErrorsDBO.
        if  return-value = "NOK":U then
            return "NOK":U.  
    end.
    */

    run emptyRowErrors in h-boin295.
    run validateCreatePedEmerg in h-boin295 (input table tt-pedido-compr, output iNumNewPedido).

    find first moeda no-lock
        where moeda.mo-codigo = i-moeda no-error.

    if not avail moeda then do:
        {utp/ut-table.i mgcad moeda 1}
        RUN _insertError IN h-boin295 (INPUT 2,
                                       INPUT "EMS":U,
                                       INPUT "ERROR":U,
                                       INPUT return-value).    
    
    end.    

    find first requisitante 
        where requisitante.nome-abrev = c-requisitante no-lock no-error.
        
    if not avail requisitante then do:
        {utp/ut-table.i mgind requisitante 1}
        RUN _insertError IN h-boin295 (INPUT 47,
                                       INPUT "EMS":U,
                                       INPUT "ERROR":U,
                                       INPUT return-value).    
    end.   

    find first comprador 
        where comprador.cod-comprado = c-comprador
        no-lock no-error.
        
    if not avail comprador then do:
        RUN _insertError IN h-boin295 (INPUT 5936,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT "").    
    end.   

    find first tipo-rec-desp 
        where tipo-rec-desp.tp-codigo = i-tp-despesa no-lock no-error.
        
    if  not available tipo-rec-desp then do:
        {utp/ut-table.i mgadm tipo-rec-desp 1}
        RUN _insertError IN h-boin295 (INPUT 2,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT return-value).    
    end.
    else do:
        if  tipo-rec-desp.tipo = 1 then do:
            RUN _insertError IN h-boin295 (INPUT 4269,
                                              INPUT "EMS":U,
                                              INPUT "ERROR":U,
                                              INPUT "").    
        end.
    end.

    /*--- Mostra os erros ocorridos nas validacoes acima ---*/
    run getRowErrors in h-boin295 ( output table RowErrors ).
    /*run ShowErrorsDBO.*/

    IF CAN-FIND(FIRST RowErrors) THEN DO:

        DISP tt-digita.it-codigo
            WITH FRAME f-item.

        FOR EACH RowErrors:
            DISP RowErrors.errorNumber
                RowErrors.errorDescription
                WITH FRAME f-erros.
            DOWN WITH FRAME f-erros.
        END.

        DISP SKIP(2).

    
        return "NOK":U.
    END.
    
    return "OK":U.

END PROCEDURE.



PROCEDURE pi-save:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-num-ordem as int  no-undo.
    def var c-contato   as char no-undo.
    def var c-discard   as char no-undo.
    def var i-discard   as int  no-undo.
    def var de-indice   as dec  no-undo.
    DEF VAR v-log-erro  AS LOG  NO-UNDO.
    DEF VAR dt-entrega  AS DATE NO-UNDO.

    DEF VAR l-codigo-icm-sensitive      AS LOGICAL NO-UNDO.
    DEF VAR l-aliquota-icm-sensitive    AS LOGICAL NO-UNDO.
    DEF VAR l-aliquota-iss-sensitive    AS LOGICAL NO-UNDO.
    DEF VAR l-valor-taxa-sensitive      AS LOGICAL NO-UNDO.
    DEF VAR l-taxa-financ-sensitive     AS LOGICAL NO-UNDO.
    DEF VAR l-possui-reaj-sensitive     AS LOGICAL NO-UNDO.

    empty temp-table tt-versao-integr.
    create tt-versao-integr.
    assign tt-versao-integr.cod-versao-integracao = 1
           v-log-erro = NO.        
    
    for first cont-emit no-lock
        where cont-emit.cod-emitente = tt-pedido-compr.cod-emitente:
        c-contato = cont-emit.nome.
    end.       
    
    for first emitente no-lock
        where emitente.cod-emitente = tt-pedido-compr.cod-emitente:
    end.    
    
    for first param-imp no-lock:
    end.

    find first param-mat no-lock no-error.

    run pi-acompanhar in h-acomp (input "Criando Pedido de Compra").

    if not valid-handle(h-boin082sd) then
        run inbo/boin082sd.p persistent set h-boin082sd.

    if  not valid-handle(hboin356ca) then do:
        run inbo/boin356ca.p persistent set hboin356ca.
        run openQueryStatic in hboin356ca ( input "Main":U ).
    end. 

    if  not valid-handle(hboin082ca) then do:
        run inbo/boin082ca.p persistent set hboin082ca.
    end. 

    DO TRANS ON ERROR UNDO, LEAVE:

        /* Pedido de Compra */
        EMPTY TEMP-TABLE RowErrors.
        run emptyRowErrors in h-boin295.
        run setConstraintMain in h-boin295.
        run openQueryStatic in h-boin295 (input "Main").
        run setRecord in h-boin295 (input table tt-pedido-compr).
        run createRecord in h-boin295.
        run getRowErrors in h-boin295 ( output table RowErrors ).

        FIND FIRST rowerrors NO-LOCK NO-ERROR.

        IF  AVAIL rowerrors THEN DO:

            PUT UNFORMATTED " *** NÆo foi poss¡vel criar Pedido de Compra para o Item " + tt-digita.it-codigo + "." SKIP(1).

            FOR EACH RowErrors:

                DISP
                    RowErrors.ErrorNumber
                    RowErrors.ErrorDescription
                    WITH FRAME f-erros.
                DOWN WITH FRAME f-erros.

            END.

            ASSIGN v-log-erro = YES.
            UNDO, LEAVE.  
        END.

        /* Ordens de Compra e Cota‡äes */
        RUN pi-desabilita-cancela IN h-acomp. 
        
        FOR FIRST item NO-LOCK 
            where item.it-codigo = tt-digita.it-codigo:

            EMPTY TEMP-TABLE tt-ordem-compra.
            EMPTY TEMP-TABLE tt-prazo-compra.  
            EMPTY TEMP-TABLE tt-cotacao-item.
            
            EMPTY TEMP-TABLE RowErrors.
            run geraNumeroOrdemPedEmerg in h-boin274sd (output i-num-ordem,
                                                       output table RowErrors).

            FIND FIRST rowerrors NO-LOCK NO-ERROR.

            IF  AVAIL rowerrors THEN DO:

                PUT UNFORMATTED " *** NÆo foi poss¡vel buscar numera‡Æo para a Ordem de Compra do Item " + tt-digita.it-codigo + "." SKIP(1).

                FOR EACH RowErrors:

                    DISP RowErrors.ErrorNumber
                         RowErrors.ErrorDescription 
                        WITH FRAME f-erros.
                    DOWN WITH FRAME f-erros.

                END.

                ASSIGN v-log-erro = YES.
                UNDO, LEAVE.  
            END.

            IF  VALID-HANDLE(h-acomp) THEN
                run pi-acompanhar in h-acomp (input "Item " + tt-digita.it-codigo). 

            /**/

            FIND FIRST item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo    = tt-digita.it-codigo
                AND   item-fornec-estab.cod-emitente = tt-pedido-compr.cod-emitente
                AND   item-fornec-estab.cod-estabel  = tt-param.cod-estab-entrega NO-ERROR.

            IF AVAIL item-fornec-estab THEN
                ASSIGN dt-entrega = TODAY + item-fornec-estab.tempo-ressup.
            ELSE 
                ASSIGN dt-entrega = TODAY.

            

            /**/

            create tt-ordem-compra.
            assign tt-ordem-compra.ind-tipo-movto = 1
                   tt-ordem-compra.numero-ordem   = i-num-ordem
                   tt-ordem-compra.num-pedido     = tt-pedido-compr.num-pedido
                   tt-ordem-compra.cod-emitente   = tt-pedido-compr.cod-emitente
                   tt-ordem-compra.mo-codigo      = i-moeda
                   tt-ordem-compra.it-codigo      = tt-digita.it-codigo
                   tt-ordem-compra.cod-estabel    = tt-param.cod-estab-entrega
                   tt-ordem-compra.data-emissao   = tt-pedido-compr.data-pedido
                   tt-ordem-compra.requisitante   = c-requisitante
                   tt-ordem-compra.cod-comprado   = c-comprador
                   tt-ordem-compra.qt-solic       = tt-digita.quantidade
                   /*tt-ordem-compra.preco-fornec   = tt-cotacao-item.preco-fornec 
                   tt-ordem-compra.preco-unit     = tt-cotacao-item.preco-fornec
                   tt-ordem-compra.pre-unit-for   = tt-cotacao-item.preco-fornec*/
                   tt-ordem-compra.tp-despesa     = 1
                   tt-ordem-compra.l-split        = no
                   tt-ordem-compra.situacao       = 2
                   tt-ordem-compra.cod-cond-pag   = tt-pedido-compr.cod-cond-pag
                   tt-ordem-compra.cod-transp     = tt-pedido-compr.cod-transp
                   tt-ordem-compra.aliquota-iss   = 0
                   tt-ordem-compra.aliquota-ipi   = 0
                   tt-ordem-compra.aliquota-icm   = 0
                   tt-ordem-compra.contato        = c-contato
                   tt-ordem-compra.data-cotacao   = tt-pedido-compr.data-pedido
                   tt-ordem-compra.data-pedido    = tt-pedido-compr.data-pedido
                   tt-ordem-compra.ep-codigo      = i-ep-codigo-usuario
                   /*tt-ordem-compra.nr-dias-taxa   = 0*/
                   tt-ordem-compra.impr-ficha     = no
                   tt-ordem-compra.taxa-finan     = no
                   tt-ordem-compra.qt-acum-nec    = tt-ordem-compra.qt-solic
                   tt-ordem-compra.natureza       = tt-pedido-compr.natureza
                   tt-ordem-compra.cod-cond-pag   = tt-pedido-compr.cod-cond-pag
                   tt-ordem-compra.cod-unid-negoc = c-unid-negoc.

            run buscaInfOrdemLeaveItem in h-boin274sd (input tt-ordem-compra.it-codigo,
                                                      input tt-ordem-compra.cod-estabel,
                                                      input tt-ordem-compra.num-pedido,
                                                      output c-discard,
                                                      output tt-ordem-compra.ct-codigo,
                                                      output tt-ordem-compra.sc-codigo,
                                                      output tt-ordem-compra.dep-almoxar,
                                                      output i-discard).

            ASSIGN tt-ordem-compra.ct-codigo = tt-param.ct-codigo
                   tt-ordem-compra.sc-codigo = tt-param.sc-codigo.

            if NOT available item-fornec-estab THEN DO:
                CREATE item-fornec-estab.
                ASSIGN item-fornec-estab.it-codigo    = tt-digita.it-codigo
                       item-fornec-estab.cod-emitente = tt-pedido-compr.cod-emitente 
                       item-fornec-estab.cod-estabel  = tt-param.cod-estab-entrega
                       item-fornec-estab.ativo        = no.
                RELEASE item-fornec-estab.
            END.

            find item-fornec where 
                 item-fornec.it-codigo    = tt-digita.it-codigo and
                 item-fornec.cod-emitente = tt-pedido-compr.cod-emitente exclusive-lock no-error.

            if NOT available item-fornec then do:
                create item-fornec.
                assign item-fornec.it-codigo    = tt-digita.it-codigo
                       item-fornec.cod-emitente = tt-pedido-compr.cod-emitente
                       item-fornec.item-do-forn = tt-digita.it-codigo
                       item-fornec.unid-med-for = item.un
                       item-fornec.fator-conver = 1
                       item-fornec.num-casa-dec = 0
                       item-fornec.ativo        = no
                       item-fornec.cod-cond-pag = tt-pedido-compr.cod-cond-pag
                       item-fornec.classe-repro = 3
                       item-fornec.aval-insp    = 5
                       item-fornec.idi-tributac-pis = 2  /*Tributacao PIS Isento*/
                       item-fornec.idi-tributac-cofins = 2. /*Tributacao COFINS Isento*/
            end.

            FIND FIRST int-item-for-PN NO-LOCK
                WHERE int-item-for-PN.cod-emitente = tt-pedido-compr.cod-emitente  
                  AND int-item-for-PN.it-codigo    = tt-digita.it-codigo NO-ERROR.
            IF  NOT AVAIL int-item-for-PN THEN DO:
                CREATE int-item-for-PN.
                ASSIGN int-item-for-PN.cod-emitente = tt-pedido-compr.cod-emitente  
                       int-item-for-PN.it-codigo    = t-digita.it-codigo
                       int-item-for-PN.item-do-forn = t-digita.it-codigo.
             END.


            create tt-prazo-compra.
            assign tt-prazo-compra.ind-tipo-movto = 1
                   tt-prazo-compra.numero-ordem   = i-num-ordem 
                   tt-prazo-compra.parcela        = 1
                   tt-prazo-compra.quantidade     = tt-ordem-compra.qt-solic
                   tt-prazo-compra.un             = ITEM.un
                   tt-prazo-compra.data-entrega   = dt-entrega
                   tt-prazo-compra.situacao       = tt-ordem-compra.situacao
                   tt-prazo-compra.data-alter     = ?
                   tt-prazo-compra.it-codigo      = tt-ordem-compra.it-codigo
                   tt-prazo-compra.qtd-a-ped-forn = tt-prazo-compra.quantidade
                   tt-prazo-compra.qtd-do-forn    = tt-prazo-compra.quantidade
                   tt-prazo-compra.qtd-sal-forn   = tt-prazo-compra.quantidade
                   tt-prazo-compra.quant-saldo    = tt-prazo-compra.quantidade
                   tt-prazo-compra.quantid-orig   = tt-prazo-compra.quantidade
                   tt-prazo-compra.natureza       = tt-pedido-compr.natureza.
                   
            run calculaProximaParcelaPrazoCompra in hboin356ca (input tt-ordem-compra.numero-ordem,
                                                                input tt-ordem-compra.it-codigo,
                                                                input tt-ordem-compra.cod-estabel,
                                                                output tt-prazo-compra.parcela,
                                                                output tt-prazo-compra.un,
                                                                output tt-prazo-compra.data-entrega).
            ASSIGN tt-prazo-compra.data-entrega = dt-entrega.
            create tt-cotacao-item.

            run emptyRowObject in h-boin082sd.

            run preparaCotacaoOrdemCompraPedEmerg in h-boin082sd (input  i-num-ordem,  /* recebeu valor gerado */
                                                                  input  tt-pedido-compr.num-pedido, /* recebeu do pedido    */
                                                                  input  tt-pedido-compr.cod-emitente,  /* recebeu do pedido    */
                                                                  input  tt-digita.it-codigo,
                                                                  input  tt-param.cod-estab-entrega,
                                                                  input  tt-digita.quantidade,
                                                                  input  dt-entrega,  /* prazo-compra */
                                                                  input-output c-comprador,
                                                                  output l-codigo-icm-sensitive,
                                                                  output l-aliquota-icm-sensitive,
                                                                  output l-aliquota-iss-sensitive,
                                                                  output l-valor-taxa-sensitive,
                                                                  output l-taxa-financ-sensitive,
                                                                  output l-possui-reaj-sensitive,  
                                                                  output table ttcotacao-item).
            
            find first ttcotacao-item no-error.

            assign /*ttcotacao-item.preco-fornec = tt-ordem-compra.preco-fornec
                   ttcotacao-item.preco-unit   = tt-ordem-compra.preco-fornec*/
                   ttcotacao-item.codigo-ipi   = FALSE /*ttcomponente.inclui-ipi*/ .

            ASSIGN ttcotacao-item.aliquota-ii  = DEC(SUBSTRING(ITEM.char-2, 22, 6)) 
                   ttcotacao-item.aliquota-ipi = 0.

            ASSIGN ttcotacao-item.aliquota-icm = 0
                   ttcotacao-item.taxa-finan   = l-taxa-financ-sensitive
                   ttcotacao-item.valor-taxa   = 0
                   ttcotacao-item.numero-ordem = i-num-ordem
                   ttcotacao-item.it-codigo    = tt-ordem-compra.it-codigo
                   ttcotacao-item.un           = tt-prazo-compra.un
                   ttcotacao-item.mo-codigo    = i-moeda
                   ttcotacao-item.cod-emitente = tt-pedido-compr.cod-emitente
                   ttcotacao-item.cod-comprado = tt-ordem-compra.cod-comprado
                   ttcotacao-item.cod-transp   = tt-ordem-compra.cod-transp
                   ttcotacao-item.hora-atualiz = string(time, "hh:mm:ss")
                   ttcotacao-item.cot-aprovada = yes
                   ttcotacao-item.contato      = c-contato
                   ttcotacao-item.usuario      = v_cod_usuar_corren
                   ttcotacao-item.prazo-entreg = 0.

            IF tt-digita.preco = 0 THEN 
                ASSIGN tt-ordem-compra.preco-fornec   = ttcotacao-item.preco-fornec 
                       tt-ordem-compra.preco-unit     = ttcotacao-item.preco-fornec
                       tt-ordem-compra.pre-unit-for   = ttcotacao-item.preco-fornec.
            ELSE
                ASSIGN tt-ordem-compra.preco-fornec   = tt-digita.preco 
                       tt-ordem-compra.preco-unit     = tt-digita.preco
                       tt-ordem-compra.pre-unit-for   = tt-digita.preco
                       ttcotacao-item.preco-fornec    = tt-digita.preco
                       ttcotacao-item.preco-unit      = tt-digita.preco
                       ttcotacao-item.pre-unit-for    = tt-digita.preco.


            ASSIGN tt-ordem-compra.taxa-financ    = l-taxa-financ-sensitive.
                   
            run calculaPrecoUnitFornecedorCotacao in hboin082ca (input no,
                                                                 input i-num-ordem,
                                                                 input-output table ttcotacao-item).
            find first ttcotacao-item no-error.

            {cdp/cd9950.i item.un 
                          ttcotacao-item.un
                          ttcotacao-item.cod-emitente}

            assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 

            buffer-copy ttcotacao-item to tt-cotacao-item.

            assign tt-cotacao-item.ind-tipo-movto = 1
                   tt-cotacao-item.preco-unit     = tt-cotacao-item.pre-unit-for * de-indice.

            EMPTY TEMP-TABLE tt-erros-geral.
            EMPTY TEMP-TABLE RowErrors.
            run ccp/ccapi302.p (input  table tt-versao-integr,
                                output table tt-erros-geral,
                                input  table tt-ordem-compra,
                                input  table tt-prazo-compra,        
                                input  table tt-cotacao-item,
                                     &if defined(bf_mat_despesa_fase_II) &then
                                     input table tt-desp-cotacao-item,
                                     &endif
                                     &if '{&bf_mat_versao_ems}' >= '2.04' &then
                                     input table tt-matriz-rat-med,
                                    &endif
                                input "INPUT").
            
            for each tt-erros-geral:

                IF  INDEX(tt-erros-geral.des-erro,"item") <> 0 THEN
                    ASSIGN tt-erros-geral.des-erro = tt-erros-geral.des-erro + " item (" + tt-cotacao-item.it-codigo + ")".

                RUN _insertErrorManual IN h-boin295 (INPUT tt-erros-geral.cod-erro,
                                                        INPUT "EMS":U,
                                                        INPUT "ERROR":U,
                                                        INPUT tt-erros-geral.des-erro,
                                                        input "",
                                                        input "").    
            end.
                
            run getRowErrors in h-boin295 ( output table RowErrors ).

            FIND FIRST rowerrors NO-LOCK NO-ERROR.
    
            IF  AVAIL rowerrors THEN DO:

                PUT UNFORMATTED " *** Erro na gera‡Æo da Ordem de Compra do Item " + tt-digita.it-codigo + "." SKIP(1).

                FOR EACH RowErrors:

                    DISP RowErrors.ErrorNumber
                         RowErrors.ErrorDescription 
                        WITH FRAME f-erros.
                    DOWN WITH FRAME f-erros.

                END.

                ASSIGN v-log-erro = YES.
                UNDO, LEAVE.  
            END.
            else do:

                for first cotacao-item 
                    where cotacao-item.cot-aprovada = yes
                    and   cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:

                    find first ordem-compra exclusive-lock
                        where ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem no-error.

                    if avail ordem-compra then
                        assign ordem-compra.pre-unit-for = cotacao-item.pre-unit-for
                               ordem-compra.preco-orig   = cotacao-item.pre-unit-for
                               ordem-compra.preco-unit   = cotacao-item.preco-unit.
                end.  

                if avail param-mat and 
                   param-mat.ind-unid-neg AND 
                   substring(param-mat.char-1,1,3) <> "" then do:

                    find first unid-neg-ordem where unid-neg-ordem.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK no-error.

                    /* Limpar eventuais lixos na base */     
                    if avail unid-neg-ordem then do:

                        for each unid-neg-ordem exclusive-lock
                            where unid-neg-ordem.numero-ordem = tt-ordem-compra.numero-ordem:
                            delete unid-neg-ordem.
                        end.
                        
                    end.  
                    /* cria unidade de negocio padrao */    
                    create unid-neg-ordem.
                    assign unid-neg-ordem.numero-ordem = tt-ordem-compra.numero-ordem
                           unid-neg-ordem.cod_unid_neg = substring(param-mat.char-1,1,3)
                           unid-neg-ordem.perc-unid-neg = 100.
                end.

                RUN pi-cria-ord-prod.

                IF RETURN-VALUE = "NOK" THEN DO:
                    ASSIGN v-log-erro = YES.
                    UNDO, LEAVE.  
                END.

                RUN pi-cria-industr.

                DISP tt-ordem-compra.num-pedido
                     tt-ordem-compra.numero-ordem
                     ord-prod.nr-ord-produ
                     tt-ordem-compra.it-codigo
                    WITH FRAME f-ordem.
                DOWN WITH FRAME f-ordem.
                     

                /* Estrangeiro ou Trading */
                /*if emitente.natureza = 3 or emitente.natureza = 4 then do:

                    empty temp-table ttcotacao-item.

                    for each cotacao-item no-lock
                        where cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
                        create ttcotacao-item.
                        buffer-copy cotacao-item to ttcotacao-item.
                        ASSIGN ttcotacao-item.r-rowid = rowid(cotacao-item).
                    end.    
                    run piImportacao.
                 end. */

            end.
        end. /* Ordens de Compra e Cota‡äes */   

        /*IF  v-log-ckd = YES THEN DO:

            FIND int-pedido-compr EXCLUSIVE-LOCK
                WHERE int-pedido-compr.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

            IF  AVAIL int-pedido-compr
            THEN DO:
                ASSIGN int-pedido-compr.log-ckd        = YES
                       int-pedido-compr.cod-produto    = v-cod-produto
                       int-pedido-compr.qtd-pedido-ckd = v-qtd-pedido
                       int-pedido-compr.tp-pedido      = 10. /* CKD Comum */

                IF  v-log-amostra = YES THEN
                    ASSIGN int-pedido-compr.tp-pedido = 11. /* CKD Amostra */
            END.

        END.

        IF  tg-proc-imp THEN DO:

            ASSIGN v-log-desfaz = NO.

            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar in h-acomp (input "Gerando processo de importa‡Æo").

            RUN pi-processo-importacao (OUTPUT v-log-desfaz).

            if  v-log-desfaz = YES then do:

                IF  VALID-HANDLE(h-acomp) THEN DO:
                    RUN pi-finalizar IN h-acomp.
                    ASSIGN h-acomp = ?.
                END.
                ASSIGN v-log-erro = YES.
                UNDO, LEAVE.  

            end.    

        END.

        IF  tg-gera-emb THEN DO:

            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar in h-acomp (input "Gerando embarque").

            RUN pi-gera-embarque (OUTPUT v-log-desfaz).

            if  v-log-desfaz = YES then do:
                RUN pi-finalizar IN h-acomp.
                ASSIGN v-log-erro = YES.
                UNDO, LEAVE.  
            end.  
        END.*/

        /*IF VALID-HANDLE(h-acomp) THEN DO:
             RUN pi-finalizar IN h-acomp.
             ASSIGN h-acomp = ?.
        END.*/

        IF  v-log-erro = YES THEN
            UNDO, LEAVE.

    END. /* DO TRANS ON ERROR UNDO, LEAVE: */

    run emptyRowObject in h-boin082sd.
    DELETE PROCEDURE h-boin082sd.
    ASSIGN h-boin082sd = ?.

    RUN emptyRowErrors in hboin356ca.
    DELETE PROCEDURE hboin356ca.
    ASSIGN hboin356ca = ?.

    run emptyRowErrors in hboin082ca.
    DELETE PROCEDURE hboin082ca.
    ASSIGN hboin082ca = ?.

    /*IF VALID-HANDLE(h-acomp) THEN DO:
         RUN pi-finalizar IN h-acomp.
         ASSIGN h-acomp = ?.
    END.*/
    
    IF  v-log-erro = YES THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".

END PROCEDURE.


PROCEDURE pi-cria-ord-prod:

    DEFINE VARIABLE c-retorno AS CHAR     NO-UNDO.


    EMPTY TEMP-TABLE tt-ord-prod.
    
    IF NOT VALID-HANDLE(h-cpapi301) THEN
        RUN cpp/cpapi301.p PERSISTENT SET h-cpapi301(input-output table tt-ord-prod,
                                                     input-output table tt-reapro,
                                                     input-output table tt-erro,
                                                     yes).
    
    /*FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = c-it-codigo:
    END.
    
    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.it-codigo = c-it-codigo
        AND   item-uni-estab.cod-estabel = c-cod-estabel:
    END.*/
    
    create tt-ord-prod.
    ASSIGN tt-ord-prod.it-codigo             = tt-ordem-compra.it-codigo
           tt-ord-prod.cod-refer             = tt-ordem-compra.cod-refer
           tt-ord-prod.dt-inicio             = TODAY
           tt-ord-prod.dt-termino            = TODAY
           tt-ord-prod.nome-abrev            = ""
           tt-ord-prod.nr-sequencia          = 0                      
           tt-ord-prod.nr-entrega            = 0                      
           tt-ord-prod.prioridade            = 99                     
           tt-ord-prod.qt-ordem              = tt-ordem-compra.qt-solic             
           tt-ord-prod.cod-estabel           = tt-ordem-compra.cod-estabel          
           tt-ord-prod.ind-tipo-movto        = 1 /* InclusÆo */       
           tt-ord-prod.gera-relacionamentos  = yes                    
           tt-ord-prod.prog-seg              = "cp0301":U
           tt-ord-prod.faixa-numeracao       = 1 /* Ordens Autom ticas */
           tt-ord-prod.nr-ord-produ          = ?                     
           tt-ord-prod.dt-orig               = TODAY                 
           tt-ord-prod.nr-pedido             = ""                    
           tt-ord-prod.considera-dias-desl   = yes                   
           tt-ord-prod.sit-aloc              = ? /* os valores são colocados automáticamente pela api*/
           tt-ord-prod.calc-cs-mat           = ? 
           tt-ord-prod.calc-cs-ggf           = ? 
           tt-ord-prod.calc-cs-mob           = ? 
           tt-ord-prod.rep-prod              = ? 
           tt-ord-prod.tipo                  = ? 
           tt-ord-prod.reporte-mob           = ? /**Este dois campos serÆo acrescentaados devido**/
           tt-ord-prod.reporte-ggf           = ? /**A FO que originou a altera‡Æo foi a 1217.946 do cliente INCODIESEL.***/
           tt-ord-prod.origem                = "CP":U
           tt-ord-prod.cod-depos             = tt-param.cod-depos
           tt-ord-prod.nr-linha              = tt-param.nr-lin-prod
           tt-ord-prod.cod-unid-negoc        = c-unid-negoc
           tt-ord-prod.cod-gr-cli            = 0.
    
    &IF DEFINED(bf_man_204) &THEN
    assign tt-ord-prod.cod-versao-integracao = 003.
    &ELSE
    assign tt-ord-prod.cod-versao-integracao = 002.
    &ENDIF
    
    
    /**/

    /* Cria a Ordem */
    if  can-find(first tt-ord-prod) then
            run pi-processa-ordens IN h-cpapi301  (input-output table tt-ord-prod,
                                                  input-output table tt-reapro,
                                                  input-output table tt-erro,
                                                  input        yes). /* deleta erros */

    ASSIGN c-retorno = RETURN-VALUE.
    
    IF c-retorno = "OK" THEN DO:
    
        find first tt-ord-prod.
        find ord-prod where rowid (ord-prod) = tt-ord-prod.rw-ord-prod no-lock no-error.
        /*IF AVAIL ord-prod THEN DO:
        END.*/
    
    END.
    
    if valid-handle(h-cpapi301) THEN DO:
        RUN finalizaAPI IN h-cpapi301.
        delete procedure h-cpapi301.
        ASSIGN h-cpapi301 = ?.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:


        PUT UNFORMATTED " *** Erro na gera‡Æo da Ordem de Produ‡Æo do Item " + tt-digita.it-codigo + "." SKIP(1).

        FOR EACH tt-erro:

            DISP tt-erro.cd-erro
                 tt-erro.mensagem
                WITH FRAME f-erros-op.
            DOWN WITH FRAME f-erros-op.
        END.

    END.

    RETURN c-retorno.

END PROCEDURE.


PROCEDURE pi-cria-industr:

    EMPTY TEMP-TABLE tt-industr.
    EMPTY TEMP-TABLE RowErrors.

    RUN emptyRowErrors IN h-boes705.

    CREATE tt-industr.

    ASSIGN tt-industr.cod-estabel   = tt-ordem-compra.cod-estabel
           tt-industr.data          = TODAY
           tt-industr.num-pedido    = tt-ordem-compra.num-pedido
           tt-industr.nr-ord-produ  = ord-prod.nr-ord-produ
           tt-industr.situacao      = 1.  /* Pendente */

    RUN openQueryStatic IN h-boes705 (INPUT "Main").

    RUN emptyRowErrors IN h-boes705.

    RUN setRecord IN h-boes705 (INPUT TABLE tt-industr).

    RUN createRecord IN h-boes705.

    RUN getRowErrors IN h-boes705 (OUTPUT TABLE RowErrors).

END PROCEDURE.

