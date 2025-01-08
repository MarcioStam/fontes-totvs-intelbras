/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i WM9020B 2.00.00.061 } /*** 010061 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i wm9020b MWM}
&ENDIF

/*******************************************************************************
**
**                           SUGESTAO DE RETIRADA
**
*******************************************************************************/

/*** Definicao EPC ***/
{include/i-epc200.i wm9020b}

/* Retirado Selecao por lote e embalagem */
{method/dbotterr.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgwms.i}
{wmp/wm9055.i}

DEFINE TEMP-TABLE tt-alocar NO-UNDO
    FIELD id-box         LIKE wm-box-saida.id-box
    FIELD cod-lote       LIKE wm-docto-itens.cod-lote
    FIELD cod-estabel    like wm-box-saida.cod-estabel   
    FIELD cod-local      like wm-box-saida.cod-local     
    FIELD dt-transacao   like wm-box-saida.dt-transacao  
    FIELD id-docto       like wm-box-saida.id-docto      
    FIELD dt-atualizacao like wm-box-saida.dt-atualizacao
    FIELD id-saldo       like wm-box-saida.id-saldo      
    FIELD num-seq-item   like wm-box-saida.num-seq-item  
    FIELD cod-embalagem  like wm-box-saida.cod-embalagem 
    FIELD qtd-original   like wm-box-movto.qtd-item-orig
    FIELD qtd-saida      like wm-box-saida.qtd-saida.

/* Defini»’o da tt-lote */
{wmp/wm9015.i}

DEF BUFFER b2-wm-saldo-estoque FOR wm-saldo-estoque.

def input  param piQtdItem      like wm-docto-itens.qtd-item no-undo.
def input  param piRwDoctoItens as   rowid                   no-undo.
def input  param piEmbalFechada as   logical                 no-undo.
def output param piQtdRetirada  like wm-docto-itens.qtd-item no-undo.
def output param table          for  RowErrors.

DEFINE QUERY q-box-saldo FOR wm-box-saldo , wm-box, wm-tipo-box, wm-item-embalagem-local.

def    buffer b-wm-saldo-estoque      for  wm-saldo-estoq.
DEFINE BUFFER b-wms-item-fornec-embal FOR wms-item-fornec-embal.

def var de-qtd-item-retirada    AS DEC                       no-undo.
def var de-qtd-disponivel       AS DEC                       no-undo.
def var de-qtd-aux              AS DEC                       no-undo.
def var c-lote                  like wm-docto-itens.cod-lote no-undo.
def var d-id-movto              like wm-box-movto.id-movto   no-undo.
def var i-qti-embalagem         as integer                   no-undo.
def var l-gera-movto            as logical                   no-undo.
def var c-descricao             as character                 no-undo.
def var c-ajuda                 as character                 no-undo.
def var i-sequencia             as integer                   no-undo.
DEF VAR d-tot-qtd-item          LIKE wm-docto-itens.qtd-item NO-UNDO.
DEF VAR rw-wm-box-saida         AS ROWID                     NO-UNDO.
DEF VAR l-item-tem-shelf-life   AS LOGICAL                   NO-UNDO.
DEF VAR l-data-validade         AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE l-abre-embal    AS LOGICAL                   NO-UNDO.
DEFINE VARIABLE de-qtd-embal    AS DECIMAL     		     NO-UNDO.

DEFINE VARIABLE l-lote-avancado     AS LOGICAL  NO-UNDO.
DEFINE VARIABLE ch-lote-verificado  LIKE wm-box-saldo.cod-lote.
DEFINE VARIABLE l-lote-bloqueado    AS LOGICAL  NO-UNDO.

DEFINE VARIABLE i-num-dias-reanalise LIKE wm-item.num-dias-reanalise NO-UNDO.
DEFINE VARIABLE i-ind-controle-saida LIKE wm-item.ind-controle-saida NO-UNDO.
DEFINE VARIABLE i-ind-seq-retirada   LIKE wm-item.ind-seq-retirada   NO-UNDO.

&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    IF CAN-FIND(FIRST funcao NO-LOCK
                WHERE funcao.cd-funcao = 'lote-avancado':U
                  AND funcao.ativo     = YES) THEN
        ASSIGN l-lote-avancado = YES.
    ELSE
        ASSIGN l-lote-avancado = NO.
&ELSE
    ASSIGN l-lote-avancado = NO.
&ENDIF

find wm-docto-itens
    where rowid(wm-docto-itens) = piRwDoctoItens no-lock no-error.

FIND wm-docto
    WHERE wm-docto.cod-estabel = wm-docto-itens.cod-estabel
      AND wm-docto.cod-local   = wm-docto-itens.cod-local
      AND wm-docto.id-docto    = wm-docto-itens.id-docto NO-LOCK NO-ERROR.

FIND FIRST wm-param NO-LOCK NO-ERROR.

FIND FIRST wm-item NO-LOCK
     WHERE wm-item.cod-item = wm-docto-itens.cod-item NO-ERROR.
ASSIGN i-num-dias-reanalise = wm-item.num-dias-reanalise
       i-ind-controle-saida = wm-item.ind-controle-saida
       i-ind-seq-retirada   = wm-item.ind-seq-retirada.

FIND FIRST wms-item-estab-local NO-LOCK
     WHERE wms-item-estab-local.cod-estab = wm-docto-itens.cod-estabel
       AND wms-item-estab-local.cod-local = wm-docto-itens.cod-local
       AND wms-item-estab-local.cod-item  = wm-docto-itens.cod-item NO-ERROR.
IF AVAIL wms-item-estab-local THEN
    ASSIGN i-num-dias-reanalise = wms-item-estab-local.num-dias-reanalise
           i-ind-controle-saida = wms-item-estab-local.ind-controle-saida
           i-ind-seq-retirada   = wms-item-estab-local.ind-seq-retirada.

find wm-docto-itens-ped 
   where wm-docto-itens-ped.cod-estabel   = wm-docto-itens.cod-estabel 
     and wm-docto-itens-ped.cod-local     = wm-docto-itens.cod-local
     and wm-docto-itens-ped.id-docto      = wm-docto-itens.id-docto
     and wm-docto-itens-ped.num-seq-item  = wm-docto-itens.num-seq-item no-lock no-error.

FIND FIRST wm-local WHERE
           wm-local.cod-estabel = wm-docto-itens.cod-estabel AND
           wm-local.cod-local   = wm-docto-itens.cod-local NO-LOCK NO-ERROR.

assign de-qtd-item-retirada = piQtdItem
       l-gera-movto        = no
       de-qtd-disponivel   = 0.

/*  ------------ VERIFICA ITEM X FORNEC X TRANS X EMB ------------- */
FIND FIRST b-wms-item-fornec-embal WHERE
     b-wms-item-fornec-embal.cod-item       = wm-docto-itens.cod-item     AND
     b-wms-item-fornec-embal.cdn-emitente   = wm-docto-itens.cdn-emitente AND
     b-wms-item-fornec-embal.cdn-tip-trans  = 2                           AND
     b-wms-item-fornec-embal.log-embal-padr = YES
     NO-LOCK NO-ERROR.

IF NOT AVAIL b-wms-item-fornec-embal THEN
    FIND FIRST wm-item-embalagem-local 
         WHERE wm-item-embalagem-local.cod-estabel = wm-docto-itens.cod-estabel AND
               wm-item-embalagem-local.cod-local   = wm-docto-itens.cod-local   AND
               wm-item-embalagem-local.cod-item    = wm-docto-itens.cod-item    AND 
               wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.
ELSE 
    FIND FIRST wm-item-embalagem-local 
         WHERE wm-item-embalagem-local.cod-estabel   = wm-docto-itens.cod-estabel        AND
               wm-item-embalagem-local.cod-local     = wm-docto-itens.cod-local          AND
               wm-item-embalagem-local.cod-item      = wm-docto-itens.cod-item           AND
               wm-item-embalagem-local.cod-embalagem = b-wms-item-fornec-embal.cod-embal NO-LOCK NO-ERROR.

/* ----------------- VERIFICA SALDO DISPONIVEL ----------------- */

ASSIGN l-item-tem-shelf-life = NO.

&IF '{&BF_MAT_VERSAO_EMS}' >= '2.071' &THEN

    /* Crit²rios de shelf-life */
    IF  wm-item.ind-tipo-contr-est = 3 
    OR  wm-item.ind-tipo-contr-est = 4 THEN DO:
    
        /*Localiza crit²rios por item*/
        FIND FIRST wms-shelflife-item
            WHERE wms-shelflife-item.cdn-cliente = wm-docto-itens.cdn-emitente 
            AND   wms-shelflife-item.cod-item    = wm-docto-itens.cod-item NO-LOCK NO-ERROR.
        IF AVAIL wms-shelflife-item THEN
            ASSIGN l-item-tem-shelf-life = YES.
        ELSE DO:
            /*Localiza crit²rios por familia*/
            FIND FIRST wms-shelflife-familia
                WHERE wms-shelflife-familia.cdn-cliente = wm-docto-itens.cdn-emitente 
                AND   wms-shelflife-familia.cod-familia = wm-item.cod-familia NO-LOCK NO-ERROR.
            IF  AVAIL wms-shelflife-familia THEN
                ASSIGN l-item-tem-shelf-life = YES.
        END.
    END.

    /* Somente faz as verifica»„es abaixo se o item tem restri»’o de shelf life */
    IF  l-item-tem-shelf-life THEN DO:
        RUN wmp/wm9015.p (INPUT  wm-docto-itens.cod-estabel,
                          INPUT  wm-docto-itens.cod-local,
                          INPUT  wm-docto-itens.cod-cliente,
                          INPUT  wm-docto-itens.cod-item,
                          INPUT  wm-docto-itens.cod-refer,
                          INPUT  wm-docto-itens.cod-lote,
                          INPUT  wm-docto-itens.cdn-emitente,
                          INPUT  de-qtd-item-retirada,
                          OUTPUT de-qtd-disponivel,
                          OUTPUT TABLE tt-lote,
                          OUTPUT TABLE rowErrors).

        EMPTY TEMP-TABLE tt-saldo-aloc.
        RUN wmp/wm9055.p (INPUT wm-docto-itens.cod-estabel,
                          INPUT wm-docto-itens.cod-local,
                          INPUT wm-docto-itens.cod-cliente,
                          INPUT wm-docto-itens.cdn-emitente,
                          INPUT wm-docto-itens.cod-item,
                          INPUT wm-docto-itens.cod-refer,
                          INPUT wm-docto-itens.cod-lote,
                          OUTPUT TABLE tt-saldo-aloc,
                          OUTPUT TABLE RowErrors).

        IF  RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
&ENDIF
IF  l-item-tem-shelf-life = NO THEN DO:
    EMPTY TEMP-TABLE tt-saldo-aloc.
    RUN wmp/wm9055.p (INPUT wm-docto-itens.cod-estabel,
                      INPUT wm-docto-itens.cod-local,
                      INPUT wm-docto-itens.cod-cliente,
                      INPUT wm-docto-itens.cdn-emitente,
                      INPUT wm-docto-itens.cod-item,
                      INPUT wm-docto-itens.cod-refer,
                      INPUT wm-docto-itens.cod-lote,
                      OUTPUT TABLE tt-saldo-aloc,
                      OUTPUT TABLE RowErrors).
    ASSIGN de-qtd-disponivel = 0.
    FOR EACH tt-saldo-aloc:
        ASSIGN de-qtd-disponivel = de-qtd-disponivel + (tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada).
    END.
END.
/********************* Chamada EPC *********************/
FOR EACH tt-epc:
    DELETE tt-epc.
END.

/* Criacao da Temp-Table tt-epc */
{include/i-epc200.i2 &CodEvent='"AlocacaoLogica"'
                     &CodParameter='"alocacao"'
                     &ValueParameter="string(rowid(wm-docto-itens)) + string(de-qtd-item-retirada, '->>,>>>,>>9.9999') + string(de-qtd-disponivel, '->>,>>>,>>9.9999')"} 

/* Chamada EPC */
{include/i-epc201.i "AlocacaoLogica"}

/* Retorno EPC */
FIND FIRST tt-epc 
     WHERE tt-epc.cod-parameter = "NOK":U    AND 
           tt-epc.cod-event     = "999999":U NO-LOCK NO-ERROR.

IF AVAIL tt-epc THEN DO:

    FIND LAST RowErrors EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE
        ASSIGN i-sequencia = 1.

    RUN pi-create-error (INPUT i-sequencia,
                         INPUT SUBSTRING(tt-epc.val-parameter,001,005),
                         INPUT SUBSTRING(tt-epc.val-parameter,006,070),
                         INPUT "",
                         INPUT "EMS",
                         INPUT SUBSTRING(tt-epc.val-parameter,076,130),
                         INPUT "ERROR").
    RETURN "NOK":U.
END.                                 
/******************* Fim Chamada EPC *******************/		

if  de-qtd-item-retirada > de-qtd-disponivel then do:
    FIND LAST RowErrors EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT 27674,
                       INPUT wm-item.cod-item).  
    ASSIGN c-descricao = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "help",
                       INPUT 27674,
                       INPUT wm-item.cod-item).  
    ASSIGN c-ajuda = RETURN-VALUE.

    RUN pi-create-error (INPUT i-sequencia,
                         INPUT 27674,
                         INPUT c-descricao,
                         INPUT "",
                         INPUT "EMS",
                         INPUT c-ajuda,
                         INPUT "ERROR"). 
    RETURN "NOK":U.
END.     

/* ---------- SUGESTAO DE RETIRADA ------------- */
/* DATA DE VALIDADE DO PRODUTO */
if  i-ind-controle-saida = 1 then do:

    /* RETIRADA POR LIFO */
    if  avail wm-docto-itens-ped 
    and wm-docto-itens-ped.log-lifo-ped-exp 
    and wm-param.log-lifo-ped-exp then  do:
        {wmp/wm9020.i2 descending}
    end.
    /* RETIRADA POR FIFO */
    else do:
        {wmp/wm9020.i2 }
    end.
end.    
/* DATA DE ENTRADA DO PRODUTO NO SISTEMA */
else do:
    assign c-lote = wm-docto-itens.cod-lote.

    /* RETIRADA POR LIFO */
    if  avail wm-docto-itens-ped 
    and wm-docto-itens-ped.log-lifo-ped-exp 
    and wm-param.log-lifo-ped-exp then  do:

        /* Abertura de Query */
        {wmp/wm9020.i1 descending }

        RUN pi-log (INPUT "wm9020b - 1").

        run doAlocation.           

        /* ----- Procura a embalagem fechada com menor quantidade que satisfa¯a a 
                 quantidade a retirar que nÊo possa ser aberta para arredondamento
                 n´a importando a data de validade ou data da entrada ----------------*/

        if  de-qtd-item-retirada > 0
        and wm-item.ind-forma-arredonda = 1 /* Para mais */ then do:

            RUN pi-log (INPUT "wm9020b - 2").
            run doAlocationMoreExit.                           
        end.                
    end.
    /* RETIRADA POR FIFO */
    else do:
        /* Abertura de Query */
        {wmp/wm9020.i1  }

            RUN pi-log (INPUT "wm9020b - 3").
        run doAlocation.           

        /* ----- Procura a embalagem fechada com menor quantidade que satisfa¯a a 
                 quantidade a retirar que nÊo possa ser aberta para arredondamento
                 n´a importando a data de validade ou data da entrada ----------------*/

        if  de-qtd-item-retirada > 0
        and wm-item.ind-forma-arredonda = 1 /* Para mais */ 
        and not piEmbalFechada then do:

            RUN pi-log (INPUT "wm9020b - 4").
            run doAlocationMoreExit.                           
        end.                
    end.

end.
RUN pi-log (INPUT "wm9020b - 5 - " + STRING(de-qtd-item-retirada) ).

/* --------- CONFIRMACAO DOS MOVTOS ------------ */

/* Atualiza Quantidade Total Retirada */
if  de-qtd-item-retirada < 0 then 
    assign piQtdRetirada = piQtdItem + de-qtd-item-retirada.
else     
    assign piQtdRetirada = piQtdItem - de-qtd-item-retirada.

    /*** Validar se a quantidade digitada jÿ foi alocada por outro usuÿrio ***/
RUN pi-log (INPUT "wm9020b - 6 - " + STRING(piQtdRetirada) ).

ASSIGN d-tot-qtd-item = 0.

for each wm-box-movto
    where wm-box-movto.cod-estabel    = wm-docto-itens.cod-estabel
    and   wm-box-movto.cod-local      = wm-docto-itens.cod-local
    and   wm-box-movto.id-docto       = wm-docto-itens.id-docto
    and   wm-box-movto.num-seq-item   = wm-docto-itens.num-seq-item
    and   wm-box-movto.ind-tipo-movto = 2 NO-LOCK:
    assign d-tot-qtd-item = d-tot-qtd-item + wm-box-movto.qtd-item *
                                             wm-box-movto.qti-embalagem.
end.

RUN pi-log (INPUT "wm9020b - 7 - d-tot-qtd-item= " + STRING(d-tot-qtd-item) ).
RUN pi-log (INPUT "wm9020b - 7 - wm-docto-itens.qtd-item= " + STRING(wm-docto-itens.qtd-item) ).

if  d-tot-qtd-item > wm-docto-itens.qtd-item then do:

    FIND LAST RowErrors NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE
    ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg":U,
                       INPUT 32647,
                       INPUT "").
    ASSIGN c-descricao = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "help":U,
                       INPUT 32647,
                       INPUT "").

    ASSIGN c-ajuda = RETURN-VALUE.

    RUN pi-create-error (INPUT i-sequencia,
                         INPUT 32647,
                         INPUT c-descricao,
                         INPUT "",
                         INPUT "EMS",
                         INPUT c-ajuda,
                         INPUT "ERROR").

    RETURN "NOK":U.
end.
RUN pi-log (INPUT "wm9020b - 8 - l-gera-movto= " + STRING(l-gera-movto) ).

/* GERA MOVIMENTOS */
if not l-gera-movto then do:
    
    FIND LAST RowErrors EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT 27674,
                       INPUT wm-item.cod-item).  
    ASSIGN c-descricao = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "help",
                       INPUT 27674,
                       INPUT wm-item.cod-item).  
    ASSIGN c-ajuda = RETURN-VALUE.

    RUN pi-create-error (INPUT i-sequencia,
                         INPUT 27674,
                         INPUT c-descricao,
                         INPUT "",
                         INPUT "EMS",
                         INPUT c-ajuda,
                         INPUT "ERROR"). 
    RETURN "NOK":U.
end.

/* --------------------------- PROCEDURES INTERNAS --------------------------- */

/* ALOCACAO DE SALDO */
PROCEDURE doAlocation :

    /*-----  1 - Procura Embalagens que a Quantidade seja modulo 0  ------*/
    /*-----  Tem como objetivo efetuar a baixa das embalagens que atendam exatamente o solicitado ---*/
    get first q-box-saldo.
    
    bloco:
    Repeat while ( avail wm-box-saldo and de-qtd-item-retirada > 0 ): 

        &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
        
            /* Se lote avancado esta ativo e item controlado por lote */
            IF l-lote-avancado AND wm-item.ind-tipo-contr-est >= 3 THEN DO:

                /* Se o lote atual ainda nao foi verificado */
                IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                    ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
                    RUN pi-lote-avancado IN THIS-PROCEDURE.
                    ASSIGN l-lote-bloqueado = RETURN-VALUE <> 'OK':U.
                END.

                /* Se Lote Bloqueado */
                IF l-lote-bloqueado THEN DO:
                    GET NEXT q-box-saldo.
                    NEXT.
                END.
            END.
        &ENDIF


        IF  l-item-tem-shelf-life = YES THEN DO:
            RUN pi-shelf-life.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST tt-saldo-aloc
                            WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                              AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                              AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                              AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                              AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                              AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                              AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                              AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
                              AND tt-saldo-aloc.qtd-box > tt-saldo-aloc.qtd-alocada) THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        
        /* Tratamento item x embalagem x emitente */
        {wmp/wm9999.i1 wm-docto-itens.cod-item 
                       wm-docto-itens.cdn-emitente 
                       wm-box-saldo.cod-embalagem 
                       "get next q-box-saldo"} 

        ASSIGN l-gera-movto = NO.
        FIND FIRST wm-item-embalagem-local
             WHERE wm-item-embalagem-local.cod-estabel   = wm-docto-itens.cod-estabel  AND
                   wm-item-embalagem-local.cod-local     = wm-docto-itens.cod-local    AND
                   wm-item-embalagem-local.cod-item      = wm-docto-itens.cod-item     AND
                   wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem  NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-item-embalagem-local THEN DO:
            FIND FIRST wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel  = wm-docto-itens.cod-estabel AND
                       wm-item-embalagem-local.cod-local     = wm-docto-itens.cod-local   AND
                       wm-item-embalagem-local.cod-item      = wm-docto-itens.cod-item    AND
                       wm-item-embalagem-local.cod-emb-item  = wm-box-saldo.cod-embalagem NO-LOCK NO-ERROR.
            IF AVAIL wm-item-embalagem THEN DO:
                ASSIGN l-abre-embal = wm-item-embalagem-local.log-abre-emb-item 
                       de-qtd-embal = wm-item-embalagem-local.qtd-emb-item.
            END.
        END.
        ELSE DO:
            ASSIGN l-abre-embal = wm-item-embalagem-local.log-abre-embalagem
                   de-qtd-embal = wm-item-embalagem-local.qtd-item-emb.
        END.
        IF l-abre-embal = NO THEN DO:
            if  ( de-qtd-item-retirada >= (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq )) 
            and ( wm-box-saldo.qtd-item  = wm-box-saldo.qtd-original )
            AND (((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq)   = wm-docto-itens.qtd-item)
             OR  de-qtd-item-retirada = de-qtd-embal) THEN DO:
                run alocaSaldoSaida .
            END.
        END.
        ELSE DO:
            if  ( de-qtd-item-retirada - (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq )) = 0 
            and ( wm-box-saldo.qtd-item  = wm-box-saldo.qtd-original ) then DO:
                run alocaSaldoSaida .
            END.
        END.            
        get next q-box-saldo.
    end.

    IF  CAN-FIND(FIRST tt-alocar) THEN DO:
        RUN wmp/wm9020d.p (INPUT ROWID(wm-docto-itens),
                           INPUT TABLE tt-alocar,
                           OUTPUT TABLE RowErrors).
        EMPTY TEMP-TABLE tt-alocar.
    END.

    if  de-qtd-item-retirada = 0 then 
        RETURN.

    /* Somente Embalagens Fechadas */        
    if  piEmbalFechada then 
        RETURN.        

    /*-----  2 - Procura Embalagens que a Quantidade seja menor que a retirar  ------*/
    get first q-box-saldo.
    bloco:
    repeat while ( avail wm-box-saldo and de-qtd-item-retirada > 0 ):

        &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
        
            /* Se lote avancado esta ativo e item controlado por lote */
            IF l-lote-avancado AND wm-item.ind-tipo-contr-est >= 3 THEN DO:

                /* Se o lote atual ainda nao foi verificado */
                IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                    ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
                    RUN pi-lote-avancado IN THIS-PROCEDURE.
                    ASSIGN l-lote-bloqueado = RETURN-VALUE <> 'OK':U.
                END.

                /* Se Lote Bloqueado */
                IF l-lote-bloqueado THEN DO:
                    GET NEXT q-box-saldo.
                    NEXT.
                END.
            END.
        &ENDIF


        IF  l-item-tem-shelf-life = YES THEN DO:
            RUN pi-shelf-life.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST tt-saldo-aloc
                            WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                              AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                              AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                              AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                              AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                              AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                              AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                              AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
                              AND tt-saldo-aloc.qtd-box > tt-saldo-aloc.qtd-alocada) THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        /* Tratamento item x embalagem x emitente */
        {wmp/wm9999.i1 wm-docto-itens.cod-item 
                       wm-docto-itens.cdn-emitente 
                       wm-box-saldo.cod-embalagem 
                       "get next q-box-saldo"} 

        ASSIGN l-gera-movto = NO.

        IF wm-docto.ind-origem-docto = 19 THEN /*Requisi»’o Material Produ»’o*/
            run alocaSaldoSaida.
        ELSE
            if  de-qtd-item-retirada >=  (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ) THEN
            run alocaSaldoSaida.

        get next q-box-saldo.
    end.

    IF  CAN-FIND(FIRST tt-alocar) THEN DO:
        RUN wmp/wm9020d.p (INPUT ROWID(wm-docto-itens),
                           INPUT TABLE tt-alocar,
                           OUTPUT TABLE RowErrors).
        EMPTY TEMP-TABLE tt-alocar.
    END.

    if  de-qtd-item-retirada = 0 then 
        RETURN.

    /*-----  3 - Procura Embalagens abertas com quantidade a retirar menor que saldo na Embalagem  ------*/
    get first q-box-saldo.
    bloco:
    repeat while ( avail wm-box-saldo and de-qtd-item-retirada > 0 ):

        &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
        
            /* Se lote avancado esta ativo e item controlado por lote */
            IF l-lote-avancado AND wm-item.ind-tipo-contr-est >= 3 THEN DO:

                /* Se o lote atual ainda nao foi verificado */
                IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                    ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
                    RUN pi-lote-avancado IN THIS-PROCEDURE.
                    ASSIGN l-lote-bloqueado = RETURN-VALUE <> 'OK':U.
                END.

                /* Se Lote Bloqueado */
                IF l-lote-bloqueado THEN DO:
                    GET NEXT q-box-saldo.
                    NEXT.
                END.
            END.
        &ENDIF


        IF  l-item-tem-shelf-life = YES THEN DO:
            RUN pi-shelf-life.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST tt-saldo-aloc
                            WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                              AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                              AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                              AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                              AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                              AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                              AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                              AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
                              AND tt-saldo-aloc.qtd-box > tt-saldo-aloc.qtd-alocada) THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        /* Tratamento item x embalagem x emitente */
        {wmp/wm9999.i1 wm-docto-itens.cod-item 
                       wm-docto-itens.cdn-emitente 
                       wm-box-saldo.cod-embalagem 
                       "get next q-box-saldo"} 

        ASSIGN l-gera-movto = NO.
        if  de-qtd-item-retirada    <= (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ) 
        and wm-box-saldo.qtd-item  <  wm-box-saldo.qtd-original  THEN DO:
            run alocaSaldoSaida.
        END.

        get next q-box-saldo.
    end.

    IF  CAN-FIND(FIRST tt-alocar) THEN DO:
        RUN wmp/wm9020d.p (INPUT ROWID(wm-docto-itens),
                           INPUT TABLE tt-alocar,
                           OUTPUT TABLE RowErrors).
        EMPTY TEMP-TABLE tt-alocar.
    END.

    if  de-qtd-item-retirada = 0 then 
        RETURN.

    /*-----  4 - Procura Embalagens  que possam ser aberta com menor quantidade que 
                 satisfa¯a  a quantidade a retirar                                          ------*/
    get first q-box-saldo.
    bloco:
    repeat while ( avail wm-box-saldo and de-qtd-item-retirada > 0 ):

        &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
        
            /* Se lote avancado esta ativo e item controlado por lote */
            IF l-lote-avancado AND wm-item.ind-tipo-contr-est >= 3 THEN DO:

                /* Se o lote atual ainda nao foi verificado */
                IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                    ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
                    RUN pi-lote-avancado IN THIS-PROCEDURE.
                    ASSIGN l-lote-bloqueado = RETURN-VALUE <> 'OK':U.
                END.

                /* Se Lote Bloqueado */
                IF l-lote-bloqueado THEN DO:
                    GET NEXT q-box-saldo.
                    NEXT.
                END.
            END.
        &ENDIF


        IF  l-item-tem-shelf-life = YES THEN DO:
            RUN pi-shelf-life.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST tt-saldo-aloc
                            WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                              AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                              AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                              AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                              AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                              AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                              AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                              AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
                              AND tt-saldo-aloc.qtd-box > tt-saldo-aloc.qtd-alocada) THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.
        /* Tratamento item x embalagem x emitente */
        {wmp/wm9999.i1 wm-docto-itens.cod-item 
                       wm-docto-itens.cdn-emitente 
                       wm-box-saldo.cod-embalagem 
                       "get next q-box-saldo"} 

        IF  de-qtd-item-retirada  <= (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ) AND 
            wm-box-saldo.qtd-item >=  wm-box-saldo.qtd-original                            AND 
            wm-item-embalagem-local.log-abre-embalagem = YES THEN DO:

            /* Se tiver embalagem filha indicada, verifica se a filha permite abrir embalagem ou n’o. 
               Se permitir, deixa retirar qualquer valor. 
               Sen’o, somente o que for mœltiplo da embalagem filha */
            IF  wm-item-embalagem-local.cod-emb-item <> "" THEN DO:
                IF  wm-item-embalagem-local.log-abre-emb-item = YES THEN
                    RUN alocaSaldoSaida. /* abre embalagem filha, retira qualquer valor */
                ELSE
                    IF  INT(de-qtd-item-retirada / wm-item-embalagem-local.qtd-emb-item) = (de-qtd-item-retirada / wm-item-embalagem-local.qtd-emb-item) THEN
                        RUN alocaSaldoSaida. /* quantidade ² mœltipla da embalagem filha, permite retirar. */
            END.
            ELSE
                RUN alocaSaldoSaida. /* n’o tem embalagem filha, retira qualquer valor */
        END.

        get next q-box-saldo.
    end.

    IF  CAN-FIND(FIRST tt-alocar) THEN DO:
        RUN wmp/wm9020d.p (INPUT ROWID(wm-docto-itens),
                           INPUT TABLE tt-alocar,
                           OUTPUT TABLE RowErrors).
        EMPTY TEMP-TABLE tt-alocar.
    END.

END PROCEDURE.

/* ------------------------------ */

PROCEDURE alocaSaldoSaida:

    /*****************************************
     * In­cio da chamada EPC
     *****************************************/ 
    if c-nom-prog-dpc-mg97  <> "" or 
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-upc-mg97  <> "" then do:

        for each tt-epc
            where tt-epc.cod-event = "ValidateBin".
            delete tt-epc.
        end.

        /*Cria»’o de registro para Temp-Table tt-epc*/
        {include/i-epc200.i2 &CodEvent='"ValidateBin"'
                             &CodParameter='"wm-docto-itens-rowid"'
                             &ValueParameter=string(rowid(wm-docto-itens))}

        {include/i-epc200.i2 &CodEvent='"ValidateBin"'
                             &CodParameter='"wm-box-saldo-rowid"'
                             &ValueParameter=string(rowid(wm-box-saldo))}

        /*Chamada do programa de EPC */
        {include/i-epc201.i "ValidateBin"}

        if can-find(first tt-epc
                    where tt-epc.cod-event = "ValidateBin"
                      and tt-epc.cod-parameter = "ERROR") then
            return "NOK".
    end.
    /*****************************************
     * Fim da chamada EPC
     *****************************************/ 

    IF AVAIL wm-local THEN DO:
        IF wm-local.log-vencto = YES THEN DO:
            /* 
            Permitir saida de produtos vencidos, desde que nao seja documentos de 
           (Pre-Faturamento = 4 ) ou (Estorno de Producao = 14) ou
           (Requisicao Material Producao = 19) atendimento de ordem de producao */
           IF wm-docto.ind-origem-docto = 4 OR wm-docto.ind-origem-docto = 14 OR wm-docto.ind-origem-docto = 19 THEN
               ASSIGN l-data-validade = YES. /* Verifica validade */
           ELSE
               ASSIGN l-data-validade = NO.  /* Nao Verifica validade */
        END.
        ELSE
            ASSIGN l-data-validade = YES.
    END.
    ELSE
        ASSIGN l-data-validade = YES.

    FOR EACH tt-epc EXCLUSIVE-LOCK
       WHERE tt-epc.cod-event = "validaDtValidadeLote":
        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"validaDtValidadeLote"'
                         &CodParameter='"rowid(wm-docto-itens)"'
                         &ValueParameter=string(rowid(wm-docto-itens))}
    {include/i-epc200.i2 &CodEvent='"validaDtValidadeLote"'
                         &CodParameter='"rowid(wm-box-saldo)"'
                         &ValueParameter=string(rowid(wm-box-saldo))}
    /*Chamada do programa de EPC */
    {include/i-epc201.i "validaDtValidadeLote"}

    /*ASSIGN l-data-validade = YES.*/
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "validaDtValidadeLote":U
           AND tt-epc.cod-parameter = "returnValidade":U NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN
        ASSIGN l-data-validade = tt-epc.val-parameter = "SIM":U.
RUN pi-log (INPUT "alocaSaldoSaida - 1 - l-data-validade= " + STRING(l-data-validade)).
    find first wm-saldo-estoque EXCLUSIVE-LOCK
         where wm-saldo-estoque.cod-estabel = wm-docto-itens.cod-estabel 
           and wm-saldo-estoque.cod-local   = wm-docto-itens.cod-local   
           and wm-saldo-estoque.cod-cliente = wm-docto-itens.cod-cliente 
           and wm-saldo-estoque.cod-item    = wm-box-saldo.cod-item      
           and wm-saldo-estoque.cod-refer   = wm-box-saldo.cod-refer     
           and wm-saldo-estoque.cod-lote    = wm-box-saldo.cod-lote NO-ERROR.
    if  avail wm-saldo-estoque then do:

RUN pi-log (INPUT "alocaSaldoSaida - 2 - wm-saldo-estoque.dt-validade-lote= " + STRING(wm-saldo-estoque.dt-validade-lote)).
RUN pi-log (INPUT "alocaSaldoSaida - 2 - i-num-dias-reanalise= " + STRING(i-num-dias-reanalise)).
        IF l-data-validade = NO                  OR
          (wm-saldo-estoque.dt-validade-lote = ? OR
           wm-saldo-estoque.dt-validade-lote >= TODAY + i-num-dias-reanalise) THEN DO:

RUN pi-log (INPUT "alocaSaldoSaida - 3 - wm-box-saldo.ind-status-saldo= " + STRING(wm-box-saldo.ind-status-saldo)).
            &IF '{&BF_MAT_VERSAO_EMS}' < '2.071' &THEN
            if  NOT l-data-validade
                OR (wm-box-saldo.ind-status-saldo = 3 AND
                    wm-saldo-estoque.dt-validade-lote = ? OR wm-saldo-estoque.dt-validade-lote >= TODAY + i-num-dias-reanalise) then do:
            &ENDIF.
                  
RUN pi-log (INPUT "alocaSaldoSaida - 4 - wm-box-saldo.qtd-item= " + STRING(wm-box-saldo.qtd-item)).
            if  ( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ) <= de-qtd-item-retirada then 
                assign de-qtd-aux = ( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ).
            else 
                assign de-qtd-aux = de-qtd-item-retirada.
RUN pi-log (INPUT "alocaSaldoSaida - 5 - de-qtd-aux= " + STRING(de-qtd-aux)).
    
            FIND FIRST tt-saldo-aloc EXCLUSIVE-LOCK
                 WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                   AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                   AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                   AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                   AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                   AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                   AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                   AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.
    
RUN pi-log (INPUT "alocaSaldoSaida - 6 - tt-saldo-aloc.qtd-box= " + STRING(tt-saldo-aloc.qtd-box)).
RUN pi-log (INPUT "alocaSaldoSaida - 6 - tt-saldo-aloc.qtd-alocada= " + STRING(tt-saldo-aloc.qtd-alocada)).
            IF de-qtd-aux > (tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada) THEN
                ASSIGN de-qtd-aux = tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada.
RUN pi-log (INPUT "alocaSaldoSaida - 7 - de-qtd-aux= " + STRING(de-qtd-aux)).
            IF de-qtd-aux > 0 THEN DO:
                CREATE tt-alocar.
                ASSIGN tt-alocar.cod-estabel    = wm-docto-itens.cod-estabel
                       tt-alocar.cod-local      = wm-docto-itens.cod-local
                       tt-alocar.id-box         = wm-box-saldo.id-box
                       tt-alocar.id-docto       = wm-docto-itens.id-docto
                       tt-alocar.num-seq-item   = wm-docto-itens.num-seq-item
                       tt-alocar.cod-embalagem  = wm-box-saldo.cod-embalagem
                       tt-alocar.id-saldo       = wm-box-saldo.id-saldo
                       tt-alocar.cod-lote       = wm-box-saldo.cod-lote
                       tt-alocar.dt-transacao   = TODAY
                       tt-alocar.dt-atualizacao = TODAY
                       tt-alocar.qtd-original   = wm-box-saldo.qtd-original
                       tt-alocar.qtd-saida      = de-qtd-aux
                       l-gera-movto             = YES.
        
                ASSIGN tt-saldo-aloc.qtd-alocada     = tt-saldo-aloc.qtd-alocada     + de-qtd-aux
                       de-qtd-item-retirada          = de-qtd-item-retirada          - de-qtd-aux
                       wm-saldo-estoque.qtd-liberada = wm-saldo-estoque.qtd-liberada - de-qtd-aux.

RUN pi-log (INPUT "alocaSaldoSaida - 8 - de-qtd-aux= " + STRING(de-qtd-aux)).
RUN pi-log (INPUT "alocaSaldoSaida - 8 - l-gera-movto= " + STRING(l-gera-movto)).
    
            if wm-saldo-estoq.qtd-liberada < 0 then assign wm-saldo-estoq.qtd-liberada = 0.
    
            FIND CURRENT wm-saldo-estoque NO-LOCK NO-ERROR.
    
            &IF '{&BF_MAT_VERSAO_EMS}' < '2.071' &THEN
            end.
            else if wm-box-saldo.qtd-pendente = 0 then do:
    
                find current wm-box-saldo exclusive-lock no-error.
                assign wm-box-saldo.ind-status-saldo = 4. /* Em An˜lise */
                find current wm-box-saldo no-lock no-error.
    
                if  wm-saldo-estoque.ind-status-saldo <> 4 then do: /* Em An˜lise */
                    assign wm-saldo-estoque.ind-status-saldo = 4 /* Em An˜lise */
                           wm-saldo-estoque.qtd-liberada     = wm-saldo-estoque.qtd-liberada
                                                             - (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq).
                    if  wm-saldo-estoq.qtd-liberada < 0  then assign wm-saldo-estoq.qtd-liberada = 0.
    
                    /********************* Chamada EPC *********************/
                    FOR EACH  tt-epc EXCLUSIVE-LOCK
                        WHERE tt-epc.cod-event = "lotAnalysisTransfer":
                        DELETE tt-epc.
                    END.
        
                    /* Criacao da Temp-Table tt-epc */
                    {include/i-epc200.i2 &CodEvent='"lotAnalysisTransfer"'
                                         &CodParameter='"rowidWm-saldo-estoque"'
                                         &ValueParameter="string(rowid(wm-saldo-estoque))"}
                    /* Chamada EPC */
                    {include/i-epc201.i "lotAnalysisTransfer"}
        
                    end.
    
                    find current wm-saldo-estoque no-lock no-error.
                end.
                &ENDIF.
            END.
        END.
    end.

    /*****************************************
    * In­cio da chamada EPC
    *****************************************/
    for each tt-epc
        where tt-epc.cod-event = "afterCreate-wm-box-saida".
        delete tt-epc.
    end.

    /*Cria»’o de registro para Temp-Table tt-epc*/
    {include/i-epc200.i2 &CodEvent='"afterCreate-wm-box-saida"'
                         &CodParameter='"wm-box-saida-rowid"'
                         &ValueParameter=string(rw-wm-box-saida)}

    /*Chamada do programa de EPC */
    {include/i-epc201.i "afterCreate-wm-box-saida"}
    /*****************************************
    * Fim da chamada EPC
    *****************************************/

END PROCEDURE.

/* ------------------------------ */

PROCEDURE doAlocationMoreExit :
    RUN pi-log (INPUT "doAlocationMoreExit - 1 - l-gera-movto= " + STRING(l-gera-movto)).

    get first q-box-saldo.
    bloco:
    REPEAT WHILE (AVAIL wm-box-saldo AND de-qtd-item-retirada > 0 ):

        &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
        
            /* Se lote avancado esta ativo e item controlado por lote */
            IF l-lote-avancado AND wm-item.ind-tipo-contr-est >= 3 THEN DO:

                /* Se o lote atual ainda nao foi verificado */
                IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                    ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
                    RUN pi-lote-avancado IN THIS-PROCEDURE.
                    ASSIGN l-lote-bloqueado = RETURN-VALUE <> 'OK':U.
                END.

                /* Se Lote Bloqueado */
                IF l-lote-bloqueado THEN DO:
                    GET NEXT q-box-saldo.
                    NEXT.
                END.
            END.
        &ENDIF


        IF  l-item-tem-shelf-life = YES THEN DO:
            RUN pi-shelf-life.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                GET NEXT q-box-saldo.
                NEXT bloco.
            END.
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST tt-saldo-aloc
                            WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel  
                              AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local    
                              AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente  
                              AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item     
                              AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer    
                              AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote      
                              AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box       
                              AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
                              AND tt-saldo-aloc.qtd-box > tt-saldo-aloc.qtd-alocada) THEN DO:
                GET NEXT q-box-saldo.
                NEXT.
            END.
        END.

        /* Tratamento item x embalagem x emitente */
        {wmp/wm9999.i1 wm-docto-itens.cod-item 
                       wm-docto-itens.cdn-emitente 
                       wm-box-saldo.cod-embalagem 
                       "get next q-box-saldo"} 
RUN pi-log (INPUT "doAlocationMoreExit - 2 - de-qtd-item-retirada= " + STRING(de-qtd-item-retirada)).
RUN pi-log (INPUT "doAlocationMoreExit - 2 - wm-box-saldo.qtd-item= " + STRING(wm-box-saldo.qtd-item)).
RUN pi-log (INPUT "doAlocationMoreExit - 2 - wm-box-saldo.qtd-item-bloq= " + STRING(wm-box-saldo.qtd-item-bloq)).
RUN pi-log (INPUT "doAlocationMoreExit - 2 - l-gera-movto= " + STRING(l-gera-movto)).

        ASSIGN l-gera-movto = NO.
        IF  de-qtd-item-retirada > (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ) AND 
            wm-item-embalagem-local.log-abre-embalagem = NO THEN DO:
            RUN alocaSaldoSaida.
        END.

        GET NEXT q-box-saldo.
    END.
    RUN pi-log (INPUT "doAlocationMoreExit - 3 - l-gera-movto= " + STRING(l-gera-movto)).

    IF  CAN-FIND(FIRST tt-alocar) THEN DO:
        RUN wmp/wm9020d.p (INPUT ROWID(wm-docto-itens),
                           INPUT TABLE tt-alocar,
                           OUTPUT TABLE RowErrors).
        EMPTY TEMP-TABLE tt-alocar.
    END.
    RUN pi-log (INPUT "doAlocationMoreExit - 4 - l-gera-movto= " + STRING(l-gera-movto)).

END PROCEDURE.


&IF '{&BF_MAT_VERSAO_EMS}' >= '2.071' &THEN
    PROCEDURE pi-shelf-life:
    
        IF  AVAIL b-wm-saldo-estoque THEN
            FIND FIRST tt-lote
                WHERE tt-lote.r-saldo-estoque = ROWID(b-wm-saldo-estoque) 
                  AND tt-lote.id-atende       = YES NO-LOCK NO-ERROR.
        ELSE DO:
            FIND b2-wm-saldo-estoque NO-LOCK
                WHERE b2-wm-saldo-estoque.cod-estabel = wm-box-saldo.cod-estabel
                  AND b2-wm-saldo-estoque.cod-local   = wm-box-saldo.cod-local
                  AND b2-wm-saldo-estoque.cod-cliente = wm-box-saldo.cod-cliente
                  AND b2-wm-saldo-estoque.cod-item    = wm-box-saldo.cod-item
                  AND b2-wm-saldo-estoque.cod-refer   = wm-box-saldo.cod-refer
                  AND b2-wm-saldo-estoque.cod-lote    = wm-box-saldo.cod-lote NO-ERROR.
            IF  AVAIL b2-wm-saldo-estoque THEN
                FIND FIRST tt-lote
                    WHERE tt-lote.r-saldo-estoque = ROWID(b2-wm-saldo-estoque) 
                      AND tt-lote.id-atende       = YES NO-LOCK NO-ERROR.
        END.
        /* Se o lote do saldo encontrado n’o atende aos crit²rios de shelf life, vai para o pr½ximo */
        IF  NOT AVAIL tt-lote THEN
            RETURN "NOK":U.
        
        RETURN "OK":U.
    
    END PROCEDURE.
&ENDIF

&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    PROCEDURE pi-lote-avancado:
        DEFINE VARIABLE h-proxy124      AS HANDLE   NO-UNDO.
        DEFINE VARIABLE l-aloca-wms     AS LOGICAL  NO-UNDO.
        DEFINE VARIABLE l-saldo-disp    AS LOGICAL  NO-UNDO.
        DEFINE VARIABLE l-existe        AS LOGICAL  NO-UNDO.

        IF NOT l-lote-avancado THEN
            RETURN 'OK':U.

        IF NOT VALID-HANDLE(h-proxy124) THEN
            RUN wmp/wmprx124.p PERSISTENT SET h-proxy124.

        RUN buscaEstadoLoteCQ IN h-proxy124 (INPUT wm-box-saldo.cod-estabel,
                                             INPUT wm-box-saldo.cod-item,
                                             INPUT wm-box-saldo.cod-lote,
                                             OUTPUT l-existe,
                                             OUTPUT TABLE RowErrors).
        IF NOT l-existe THEN DO:
            FOR EACH RowErrors:
                DELETE RowErrors.
            END.
            IF VALID-HANDLE(h-proxy124) THEN DO:
                RUN destroy IN h-proxy124.
                DELETE OBJECT h-proxy124 NO-ERROR.
            END.
            RETURN 'OK':U.
        END.

        RUN getLoteSaldoDisponivel  IN h-proxy124 (OUTPUT l-saldo-disp).
        RUN getLoteAlocaWMS         IN h-proxy124 (OUTPUT l-aloca-wms).

        IF VALID-HANDLE(h-proxy124) THEN DO:
            RUN destroy IN h-proxy124.
            DELETE OBJECT h-proxy124 NO-ERROR.
        END.

        IF l-saldo-disp AND l-aloca-wms THEN
            RETURN 'OK':U.
        ELSE
            RETURN 'NOK':U.

    END PROCEDURE.
&ENDIF

PROCEDURE pi-create-error:

    DEFINE INPUT PARAMETER pErrorSequence    AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorDescription AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorHelp        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType     AS CHARACTER NO-UNDO.

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = pErrorDescription NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = pErrorSequence
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorDescription = pErrorDescription
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorHelp        = pErrorHelp
               RowErrors.ErrorSubType     = pErrorSubType.
    END.

    RETURN "OK":U.    

END PROCEDURE.

PROCEDURE pi-log:
    DEF INPUT PARAMETER c-msg AS CHAR NO-UNDO.

END PROCEDURE. 
