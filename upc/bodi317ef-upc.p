/* ----------------------------------------------------------------------------
   Programa..: upc/boin317ef-upc.p
   Data......: Dezembro / 2004.
   Autor.....: Robinson Rafael Koprowski - Datasul Gestech. 
   Objetivo..: Alteracao de status da ped-fiscal na efetivacao da NF
             : 25/10/2011 - Hoepers: implementar controle para kanban eletronico
---------------------------------------------------------------------------- */

def new shared var l-aliq-nat        as logical                        no-undo.
def new shared var l-tipo-nota       as logical format "Entrada/Saida" no-undo.
def new shared var de-aliquota-icm   like natur-oper.aliquota-icm.
def new shared var r-ped-venda       as rowid no-undo.
def new shared var r-pre-fat         as rowid no-undo.
def new shared var r-emitente        as rowid no-undo.
def new shared var r-estabel         as rowid no-undo.
def new shared var r-docum-est       as rowid no-undo.
                                              
def new shared var r-nota            as rowid no-undo.
def new shared var de-cotacao        as decimal format ">>>,>>9.99999999" NO-UNDO.
def new shared var r-nota-fiscal     as ROWID.
def new shared var i-codigo          as integer.
def new shared var i-cont            as integer no-undo.
DEFINE VARIABLE i-ordena-vol AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ult-vol    AS INTEGER     NO-UNDO.
def new shared var de-conv           as decimal format ">>>>9.99".
def new shared var r-item            as rowid.
def new shared var r-natur-oper      as rowid.
def new shared var c-num-nota        as char format "x(16)" NO-UNDO.
def new shared var c-num-duplic      as CHAR NO-UNDO.

def new shared var de-conv-total        AS DECIMAL.
def new shared var de-tot-icms-obs      like it-nota-fisc.vl-icms-it.
def new shared var de-tot-icmssubs-obs  like it-nota-fisc.vl-icmsub-it.
def new shared var de-tot-bicmssubs-obs like it-nota-fisc.vl-bsubs-it.
def new shared var de-tot-ipi-dev-obs   like it-nota-fisc.vl-ipi-it.
def new shared var de-tot-ipi-calc      like it-nota-fisc.vl-ipi-it.
def new shared var de-tot-ipi-nota      like it-nota-fisc.vl-ipi-it.

DEF NEW GLOBAL SHARED VAR v_val_dec_1      LIKE int-ped-venda2.dec-2 NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_desc_bloq      AS CHAR                   NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_categ      AS CHAR                   NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-int-ped-venda2 AS RECID                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_val_entrada    LIKE int-ped-venda2.dec-2 NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_status_ped     AS CHAR                   NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-volume-ft4003  AS CHAR                   NO-UNDO.

DEFINE VARIABLE d-tot-emb AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-ultimo-volume AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qt-vol-item AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nro-vol-gerar AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nro-vol-gerado AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-nf-referenciado AS CHAR  NO-UNDO.

DEF VAR d-totalItens AS DEC     NO-UNDO.
DEF VAR d-aliq-ipi   AS DECIMAL NO-UNDO.

DEFINE VARIABLE raw-param AS RAW       NO-UNDO.

DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
       FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-controla-mensagem NO-UNDO
    FIELD cod-mensagem LIKE mensagem.cod-mensagem.

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-origem-inegr AS INT /*1 - Pedido, 2 - Faturamento, 3 - Atualiza saldo*/.

define temp-table tt-param-esftp119 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    FIELD cod-estab-ini    LIKE nota-fiscal.cod-estabel
    FIELD cod-estab-fim    LIKE nota-fiscal.cod-estabel
    FIELD serie-ini        LIKE nota-fiscal.serie
    FIELD serie-fim        LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE nota-fiscal.nr-nota-fis
    FIELD l-envia-email    AS LOG INITIAL NO
    FIELD l-imprime-trib   AS LOG INITIAL NO.

/*{esp/esb/esesb000.i}*/
{esp/esb/out/msg0316.i}

DEFINE NEW GLOBAL SHARED TEMP-TABLE msg0316r2 NO-UNDO
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD StatusAvaliacao                  AS CHAR
   FIELD LimiteAdotado                    AS DEC FORMAT ">>>,>>>,>>>,>>9.99" /*LIKE val_tit_acr.val_origin_tit_acr DECIMALS 2*/
   FIELD LimiteDisponivel                 AS DEC FORMAT ">>>,>>>,>>>,>>9.99" /*LIKE val_tit_acr.val_origin_tit_acr DECIMALS 2*/
   FIELD DataValidade                     AS CHAR FORMAT "x(20)"
   FIELD Observacao                       AS CHAR.

/* RPS */
DEFINE NEW GLOBAL SHARED VARIABLE wh-TribRPS-FT4002             AS WIDGET-HANDLE NO-UNDO.

DEF VAR v_val_margem_aprov LIKE int-ped-venda2.dec-2 NO-UNDO.
DEF VAR v_resultado        AS CHAR                   NO-UNDO.
DEF VAR l-troca            AS LOG                    NO-UNDO.
DEF VAR v_log_nat_deps     AS LOG                    NO-UNDO.
DEFINE VARIABLE i-qt-item  LIKE item-caixa.qt-item   NO-UNDO.
DEFINE VARIABLE c-email-destino    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nr-sequencia-vpc AS INTEGER     NO-UNDO.
DEF BUFFER b-emitente FOR emitente.
DEF BUFFER b-emitente_red FOR emitente.
DEF BUFFER b-natur-oper FOR natur-oper.
DEF BUFFER bf_usuar_mestre FOR usuar_mestre.
DEF BUFFER b-tranp-redes  FOR transporte.
DEFINE VARIABLE  c-chave LIKE NOTA-FISCAL.COD-CHAVE-ACES-NF-ELETRO   NO-UNDO.
DEFINE TEMP-TABLE tt-pagto-vpc-aux NO-UNDO LIKE pagto-vpc
       field r-rowid as rowid.

DEFINE VARIABLE de-SomaQtdePorCaixa AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-ped-cli           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-portaria     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-oc AS CHAR NO-UNDO. /*ordens compra Decio*/

{esp/ftp/esftp083tt.i}

DEFINE TEMP-TABLE tt-itens-flow-rack NO-UNDO LIKE tt-itens-calculo.

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".

DEF BUFFER b-it-nota-fisc FOR it-nota-fisc.
DEF BUFFER b-nf-esedex    FOR nota-fiscal.
DEF BUFFER b-estrutura-filho FOR estrutura.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-notas-lidas NO-UNDO
    FIELD  r-nfe-gati AS ROWID.

def new shared temp-table item-nota no-undo
    field registro        as rowid
    field it-codigo       like it-nota-fisc.it-codigo
    field aliquota-icm    like it-nota-fisc.aliquota-icm
    field nr-seq-fat      like it-nota-fisc.nr-seq-fat
    field sit-tribut      as integer format ">>>".


define temp-table b-class-fis NO-UNDO
    field b-cod-class  like  item.class-fisc
    field b-indice     as    integer initial 0
    index b-cod-class
    is primary b-cod-class ascending.

DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME AS CHARACTER
    FIELD FullPath AS CHARACTER
    FIELD FILE     AS CHARACTER.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(250)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEFINE VARIABLE i-caixa  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nro-caixas AS DECIMAL     NO-UNDO.
def var r-it-nota               as ROWID NO-UNDO.
def var i-sit-nota-ini          as INTEGER NO-UNDO.
def var i-sit-nota-fim          as INTEGER NO-UNDO.
def var c-formato-cfop          as CHAR NO-UNDO.
def var l-sub                   as LOGICAL NO-UNDO.
def var c-cod-suframa-est     like estabelec.cod-suframa NO-UNDO.
def var c-cod-suframa-cli     like emitente.cod-suframa NO-UNDO.
def var de-qt-fatur             as decimal format ">>>>,>>9.9999" NO-UNDO.
def var c-class-fiscal          as character format "99" NO-UNDO.
def var c-mensagem1             as character format "x(380)" NO-UNDO.
def var c-mensagem2             as character format "x(152)" NO-UNDO.
def var c-especie               as character extent 5 format "x(30)" NO-UNDO.
def var c-desc-prod             as character format "x(42)" NO-UNDO.
def var c-repres                as character format "x(15)" NO-UNDO.
def var c-redesp                as character NO-UNDO.
def var c-nat                   as character format "x.xxx" NO-UNDO.
def var c-un-fatur              as character format "x(2)" NO-UNDO.
def var i                       as INTEGER NO-UNDO.
def var l-tem-portaria-note     as LOGICAL NO-UNDO.
def var l-familia-701           as LOGICAL NO-UNDO.
def var l-familia-709           as LOGICAL NO-UNDO.
def var c-familia-701           as CHAR NO-UNDO.
def var c-familia-709           as CHAR NO-UNDO.

DEFINE VARIABLE de-peso-bruto       AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-peso-liquido     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE l-tem-portaria      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-nao-tem-portaria  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-software          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-emb-escolhida     LIKE embalag.sigla-emb NO-UNDO.
DEFINE VARIABLE de-vol-embalag      AS DECIMAL     NO-UNDO FORMAT "99.999999999".
DEFINE VARIABLE de-volume-resto  AS DECIMAL     NO-UNDO FORMAT "99.999999999".

def temp-table tt-volume-nf NO-UNDO like volume-nf.
def buffer b-embalag for embalag.
def buffer b-embalagResto   for embalag.

DEFINE VARIABLE hBODI317ef          AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-procedimento-ok   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-proximo-vol       AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-so-portaria       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-boes150b          AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-retorno           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-mensagem          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tipo-transacao    AS CHARACTER  NO-UNDO.
DEFINE variable c-nat-vinculada     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nome-abrev-tri    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-entrega-tri   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-esapi014          AS HANDLE     NO-UNDO.
DEFINE VARIABLE pcNroCartao         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-vl-tot-nota      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-vl-tot-nota-deps AS DECIMAL    NO-UNDO.
DEFINE VARIABLE v_log_envio         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-remetente         AS CHARACTER  NO-UNDO.   
DEFINE VARIABLE c-email             AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE c-titulo            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-controladoria     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-estab         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-boes398           AS HANDLE     NO-UNDO.
DEFINE VARIABLE p-dt-implant-ped    AS DATE       NO-UNDO.
DEFINE VARIABLE p-erro              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE v_dias_negoc        AS INT        NO-UNDO.
DEFINE VARIABLE v_dt_negoc          AS DATE       NO-UNDO.

DEFINE TEMP-TABLE tt-comissao-fat NO-UNDO LIKE comissao-fat.

DEFINE VARIABLE h-escrm001api       AS HANDLE      NO-UNDO.

/** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 - In°cio **/
DEFINE VARIABLE l-atraso-pagto        AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE de-vl-lim-tot-supcard AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-limite-supcard     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-ped-aloc-supcard   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-lim-nfs-supcard    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-lim-disp-supcard   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-dias-atraso-tit     AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-tit-atrasado        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE dt-venc-prim-parc     AS DATE        NO-UNDO.
DEFINE VARIABLE i-num-parc-fat        AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-esapi001            AS HANDLE      NO-UNDO.
DEFINE VARIABLE de-parcelas-aux       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-comis-aux          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-tot-item        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-diferenca          AS DECIMAL     NO-UNDO.
/** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Setembro de 2011 - Final **/

/** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Junho de 2012 - In°cio **/
DEFINE VARIABLE de-vl-tot-nota-supcard AS DECIMAL     NO-UNDO.
/** SupplierCard - Fabiano Sakae Ribeiro (Exponencial TI) - Junho de 2012 - Final **/

/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - Final */
DEFINE VARIABLE l-encontrou-cond-pagto AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE i-count                AS INTEGER                       NO-UNDO.
DEFINE VARIABLE v-cod-cond-pag         LIKE int-cond-pagto.cod-cond-pag NO-UNDO.
/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - Final */

/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */
DEFINE VARIABLE l-natur-oper-servico AS LOGICAL     NO-UNDO.
/* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - Final */

/* Fabiano Sakae Ribeiro (Exponencial TI) - Julho/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */
DEFINE BUFFER bf-int-ped-venda FOR int-ped-venda.
/* Fabiano Sakae Ribeiro (Exponencial TI) - Julho/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - Final */

DEFINE VARIABLE c-lista-clientes AS CHARACTER FORMAT 'x(100)':U NO-UNDO.

DEF BUFFER b-wt-fat-ser-lote FOR wt-fat-ser-lote.
DEF VAR c-msg AS CHAR FORMAT "x(150)" NO-UNDO.


DEFINE VARIABLE l-ativa-log AS LOGICAL INITIAL YES    NO-UNDO.
{esp/cpp/escpp058.i}

DEFINE VARIABLE c-ambiente AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-tt-volumes FOR tt-volumes.
DEFINE TEMP-TABLE tt-volumes-flow-rack NO-UNDO LIKE tt-volumes.

/* Inicio conex∆o RPC */

&scoped-define TESTE 
&SCOPED-DEFINE SERVIDOR-PRODUCAO rpcredecard

/*
&scoped-define TESTE 1                    
&SCOPED-DEFINE SERVIDOR-TESTE rpcredecard
*/

&IF "{&TESTE}" = "" &THEN
&SCOPED-DEFINE PARAM-RPC -AppService {&SERVIDOR-PRODUCAO} 
&ELSE
&SCOPED-DEFINE PARAM-RPC -AppService {&SERVIDOR-TESTE} 
MESSAGE "ATENÄ«O, Vocà est† usando o servidor RPC de Testes"
VIEW-AS ALERT-BOX INFO.
&ENDIF
DEF VAR hproc AS HANDLE NO-UNDO.
DEF VAR hprog AS HANDLE NO-UNDO.
/* Fim conex∆o RPC */

/* Ocorrància ASTEC */
DEFINE VARIABLE h-esapi018 AS HANDLE      NO-UNDO.

/* 61597 */
DEFINE VARIABLE vl-IcmsUFDest LIKE item-nf-adc.val-livre-3 NO-UNDO.
DEFINE VARIABLE vl-FCP        LIKE item-nf-adc.val-livre-2 NO-UNDO.
/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc */
{include/i-epc200.i1}
{utp/utapi019.i}
{utp/ut-glob.i}


DEFINE TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal    AS ROWID
    FIELD nr-nota           LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto      LIKE wt-docto.seq-wt-docto.

/**
def temp-table tt-resto
    field it-codigo like item.it-codigo
    field qtde      as dec
    index tt-resto is primary unique it-codigo
    index qtde     qtde.
 */
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

/*MasterSaf*/
RUN upc/bodi317ef1-upc.p (INPUT p-ind-event,
                          INPUT-OUTPUT TABLE tt-epc).

DEF BUFFER b-tt-resto FOR tt-resto.
DEF BUFFER b-item     FOR ITEM.
/*output to c:\temp\rener.txt append.
FOR EACH tt-epc NO-LOCK:
put unformatted
            tt-epc.cod-event        ';'
            tt-epc.cod-parameter    ';'
            tt-epc.val-parameter skip.
END.
output close.*/


/** Tratamento de ponto de programa **/
DEF VAR i-nome-programa AS CHAR NO-UNDO.
DEF VAR i-ponto AS INT NO-UNDO.
DEF VAR i-sequencia AS INT NO-UNDO.
DEF VAR i-conteudo AS CHAR NO-UNDO.
{esp/es0018.i}

DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   
DEF BUFFER b-ponto-programa FOR ponto-programa.
def buffer b-nota-fiscal    for nota-fiscal.
    
    
DEF TEMP-TABLE rowerrorsaux   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.


{method/dbotterr.i}

DEFINE TEMP-TABLE RowErrorsAstec NO-UNDO LIKE RowErrors.

EMPTY TEMP-TABLE tt-prog-ponto.

FOR EACH b-ponto-programa WHERE 
         b-ponto-programa.nome-programa = "bodi317ef":
    RUN esp/es0018p.p (INPUT b-ponto-programa.nome-programa,
                       INPUT b-ponto-programa.ponto,
                       INPUT i-sequencia,
                       INPUT i-conteudo,
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR EACH TT-PROG-PONTO:
        CREATE tt-prog-ponto-tmp.
        BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
    END.
END.
/* Fim */

/*MESSAGE "p-ind-event " p-ind-event VIEW-AS ALERT-BOX.*/

/*ASSIGN l-ativa-log = NO.*/
IF l-ativa-log THEN DO:
    IF OPSYS = 'unix' THEN
       OUTPUT TO VALUE(session:temp-directory + "/" + TRIM(v_cod_usuar_corren)  +  "1.LOG") APPEND.
    ELSE 
       OUTPUT TO VALUE(session:temp-directory + "/" + TRIM(v_cod_usuar_corren)  +  "1.LOG") APPEND.


   PUT "bodi317ef-upc " p-ind-event FORMAT "x(50)" " data " TODAY " hora " string(TIME,"HH:MM:SS") SKIP.
END.
IF p-ind-event = 'EndCalculaComis' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
    /*log-manager:write-message('BODI317EF-UPC EndCalculaComis ').*/
    
    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.

    IF AVAILABLE tt-epc THEN DO:
    
        ASSIGN hbodi317ef = WIDGET-HANDLE(tt-epc.val-parameter).

           

        IF VALID-HANDLE(hbodi317ef) THEN DO:
            RUN GetRowerrors IN hbodi317ef (OUTPUT table RowErrorsAux).
            IF CAN-FIND(FIRST rowErrorsAux) THEN DO:
                RUN emptyRowErrorsBodi317ef IN hbodi317ef. 
        
                for each RowErrorsAux
                     WHERE RowErrorsAux.errornumber <> 0
                       AND RowErrorsAux.ERRORtype   <> "Internal"
                       AND RowErrorsAux.errornumber <> 28642:
                    
                    
    
                    RUN _insertErrorManual IN hbodi317ef (INPUT RowErrorsAux.errornumber,
                                                          INPUT RowErrorsAux.ERRORtype,
                                                          INPUT RowErrorsAux.ERRORsubtype,
                                                          INPUT RowErrorsAux.errordescription,
                                                          INPUT RowErrorsAux.errorhelp,
                                                          INPUT "":U).
                end.
            END.
        END.
    END.
END.

IF p-ind-event = "beforeEfetivaNota":U THEN DO TRANSACTION ON ERROR UNDO, RETURN "NOK":U:
    /*log-manager:write-message('BODI317EF-UPC beforeEfetivaNota ').*/

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.

    IF AVAILABLE tt-epc THEN
        ASSIGN hbodi317ef = WIDGET-HANDLE(tt-epc.val-parameter).

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.

    IF AVAILABLE tt-epc THEN
        FIND FIRST wt-docto
            WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

    IF AVAILABLE wt-docto THEN DO:
        RUN GetRowerrors IN hbodi317ef (OUTPUT TABLE RowErrorsAux).

        IF CAN-FIND(FIRST rowErrorsAux) THEN DO:
            RUN setInterrompeCalculo IN hbodi317ef (INPUT NO).

            RUN emptyRowErrorsBodi317ef IN hbodi317ef.

            FOR EACH RowErrorsAux
                WHERE RowErrorsAux.errornumber <> 0
                  AND RowErrorsAux.ERRORtype   <> "Internal":U:
                RUN _insertErrorManual IN hbodi317ef (INPUT RowErrorsAux.errornumber,
                                                      INPUT RowErrorsAux.ERRORtype,
                                                      INPUT RowErrorsAux.ERRORsubtype,
                                                      INPUT RowErrorsAux.errordescription,
                                                      INPUT RowErrorsAux.errorhelp,
                                                      INPUT "":U).
            END. /* FOR EACH RowErrorsAux
                        WHERE RowErrorsAux.errornumber <> 0
                          AND RowErrorsAux.ERRORtype   <> "Internal":U: */
        END. /* IF CAN-FIND(FIRST rowErrorsAux) THEN DO: */

        IF AVAIL wt-docto THEN DO:

            IF c-volume-ft4003 <> "" THEN
                ASSIGN wt-docto.nr-volume = c-volume-ft4003
                       c-volume-ft4003    = "". //tratar qndo vem do ft4003 e limpa a variavel

            FOR FIRST ped-venda no-lock
                WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                AND   ped-venda.nr-pedcli  = wt-docto.nr-pedcli,
                FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                  AND int-ped-venda.cod-estabel = ped-venda.cod-estabel:

                IF int-ped-venda.ValorFrete <> 0 THEN DO:
                    ASSIGN wt-docto.vl-frete-inf = int-ped-venda.ValorFrete.
                END.
                ELSE DO:
                    
                    IF int-ped-venda.vl-frete <> 0 THEN DO:
                       ASSIGN wt-docto.vl-frete-inf = int-ped-venda.vl-frete.
    
                   /*     ASSIGN d-aliq-ipi   = 0
                               d-totalItens = 0.
                        FOR EACH wt-it-docto NO-LOCK
                           WHERE wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                             AND wt-it-docto.calcula:
                            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
                            IF AVAIL ITEM AND ITEM.aliquota-ipi > 0 THEN
                                ASSIGN d-aliq-ipi = d-aliq-ipi + int-ped-venda.vl-frete * wt-it-docto.vl-preori * wt-it-docto.quantidade[1] * ITEM.aliquota-ipi.
                            ASSIGN d-totalItens = d-totalItens + (wt-it-docto.vl-preori * wt-it-docto.quantidade[1]).
                        END.
                        ASSIGN d-aliq-ipi = d-aliq-ipi / 100 / int-ped-venda.vl-frete / d-totalItens.
    
                        IF d-aliq-ipi = ? THEN
                            ASSIGN d-aliq-ipi = 0.                        

                        IF ped-venda.estado <> "EX" THEN
                           
                            ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete / (1 + d-aliq-ipi),2).
                        ELSE
                            ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete,2). */
    
                    END. 
                END.
            END.
        END.    
        
        FIND FIRST emitente
            WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.

        /* Tratativa declaraá∆o c¢pia */
        IF  wt-docto.cod-estabel = "105" THEN DO:
            FIND FIRST int-emitente-trib NO-LOCK
                WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
            IF  AVAIL  int-emitente-trib THEN DO:
                IF int-emitente-trib.ind-tipo-declaracao = 2 THEN DO:

                    IF TODAY > int-emitente-trib.dt-copia-declaracao + 30 THEN DO:
                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                        RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                               INPUT "EMS",
                                                               INPUT "ERROR", 
                                                               INPUT "Declaraá∆o ZFM original n∆o entregue!. Por favor, entrar em contato com o grupo tribut†rio.",
                                                               INPUT "Declaraá∆o ZFM original n∆o entregue!. Por favor, entrar em contato com o grupo tribut†rio.",
                                                               INPUT "Declaraá∆o ZFM original n∆o entregue!. Por favor, entrar em contato com o grupo tribut†rio.":U). 
                        RETURN "NOK".
                    END. /* IF TODAY > int-emitente-trib.dt-copia-declaracao + 30 THEN DO: */

                END. /* IF int-emitente-trib.ind-tipo-declaracao = 2 THEN DO: */
            END.
        END.

        /*
        /*----------------------------------------------------------------------------------------------*/
        /*                     TRATAMENTO PARA IMPEDIR FATURAR UM MESMO ITEM DE 2                       */
        /*                     DEP‡SITOS DIFERENTES NA NOTA.                                            */
        /*----------------------------------------------------------------------------------------------*/
        FOR EACH wt-fat-ser-lote NO-LOCK
            WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto:
    
            FIND FIRST b-wt-fat-ser-lote 
                WHERE b-wt-fat-ser-lote.seq-wt-docto    = wt-fat-ser-lote.seq-wt-docto
                  AND b-wt-fat-ser-lote.it-codigo       = wt-fat-ser-lote.it-codigo
                  AND b-wt-fat-ser-lote.cod-depos       <> wt-fat-ser-lote.cod-depos
                  AND b-wt-fat-ser-lote.seq-wt-it-docto <> wt-fat-ser-lote.seq-wt-it-docto NO-LOCK NO-ERROR.
    
            IF  AVAIL b-wt-fat-ser-lote THEN DO:
                RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
    
                ASSIGN c-msg = "O Item " + wt-fat-ser-lote.it-codigo + ", Seq de baixa " + String(wt-fat-ser-lote.seq-wt-it-docto)   + ", Dep¢sito " +  wt-fat-ser-lote.cod-depos  + ", Qtde " + string(wt-fat-ser-lote.quantidade[1]  ) +
                                                ", est† em conflito com a Seq de Baixa " + string(b-wt-fat-ser-lote.seq-wt-it-docto) + ", Dep¢sito " + b-wt-fat-ser-lote.cod-depos + ", Qtde " + string(b-wt-fat-ser-lote.quantidade[1]).
    
    
                RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                       INPUT "EMS",
                                                       INPUT "ERROR", 
                                                       INPUT "Alocaá∆o de um mesmo item da nota de dep¢sitos diferentes.",
                                                       INPUT c-msg,
                                                       INPUT c-msg). 
                RETURN "NOK".
    
            END.
    
        END.
        /******************************************************************************************************/
        */
        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli NO-LOCK NO-ERROR.

        IF AVAILABLE emitente  AND
           AVAILABLE ped-venda THEN DO:

            FIND FIRST bf-int-ped-venda
                WHERE bf-int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.

            IF AVAILABLE bf-int-ped-venda             AND
               NOT bf-int-ped-venda.liberacao-forcada THEN DO:
                FIND FIRST natur-oper
                    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.

                /* S¢ valida os dias de atraso para os pedidos que geram duplicatas (n∆o s∆o de garantia, p¢s-venda, etc) */
                IF AVAILABLE natur-oper    AND
                   natur-oper.emite-duplic THEN DO:
                    FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                    IF AVAILABLE int-param-supcard THEN DO:
                        RUN esp/acr/esacr043.p (INPUT  SUBSTRING(emitente.cgc, 1, 8),
                                                INPUT  emitente.nome-matriz,
                                                INPUT  int-param-supcard.qtd-dias-atraso,
                                                OUTPUT i-dias-atraso-tit,
                                                OUTPUT l-tit-atrasado,
                                                OUTPUT c-lista-clientes).

                        IF l-tit-atrasado THEN DO:
                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                            RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                  INPUT "EMS":U,
                                                                  INPUT "ERROR":U,
                                                                  INPUT "O cliente possui t°tulos em atraso com a Intelbras":U,
                                                                  INPUT "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes,
                                                                  INPUT "O cliente possui t°tulos em atraso com a Intelbras~~O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).

                            RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                        INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" possui t°tulos em atraso com a Intelbras":U,
                                                        INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso. O pedido n∆o ser† faturado.":U).

                            ASSIGN l-atraso-pagto = YES.

                            RETURN "NOK":U.
                        END. /* IF l-tit-atrasado THEN DO: */
                    END. /* IF AVAILABLE int-param-supcard THEN DO: */

                    /*********************************************************************************
                    **  Prop¢sito:  Validar as notas fiscais com os limites do SupplierCard (Movido da
                    **              BO de validaá∆o para o de efetivaá∆o pela falta do calculo dos
                    **              impostos).
                    **  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
                    **  Criaá∆o:    Junho de 2012
                    **********************************************************************************/
                    /****************************************
                    **  Validaá∆o do SupplierCard - In°cio
                    *****************************************/

                    /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
                    IF NOT l-atraso-pagto THEN DO:
                        /* A validaá∆o do limite deve ser feita com base na data de emiss∆o da nota,para
                           os casos de notas do £ltimo dia de faturamento (emite dia 31 e fatura dia 1) */
                        FIND FIRST int-emitente-supcard
                            WHERE int-emitente-supcard.raiz-cnpj      = SUBSTRING(emitente.cgc, 1, 8)
                              AND int-emitente-supcard.dat-avaliacao  = wt-docto.dt-emis-nota
                              AND int-emitente-supcard.log-habilitado = YES NO-LOCK NO-ERROR.

                        IF AVAILABLE int-emitente-supcard THEN DO:
                            /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - In°cio */
                            IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO:
                                IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                                    IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                              INPUT "EMS":U,
                                                                              INPUT "ERROR":U,
                                                                              INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U,
                                                                              INPUT "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U,
                                                                              INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube~~O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U).

                                        RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                    INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" est† em atraso com o cart∆o Intelbras Clube":U,
                                                                    INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso. O pedido n∆o ser† faturado.":U).

                                        ASSIGN l-atraso-pagto = YES.

                                        RETURN "NOK":U.
                                    END. /* IF int-emitente-supcard.qtd-dias-atraso-int < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                                END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                                ELSE DO:
                                    FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                                    IF AVAILABLE int-param-supcard THEN DO:
                                        IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO:
                                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                            RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                                  INPUT "EMS":U,
                                                                                  INPUT "ERROR":U,
                                                                                  INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube":U,
                                                                                  INPUT "O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U,
                                                                                  INPUT "O cliente est† em atraso com o cart∆o Intelbras Clube~~O cliente est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso.":U).

                                            RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                        INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" est† em atraso com o cart∆o Intelbras Clube":U,
                                                                        INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" est† ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-sc)) + " dias em atraso com o cart∆o Intelbras Clube. A tolerancia Ç de ":U + TRIM(STRING(int-param-supcard.qtd-dias-atraso)) + " dias de atraso. O pedido n∆o ser† faturado.":U).

                                            ASSIGN l-atraso-pagto = YES.

                                            RETURN "NOK":U.
                                        END. /* IF int-param-supcard.qtd-dias-atraso < int-emitente-supcard.qtd-dias-atraso-sc THEN DO: */
                                    END. /* IF AVAILABLE int-param-supcard THEN DO: */
                                END. /* ELSE DO: - IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                                      int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                            END. /* IF int-emitente-supcard.qtd-dias-atraso-sc > 0 THEN DO: */
                            /* Verificando se o cliente est† em atraso com o SupplierCard e se est† dentro do tolerado pela Intelbras - Final */

                            /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - In°cio */
                            IF NOT l-atraso-pagto THEN DO:
                                IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                   int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO:
                                    RUN esp/acr/esacr043.p (INPUT  int-emitente-supcard.raiz-cnpj,
                                                            INPUT  emitente.nome-matriz,
                                                            INPUT  int-emitente-supcard.qtd-dias-atraso-int,
                                                            OUTPUT i-dias-atraso-tit,
                                                            OUTPUT l-tit-atrasado,
                                                            OUTPUT c-lista-clientes).

                                    IF l-tit-atrasado THEN DO:
                                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                              INPUT "EMS":U,
                                                                              INPUT "ERROR":U,
                                                                              INPUT "O cliente possui t°tulos em atraso com a Intelbras":U,
                                                                              INPUT "O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes,
                                                                              INPUT "O cliente possui t°tulos em atraso com a Intelbras~~O cliente possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso.":U + CHR(13) + "Cliente(s): ":U + CHR(13) + c-lista-clientes).

                                        RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                    INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" possui t°tulos em atraso com a Intelbras":U,
                                                                    INPUT "O cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" ~/pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" possui t°tulos em atraso com a Intelbras de atÇ ":U + TRIM(STRING(i-dias-atraso-tit)) + " dias. A tolerancia Ç de ":U + TRIM(STRING(int-emitente-supcard.qtd-dias-atraso-int)) + " dias de atraso. O pedido n∆o ser† faturado.":U).

                                        ASSIGN l-atraso-pagto = YES.

                                        RETURN "NOK":U.
                                    END. /* IF l-tit-atrasado THEN DO: */
                                END. /* IF int-emitente-supcard.qtd-dias-atraso-int <> 0 AND
                                           int-emitente-supcard.qtd-dias-atraso-int <> ? THEN DO: */
                            END. /* IF NOT l-atraso-pagto THEN DO: */
                            /* Verificando se o cliente est† em atraso com os t°tulos da Intelbras e se est† dentro do tolerado pela Intelbras - Final */
                        END. /* IF AVAILABLE int-emitente-supcard THEN DO: */
                    END. /* IF NOT l-atraso-pagto THEN DO: */
                    /* Validaá∆o de T°tulos em Atraso com o "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - Final */
                END. /* IF AVAILABLE natur-oper    AND
                           natur-oper.emite-duplic THEN DO: */

                /* Validaá∆o de Limites de CrÇdito caso a condiá∆o de pagamento seja "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - In°cio */
                IF NOT l-atraso-pagto THEN DO:
                    /* Verificar se na Condiá∆o de Pagamento est† marcado o "Cart∆o Intelbras Clube", se "Sim", validar o limite do SupplierCard */
                    FIND FIRST int-cond-pagto
                        WHERE int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-LOCK NO-ERROR.

                    IF AVAILABLE int-cond-pagto                       AND
                       SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                        /* A validaá∆o do limite deve ser feita com base na data de emiss∆o da nota,para
                           os casos de notas do £ltimo dia de faturamento (emite dia 31 e fatura dia 1) */
                        FIND FIRST int-emitente-supcard
                            WHERE int-emitente-supcard.raiz-cnpj      = SUBSTRING(emitente.cgc, 1, 8)
                              AND int-emitente-supcard.dat-avaliacao  = wt-docto.dt-emis-nota
                              AND int-emitente-supcard.log-habilitado = YES NO-LOCK NO-ERROR.

                        IF AVAILABLE int-emitente-supcard THEN DO:
                            /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - In°cio */
                            ASSIGN l-encontrou-cond-pagto = NO.

                            FIND FIRST int-classe-cli-supcard
                                WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-LOCK NO-ERROR.

                            IF NOT AVAILABLE int-classe-cli-supcard THEN DO:
                                RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                      INPUT "EMS":U,
                                                                      INPUT "ERROR":U,
                                                                      INPUT "N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o Cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~".":U,
                                                                      INPUT "A validaá∆o foi realizada para o Cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~".":U,
                                                                      INPUT "N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o Cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~".~~A validaá∆o foi realizada para o Cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~".":U).

                                RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                            INPUT "N∆o foi encontrado Classe de Cliente do Cart∆o Intelbras Clube para o cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~".":U,
                                                            INPUT "A validaá∆o foi realizada para o Cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~".":U).

                                RETURN "NOK":U.
                            END. /* IF NOT AVAILABLE int-classe-cli-supcard THEN DO: */
                            ELSE DO:
                                FOR LAST int-classe-cli-supcard NO-LOCK
                                    WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe
                                    BY int-classe-cli-supcard.dat-alteracao:
                                    DO i-count = 1 TO NUM-ENTRIES(int-classe-cli-supcard.cod-cond-pag, ",":U):
                                        ASSIGN v-cod-cond-pag = INTEGER(TRIM(ENTRY(i-count, int-classe-cli-supcard.cod-cond-pag, ",":U))) NO-ERROR.

                                        IF NOT ERROR-STATUS:ERROR                       AND
                                           v-cod-cond-pag = int-cond-pagto.cod-cond-pag THEN
                                            ASSIGN l-encontrou-cond-pagto = YES.
                                    END. /* DO i-count = 1 TO NUM-ENTRIES(int-classe-cli-supcard.cod-cond-pag, ",":U): */
                                END. /* FOR LAST int-classe-cli-supcard NO-LOCK
                                            WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe
                                            BY int-classe-cli-supcard.dat-alteracao: */

                                IF NOT l-encontrou-cond-pagto THEN DO:
                                    FIND FIRST int-classe-cli-supcard
                                        WHERE int-classe-cli-supcard.cod-classe = int-emitente-supcard.cod-classe NO-LOCK NO-ERROR.

                                    RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                    RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                          INPUT "EMS":U,
                                                                          INPUT "ERROR":U,
                                                                          INPUT "N∆o foi encontrado a Condiá∆o de Pagamento da Nota Fiscal na Classe de Cliente Intelbras Clube.":U,
                                                                          INPUT "O Cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~", utiliza a Condiá∆o de Pagamento ~"":U + TRIM(STRING(int-cond-pagto.cod-cond-pag, ">>>9":U)) + "~", que n∆o est† parametrizada na Classe de Cliente ~"":U + TRIM(int-classe-cli-supcard.des-classe) + "~" do Cart∆o Intelbras Clube.":U,
                                                                          INPUT "N∆o foi encontrado a Condiá∆o de Pagamento da Nota Fiscal na Classe de Cliente Intelbras Clube.~~O Cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~", utiliza a Condiá∆o de Pagamento ~"":U + TRIM(STRING(int-cond-pagto.cod-cond-pag, ">>>9":U)) + "~", que n∆o est† parametrizada na Classe de Cliente ~"":U + TRIM(int-classe-cli-supcard.des-classe) + "~" do Cart∆o Intelbras Clube.":U).

                                    RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                INPUT "N∆o foi encontrado a Condiá∆o de Pagamento da Nota Fiscal na Classe de Cliente Intelbras Clube.":U,
                                                                INPUT "O Cliente ~"":U + TRIM(wt-docto.nome-abrev) + "~", Pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~", utiliza a Condiá∆o de Pagamento ~"":U + TRIM(STRING(int-cond-pagto.cod-cond-pag, ">>>9":U)) + "~", que n∆o est† parametrizada na Classe de Cliente ~"":U + TRIM(int-classe-cli-supcard.des-classe) + "~" do Cart∆o Intelbras Clube.":U).

                                    RETURN "NOK":U.
                                END. /* ELSE DO: - IF NOT AVAILABLE int-classe-cli-supcard THEN DO: */
                            END. /* IF NOT l-encontrou-cond-pagto THEN DO: */
                            /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Condiá∆o de Pagamento da Classe de Cliente SupplierCard - Final */

                            /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */
                            ASSIGN l-natur-oper-servico = YES.

                            IF l-encontrou-cond-pagto THEN DO:
                                FIND FIRST natur-oper
                                    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.

                                IF NOT AVAILABLE natur-oper THEN DO:
                                    RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                    RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                          INPUT "EMS":U,
                                                                          INPUT "ERROR":U,
                                                                          INPUT "N∆o encontrado(a) Natureza de Operaá∆o para chave informada.":U,
                                                                          INPUT "A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " n∆o foi encotrado.":U,
                                                                          INPUT "N∆o encontrado(a) Natureza de Operaá∆o para chave informada.~~A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " n∆o foi encotrado.":U).

                                    RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                INPUT "N∆o encontrado(a) Natureza de Operaá∆o para chave informada.":U,
                                                                INPUT "A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " n∆o foi encotrado.":U).

                                    RETURN "NOK":U.
                                END. /* IF NOT AVAILABLE natur-oper THEN DO: */
                                ELSE IF natur-oper.tipo = 3 THEN DO:
                                    RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                    RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                          INPUT "EMS":U,
                                                                          INPUT "ERROR":U,
                                                                          INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo.":U,
                                                                          INPUT "A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagemento do Cart∆o Intelbras Clube.":U,
                                                                          INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo.~~A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagemento do Cart∆o Intelbras Clube.":U).

                                    RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo.":U,
                                                                INPUT "A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagemento do Cart∆o Intelbras Clube.":U).

                                    RETURN "NOK":U.
                                END. /* ELSE IF natur-oper.tipo = 3 THEN DO: */
                                ELSE
                                    ASSIGN l-natur-oper-servico = NO.
                            END. /* IF l-encontrou-cond-pagto THEN DO: */
                            /* Fabiano Sakae Ribeiro (Exponencial TI) - Janeiro/2013 - Validaá∆o da Natureza de Operaá∆o de Serviáo do Pedido SupplierCard - In°cio */

                            /* Caso n∆o tenha atraso de pagamento n∆o tolerado */
                            IF l-encontrou-cond-pagto   AND
                               NOT l-natur-oper-servico THEN DO:
                                IF NOT VALID-HANDLE(h-esapi001) THEN
                                    RUN esp/esapi001.p PERSISTENT SET h-esapi001.

                                RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  int-emitente-supcard.raiz-cnpj,
                                                                      OUTPUT de-vl-lim-tot-supcard,
                                                                      OUTPUT de-limite-supcard,
                                                                      OUTPUT de-ped-aloc-supcard,
                                                                      OUTPUT de-lim-nfs-supcard,
                                                                      OUTPUT de-lim-disp-supcard).

                                IF VALID-HANDLE(h-esapi001) THEN
                                    DELETE PROCEDURE h-esapi001.
                                /* Acumulando os valores totais dos itens (pedidos e notas fiscais) para validar contra o limite do SupplierCard */
                                ASSIGN de-vl-tot-nota-supcard = 0.

                                FOR EACH wt-it-docto OF wt-docto NO-LOCK:
                                    ASSIGN de-vl-tot-nota-supcard = de-vl-tot-nota-supcard + wt-it-docto.vl-tot-item.
                                END. /* FOR EACH wt-it-docto OF wt-docto NO-LOCK: */

                                /* Valida se o limite Ç inferior ao valor da nota fiscal */
                                IF ROUND(de-limite-supcard - de-lim-nfs-supcard, 2) < ROUND(de-vl-tot-nota-supcard, 2) THEN DO:
                                    RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                    RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                          INPUT "EMS":U,
                                                                          INPUT "ERROR":U,
                                                                          INPUT "O valor da nota fiscal ultrapassou o limite do cart∆o Intelbras Clube":U,
                                                                          INPUT "O valor da nota fiscal (R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + ") do cliente ~"":U + emitente.nome-abrev + "~" ultrapassou o limite de R$ ":U + TRIM(STRING(ROUND(de-limite-supcard - de-lim-nfs-supcard, 2), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube.":U,
                                                                          INPUT "O valor da nota fiscal ultrapassou o limite do cart∆o Intelbras Clube~~O valor da nota fiscal (R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + ") do cliente ~"":U + emitente.nome-abrev + "~" ultrapassou o limite de R$ ":U + TRIM(STRING(ROUND(de-limite-supcard - de-lim-nfs-supcard, 2), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube.":U).

                                    RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                INPUT "O valor do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" do cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~"  ultrapassou o limite do cart∆o Intelbras Clube":U,
                                                                INPUT "O valor do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" (R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + ") do cliente ~"":U + emitente.nome-abrev + "~" ultrapassou o limite de R$ ":U + TRIM(STRING(ROUND(de-limite-supcard - de-lim-nfs-supcard, 2), "->>>,>>>,>>9.99":U)) + " do cart∆o Intelbras Clube.":U).

                                    RETURN "NOK":U.
                                END. /* IF ROUND(de-limite-supcard - de-lim-nfs-supcard, 2) < ROUND(de-vl-tot-nota-supcard, 2) THEN DO: */
                                ELSE DO:
                                    FIND LAST int-param-supcard NO-LOCK NO-ERROR.

                                    FIND FIRST cond-pagto
                                        WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.

                                    IF ROUND(de-vl-tot-nota-supcard, 2) < ROUND(int-param-supcard.val-min-trans, 2) THEN DO:

                                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                              INPUT "EMS":U,
                                                                              INPUT "ERROR":U,
                                                                              INPUT "Valor da compra no cart∆o Intelbras Clube menor que valor m°nimo permitido na transaá∆o.":U,
                                                                              INPUT "O valor da compra de R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + " , do cliente ":U + emitente.nome-abrev + " Ç menor do que o valor m°nimo permitido na transaá∆o do cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-trans, 2), "->>>,>>>,>>9.99":U)) + ").":U,
                                                                              INPUT "Valor da compra no cart∆o Intelbras Clube menor que valor m°nimo permitido na transaá∆o.~~O valor da parcela de R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + " , do cliente ":U + emitente.nome-abrev + " Ç menor do que o valor m°nimo permitido na transaá∆o do cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-trans, 2), "->>>,>>>,>>9.99":U)) + ").":U).

                                        RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                    INPUT "O valor do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" do cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~"  menor do que o m°nimo permitido na transaá∆o do cart∆o Intelbras Clube":U,
                                                                    INPUT "O valor do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" (R$ ":U + TRIM(STRING(ROUND(de-vl-tot-nota-supcard, 2), "->>>,>>>,>>9.99":U)) + ") do cliente ~"":U + emitente.nome-abrev + "~" Ç menor do que o valor m°nimo permitido na transaá∆o do cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-trans, 2), "->>>,>>>,>>9.99":U)) + ").":U).

                                        RETURN "NOK":U.
                                    END. /* IF ROUND(de-vl-tot-nota-supcard, 2) < ROUND(int-param-supcard.val-min-trans, 2) THEN DO: */
                                    ELSE IF ROUND((de-vl-tot-nota-supcard / cond-pagto.num-parcelas), 2) < ROUND(int-param-supcard.val-min-parc, 2) THEN DO:
                                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                              INPUT "EMS":U,
                                                                              INPUT "ERROR":U,
                                                                              INPUT "Valor da parcela do cart∆o Intelbras Clube menor que valor m°nimo permitido.":U,
                                                                              INPUT "O valor da parcela de R$ ":U + TRIM(STRING(ROUND((de-vl-tot-nota-supcard / cond-pagto.num-parcelas), 2), "->>>,>>>,>>9.99":U)) + " , do cliente ":U + emitente.nome-abrev + " Ç menor do que o valor m°nimo permitido no cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-parc, 2), "->>>,>>>,>>9.99":U)) + ").":U,
                                                                              INPUT "Valor da parcela do cart∆o Intelbras Clube menor que valor m°nimo permitido.~~O valor da parcela de R$ ":U + TRIM(STRING(ROUND((de-vl-tot-nota-supcard / cond-pagto.num-parcelas), 2), "->>>,>>>,>>9.99":U)) + " , do cliente ":U + emitente.nome-abrev + " Ç menor do que o valor m°nimo permitido no cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-parc, 2), "->>>,>>>,>>9.99":U)) + ").":U).
    
                                        RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                                    INPUT "O valor da parcela do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" do cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~"  menor do que o m°nimo permitido no cart∆o Intelbras Clube":U,
                                                                    INPUT "O valor da parcela do pedido ~"":U + TRIM(ped-venda.nr-pedcli) + "~" (R$ ":U + TRIM(STRING(ROUND((de-vl-tot-nota-supcard / cond-pagto.num-parcelas), 2), "->>>,>>>,>>9.99":U)) + ") do cliente ~"":U + emitente.nome-abrev + "~" Ç menor do que o valor m°nimo permitido no cart∆o Intelbras Clube (R$ ":U + TRIM(STRING(ROUND(int-param-supcard.val-min-parc, 2), "->>>,>>>,>>9.99":U)) + ").":U).
    
                                        RETURN "NOK":U.
                                    END. /* IF ROUND((de-vl-tot-nota-supcard / cond-pagto.num-parcelas), 2) < ROUND(int-param-supcard.val-min-parc, 2) THEN DO: */
                                END. /* ELSE DO: - IF ROUND(de-limite-supcard - de-lim-nfs-supcard, 2) < ROUND(de-vl-tot-nota-supcard, 2) THEN DO: */
                            END. /* IF l-encontrou-cond-pagto   AND
                                       NOT l-natur-oper-servico THEN DO: */
                        END. /* IF AVAILABLE int-emitente-supcard THEN DO: */
                        ELSE DO:
                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
    
    
                            RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                  INPUT "EMS":U,
                                                                  INPUT "ERROR":U,
                                                                  INPUT "Limite do cart∆o Intelbras Clube indispon°vel":U,
                                                                  INPUT "N∆o foi possivel faturar o pedido ":U + TRIM(ped-venda.nr-pedcli) + " pois o limite do cliente est† indisponivel na data de emiss∆o (":U + STRING(wt-docto.dt-emis-nota, "99/99/9999":U) + ") para o cliente ":U + TRIM(ped-venda.nome-abrev) + ". Favor aguardar que esta informaá∆o entre no sistema ou entre em contato com a †rea de Inform†tica.":U,
                                                                  INPUT "Limite do cart∆o Intelbras Clube indispon°vel~~N∆o foi possivel faturar o pedido ":U + TRIM(ped-venda.nr-pedcli) + " pois o limite do cliente est† indisponivel na data de emiss∆o (":U + STRING(wt-docto.dt-emis-nota, "99/99/9999":U) + ") para o cliente ":U + TRIM(ped-venda.nome-abrev) + ". Favor aguardar que esta informaá∆o entre no sistema ou entre em contato com a †rea de Inform†tica.":U).
    
                            RUN pi-envia-email-supcard (INPUT ped-venda.user-alte,
                                                        INPUT "Limite do cart∆o Intelbras Clube do cliente ~"":U + TRIM(ped-venda.nome-abrev) + "~" indispon°vel.":U,
                                                        INPUT "N∆o foi possivel faturar o pedido ":U + TRIM(ped-venda.nr-pedcli) + " pois o limite do cliente est† indisponivel na data de emiss∆o (":U + STRING(wt-docto.dt-emis-nota, "99/99/9999":U) + ") para o cliente ":U + TRIM(ped-venda.nome-abrev) + ". Favor aguardar que esta informaá∆o entre no sistema ou entre em contato com a †rea de Inform†tica.":U).
    
                            RETURN "NOK":U.
                        END. /* ELSE DO: - IF AVAILABLE int-emitente-supcard THEN DO: */
                    END. /* IF AVAILABLE int-cond-pagto                       AND
                               SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */
                END. /* IF NOT l-atraso-pagto THEN DO: */
                /* Validaá∆o de Limites de CrÇdito caso a condiá∆o de pagamento seja "Cart∆o Intelbras Clube" (SupplierCard) - Fabiano Sakae Ribeiro (Exponencial TI) - Final */

                /****************************************
                **  Validaá∆o do SupplierCard - Final
                *****************************************/
            END. /* IF AVAILABLE bf-int-ped-venda             AND
                       NOT bf-int-ped-venda.liberacao-forcada THEN DO: */
        END. /* IF AVAILABLE emitente  AND
                   AVAILABLE ped-venda THEN DO: */
    END. /* IF AVAILABLE wt-docto THEN DO: */

    /* Rotina utilizada para validar o cart∆o Intelbras */

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = "table-rowid":
        FIND wt-docto NO-LOCK 
             WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF AVAIL wt-docto THEN 
           IF l-ativa-log THEN
               PUT "wt-docto.nr-pedcli " wt-docto.nr-pedcli SKIP.
    END.

    
    FIND int-cond-pagto
         WHERE int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag
         NO-LOCK no-error.

    IF AVAIL int-cond-pagto AND
       int-cond-pagto.transacao-com-cartao = YES AND
       int-cond-pagto.tipo-trans-cartao    = 1 THEN DO:
    
        find tt-epc
             where tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "object-handle"
               NO-LOCK NO-ERROR.
        IF  AVAIL tt-epc  AND
            AVAIL wt-docto THEN DO:

            FIND ped-venda
                 WHERE ped-venda.nr-pedcli = wt-docto.nr-pedcli
                   AND ped-venda.nome-abrev = wt-docto.nome-abrev
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL ped-venda  THEN DO:
            
            
                ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).  
        
                RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                  
                RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                       INPUT "EMS",
                                                       INPUT "ERROR", 
                                                       INPUT "Faturamento com condicao de cartao de credito, n∆o encontrou pedido",
                                                       INPUT "Faturamento com condicao de cartao de credito, n∆o encontrou pedido",
                                                       INPUT "":U). 
                RETURN "NOK".
            END.

            FIND int-ped-venda
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                   AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
                 NO-LOCK NO-ERROR.
                 
            IF NOT AVAIL int-ped-venda  THEN DO:
                ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).  

                RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                       INPUT "EMS",
                                                       INPUT "ERROR", 
                                                       INPUT "Faturamento com condicao de cartao de credito, n∆o encontrou pedido (int-ped-venda)",
                                                       INPUT "Faturamento com condicao de cartao de credito, n∆o encontrou pedido (int-ped-venda)",
                                                       INPUT "":U). 
                RETURN "NOK".
            END.
    
            FIND cond-pagto
                 WHERE cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag
                 NO-LOCK NO-ERROR.
            IF int-ped-venda.nr-parcelas <= 1 THEN
               ASSIGN c-tipo-transacao = "04".
            ELSE
               ASSIGN c-tipo-transacao = "06".

            FIND FIRST emitente-cartao-cred
                 WHERE emitente-cartao-cred.cod-emitente = wt-docto.cod-emitente
                   AND emitente-cartao-cred.sequencia    = int-ped-venda.seq-cartao-cred
                 NO-LOCK NO-ERROR.
            IF AVAIL emitente-cartao-cred THEN DO:
                EMPTY TEMP-TABLE tt-prog-ponto.

                RUN esp/es0018p.p (INPUT  "ambiente":U,
                                   INPUT  1,
                                   INPUT  0,
                                   INPUT  "":U,
                                   OUTPUT TABLE tt-prog-ponto).

                FIND FIRST tt-prog-ponto NO-ERROR.

                IF  NOT AVAILABLE tt-prog-ponto    OR
                   (AVAILABLE tt-prog-ponto        AND
                    tt-prog-ponto.conteudo <> "PRODUCAO":U) THEN
                    MESSAGE "BANCO TESTE - Calculo com Cartao Intelbras nao sera efetivado"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ELSE DO:
                    RUN conecta-rpc IN THIS-PROCEDURE (output hproc).

                    IF RETURN-VALUE = "NOK" THEN DO:
                        ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).

                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                        RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                               INPUT "EMS",
                                                               INPUT "ERROR",
                                                               INPUT "Erro na conex∆o com o servidor RPC",
                                                               INPUT "Erro na conex∆o com o servidor RPC",
                                                               INPUT "":U).
                    END.
                    ELSE DO:
                        RUN esbo/boes150b.p PERSISTENT SET hprog ON SERVER hproc.

                        RUN esapi/esapi014.p PERSISTENT SET h-esapi014.

                        run decryptText in h-esapi014 (emitente-cartao-cred.nro-cartao, output pcNroCartao).

                        DELETE PROCEDURE h-esapi014.

                        ASSIGN de-vl-tot-nota = 0.

                        FOR EACH wt-it-docto NO-LOCK
                            WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
                            ASSIGN de-vl-tot-nota = de-vl-tot-nota + wt-it-docto.vl-tot-item.
                        END.

                        RUN ValidaCartaoIntelbras IN hprog (INPUT wt-docto.seq-wt-docto,
                                                            INPUT de-vl-tot-nota,
                                                            INPUT c-tipo-transacao,                                                                /* tipo-transacao     */
                                                            INPUT IF c-tipo-transacao = "04":U THEN "00":U ELSE STRING(int-ped-venda.nr-parcelas), /* c-parcelas         */
                                                            INPUT "25767470":U,                                                                    /* c-filiacao         */
                                                            INPUT "1":U,                                                                           /* c-pedido           */
                                                            INPUT pcNroCartao,                                                                     /* c-cartao           */
                                                            INPUT string(emitente-cartao-cred.cod-seguranca),                                      /* c-codigo-seguranca */
                                                            INPUT emitente-cartao-cred.mes-validade,                                               /* c-mes-validade     */
                                                            INPUT emitente-cartao-cred.ano-validade,                                               /* c-ano-validade     */
                                                            INPUT emitente-cartao-cred.nome-pessoa,                                                /* c-nome-portador    */
                                                            INPUT "":U,                                                                            /* c-iata             */
                                                            INPUT "":U,                                                                            /* c-distribuidor     */
                                                            INPUT "":U,                                                                            /* c-concentrador     */
                                                            INPUT "":U,                                                                            /* c-taxa-embarque    */
                                                            INPUT "":U,                                                                            /* c-entrada          */
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "":U,
                                                            INPUT "S":U,
                                                            OUTPUT c-retorno,  
                                                            OUTPUT c-mensagem).

                        IF ERROR-STATUS:ERROR THEN DO:
                            ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).

                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

                            RUN _insertErrorManual IN hBODI317ef (INPUT 0,
                                                                  INPUT "EMS":U,
                                                                  INPUT "ERROR":U,
                                                                  INPUT "Ocorreu erro na conecá∆o RPC":U,
                                                                  INPUT "Ocorreu erro na conecá∆o RPC":U,
                                                                  INPUT "":U).

                            RUN pi-envia-e-mail-cartao.

                            RETURN "NOK":U.
                        END.

                        RUN desconecta-rpc IN THIS-PROCEDURE (input hproc).

                        IF c-retorno <> "00":U THEN DO:
                            ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).
                    
                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                              
                            RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR", 
                                                                   INPUT c-retorno + " - " + c-mensagem,
                                                                   INPUT c-retorno + " - " + c-mensagem,
                                                                   INPUT "":U). 
                            RUN pi-envia-e-mail-cartao .

                            RETURN "NOK".
                        END.
                    END. 
               END.
           END.
           ELSE DO:
               ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).  

               RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

               RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                      INPUT "EMS",
                                                      INPUT "ERROR", 
                                                      INPUT "Emitente do Cartao de Credito nao encontrado " + STRING(wt-docto.cod-emitente),
                                                      INPUT "Emitente do Cartao de Credito nao encontrado " + STRING(wt-docto.cod-emitente),
                                                      INPUT "":U). 
               RETURN "NOK".
           END.
        END.
    END.
    /* Fim Rotina utilizada para validar o cart∆o Intelbras */
    
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
           AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli NO-ERROR.

    IF AVAIL ped-venda THEN DO:

        FIND FIRST int-ped-venda
             WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
             AND   int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

        FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
    
        IF NOT AVAIL int-ped-venda2 THEN DO:
            CREATE int-ped-venda2.
            ASSIGN int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   int-ped-venda2.cod-estabel = ped-venda.cod-estabel.
        END.
    
        ASSIGN de-vl-tot-nota-deps = 0.

        FOR EACH wt-it-docto OF wt-docto NO-LOCK:
            ASSIGN de-vl-tot-nota-deps = de-vl-tot-nota-deps + wt-it-docto.vl-tot-item.
        END.

        ASSIGN int-ped-venda2.dec-2 = de-vl-tot-nota-deps.

        /*Integraá∆o Faturamento DEPS*/
        CREATE tt-pedido-integra.
        ASSIGN tt-pedido-integra.r-rowid = ROWID(ped-venda)
               tt-pedido-integra.i-origem-inegr = 2.
        
        RAW-TRANSFER tt-pedido-integra TO raw-param.
        
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = wt-docto.cod-emitente NO-ERROR.

        IF  AVAIL int-emitente THEN DO:
            ASSIGN v_log_nat_deps = YES.
                           
            IF   ped-venda.cod-cond-pag = 0
            AND (ped-venda.tp-pedido    = "94" 
            OR   ped-venda.tp-pedido    = "97") THEN /* pedidos do assist devem ser ignorados */
                ASSIGN v_log_nat_deps = NO.
            ELSE DO:
                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "dps-nat-oper", /* Nome do programa */
                                   INPUT 1,             /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(ped-venda.nat-operacao)) THEN
                    ASSIGN v_log_nat_deps = NO.
            END.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "dps-canal-vd",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
                IF  v_log_nat_deps = yes /* garantia */ THEN DO:
                    FIND FIRST int-ped-venda2 NO-LOCK
                         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        
                    IF  AVAIL int-ped-venda2 THEN DO:
        
                        FIND FIRST ped-antecip NO-LOCK
                             WHERE ped-antecip.nr-pedido = ped-venda.nr-pedido NO-ERROR.

                        ASSIGN v_val_entrada = IF AVAIL ped-antecip THEN ped-antecip.vl-antecip[1] ELSE 0.
                       
                        RUN esp/es0018p.p (INPUT "dps-dt-negoc", /* Nome do programa  */
                                           INPUT 1,             /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                        FIND FIRST tt-prog-ponto 
                            WHERE entry(1,tt-prog-ponto.conteudo,";") = STRING(month(today)) NO-LOCK NO-ERROR.

                        IF  AVAIL tt-prog-ponto THEN
                            ASSIGN v_dt_negoc = date((entry(2,tt-prog-ponto.conteudo,";"))).
                        ELSE
                            ASSIGN v_dt_negoc = today.

                        RUN esp/es0018p.p (INPUT "dps-dias-neg", /* Nome do programa  */
                                           INPUT 1,             /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                        FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

                        IF  AVAIL tt-prog-ponto THEN
                            ASSIGN v_dias_negoc = int(tt-prog-ponto.conteudo).
                        ELSE
                            ASSIGN v_dias_negoc = 0.

                        RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                                           INPUT 1,             /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                        FIND FIRST tt-prog-ponto
                            WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.

                        ASSIGN v_log_envio = NO.

                        IF   ped-venda.cod-sit-aval          <> 3 /* nao estiver aprovado */
                        AND (AVAIL tt-prog-ponto
                        OR   ped-venda.cod-cond-pag           = 0
                        OR  (int-ped-venda.dt-negociacao     <> ?
                        AND  int-ped-venda.dt-negociacao      > v_dt_negoc
                        AND  int-ped-venda.dt-negociacao      > TODAY)
                        OR  (int-ped-venda.dias-negociacao    > 0
                        AND  int-ped-venda.dias-negociacao    > v_dias_negoc)
                        OR   v_val_entrada                    > 0) THEN DO:
                            ASSIGN v_log_envio = YES.

                            RUN esp/trgw/wdi154a.p (INPUT raw-param,
                                                    INPUT 'msg0310',
                                                    OUTPUT TABLE resultado).

                            IF  v_desc_bloq = "" THEN DO:
                                IF  AVAIL tt-prog-ponto THEN
                                    ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")) + " - Saldo: " + string(v_val_dec_1)
                                           v_resultado = v_desc_bloq.
                                ELSE DO:
                                    IF   ped-venda.cod-cond-pag           = 0
                                    OR  (int-ped-venda.dt-negociacao     <> ?
                                    AND  int-ped-venda.dt-negociacao      > v_dt_negoc
                                    AND  int-ped-venda.dt-negociacao      > TODAY)
                                    OR  (int-ped-venda.dias-negociacao    > 0
                                    AND  int-ped-venda.dias-negociacao    > v_dias_negoc)
                                    OR   v_val_entrada                    > 0 THEN
                                         ASSIGN v_desc_bloq  = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: REES - Saldo: " + string(v_val_dec_1)
                                                v_resultado  = v_desc_bloq
                                                v_status_ped = "REES".
                                    ELSE
                                         ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: REAV - Saldo: " + string(v_val_dec_1)
                                                v_resultado = v_desc_bloq.
                                END.
                            END.
                            ELSE
                                ASSIGN v_desc_bloq = v_desc_bloq + " - Saldo: " + string(v_val_dec_1)
                                       v_resultado = v_desc_bloq.

                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                            RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                  INPUT "EMS",
                                                                  INPUT "ERROR",
                                                                  INPUT v_desc_bloq,
                                                                  INPUT v_resultado,
                                                                  INPUT "").

                            RETURN "NOK":U.
                        END.
                        ELSE
                            ASSIGN v_cod_categ = int-ped-venda2.char-3.

                        ASSIGN v_val_margem_aprov = int-ped-venda2.dec-1 + 1. /* andrey C2007-0373 */

                        IF  (int-ped-venda2.dec-1    = 0
                        AND  ped-venda.cod-sit-aval <> 3)
                        OR  (int-ped-venda2.dec-1    > 0
                        AND  ped-venda.cod-sit-aval  = 3 /* aprovado */
                        AND  int-ped-venda2.dec-2    > v_val_margem_aprov) /* andrey C2007-0373 */
                        OR   ped-venda.cod-sit-aval  = 4 /* nao aprovado  */ 
                        OR   ped-venda.cod-sit-aval  = 1 /* nao avaliado  */  THEN DO:

                            IF  v_log_envio = NO THEN DO:
                                RUN esp/trgw/wdi154a.p (INPUT raw-param,
                                                        INPUT 'msg0310',
                                                        OUTPUT TABLE resultado).
                            
                                IF  RETURN-VALUE <> "OK" THEN DO:
                                    RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                                                       INPUT 1,             /* Ponto do programa */
                                                       INPUT 0,
                                                       INPUT "",
                                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
            
                                    IF  v_desc_bloq = "" THEN DO:
                                        FIND FIRST tt-prog-ponto
                                            WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.
    
                                        IF  AVAIL tt-prog-ponto THEN
                                            ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")) + " - Saldo: " + string(v_val_dec_1)
                                                   v_resultado = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")) + " - Saldo: " + string(v_val_dec_1).
                                        ELSE DO:
                                            IF   ped-venda.cod-cond-pag           = 0
                                            OR  (int-ped-venda.dt-negociacao     <> ?
                                            AND  int-ped-venda.dt-negociacao      > v_dt_negoc
                                            AND  int-ped-venda.dt-negociacao      > TODAY)
                                            OR  (int-ped-venda.dias-negociacao    > 0
                                            AND  int-ped-venda.dias-negociacao    > v_dias_negoc)
                                            OR   v_val_entrada                    > 0 THEN
                                                 ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: REES - Saldo: " + string(v_val_dec_1)
                                                        v_resultado = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: REES - Saldo: " + string(v_val_dec_1).
                                            ELSE DO:
                                                FIND FIRST resultado NO-ERROR.
    
                                                IF  AVAIL resultado THEN
                                                    ASSIGN v_desc_bloq = resultado.mensagem
                                                           v_resultado = resultado.mensagem.
                                            END.
                                        END.
                                    END.
                                    ELSE
                                        ASSIGN v_desc_bloq = v_desc_bloq + " - Saldo: " + string(v_val_dec_1).
                                               v_resultado = v_desc_bloq.

                                    ASSIGN r-int-ped-venda2 = RECID(int-ped-venda2).
                                      
                                    RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                                    RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                          INPUT "EMS",
                                                                          INPUT "ERROR",
                                                                          INPUT v_desc_bloq,
                                                                          INPUT v_resultado /*resultado.mensagem*/,
                                                                          INPUT "").
                            
                                    RETURN "NOK":U.
                                END.
                                ELSE DO:
                                    RUN esp/es0018p.p (INPUT "dps-cond-pag", /* Nome do programa  */
                                                       INPUT 1,             /* Ponto do programa */
                                                       INPUT 0,
                                                       INPUT "",
                                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
                                    FIND FIRST tt-prog-ponto
                                        WHERE entry(1,tt-prog-ponto.conteudo,";") = string(ped-venda.cod-cond-pag) NO-LOCK NO-ERROR.
    
                                    IF  AVAIL tt-prog-ponto
                                    OR  ped-venda.cod-cond-pag           = 0
                                    OR (int-ped-venda.dt-negociacao     <> ?
                                    AND int-ped-venda.dt-negociacao      > v_dt_negoc
                                    AND int-ped-venda.dt-negociacao      > TODAY)
                                    OR (int-ped-venda.dias-negociacao    > 0
                                    AND int-ped-venda.dias-negociacao    > v_dias_negoc)
                                    OR  v_val_entrada                    > 0 THEN DO:
    
                                        IF  AVAIL tt-prog-ponto THEN 
                                            ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: " + string(entry(2,tt-prog-ponto.conteudo,";")).
                                        ELSE
                                            ASSIGN v_desc_bloq = "Dt Bloqueio: " + string(today,"99/99/9999") + " - Motivos: REAV".
    
                                        ASSIGN v_val_dec_1 = int-ped-venda2.dec-2.
    
                                        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                                        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                              INPUT "EMS",
                                                                              INPUT "ERROR",
                                                                              INPUT v_desc_bloq,
                                                                              INPUT "Erro: ",
                                                                              INPUT "").
    
                                        RETURN "NOK".
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.


IF p-ind-event = 'afterEfetivaNota' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
    log-manager:write-message('BODI317EF-UPC afterEfetivaNota ').

    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event      = p-ind-event
          AND tt-epc.cod-parameter  = 'Object-Handle'
        NO-ERROR.        

    IF l-ativa-log THEN
       PUT "bodi317ef - after efetiva nota"  SKIP. 

    ASSIGN hBODI317ef = WIDGET-HANDLE(tt-epc.val-parameter).

    RUN buscattNotasGeradas IN hBODI317ef (OUTPUT l-procedimento-ok, 
                                           OUTPUT TABLE tt-notas-geradas).

    FOR EACH tt-notas-lidas:
        DELETE tt-notas-lidas.
    END.

    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event      = p-ind-event
          AND tt-epc.cod-parameter  = 'table-rowid'
        NO-ERROR.
     
    FIND wt-docto NO-LOCK WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.

    FIND int-emitente
         WHERE int-emitente.cod-emitente = wt-docto.cod-emitente
         NO-LOCK NO-ERROR.
    
    RUN pi-atualiza-ped-fiscal IN THIS-PROCEDURE.
    
    RUN pi-gerar-dados-extrato ("after efetiva nota -antes envia mail-").

    //RUN pi-envia-e-mail IN THIS-PROCEDURE.
    
    RUN pi-gerar-dados-extrato ("after efetiva nota -depois envia mail-").

    IF l-ativa-log THEN
       PUT "bodi317ef - after efetiva nota -2- "  SKIP. 

    RUN pi-atualiza-transp IN THIS-PROCEDURE.

    IF l-ativa-log THEN
       PUT "bodi317ef - after efetiva nota -3- "  SKIP. 
     
    RUN pi-atualiza-volume IN THIS-PROCEDURE.

    IF RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

     RUN pi-envia-e-mail IN THIS-PROCEDURE.
                                              
    RUN esbo/boes398.p PERSISTENT SET h-boes398. 
    IF l-ativa-log THEN
        PUT "bodi317ef-upc antes pi-atualiza-observ " SKIP.

    RUN pi-atualiza-observ IN THIS-PROCEDURE.

    IF l-ativa-log THEN
        PUT "bodi317ef-upc apos pi-atualiza-observ " SKIP.

    
    FOR EACH tt-notas-geradas NO-LOCK,
    FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
          AND nota-fiscal.serie         = wt-docto.serie
          AND nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota:

/*         MESSAGE 12                             */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        IF VALID-HANDLE(wh-TribRPS-FT4002) THEN DO:

/*             MESSAGE 22                             */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK. */

            FIND FIRST esp-ext-ser-estab
                WHERE esp-ext-ser-estab.cod-estabel = nota-fiscal.cod-estabel
                  AND esp-ext-ser-estab.serie       = nota-fiscal.serie      NO-LOCK NO-ERROR.
            IF AVAIL esp-ext-ser-estab THEN DO:

/*                 MESSAGE 32                             */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                CREATE int-nota-rps.
                ASSIGN int-nota-rps.cod-estabel     = nota-fiscal.cod-estabel
                       int-nota-rps.serie           = nota-fiscal.serie      
                       int-nota-rps.nr-nota-fis     = nota-fiscal.nr-nota-fis
                       int-nota-rps.nat-op-especial = IF wh-TribRPS-FT4002:SCREEN-VALUE = 'yes' THEN '' ELSE '1'.

/*                 MESSAGE 'int-nota-rps.cod-estabel     '  int-nota-rps.cod-estabel       skip               */
/*                         'int-nota-rps.serie           '  int-nota-rps.serie             skip               */
/*                         'int-nota-rps.nr-nota-fis     '  int-nota-rps.nr-nota-fis       skip               */
/*                         'int-nota-rps.nat-op-especial '  int-nota-rps.nat-op-especial   VIEW-AS ALERT-BOX. */

            END. /* IF AVAIL esp-ext-ser-estab THEN DO: */

            
        END.


        /* Foráar frete E-sedex se transportadora da nota Ç Sedex/E-Sedex, se CEP atendido por E-Sedex, trocar a transpotadora para este*/
        FIND b-nf-esedex EXCLUSIVE-LOCK
            WHERE ROWID(b-nf-esedex) = ROWID(nota-fiscal) NO-ERROR.

        IF  AVAIL  b-nf-esedex                        AND
                  (b-nf-esedex.nome-transp = "Sedex"   OR
                   b-nf-esedex.nome-transp = "E-Sedex" OR
                   b-nf-esedex.nome-transp = "Sedex MG" OR
                   b-nf-esedex.nome-transp = "Sedex 10")
        THEN DO:
            FIND FIRST int-cep-esedex NO-LOCK
                WHERE  int-cep-esedex.log-ativo        = YES 
                  AND  int-cep-esedex.cod-cep-inicial <= b-nf-esedex.cep 
                  AND  int-cep-esedex.cod-cep-final   >= b-nf-esedex.cep NO-ERROR.
    
            IF  AVAIL int-cep-esedex
            THEN
                ASSIGN b-nf-esedex.nome-transp = "E-Sedex".
            ELSE
                ASSIGN b-nf-esedex.nome-transp = "Sedex".

            FIND CURRENT b-nf-esedex NO-LOCK NO-ERROR.
        END.
        /* Fim Foráar frete E-sedex */

        /* Gerar tabela de controle das notas fiscais para integraá∆o com os correios */
        IF  nota-fiscal.nome-transp = "PAC"     OR 
            nota-fiscal.nome-transp = "SEDEX"   OR
            nota-fiscal.nome-transp = "E-SEDEX" OR
            nota-fiscal.nome-transp = "SEDEX MG" OR 
            nota-fiscal.nome-transp = "SEDEX 10" OR
            nota-fiscal.nome-transp = "MERCADO ENVI" OR
            nota-fiscal.nome-transp = "EBAZAR01" OR
            nota-fiscal.nome-transp = "EBAZAR02" OR
            nota-fiscal.nome-transp = "MAGALU" OR
            nota-fiscal.nome-transp = "TOTAL EXP"
        THEN DO:
            FOR EACH volume-nf NO-LOCK
               WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                 AND volume-nf.serie       = nota-fiscal.serie
                 AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
               BREAK BY volume-nf.nr-volume:

               IF FIRST-OF(volume-nf.nr-volume) 
               THEN DO:
                   FIND FIRST int-nota-conhec NO-LOCK
                        WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                          AND int-nota-conhec.serie       = nota-fiscal.serie          
                          AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                          AND int-nota-conhec.nr-volume   = volume-nf.nr-volume NO-ERROR.

                   IF  NOT AVAIL int-nota-conhec
                   THEN DO:
                       CREATE int-nota-conhec.
                       ASSIGN int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel
                              int-nota-conhec.serie       = nota-fiscal.serie      
                              int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                              int-nota-conhec.nr-volume   = volume-nf.nr-volume.
                       RELEASE int-nota-conhec.
                   END. /* IF  NOT AVAIL int-nota-conhec */
               END. /* IF FIRST-OF(volume-nf.nr-volume) */
            END. /* FOR EACH  volume-nf NO-LOCK */
        END.
        /* Fim Gerar tabela de controle */

        FOR EACH vpc
            WHERE vpc.cod-emitente = nota-fiscal.cod-emitente
            AND vpc.id-pagto = 3
            AND vpc.forma-pagto = 2
            AND vpc.num-pagto = nota-fiscal.nr-pedcli EXCLUSIVE-LOCK:

            FIND LAST pagto-vpc
                 WHERE pagto-vpc.nr-vpc   = vpc.nr-vpc
                 NO-LOCK NO-ERROR.
            IF AVAIL pagto-vpc THEN
                ASSIGN i-nr-sequencia-vpc = pagto-vpc.sequencia.
                
            RUN pi-cria-pagto.
        END.

        FIND FIRST fat-duplic
            WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
              AND fat-duplic.serie        = nota-fiscal.serie
              AND fat-duplic.nr-fatura    = nota-fiscal.nr-fatura NO-LOCK NO-ERROR.
        
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                   AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

             FIND natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.
            
            FIND FIRST ped-item OF ped-venda NO-LOCK
                 WHERE ped-item.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

            /*considerar somente os pedidos que geram titulo*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

            /*FIND FIRST int-pv-canal EXCLUSIVE-LOCK
                 WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
                   AND int-pv-canal.it-codigo = it-nota-fisc.it-codigo
                   AND int-pv-canal.mes-meta  = MONTH(nota-fiscal.dt-emis)
                   AND int-pv-canal.ano-meta  = YEAR(nota-fiscal.dt-emis)  NO-ERROR.
    
            IF  AVAIL int-pv-canal 
            AND natur-oper.emite-duplic THEN DO:
                ASSIGN int-pv-canal.qt-faturada = int-pv-canal.qt-faturada + it-nota-fisc.qt-faturada[1]
                       int-pv-canal.qt-carteira = int-pv-canal.qt-carteira - it-nota-fisc.qt-faturada[1].

                RELEASE int-pv-canal.
            END. */

            IF  AVAIL natur-oper
            THEN DO:
                IF  natur-oper.subs-trib       = NO AND
                    natur-oper.log-oper-triang = NO AND
                    it-nota-fisc.ind-icm-ret   = YES 
                THEN DO:
                   FIND b-it-nota-fisc
                        WHERE ROWID(b-it-nota-fisc) = ROWID(it-nota-fisc) 
                        EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAIL b-it-nota-fisc THEN DO:
                       ASSIGN b-it-nota-fisc.ind-icm-ret = NO.
                   END.
                END.

                /* Atualizar controle kanban eletronico */
                IF  natur-oper.tipo        = 2 AND /* Saida */
                    natur-oper.baixa-estoq = YES
                THEN
                    RUN esp/cpp/escpp058a.p (INPUT "yes", /* limpar temp-table saldo */
                                             INPUT "yes", /* atualizar base */
                                             INPUT it-nota-fisc.it-codigo,
                                             INPUT it-nota-fisc.qt-faturada[1],
                                             INPUT-OUTPUT TABLE tt-saldo).
            END.

            find first wt-it-docto 
                 where wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                   and wt-it-docto.it-codigo     = it-nota-fisc.it-codigo
                   and wt-it-docto.quantidade[1] = it-nota-fisc.qt-faturada[1]
                   no-lock no-error.
            IF AVAIL wt-it-docto THEN DO:
                FIND int-it-nota-fisc
                     WHERE int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                       AND int-it-nota-fisc.serie       = it-nota-fisc.serie
                       AND int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                       AND int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                       AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo
                     EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL INT-it-nota-fisc THEN DO:
                    CREATE int-it-nota-fisc.
                    ASSIGN int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel  
                           int-it-nota-fisc.serie       = it-nota-fisc.serie        
                           int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis  
                           int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat   
                           int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo.
                END.
                FIND int-wt-it-docto
                     WHERE int-wt-it-docto.seq-wt-docto    = wt-it-docto.seq-wt-docto
                       AND int-wt-it-docto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                     NO-LOCK NO-ERROR.
                IF AVAIL INT-wt-it-docto THEN DO:
                    ASSIGN int-it-nota-fisc.codigo-orig = int-wt-it-docto.codigo-orig.
                END.
                ELSE DO:
                    FIND ITEM 
                         WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
                         NO-LOCK NO-ERROR.
                    IF AVAIL ITEM THEN DO:
                        ASSIGN int-it-nota-fisc.codigo-orig = ITEM.codigo-orig
                               int-it-nota-fisc.cod-dcr-e   = item.cod-dcr-item.
                    END.
                END.
            END.

            IF  AVAIL fat-duplic THEN DO:
                FOR each  fat-repre no-lock
                   where fat-repre.cod-estabel = nota-fiscal.cod-estabel
                   and   fat-repre.serie       = nota-fiscal.serie
                   and   fat-repre.nr-fatura   = nota-fiscal.nr-fatura,
                   first repres no-lock
                   where repres.nome-abrev     = fat-repre.nome-ab-rep:
    
                    IF nota-fiscal.nr-pedcli <> "" THEN DO:
                       FIND ped-venda
                            WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                              AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                            NO-LOCK NO-ERROR.
                       IF AVAIL ped-venda THEN
                          ASSIGN p-dt-implant-ped = ped-venda.dt-implant.
                       ELSE
                          ASSIGN p-dt-implant-ped = ?.
                    END.
                    ELSE ASSIGN p-dt-implant-ped = ?.
    
                    RUN comissoes IN h-boes398 (INPUT 1,
                                                INPUT YES,
                                                INPUT nota-fiscal.cod-estabel,
                                                INPUT nota-fiscal.cod-emitente,
                                                INPUT nota-fiscal.cod-rep,
                                                INPUT it-nota-fisc.it-codigo,
                                                INPUT it-nota-fisc.nr-seq-fat,
                                                INPUT it-nota-fisc.qt-faturada[1],
                                                INPUT nota-fiscal.dt-emis-nota,
                                                INPUT p-dt-implant-ped,
                                                INPUT ?,
                                                INPUT nota-fiscal.serie,
                                                INPUT nota-fiscal.nr-nota-fis,
                                                INPUT "",
                                                INPUT "",
                                                INPUT fat-duplic.cod-esp,
                                                INPUT nota-fiscal.nr-praz-med,
                                                INPUT nota-fiscal.cod-cond-pag,
                                                INPUT it-nota-fisc.vl-merc-liq,
                                                output p-erro,
                                                INPUT-OUTPUT TABLE tt-comissao-fat).
    
                END.
            END.
        END.
/*         IF nota-fiscal.nat-operacao = "594908"       */
/*         OR nota-fiscal.nat-operacao = "594939"       */
/*         OR nota-fiscal.nat-operacao = "694911"       */
/*         OR nota-fiscal.nat-operacao = "694939" THEN  */
/*             RUN pi-busca-contrato IN THIS-PROCEDURE. */

        /*Chamado 99798*/
        FIND FIRST ser-estab NO-LOCK
             WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel
               AND ser-estab.serie       = nota-fiscal.serie NO-ERROR.
        
        /*Nota de fatura*/
        IF  AVAIL ser-estab
        AND ser-estab.log-nf-eletro = NO 
        AND SUBSTR(ser-estab.char-1,71,1) <> "S"  THEN DO:

            EMPTY TEMP-TABLE tt-param-esftp119.
            CREATE tt-param-esftp119.
            ASSIGN tt-param-esftp119.cod-estab-ini   = nota-fiscal.cod-estabel
                   tt-param-esftp119.cod-estab-fim   = nota-fiscal.cod-estabel
                   tt-param-esftp119.serie-ini       = nota-fiscal.serie
                   tt-param-esftp119.serie-fim       = nota-fiscal.serie
                   tt-param-esftp119.nr-nota-fis-ini = nota-fiscal.nr-nota-fis
                   tt-param-esftp119.nr-nota-fis-fim = nota-fiscal.nr-nota-fis
                   tt-param-esftp119.l-envia-email   = YES
                   tt-param-esftp119.l-imprime-trib  = NO.

            RAW-TRANSFER tt-param-esftp119 TO raw-param.

            RUN esp/ftp/esftp119rp.p (INPUT raw-param, 
                                      INPUT TABLE tt-raw-digita).
        END.
    END.
                               
    DELETE PROCEDURE h-boes398. 
                                 
    /*********************************************************************************
    **  Prop¢sito:  Validar os pedidos/notas fiscais com os limites do SupplierCard
    **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    **  Criaá∆o:    Setembro de 2011
    **********************************************************************************/
    /****************************************
    **  Validaá∆o do SupplierCard - In°cio
    *****************************************/
    IF NOT VALID-HANDLE(h-esapi001) THEN
        RUN esp/esapi001.p PERSISTENT SET h-esapi001.
        
    FOR EACH tt-notas-geradas NO-LOCK,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = wt-docto.cod-estabel
          AND nota-fiscal.serie       = wt-docto.serie
          AND nota-fiscal.nr-nota-fis = tt-notas-geradas.nr-nota,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FIND FIRST int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.

        IF AVAILABLE int-cond-pagto                       AND
           SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
            RUN pi-compromete-saldo-nfs IN h-esapi001 (INPUT nota-fiscal.cod-estabel,
                                                       INPUT nota-fiscal.serie,
                                                       INPUT nota-fiscal.nr-nota-fis,
                                                       INPUT it-nota-fisc.it-codigo).
        END. /* IF AVAILABLE int-cond-pagto                       AND
                   SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */
    END. /* FOR EACH tt-notas-geradas NO-LOCK, */
    /****************************************
    **  Validaá∆o do SupplierCard - Final
    *****************************************/
    IF VALID-HANDLE(h-esapi001) THEN
        DELETE PROCEDURE h-esapi001.

    /*********************************************************************************
     **  Prop¢sito:  Alocar Ocorrància ASTEC
     **  Autor:      Fabiano Sakae Ribeiro (Exponencial TI)
     **  Criaá∆o:    Junho de 2013
     *********************************************************************************/
    /****************************************
     ** Alocar Ocorrància ASTEC - In°cio
     ****************************************/
    EMPTY TEMP-TABLE RowErrors.

    IF  NOT VALID-HANDLE(h-esapi018)                  OR
        h-esapi018:TYPE      <> "PROCEDURE":U         OR
       (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
        h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
        RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

    FOR EACH tt-notas-geradas NO-LOCK,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = wt-docto.cod-estabel
          AND nota-fiscal.serie       = wt-docto.serie
          AND nota-fiscal.nr-nota-fis = tt-notas-geradas.nr-nota,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK,
        FIRST ped-item NO-LOCK /* Rubia */
        WHERE  ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli
          AND  ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli  
          AND  ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped 
          AND  ped-item.it-codigo    = it-nota-fisc.it-codigo 
          AND  ped-item.cod-refer    = it-nota-fisc.cod-refer :
        IF CAN-FIND(FIRST int-ped-item-astec
                    WHERE int-ped-item-astec.nome-abrev   = nota-fiscal.nome-ab-cli
                      AND int-ped-item-astec.nr-pedcli    = ped-item.nr-pedcli
                      AND int-ped-item-astec.nr-sequencia = ped-item.nr-sequencia
                      AND int-ped-item-astec.it-codigo    = ped-item.it-codigo) THEN DO:
            IF VALID-HANDLE(h-esapi018) THEN DO:
                EMPTY TEMP-TABLE RowErrorsAstec.

                RUN emptyRowErrors IN h-esapi018.

                RUN alocarItemNotaFiscal IN h-esapi018 (INPUT it-nota-fisc.nome-ab-cli,
                                                        INPUT it-nota-fisc.nr-pedcli,
                                                        INPUT it-nota-fisc.nr-seq-ped,
                                                        INPUT it-nota-fisc.it-codigo,
                                                        INPUT nota-fiscal.cod-estabel,
                                                        INPUT nota-fiscal.serie,
                                                        INPUT nota-fiscal.nr-nota-fis,
                                                        INPUT it-nota-fisc.qt-faturada[1]).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrorsAstec).

                    FOR EACH RowErrorsAstec:
                        CREATE RowErrors.
                        BUFFER-COPY RowErrorsAstec TO RowErrors.
                    END.
                END.
            END.
        END.
    END.

    FOR EACH RowErrors:
        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).

        RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                              INPUT RowErrors.ErrorType,
                                              INPUT RowErrors.ErrorSubType,
                                              INPUT RowErrors.ErrorDescription,
                                              INPUT RowErrors.ErrorHelp,
                                              INPUT RowErrors.ErrorParameters).
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    /****************************************
     ** Alocar Ocorrància ASTEC - Final
     ****************************************/
END.

IF p-ind-event = 'AfterGeraXMLTXT' THEN DO:

   FIND tt-epc WHERE tt-epc.cod-event      = p-ind-event
                 AND tt-epc.cod-parameter  = 'rowid-notafiscal'
   NO-LOCK NO-ERROR.        

   IF AVAIL tt-epc THEN DO:

      FIND nota-fiscal WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

      /* MOVE XML DA PASTA */
     // RUN pi-move-xml-diretorio-neogrid.

   END.
END.


IF VALID-HANDLE(h-esapi018) THEN
    RUN destroy IN h-esapi018.

IF VALID-HANDLE(h-esapi018) THEN
    DELETE PROCEDURE h-esapi018.

ASSIGN h-esapi018 = ?.

IF VALID-HANDLE(h-esapi001) THEN
    DELETE PROCEDURE h-esapi001.

IF  l-ativa-log THEN DO:
    PUT "bodi317ef-upc - saida - hora " string(TIME,"HH:MM:SS") SKIP
        "" SKIP.
END.

PROCEDURE pi-atualiza-ped-fiscal:

    DEF VAR c-integrador AS CHAR NO-UNDO.

    RUN pi-gerar-dados-extrato ("pi-atualiza-ped-fiscal").
    /*n∆o haver† mais de um registro nesta temp-table, mas Ç feito um for por garantia*/
    FOR EACH tt-notas-geradas NO-LOCK:

        ASSIGN c-integrador = "".
        
        FIND nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
            AND   nota-fiscal.serie         = wt-docto.serie
            AND   nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota NO-ERROR.
        
        RUN pi-gerar-dados-extrato ("wt-docto.cod-estabel: " + wt-docto.cod-estabel).
        RUN pi-gerar-dados-extrato ("wt-docto.serie: " + wt-docto.serie).
        RUN pi-gerar-dados-extrato ("tt-notas-geradas.nr-nota: " + tt-notas-geradas.nr-nota).

        IF  AVAIL nota-fiscal THEN DO:

            FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK
                 WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel   
                 AND   int-nota-fiscal.serie       = nota-fiscal.serie         
                 AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
            
            RUN pi-gerar-dados-extrato ("AVAIL int-nota-fiscal: " + STRING(AVAIL int-nota-fiscal)).
            IF  NOT AVAIL int-nota-fiscal THEN DO:
                CREATE int-nota-fiscal.
                ASSIGN int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       int-nota-fiscal.serie       = nota-fiscal.serie
                       int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis.
            END.

            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            RUN pi-gerar-dados-extrato ("AVAIL emitente: " + STRING(AVAIL emitente)).
            IF  AVAIL emitente THEN
                ASSIGN int-nota-fiscal.nome-emit = emitente.nome-emit.

            RUN pi-gerar-dados-extrato ("int-nota-fiscal.nome-emit: " + STRING(int-nota-fiscal.nome-emit)).

            FIND int-wt-docto
                 WHERE int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL int-wt-docto THEN DO:
                ASSIGN int-nota-fiscal.cod-mensagem = int-wt-docto.cod-mensagem.
                c-integrador = int-wt-docto.integrador.
                
                DELETE int-wt-docto.
            END.

            IF  c-integrador <> ""  THEN
                OVERLAY(int-nota-fiscal.char-1, 30, 12) = c-integrador. /* Integrador */
            ELSE DO:
                FIND FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                    AND   ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

                IF  AVAIL ped-venda THEN DO:
                    FIND FIRST int-ped-venda NO-LOCK
                        WHERE int-ped-venda.nr-pedido  = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL int-ped-venda AND substr(int-ped-venda.char-1, 41, 12) <> "" THEN
                        OVERLAY(int-nota-fiscal.char-1, 30, 12) = substr(int-ped-venda.char-1, 41, 12).
                END.
            END.

            /* O Campo int-nota-fiscal.cod-usuario-solic est† sendo usado 
               para gravar o c¢digo do pedido da solicitaá∆o. */  
            FIND ped-fiscal EXCLUSIVE-LOCK
                 WHERE ped-fiscal.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
            
            IF  AVAIL ped-fiscal THEN DO:
                ASSIGN int-nota-fiscal.cod-usuario-solic = string(ped-fiscal.nr-pedido)
/*                        ped-fiscal.situacao      = IF TODAY >= 08/28/09 THEN 4 ELSE 2  */
                       ped-fiscal.situacao      = 5 /* Atendido */
                       ped-fiscal.cod-estabel   = wt-docto.cod-estabel
                       ped-fiscal.serie         = wt-docto.serie
                       ped-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota
                       ped-fiscal.seq-wt-docto  = 0.
            END.
            
            FIND FIRST ped-venda
                WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                AND   ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
            
            IF  AVAIL ped-venda THEN DO:
                FIND int-ped-venda
                     WHERE int-ped-venda.cod-estabel = nota-fiscal.cod-estabel
                     AND   int-ped-venda.nr-pedido   = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.

                IF  AVAIL int-nota-fiscal THEN
                    ASSIGN OVERLAY(int-nota-fiscal.char-1,28,2) = ped-venda.tp-pedido.
            END.

            FOR EACH retorno-cartao-cred
                WHERE retorno-cartao-cred.seq-wt-docto = wt-docto.seq-wt-docto EXCLUSIVE-LOCK:
                
                ASSIGN retorno-cartao-cred.cod-estabel = nota-fiscal.cod-estabel
                       retorno-cartao-cred.serie       = nota-fiscal.serie
                       retorno-cartao-cred.nr-nota-fis = nota-fiscal.nr-nota-fis.

                IF  AVAIL int-ped-venda THEN
                    ASSIGN int-ped-venda.CarTID = retorno-cartao-cred.num-autorizacao.
            END.

            IF  AVAIL int-ped-venda THEN DO:
                ASSIGN int-ped-venda.atualizaIkeda = YES.
            END.

            FIND CURRENT int-nota-fiscal NO-LOCK NO-ERROR.
            FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.


/*             FOR FIRST ped-venda                                                           */
/*                 WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli                        */
/*                   AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli:                     */
/*                 FOR EACH nota-entr-saida                                                  */
/*                     where nota-entr-saida.nr-pedido = ped-venda.nr-pedido EXCLUSIVE-LOCK: */
/*                     ASSIGN nota-entr-saida.nr-nota-fis = nota-fiscal.nr-nota-fis          */
/*                            nota-entr-saida.serie       = nota-fiscal.serie.               */
/*                 END.                                                                      */
/*             END.                                                                          */

        END.
    END.

END PROCEDURE.


PROCEDURE pi-envia-e-mail:

    DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEFINE VARIABLE c-mensagem2 AS CHAR NO-UNDO INITIAL ''.
    DEFINE VARIABLE c-narrativa AS CHAR NO-UNDO.

    FOR EACH tt-notas-geradas NO-LOCK:
    
        ASSIGN c-remetente = " "
               c-email     = " "
               c-titulo    = " " 
               c-mensagem  = " "
               c-controladoria = " ".
              
    
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = wt-docto.cod-estabel
               AND nota-fiscal.serie       = wt-docto.serie
               AND nota-fiscal.nr-nota-fis = tt-notas-geradas.nr-nota NO-ERROR.
        
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
        FIND FIRST estab-uf NO-LOCK
             WHERE estab-uf.cod-estabel = nota-fiscal.cod-estabel
               AND estab-uf.estado      = nota-fiscal.estado NO-ERROR.
    
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
    
        IF estabelec.estado <> emitente.estado and
           (NOT AVAIL estab-uf or
            estab-uf.ins-estadual = "")  THEN DO:
    
            ASSIGN vl-IcmsUFDest = 0
                   vl-FCP        = 0.
    
            /* 61597 */
            IF emitente.contrib-icms = NO THEN DO:
    
                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
    
                    FOR EACH ITEM-NF-ADC
                         WHERE ITEM-NF-ADC.cod-estab        = nota-fiscal.cod-estabel
                           AND ITEM-NF-ADC.cod-serie        = nota-fiscal.serie
                           AND ITEM-NF-ADC.cod-nota-fis     = nota-fiscal.nr-nota-fis
                           AND item-nf-adc.cod-natur-operac = it-nota-fisc.nat-operacao
                           AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat
                           AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:
                        
                        ASSIGN vl-IcmsUFDest = vl-IcmsUFDest + item-nf-adc.val-livre-3 
                               vl-FCP        = vl-FCP        + item-nf-adc.val-livre-2 .
    
                    END. /* IF AVAIL nota-fisc-adc THEN DO: */
    
                END. /* FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK */
    
                IF vl-FCP > 0.01 OR vl-IcmsUFDest > 0.01 THEN DO:
    
                    FIND FIRST param-global NO-LOCK.
                    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
    
                    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
                    RUN esp/es0018p.p (INPUT "bodi317ef", /* Nome do programa */
                                       INPUT 7,           /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto).
    
                    FOR EACH tt-prog-ponto
                       WHERE tt-prog-ponto.nome-programa = "bodi317ef"
                         AND tt-prog-ponto.ponto         = 7:
                        /*estab;email-expediá∆o;email-controladoria*/
    
                        ASSIGN c-cod-estab     = ENTRY(1,tt-prog-ponto.conteudo,";")
                               c-email         = ENTRY(2,tt-prog-ponto.conteudo,";")
                               c-controladoria = ENTRY(3,tt-prog-ponto.conteudo,";").
    
                        IF c-cod-estab  = nota-fiscal.cod-estabel THEN DO:
    
                            ASSIGN c-remetente = usuar_mestre.cod_e_mail_local
                                   c-titulo    = "Instruá∆o para recolhimento de DIFA N∆o contribuintes - " + nota-fiscal.nr-nota-fis
                                   c-mensagem  = "A nota fiscal " +  STRING(nota-fiscal.nr-nota-fis) + " foi emitida do estabelecimento " + c-cod-estab + " para um " +
                                                 "cliente que n∆o Ç contribuinte de ICMS, <u><b>N«O EXPEDIR A MERCADORIA</b></u>, aguardar recolhimento da guia de DIFA (Diferencial de Al°quotas), que ser† encaminhado Ö expediá∆o pelo grupo tributario. " + "<br> <br>" +
                                                 "Raz∆o social Cliente: " + emitente.nome-emit                               + "<br>" +
                                                 "CNPJ Cliente: " + emitente.cgc                                             + "<br>" +
                                                 "UF Cliente: " + emitente.estado                                            + "<br>" +
                                                 "Valor ICMS Partilha UF destino: "   + string(vl-IcmsUFDest,'999999.9999')  + "<br>" +
                                                 "Valor Fundo de Combate a Pobreza: " + string(vl-FCP,'999999.9999')         + "<br>" .
    
                            CREATE tt-envio.
                            ASSIGN tt-envio.Remetente     = c-remetente
                                   tt-envio.destino       = usuar_mestre.cod_e_mail_local + ';' + c-email
                                   tt-envio.Assunto       = c-titulo
                                   tt-envio.Mensagem      = c-mensagem.
                            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
                            FOR FIRST tt-envio:
                                EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
                                EMPTY TEMP-TABLE tt-mensagem NO-ERROR.
                                CREATE tt-envio2.
                                ASSIGN tt-envio2.versao-integracao = 1
                                       tt-envio2.exchange          = param-global.log-1  
                                       tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
                                       tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
                                       tt-envio2.destino           = tt-envio.Destino        /* Destinat·rio       */ 
                                       tt-envio2.remetente         = tt-envio.Remetente      /* Remetente          */ 
                                       tt-envio2.assunto           = tt-envio.Assunto        /* Assunto            */
                                       tt-envio2.importancia       = 2
                                       tt-envio2.log-enviada       = YES
                                       tt-envio2.log-lida          = NO
                                       tt-envio2.acomp             = NO
                                       tt-envio2.arq-anexo         = ?
                                       tt-envio2.formato           = "html". 
                                CREATE tt-mensagem.
                                ASSIGN tt-mensagem.seq-mensagem = 1
                                       tt-mensagem.mensagem     = tt-envio.Mensagem.         /* Mensagem de e-mail */
                                RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                                               INPUT  TABLE tt-mensagem,
                                                               OUTPUT TABLE tt-erros).
                                FIND FIRST tt-erros NO-LOCK NO-ERROR.
                                IF  AVAIL tt-erros THEN DO:
                                    OUTPUT TO erros-comerc.LOG APPEND.
                                    FOR EACH tt-erros:
                                        DISP tt-erros.cod-erro
                                             tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
                                    END.
                                    OUTPUT CLOSE.
                                END. /* IF  AVAIL tt-erros THEN DO: */
                            END. /* FOR FIRST tt-mail: */
                            DELETE PROCEDURE h-utapi019.
    
                        END. /* IF c-cod-estab  = nota-fiscal.cod-estabel THEN DO: */
    
                    END. /* FOR EACH tt-prog-ponto */
                    LEAVE.
    
                END. /* IF vl-FCP <> 0 OR vl-IcmsDest <> 0 THEN DO: */
    
            END. /* IF emitente.contrib-icms = NO THEN DO: */
            /* 61597 */
            FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK
                WHERE it-nota-fisc.vl-icmsub-it <> 0:
                FIND FIRST param-global NO-LOCK.
                FIND usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
                EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
                RUN esp/es0018p.p (INPUT "bodi317ef", /* Nome do programa */
                                   INPUT 6,           /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).
                FOR EACH tt-prog-ponto
                   WHERE tt-prog-ponto.nome-programa = "bodi317ef"
                     AND tt-prog-ponto.ponto         = 6:
                    /*estab;email-expediá∆o;email-controladoria*/
                    ASSIGN c-cod-estab     = ENTRY(1,tt-prog-ponto.conteudo,";")
                           c-email         = ENTRY(2,tt-prog-ponto.conteudo,";")
                           c-controladoria = ENTRY(3,tt-prog-ponto.conteudo,";").
    
                    FIND FIRST bf_usuar_mestre NO-LOCK
                         WHERE bf_usuar_mestre.cod_usuar = nota-fiscal.user-calc NO-ERROR.        
                    IF AVAIL bf_usuar_mestre AND bf_usuar_mestre.cod_e_mail_local <> "" AND c-email <> "" THEN
                       ASSIGN c-email = c-email + "," + bf_usuar_mestre.cod_e_mail_local.
    
                    IF c-cod-estab  = nota-fiscal.cod-estabel THEN DO:
                         ASSIGN c-remetente = usuar_mestre.cod_e_mail_local
                                c-titulo    = "Instruá∆o para recolhimento de ICMS ST - " + nota-fiscal.nr-nota-fis
                                c-mensagem  = "A nota fiscal nß" +  STRING(nota-fiscal.nr-nota-fis) + " " + "foi emitida do estabelecimento" +  " " + 
                                              STRING(nota-fiscal.cod-estabel) + " " + "para o estado" + " " + nota-fiscal.estado + " " +
                                              "com o destaque de ICMS ST." + " " + "Dado que a Intelbras n∆o possui inscriá∆o estadual de substituto tribut†rio nesse estado, deve-se efetuar o recolhimento desse tributo em guia espec°fica. Favor solicitar a Controladoria" + " " + 
                                              c-controladoria + " " + "que emita a respectiva guia para recolhimento desse tributo." + "~n" + "~n" +
                                              "Favor enviar os dados abaixo para a controladoria" + "~n" + "~n" +
                                              "Raz∆o social do cliente:" + emitente.nome-emit + "~n" +
                                              "CNPJ:" + nota-fiscal.cgc + "~n" +
                                              "Inscriá∆o Estadual:" + nota-fiscal.ins-estadual + "~n" +
                                              "UF:" + nota-fiscal.estado + "~n" +
                                              "Data de emiss∆o:" + STRING(nota-fiscal.dt-emis-nota) + "~n" +
                                              "Chave de acesso:" + STRING(nota-fiscal.cod-chave-aces-nf-eletro).
                        CREATE tt-envio.
                        ASSIGN tt-envio.Remetente     = c-remetente
                               tt-envio.destino       = c-email
                               tt-envio.Assunto       = c-titulo
                               tt-envio.Mensagem      = c-mensagem.
                        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
                        FOR FIRST tt-envio:
                            EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
                            EMPTY TEMP-TABLE tt-mensagem NO-ERROR.
                            CREATE tt-envio2.
                            ASSIGN tt-envio2.versao-integracao = 1
                                   tt-envio2.exchange          = param-global.log-1  
                                   tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
                                   tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
                                   tt-envio2.destino           = tt-envio.Destino        /* Destinat·rio       */ 
                                   tt-envio2.remetente         = tt-envio.Remetente      /* Remetente          */ 
                                   tt-envio2.assunto           = tt-envio.Assunto        /* Assunto            */
                                   tt-envio2.importancia       = 2
                                   tt-envio2.log-enviada       = YES
                                   tt-envio2.log-lida          = NO
                                   tt-envio2.acomp             = NO
                                   tt-envio2.arq-anexo         = ?
                                   tt-envio2.formato           = "text". 
                            CREATE tt-mensagem.
                            ASSIGN tt-mensagem.seq-mensagem = 1
                                   tt-mensagem.mensagem     = tt-envio.Mensagem.         /* Mensagem de e-mail */
                            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                                           INPUT  TABLE tt-mensagem,
                                                           OUTPUT TABLE tt-erros).
                            FIND FIRST tt-erros NO-LOCK NO-ERROR.
                            IF  AVAIL tt-erros THEN DO:
                                OUTPUT TO erros-comerc.LOG APPEND.
                                FOR EACH tt-erros:
                                    DISP tt-erros.cod-erro
                                         tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
                                END.
                                OUTPUT CLOSE.
                            END. /* IF  AVAIL tt-erros THEN DO: */
                        END. /* FOR FIRST tt-mail: */
                        DELETE PROCEDURE h-utapi019.
                    END.
                END.
            END.
        END.
        
        ASSIGN c-email = "".
        ASSIGN c-narrativa = "".
        EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
        FIND FIRST param-global NO-LOCK.
        RUN esp/es0018p.p (INPUT "bodi317ef", /* Nome do programa */
                           INPUT 11,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).
        FOR EACH tt-prog-ponto:
            
            IF AVAIL nota-fiscal 
               AND  nota-fiscal.cod-emitente = int(ENTRY(1,tt-prog-ponto.conteudo,","))
               AND  nota-fiscal.nat-operacao = ENTRY(2,tt-prog-ponto.conteudo,",")  THEN DO:

                RUN pi-gerar-dados-extrato ("after efetiva nota -mail notas relacionadas 2-").

                 FOR EACH cont-emit NO-LOCK
                      WHERE cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                        AND (cont-emit.nome        BEGINS 'NFE'
                         OR cont-emit.nome         BEGINS 'NF-e'):
                                              
                     IF c-email = "" THEN 
                        ASSIGN c-email = trim(cont-emit.e-mail)  + ";" + ENTRY(3,tt-prog-ponto.conteudo,",").
                     ELSE
                        ASSIGN c-email = trim(c-email) + ";" + trim(cont-emit.e-mail) + ";" + ENTRY(3,tt-prog-ponto.conteudo,",").
                   END.

                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK,

                    FIRST item-doc-est USE-INDEX documento
                    WHERE item-doc-est.serie-docto = it-nota-fisc.serie-docum
                    AND   item-doc-est.nro-docto = it-nota-fisc.nr-docum
                    AND   item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                    AND   ITEM-doc-est.nat-operacao = it-nota-fisc.nat-docum
                    AND   item-doc-est.it-codigo    = it-nota-fisc.it-codigo NO-LOCK,
                    
                    EACH narrativa
                    WHERE narrativa.it-codigo = it-nota-fisc.it-codigo NO-LOCK:

                    ASSIGN c-narrativa = narrativa.descricao
                           c-narrativa = REPLACE(c-narrativa, CHR(10),"") 
                           c-narrativa = REPLACE(c-narrativa, CHR(13),"").

                   ASSIGN c-remetente = 'ems@intelbras.com.br'
                          c-titulo    = "Relaá∆o notas fiscais Referenciadas - " + nota-fiscal.nr-nota-fis
                          c-mensagem = c-mensagem + CHR(10) +  "Estabel " + STRING(nota-fiscal.cod-estabel)  + ";" + 
                                                               "serie: " + STRING(it-nota-fisc.serie-docum)  + ";" + 
                                                               "Nr Nota: " + STRING(it-nota-fisc.nr-docum)   + ";" + 
                                                               "Natur: " + STRING(it-nota-fisc.nat-docum)    + ";" + 
                                                               "Item: " + STRING(it-nota-fisc.it-codigo)     + ";" + 
                                                               "Desc: " + STRING(c-narrativa)                + ";" + 
                                                               "Qtd: " + STRING(it-nota-fisc.qt-faturada[2]) + ";" + 
                                                               "Pre unit: " + STRING(it-nota-fisc.vl-preuni)  + ";" + 
                                                               "Vl Tot item: " + STRING(it-nota-fisc.vl-tot-item).                    
                END.  
                
                CREATE tt-envio.
                ASSIGN tt-envio.Remetente     = c-remetente
                       tt-envio.destino       = c-email
                       tt-envio.Assunto       = c-titulo
                       tt-envio.Mensagem      = c-mensagem.
                RUN utp/utapi019.p PERSISTENT SET h-utapi019.
                FOR FIRST tt-envio:
                    EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
                    EMPTY TEMP-TABLE tt-mensagem NO-ERROR.
                    CREATE tt-envio2.
                    ASSIGN tt-envio2.versao-integracao = 1
                           tt-envio2.exchange          = param-global.log-1  
                           tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
                           tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
                           tt-envio2.destino           = tt-envio.Destino        /* Destinat·rio       */ 
                           tt-envio2.remetente         = tt-envio.Remetente      /* Remetente          */ 
                           tt-envio2.assunto           = tt-envio.Assunto        /* Assunto            */
                           tt-envio2.importancia       = 2
                           tt-envio2.log-enviada       = YES
                           tt-envio2.log-lida          = NO
                           tt-envio2.acomp             = NO
                           tt-envio2.arq-anexo         = ?
                           tt-envio2.formato           = "text". 
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.seq-mensagem = 1
                           tt-mensagem.mensagem     = tt-envio.Mensagem.         /* Mensagem de e-mail */

                    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                                   INPUT  TABLE tt-mensagem,
                                                   OUTPUT TABLE tt-erros).
                    FIND FIRST tt-erros NO-LOCK NO-ERROR.
                    IF  AVAIL tt-erros THEN DO:
                        
                        OUTPUT TO erros-comerc.LOG APPEND.
                        FOR EACH tt-erros:
                            DISP tt-erros.cod-erro
                                 tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
                        END.
                        OUTPUT CLOSE.
                    END. /* IF  AVAIL tt-erros THEN DO: */
                END. /* FOR FIRST tt-mail: */
                DELETE PROCEDURE h-utapi019.
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-notas-geradas) THEN DO:

        FIND FIRST param-global NO-LOCK.

        FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
        IF AVAILABLE usuar_mestre THEN
            ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
        
        IF cNom_from = '' THEN
            ASSIGN cNom_from = 'ems@intelbras.com.br'.

    END.

    FOR EACH tt-notas-geradas NO-LOCK,
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
              AND nota-fiscal.serie         = wt-docto.serie
              AND nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota:
        FOR EACH cli-difer NO-LOCK
            WHERE cli-difer.cod-emitente = nota-fiscal.cod-emitente
              AND cli-difer.e-mail <> "":
/*              AND cli-difer.tipo: */

           /* IF nota-fiscal.emite-dupl = NO THEN NEXT.  chamado 145337*/
            FIND emitente
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                 NO-LOCK NO-ERROR.

            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    
            FOR EACH tt-envio2:     DELETE tt-envio2.   END.
            FOR EACH tt-mensagem:   DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.exchange    = param-global.log-1 
                   tt-envio2.servidor    = param-global.serv-mail
                   tt-envio2.porta       = param-global.porta-mail
                   tt-envio2.remetente   = cNom_from
                   tt-envio2.destino     = replace(cli-difer.e-mail," ","")
                   tt-envio2.assunto     = "Cliente Diferenciado : " + STRING(nota-fiscal.cod-emitente) + " - " + emitente.nome-emit
                   tt-envio2.importancia = 2
                   tt-envio2.log-enviada = YES
                   tt-envio2.log-lida    = NO
                   tt-envio2.acomp       = NO
                   tt-envio2.arq-anexo   = ?
                   tt-envio2.formato     = "text".
    
    
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "INFORMAÄÂES REFERENTE CLIENTE DIFERENCIADO" + CHR(10).
    
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 2
                   tt-mensagem.mensagem     = "Cliente ...: " + STRING(nota-fiscal.cod-emitente) + " - " + nota-fiscal.nome-ab-cli + " - " + emitente.nome-emit + CHR(10).
            
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 3
                   tt-mensagem.mensagem     = "Nota Fiscal: " + nota-fiscal.nr-nota-fis + CHR(10).
    
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 4
                   tt-mensagem.mensagem     = "Valor Total: " + string(nota-fiscal.vl-tot-nota) + CHR(10).

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 5
                   tt-mensagem.mensagem     = "Nr Volumes: " + string(nota-fiscal.nr-volumes) + CHR(10).


            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 6
                   tt-mensagem.mensagem     = "Nome Transp: " + string(nota-fiscal.nome-transp) + CHR(10) + CHR(10).
            
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 7
                   tt-mensagem.mensagem     = IF nota-fiscal.emite-dupl then
                                                 "Emite dupl : Sim "  + CHR(10) + CHR(10)
                                              ELSE
                                                 "Emite dupl : N∆o "  + CHR(10) + CHR(10).
            
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 8
                   tt-mensagem.mensagem     = cli-difer.descricao + CHR(10).
    
            RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).
    
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'envemail-fatur.txt') APPEND.
            IF RETURN-VALUE = "NOK" THEN DO:
                FOR EACH tt-erros:
                    PUT "Erro no envio de email Cliente Diferenciado (bodi317ef)- NOta =  " nota-fiscal.nr-nota-fis " / " nota-fiscal.serie " / " nota-fiscal.cod-estabel SKIP.
                    PUT tt-erros.desc-erro SKIP.
                END.
                ASSIGN lErro = YES.
            END.
            OUTPUT CLOSE.
    
            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.

        END.
        
        IF nota-fiscal.cod-estabel = "105" AND
           nota-fiscal.emite-duplic = YES THEN DO:

            
            FIND natur-oper
                    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao 
                    NO-LOCK NO-ERROR.
            IF AVAIL natur-oper AND
               natur-oper.tipo = 2 THEN DO:

               
                ASSIGN c-email-destino = "".

                IF CAN-find(FIRST cont-emit no-lock
                    where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      and (cont-emit.nome        BEGINS 'NFE'
                       or cont-emit.nome         BEGINS 'NF-e')) THEN DO:
                    FOR each cont-emit no-lock
                        where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                          and (cont-emit.nome        BEGINS 'NFE'
                           or cont-emit.nome         BEGINS 'NF-e'):
                       IF c-email-destino = "" THEN
                          ASSIGN c-email-destino = trim(cont-emit.e-mail).
                       ELSE
                          ASSIGN c-email-destino = trim(c-email-destino) + "," + trim(cont-emit.e-mail).
                   END.
                END.
                ELSE DO:
                    find first b-emitente no-lock
                         where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
                    ASSIGN c-email-destino = b-emitente.e-mail.
                END.
                
/*                 FIND ped-venda                                            */
/*                      WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli    */
/*                        AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli */
/*                      NO-LOCK NO-ERROR.                                    */
/*                 FIND atendente                                                 */
/*                      WHERE atendente.cd-oper =  int(ped-venda.tp-pedido)              */
/*                      NO-LOCK NO-ERROR.                                                */
/*                 IF AVAIL atendente AND                                                */
/*                     atendente.email <> "" THEN                                        */
/*                     ASSIGN c-email-destino = c-email-destino + "," + atendente.email. */

                

                IF c-email-destino <> "" THEN DO:

                    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
                    
                    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
                    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.
            
                    CREATE tt-envio2.
                    ASSIGN tt-envio2.versao-integracao = 1
                           tt-envio2.exchange    = param-global.log-1 
                           tt-envio2.servidor    = param-global.serv-mail
                           tt-envio2.porta       = param-global.porta-mail
                           tt-envio2.remetente   = "nfesaida@intelbras.com.br"
                           tt-envio2.destino     = c-email-destino
                           tt-envio2.assunto     = "Nota Fiscal Emitida de Manaus - Recolhimento ST"
                           tt-envio2.importancia = 2
                           tt-envio2.log-enviada = YES
                           tt-envio2.log-lida    = NO
                           tt-envio2.acomp       = NO
                           tt-envio2.arq-anexo   = ?
                           tt-envio2.formato     = "text".
            
            
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.seq-mensagem = 1
                           tt-mensagem.mensagem     = "Prezado Cliente, foi emitido a nf " + nota-fiscal.nr-nota-fis  + " com sa°da de Manaus." + CHR(10). 
            
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.seq-mensagem = 2
                           tt-mensagem.mensagem     = "Favor verificar se deve ser recolhido ST. Neste caso efetuar o recolhimento evitando atrasos ou cancelamento da NF que ser† no prazo m†ximo de 8 dias." + CHR(10).
                    
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.seq-mensagem = 3
                           tt-mensagem.mensagem     = "Favor encaminhar o comprovante de pagamento para o e-mail grupo.expedicao_manaus@intelbras.com.br." + CHR(10) + CHR(10).
            
                    CREATE tt-mensagem.
                    ASSIGN tt-mensagem.seq-mensagem = 4
                           tt-mensagem.mensagem     = " Caso n∆o se enquadre nesta situaá∆o, favor desconsiderar este e-mail." + CHR(10) + CHR(10).
                                                      
            
                    
                    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).
            
                    

                    IF RETURN-VALUE = "NOK" THEN DO:
                        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'envemail-fatur.txt') APPEND.
                        FOR EACH tt-erros:
                            PUT tt-erros.desc-erro SKIP.
                        END.
                        ASSIGN lErro = YES.
                        OUTPUT CLOSE.
                    END.
                    
            
                    IF VALID-HANDLE(h-utapi019) THEN
                        DELETE PROCEDURE h-utapi019.
                END.
            END.
        END.

    END.


    IF lErro  THEN DO:
        PUT "Erro no envio de email Cliente Diferenciado (bodi317ef)- NOta =  " FORMAT "x(80)"
             nota-fiscal.nr-nota-fis " / " nota-fiscal.serie " / " nota-fiscal.cod-estabel SKIP.
   END.


END PROCEDURE.

PROCEDURE pi-atualiza-transp:

    RUN pi-gerar-dados-extrato ("pi-atualiza-transp").
    /* atualiza transportadora das notas de faturamento de operacao triangular - conta e ordem */
    FOR EACH tt-notas-geradas NO-LOCK,
       FIRST nota-fiscal EXCLUSIVE-LOCK
       WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
         AND nota-fiscal.serie         = wt-docto.serie
         AND nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota:


        RUN pi-gerar-dados-extrato ("pi-atualiza-transp tt-notas-geradas.nr-nota: " + STRING(tt-notas-geradas.nr-nota)).

        RUN pi-gerar-dados-extrato ("pi-atualiza-transp nota-fiscal.nr-pedcli: " + STRING(nota-fiscal.nr-pedcli)).
        RUN pi-gerar-dados-extrato ("pi-atualiza-transp nota-fiscal.nome-ab-cli: " + STRING(nota-fiscal.nome-ab-cli)).

        FIND FIRST ped-venda NO-LOCK 
             WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
               AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.  

        FIND FIRST natur-oper NO-LOCK 
             WHERE natur-oper.nat-operacao    = nota-fiscal.nat-operacao NO-ERROR.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

        ASSIGN c-nat-vinculada   = ""
               c-nome-abrev-tri  = ""
               c-cod-entrega-tri = "".

        IF  AVAIL natur-oper 
        AND natur-oper.log-oper-triang = YES THEN DO:        

           ASSIGN c-nat-vinculada   = natur-oper.nat-vinculada
                  c-nome-abrev-tri  = ped-venda.nome-abrev-tri
                  c-cod-entrega-tri = ped-venda.cod-entrega-tri.

           FIND FIRST transporte NO-LOCK 
                WHERE transporte.cod-transp = 0 NO-ERROR.
           IF AVAIL transporte THEN
              ASSIGN nota-fiscal.cod-rota    = ""
                     nota-fiscal.cidade-cif  = ""
                     nota-fiscal.nome-transp = transporte.nome-abrev
                     nota-fiscal.nome-tr-red = "".   /* redespacho */
        END.

        IF c-nat-vinculada = nota-fiscal.nat-operacao AND c-nome-abrev-tri = nota-fiscal.nome-ab-cli THEN DO:

            IF  c-nat-vinculada = nota-fiscal.nat-operacao    
            AND c-nome-abrev-tri = nota-fiscal.nome-ab-cli THEN DO:
                FOR FIRST loc-entr NO-LOCK
                    WHERE loc-entr.cod-entrega = c-cod-entrega-tri 
                      AND loc-entr.nome-abrev  = c-nome-abrev-tri:
                END.

                ASSIGN c-nat-vinculada   = ""
                       c-nome-abrev-tri  = ""
                       c-cod-entrega-tri = "".
            END.
            ELSE DO:
                FOR FIRST loc-entr NO-LOCK
                    WHERE loc-entr.cod-entrega = ped-venda.cod-entrega
                      AND loc-entr.nome-abrev  = ped-venda.nome-abrev:
                END.
            END.
  
            IF  AVAIL loc-entr THEN DO:
                ASSIGN nota-fiscal.cod-entrega  = loc-entr.cod-entrega
                       nota-fiscal.bairro       = loc-entr.bairro
                       nota-fiscal.cep          = loc-entr.cep
                       nota-fiscal.cgc          = loc-entr.cgc
                       nota-fiscal.cidade       = loc-entr.cidade
                       nota-fiscal.endereco     = loc-entr.endereco
                       nota-fiscal.estado       = loc-entr.estado
                       nota-fiscal.ins-estadual = loc-entr.ins-estadual
                       nota-fiscal.pais         = loc-entr.pais
                       nota-fiscal.zip-code     = loc-entr.zip-code.
                       &IF DEFINED (bf_dis_drop_shipment) &THEN
                           assign nota-fiscal.endereco_text = loc-entr.endereco_text.
                       &ENDIF
            END.
        END.

        /* tratamento para pedido VTEX, quando transportadora Ç retira */
        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        RUN pi-gerar-dados-extrato ("AVAIL int-ped-venda2: " + STRING(AVAIL int-ped-venda2)).
        IF  AVAIL int-ped-venda2 AND int-ped-venda2.PedidoeCommerce <> "" AND nota-fiscal.nome-tr-red BEGINS "RETIRA" THEN DO:

            FIND b-tranp-redes NO-LOCK
                WHERE b-tranp-redes.nome-abrev = nota-fiscal.nome-tr-red NO-ERROR.


            RUN pi-gerar-dados-extrato ("avail b-tranp-redes: " + STRING(AVAIL b-tranp-redes)).
            IF  AVAIL b-tranp-redes THEN
                FIND FIRST b-emitente_red NO-LOCK
                    WHERE b-emitente_red.cgc =  b-tranp-redes.cgc NO-ERROR.

            RUN pi-gerar-dados-extrato ("nota-fiscal.nome-tr-red: " + STRING(nota-fiscal.nome-tr-red)).

            RUN pi-gerar-dados-extrato ("b-emitente_red: " + STRING(AVAIL b-emitente_red)).

            IF  AVAIL b-emitente_red THEN DO:
                FIND FIRST int-loc-entr
                    WHERE int-loc-entr.nome-abrev = b-emitente_red.nome-abrev
                      AND int-loc-entr.cod-entrega = "Padr∆o" NO-LOCK NO-ERROR.
                FIND FIRST loc-entr
                     WHERE loc-entr.nome-abrev  = b-emitente_red.nome-abrev
                       AND loc-entr.cod-entrega = "Padr∆o" NO-LOCK NO-ERROR.   

                ASSIGN nota-fiscal.cod-entrega  = loc-entr.cod-entrega
                       nota-fiscal.bairro       = loc-entr.bairro
                       nota-fiscal.cep          = loc-entr.cep
                       /*nota-fiscal.cgc          = loc-entr.cgc*/
                       nota-fiscal.cidade       = loc-entr.cidade
                       nota-fiscal.endereco     = loc-entr.endereco
                       nota-fiscal.estado       = loc-entr.estado
                       /*nota-fiscal.ins-estadual = loc-entr.ins-estadual*/
                       nota-fiscal.pais         = loc-entr.pais
                       nota-fiscal.zip-code     = loc-entr.zip-code.
                       &IF DEFINED (bf_dis_drop_shipment) &THEN
                           assign nota-fiscal.endereco_text = loc-entr.endereco_text.
                       &ENDIF

                 RUN pi-gerar-dados-extrato ("nota-fiscal.cod-entrega..: " + STRING(nota-fiscal.cod-entrega)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.bairro.......: " + STRING(nota-fiscal.bairro)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.cep..........: " + STRING(nota-fiscal.cep)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.cidade.......: " + STRING(nota-fiscal.cidade)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.endereco.....: " + STRING(nota-fiscal.endereco)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.estado.......: " + STRING(nota-fiscal.estado)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.pais.........: " + STRING(nota-fiscal.pais)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.zip-code.....: " + STRING(nota-fiscal.zip-code)).
                 RUN pi-gerar-dados-extrato ("nota-fiscal.endereco_text: " + STRING(nota-fiscal.endereco_text)).


            END.

        END.

    END.
END PROCEDURE.

PROCEDURE pi-atualiza-observ:
    DEFINE VARIABLE i-indice                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-acum-vl-merc-ori     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-ger-inssretido       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-ger-pisretido        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-ger-cofinsretido     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-ger-csllretido       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-protocolo-icms        AS CHAR        NO-UNDO.
    DEFINE VARIABLE c-observ-concat-pedidos AS CHAR FORMAT "x(500)" NO-UNDO.

    DEFINE BUFFER b-ped-venda-obs FOR ped-venda.

/*  FOR EACH b-class-fis:   DELETE b-class-fis. END.*/

    FOR EACH tt-notas-geradas NO-LOCK,
        FIRST nota-fiscal exclusive-LOCK
            WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
              AND nota-fiscal.serie         = wt-docto.serie
              AND nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota:

        IF INDEX(nota-fiscal.observ-nota, "Cod.Cliente:") = 0 THEN DO: /* Significa que ja gravou a mensagem, ou seja ja passou por aqui */
            ASSIGN 
               de-cotacao           = 0
               de-tot-ipi-nota      = 0
               de-tot-ipi-calc      = 0
               de-tot-icmssubs-obs  = 0
               de-tot-bicmssubs-obs = 0
               de-tot-icms-obs      = 0
               de-tot-ipi-dev-obs   = 0
               i-codigo             = 0
               c-mensagem1          = ""
               c-mensagem2          = ""
               c-especie            = "VOLUME"
               c-nat                = " "
               c-num-nota           = " "
               c-num-duplic         = " "
               de-ger-pisretido     = 0
               de-ger-cofinsretido  = 0
               de-ger-csllretido    = 0
               de-acum-vl-merc-ori  = 0
               de-ger-inssretido    = 0.
            ASSIGN i-indice = 0.    
            FIND estabelec OF nota-fiscal NO-LOCK NO-ERROR.

            find emitente where emitente.nome-abrev  = nota-fiscal.nome-ab-cli no-lock no-error.

            find natur-oper where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.

            find first cidade-zf no-lock
                where cidade-zf.cidade = nota-fiscal.cidade
                  and cidade-zf.estado = nota-fiscal.estado no-error.

            /**---------------CODIGO SUFRAMA---------------*/
            IF AVAILABLE cidade-zf THEN 
                ASSIGN c-cod-suframa-est = estabelec.cod-suframa
                       c-cod-suframa-cli = emitente.cod-suframa.
            ELSE
                ASSIGN c-cod-suframa-est = ""
                       c-cod-suframa-cli = "".


            IF c-cod-suframa-cli = "" THEN DO:
                FIND FIRST ponto-programa
                    WHERE ponto-programa.nome-programa = "bodi317ef":U
                      AND ponto-programa.ponto         = 3 NO-LOCK NO-ERROR.
                
                IF AVAILABLE ponto-programa THEN DO:
                    FOR EACH conteudo-programa
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:

                        IF conteudo-programa.conteudo = nota-fiscal.estado THEN DO:
                            
                           ASSIGN c-cod-suframa-cli = emitente.cod-suframa.
                           LEAVE.
                        END.
                    END.
                END.
            END.

            /*--------------------------------------------*/

            FOR EACH item-nota exclusive-lock:
                delete item-nota.
            END.

            FOR EACH it-nota-fisc of nota-fiscal NO-LOCK,
                EACH item NO-LOCK
                WHERE item.it-codigo = it-nota-fisc.it-codigo:

                ASSIGN r-it-nota           = rowid(it-nota-fisc)
                       r-natur-oper        = rowid(natur-oper)
                       r-nota-fiscal       = rowid(nota-fiscal)
                       r-item              = rowid(item)
                       de-acum-vl-merc-ori = de-acum-vl-merc-ori + it-nota-fisc.vl-merc-ori. /* Este acumulador ≤ para o cˇlculo de valor de PIS e COFINS do trecho OBS PIS/COFINS MANAUS. Autor: Pedro Faraco.*/



                ASSIGN de-ger-csllretido   = de-ger-csllretido   + it-nota-fisc.val-retenc-csll
                       de-ger-pisretido    = de-ger-pisretido    + it-nota-fisc.val-retenc-pis
                       de-ger-cofinsretido = de-ger-cofinsretido + it-nota-fisc.val-retenc-cofins
                       de-ger-inssretido   = de-ger-inssretido   + it-nota-fisc.vl-ir-adic.

                IF SUBSTRING(it-nota-fisc.nat-operacao,1,3) <> SUBSTRING(nota-fiscal.nat-operacao,1,3) THEN DO:
                    FIND natur-oper WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.
                    {cdp/cd0620.i1 nota-fiscal.cod-estabel}
                    ASSIGN c-nat = {cdp/cd0620.i2 natur-oper nota-fiscal.dt-emis-nota "'XXXX'" "'XXX'"}. 
                END.

                RUN ftp/ft0515a.p (INPUT r-it-nota, output i-codigo, output l-sub).

                IF SUBSTRING(natur-oper.nat-operacao,1,4) <> "5933" AND
                   SUBSTRING(natur-oper.nat-operacao,1,4) <> "6933" AND
                   SUBSTRING(natur-oper.nat-operacao,1,4) <> "7933" THEN
                    RUN ftp/ft0515d.p (INPUT r-it-nota, IF AVAILABLE cidade-zf THEN rowid(cidade-zf) ELSE ?).
            END.

            FIND natur-oper WHERE ROWID(natur-oper) = r-natur-oper NO-LOCK NO-ERROR.

            ASSIGN r-nota-fiscal = rowid(nota-fiscal).

            /*------  ObservaªÑes do pedido  ------*/

            /**** BUSCANDO O PEDIDO DO ITEM DA NOTA FISCAL POIS TAMB»M TEM QUE IMPRIMIR
                  A MENSAGEM DO PEDIDO NA NOTA FISCAL DE REMESSA.
                  E O NUMERO DO PEDIDO ESTA GRAVADO SOMENTE NO ITEM DA NOTA   *******/
            FOR FIRST ponto-programa
                WHERE ponto-programa.nome-programa = "bodi317ef":U
                  AND ponto-programa.ponto         = 5 NO-LOCK,
                FIRST conteudo-programa
                WHERE conteudo-programa.cod-programa  = ponto-programa.cod-programa 
                  AND conteudo-programa.sequencia     = nota-fiscal.cod-canal-venda NO-LOCK:
                   ASSIGN nota-fiscal.observ-nota = "C/C " + TRIM(conteudo-programa.conteudo) + "-" +  nota-fiscal.observ-nota.
                
            END.

            FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK NO-ERROR. 

            FIND FIRST ped-venda NO-LOCK
                WHERE ped-venda.nr-pedido = it-nota-fisc.nr-pedido NO-ERROR.

            /*
            IF AVAILABLE ped-venda AND ped-venda.cond-espec <> "" THEN DO:
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(ped-venda.cond-espec).
            END.
            */
            IF l-ativa-log THEN
                PUT "cond-espec " nota-fiscal.observ-nota SKIP.

                /*------  VERIFICA A CLASSIFICACAO FISCAL DO ITEM  ------*/

            assign l-tem-portaria = NO
                   l-nao-tem-portaria = NO
                   l-software = NO.
            
            ASSIGN c-protocolo-icms = ""
                   c-desc-portaria  = "".

            for each it-nota-fisc of nota-fiscal no-lock,
                first item no-lock where item.it-codigo = it-nota-fisc.it-codigo:
                FOR FIRST natur-oper
                    WHERE natur-oper.nat-operacao    = it-nota-fisc.nat-operacao NO-LOCK:
                END.

                IF (SUBSTRING(ITEM.fm-codigo, 7, 2) = '30' 
                    OR SUBSTRING(ITEM.fm-codigo, 7, 2) = '32'
                    OR SUBSTRING(ITEM.fm-codigo, 7, 2) = '33'
                    OR SUBSTRING(ITEM.fm-codigo, 7, 2) = '34') AND natur-oper.cd-trib-ipi = 1 THEN
                    ASSIGN l-tem-portaria = YES.
                ELSE IF (SUBSTRING(item.fm-codigo, 7, 2) = '60'
                         OR SUBSTRING(ITEM.fm-codigo, 7, 2) = '61') THEN
                    ASSIGN l-software = YES.
                ELSE
                    ASSIGN l-nao-tem-portaria = YES. 

                FIND LAST int-portaria-movto NO-LOCK
                    WHERE int-portaria-movto.it-codigo     = it-nota-fisc.it-codigo  
                      AND int-portaria-movto.cod-estabel   = it-nota-fisc.cod-estabel        
                      AND int-portaria-movto.dt-fim        = ?
                      AND int-portaria-movto.classificacao = "DEF" NO-ERROR.
                IF NOT AVAIL int-portaria-movto THEN
                    FIND LAST int-portaria-movto NO-LOCK
                        WHERE int-portaria-movto.it-codigo     = it-nota-fisc.it-codigo  
                          AND int-portaria-movto.cod-estabel   = it-nota-fisc.cod-estabel       
                          AND int-portaria-movto.dt-fim        = ?
                          AND int-portaria-movto.classificacao = "PROV" NO-ERROR.
                IF AVAIL int-portaria-movto THEN DO:
                    ASSIGN l-tem-portaria = YES.

                    IF NOT c-desc-portaria MATCHES ("*" + int-portaria-movto.codigo + "*") THEN
                        IF c-desc-portaria = "" THEN
                            ASSIGN c-desc-portaria = int-portaria-movto.codigo.
                        ELSE ASSIGN c-desc-portaria = c-desc-portaria + ", " + int-portaria-movto.codigo.

                END.
                
                /* IR68336 */
                FIND item-uf NO-LOCK 
                    WHERE item-uf.it-codigo           = it-nota-fisc.it-codigo
                      AND item-uf.cod-estado-orig     = estabelec.estado
                      AND item-uf.estado              = nota-fiscal.estado NO-ERROR.
                IF  AVAIL item-uf THEN
                    for first int-item-uf
                        where int-item-uf.it-codigo       = item-uf.it-codigo      
                        and   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                        and   int-item-uf.estado          = item-uf.estado          NO-LOCK:
                    end.
    
                /* Localizacao dos dados da relacao item X UF do item do documento */
                IF  nota-fiscal.esp-docto     = 20 /* Devoluá∆o a fornecedor */
                AND nota-fiscal.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                    for first int-unid-feder
                        where int-unid-feder.pais         = estabelec.pais
                        and   int-unid-feder.estado       = estabelec.estado  no-lock:
                    end.
                else 
                    for first int-unid-feder
                        where int-unid-feder.pais         = wt-docto.pais
                        and   int-unid-feder.estado       = wt-docto.estado  no-lock:
                    end.
    
    
                If AVAIL item-uf and
                   AVAIL natur-oper AND
                   natur-oper.consum-final = YES  AND
                   emitente.contrib-icms   = YES  AND
                   AVAIL int-item-uf              AND
                   int-item-uf.perc-credito-interno > 0 THEN DO:
                    /* Nao fazer Nada */
    
                END.
                ELSE /* Reuá∆o de base (dc0904) para optantes do Simples em SP */
                    IF      /*AVAIL int-item-uf
                              AND int-item-uf.perc-credito-interno > 0*/ /*Retirado conforme solicitado por Thiago (fiscal)*/ 
                        avail item-uf
                    and item-uf.perc-red-sub > 0
                    AND AVAIL int-unid-feder 
                    AND int-unid-feder.simples-nao-red-base  /* cd0904*/
                    AND int-emitente.ind-forma-tributo = 3 THEN DO:
    
                        /* Nao fazer Nada */
                    END.
                    ELSE
                        IF AVAIL item-uf  THEN DO:
                            FIND int-item-uf NO-LOCK
                                 WHERE int-item-uf.estado          = item-uf.estado
                                   AND int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                                   AND int-item-uf.it-codigo       = item-uf.it-codigo NO-ERROR.
    
                            IF AVAIL INT-item-uf AND
                               AVAIL int-item-uf AND
                               int-item-uf.perc-credito-interno > 0 THEN DO:
                                
                                /* Localizacao dos dados da relacao item X UF do item do documento */
                                IF  wt-docto.esp-docto     = 20 /* Devoluá∆o a fornecedor */
                                AND wt-docto.ind-tip-nota <> 8  /* Nota do Recebimento */ THEN
                                    for first int-unid-feder
                                        where int-unid-feder.pais         = estabelec.pais
                                        and   int-unid-feder.estado       = estabelec.estado  no-lock:
                                    end.
                                else
                                    for first int-unid-feder
                                        where int-unid-feder.pais         = nota-fiscal.pais
                                        and   int-unid-feder.estado       = nota-fiscal.estado  no-lock:
                                    end.
    
                                IF AVAIL int-unid-feder                      AND
                                   int-unid-feder.perc-red-subst-simples > 0 and
                                   AVAIL int-emitente                        AND
                                   item-uf.dec-1 >= 17                       AND /* Chamado IR 68336 */ 
                                   int-emitente.ind-forma-tributo = 3        THEN DO:

                                    FIND FIRST mensagem NO-LOCK
                                         WHERE mensagem.cod-mensagem = 87 NO-ERROR. /*c¢digo da mensagem dispositivo*/

                                     IF  AVAIL mensagem AND mensagem.cod-mensagem <> 0 AND INDEX(nota-fiscal.observ-nota, mensagem.texto-mensag) = 0 THEN
                                         ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(mensagem.texto-mensag).


                                END.
                            END.
                        END.


                    /* Fim */       

                /**************** Adiciona o protocolo de ICMS na observaá∆o ******************/
                IF natur-oper.subs-trib THEN DO:

                    FOR FIRST int-item-uf NO-LOCK
                       WHERE int-item-uf.it-codigo       = it-nota-fisc.it-codigo
                         AND int-item-uf.cod-estado-orig = estabelec.estado
                         AND int-item-uf.estado          = nota-fiscal.estado
                         AND int-item-uf.protocolo       <> "":

                        IF INDEX(c-protocolo-icms,int-item-uf.protocolo) = 0 THEN DO:
                            IF c-protocolo-icms = "" THEN
                                ASSIGN c-protocolo-icms = int-item-uf.protocolo.
                            ELSE ASSIGN c-protocolo-icms = c-protocolo-icms + ";" + int-item-uf.protocolo.
                        END.
                    END.

                    /* Mesagem do dispositivo legal, escdp050*/
                    FOR FIRST item-uf-sem-prot NO-LOCK
                        WHERE item-uf-sem-prot.it-codigo       = it-nota-fisc.it-codigo
                          AND item-uf-sem-prot.cod-estado-orig = estabelec.estado
                          AND item-uf-sem-prot.estado          = nota-fiscal.estado
                        ,FIRST int-item-uf NO-LOCK
                            WHERE int-item-uf.it-codigo       = item-uf-sem-prot.it-codigo      
                              AND int-item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig
                              AND int-item-uf.estado          = item-uf-sem-prot.estado:         
                         
                         FIND FIRST mensagem NO-LOCK
                             WHERE mensagem.cod-mensagem = item-uf-sem-prot.int-1 NO-ERROR. /*c¢digo da mensagem dispositivo*/
    
                         IF  AVAIL mensagem AND mensagem.cod-mensagem <> 0 AND INDEX(nota-fiscal.observ-nota, mensagem.texto-mensag) = 0 THEN
                             ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(mensagem.texto-mensag).
                         
                    END.
                END.

                IF it-nota-fisc.nr-pedcli <> "" THEN DO:
                    IF c-ped-cli = "" THEN
                        ASSIGN c-ped-cli = " Pedido(s): ".
                    IF LOOKUP(it-nota-fisc.nr-pedcli,c-ped-cli) = 0 THEN
                        ASSIGN c-ped-cli = c-ped-cli + (IF c-ped-cli = " Pedido(s): " THEN "" ELSE ",") + it-nota-fisc.nr-pedcli.
                END.

                /* CONCATERNA OBSERVAÄÂES DO PEDIDO DE VENDA DE CADA ITEM (JUTNA PEDIDOS ATIVADO) */
                FOR FIRST b-ped-venda-obs NO-LOCK
                    WHERE b-ped-venda-obs.nr-pedido = it-nota-fisc.nr-pedido:

                    IF  b-ped-venda-obs.cond-espec <> "" 
                    AND INDEX(c-observ-concat-pedidos, b-ped-venda-obs.cond-espec) = 0    
                    THEN
                        ASSIGN c-observ-concat-pedidos = c-observ-concat-pedidos + " " + b-ped-venda-obs.cond-espec + " ".
                END.
                
            END.

            IF TRIM(c-protocolo-icms) <> "" THEN
                ASSIGN nota-fiscal.observ-nota = "Protocolo ICMS Nr: " + REPLACE(c-protocolo-icms,";",", ") + " " + nota-fiscal.observ-nota.

            ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + c-ped-cli + ".".
                   c-ped-cli               = "".

           IF  c-observ-concat-pedidos <> "" THEN
               ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + c-observ-concat-pedidos + ' ' .

            /*------  CODIGO DE MENSAGEM DA NOTA FISCAL  ------*/
            IF nota-fiscal.cod-mensagem <> 20 OR emitente.estado <> "sc" OR l-nao-tem-portaria THEN DO:
                FOR FIRST mensagem FIELDS(texto-mensag) NO-LOCK 
                    WHERE mensagem.cod-mensag = nota-fiscal.cod-mensagem.
                    IF mensagem.texto-mensag <> '' THEN
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(mensagem.texto-mensag).
                END.
            END.
            
            EMPTY TEMP-TABLE tt-controla-mensagem.

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                
                FIND FIRST b-natur-oper NO-LOCK
                     WHERE b-natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.

                FIND FIRST tt-controla-mensagem
                     WHERE tt-controla-mensagem.cod-mensagem = b-natur-oper.cod-mensagem NO-ERROR.

                IF  NOT AVAIL tt-controla-mensagem
                AND b-natur-oper.cod-mensagem <> nota-fiscal.cod-mensagem THEN DO:
                    CREATE tt-controla-mensagem.
                    ASSIGN tt-controla-mensagem.cod-mensagem = b-natur-oper.cod-mensagem.
                END.
            END.

            FOR EACH tt-controla-mensagem:
                FIND FIRST mensagem NO-LOCK
                     WHERE mensagem.cod-mensagem = tt-controla-mensagem.cod-mensagem NO-ERROR.
                
                IF AVAIL mensagem THEN DO:
                    IF  INDEX(nota-fiscal.observ-nota, mensagem.texto-mensag) = 0 THEN
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(mensagem.texto-mensag).
                END.
            END.
            
            IF l-ativa-log THEN
                PUT "cod-mensagem " nota-fiscal.observ-nota SKIP.

            /** Solicitaªío do Rog≤rio em 27.08.2007 **/
            IF (l-software) THEN DO:
                FOR FIRST mensagem FIELDS(texto-mensag) NO-LOCK 
                    WHERE mensagem.cod-mensag = 93.
                    IF mensagem.texto-mensag <> '' THEN
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(mensagem.texto-mensag).
                END.
            END.

            IF (l-tem-portaria) THEN DO:

                IF c-desc-portaria <> "" THEN
                   /* ASSIGN nota-fiscal.observ-nota = "Produto beneficiado pela Lei nß 8.248/91 com as modificaá‰es da Lei nß 13.969/2019 e conf. Decreto 5.906/06 - Portaria " + c-desc-portaria + " | Produto fabricado no estab. CNPJ " + estabelec.cgc + " | " + 
                                                     "Portaria de Habilitaá∆o no estab. 101 - CNPJ 82.901.000/0001-27 solicitada transferància de titularidade do estabelecimento 101 para 104 em 19/05/2020, Processo nß 01250.021778/2020-25." + " | " + nota-fiscal.observ-nota. */

                   /* ASSIGN nota-fiscal.observ-nota =  nota-fiscal.observ-nota + " | Produto beneficiado pela Lei n 8.248/91 com as modificaá‰es da Lei n 13.969/2019 e conf. Decreto 5.906/06 Œ portaria " + c-desc-portaria +  " | Produto Fabricado no estab "  + nota-fiscal.cod-estabel +
                                                     "| CNPJ " + IF nota-fiscal.cod-estabel = "103" THEN "82.901.000/0016-03" ELSE "82.901.000/0014-41 ". */

                    IF (nota-fiscal.cod-estabel = "601" OR nota-fiscal.cod-estabel = "602") THEN DO:
                        ASSIGN nota-fiscal.observ-nota =  nota-fiscal.observ-nota + " | " + " Produto fabricado pela DÇcio, nos termos das Leis nß 8.248/91 e Lei n 13.969/19, regulamentadas pelos Decretos 5.906/06 e 10.356/20. A relaá∆o completa de produtos pode ser consultada na p†gina do MinistÇrio da Ciància, Tecnologia e Inovaá‰es (MCTI).".
                    END.
                    ELSE DO:
                        ASSIGN nota-fiscal.observ-nota =  nota-fiscal.observ-nota + " | " + " Produto fabricado pela Intelbras, nos termos das Leis nß 8.248/91 e Lei n 13.969/19, regulamentadas pelos Decretos 5.906/06 e 10.356/20. A relaá∆o completa de produtos pode ser consultada na p†gina do MinistÇrio da Ciància, Tecnologia e Inovaá‰es (MCTI).".
                    END.

            END.

            /*-------- IMPRIME O CODIGO SUFRAMA DO CLIENTE E DO ESTABELECIMENTO ---------*/

            if c-cod-suframa-est <> "" THEN 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Reg. do Estabelecimento na SUFRAMA: " + c-cod-suframa-est.
            if c-cod-suframa-cli <> "" THEN 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Reg. do Cliente na SUFRAMA: " + c-cod-suframa-cli.

            if recid(cidade-zf) <> ? then do:
                if can-find(first it-nota-fisc of nota-fiscal 
                            WHERE it-nota-fisc.nat-operacao begins "6") 
                AND dec(substring(natur-oper.char-2,66,5)) <> 0 then do:

                    assign de-conv = (100 - dec(SUBSTRING(natur-oper.char-2,66,5))) / 100.
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "DESC.ICMS ZFM " 
                                                                                   + string(dec(SUBSTRING(natur-oper.char-2,66,5)), ">9.99")
                                                                                   + "% = " + string(TRUNCATE(nota-fiscal.vl-mercad / de-conv , 2)
                                                                                   - nota-fiscal.vl-mercad, ">>>>>>9.99").                                        
                end.                           
            end.

            /*------    ------*/
            find first tab-ocor no-lock 
                where tab-ocor.cod-tab   = 105 
                    and tab-ocor.descricao = estabelec.cod-estabel no-error.
            if avail tab-ocor and tab-ocor.c-campo[1] <> "" then
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Cod.Repart.Fiscal: " + tab-ocor.c-campo[1].


            /*------  SUBSTITUICAO TRIBUTARIA  ------*/
            if de-tot-icmssubs-obs > 0 THEN DO:

/*                 IF  INDEX(nota-fiscal.observ-nota, "Retido na fonte por Subst") = 0 THEN         */ /* REtirado porque no EMS PADRAO JA INSERE ESTA MENSAGEM                                                   */
/*                                                                                                                      */
/*                     ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "ICMS  Retido na fonte por Substituicao Tributaria com base: " */
/*                                                                                    + STRING(de-tot-bicmssubs-obs, ">>>,>>>,>>9.99")                 */
/*                                                                                    + " e valor: "                                                   */
/*                                                                                    + STRING(de-tot-icmssubs-obs, ">>>,>>>,>>9.99").                 */
/*                 IF emitente.estado = "MG" THEN                                                                                    */
/*                     ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "SUBSTITUTO TRIBUTARIO/MG: 168.363566.0090"  */
/*                            nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "REGIME ESPECIAL / PTA: 16.000128134-66".    */

                if estabelec.estado = "SP" and emitente.estado  = "SP" THEN 
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Valor do ICMS: " 
                                                                                   + STRING(de-tot-icms-obs, ">>>,>>>,>>9.99").
            END.

            /*------  VALOR DO IPI SOBRE AS DESPESAS  ------*/
            if de-tot-ipi-calc > 0 THEN 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Valor do IPI sobre Despesas acessorias..: " 
                                                                               + STRING(de-tot-ipi-nota - de-tot-ipi-calc ,">>>>>>>>>9.99").
            

/*             if  ((nota-fiscal.cidade = "Manaus"          AND nota-fiscal.estado = "AM") OR                                                              */
/*                  (nota-fiscal.cidade = "Tabatinga"       AND nota-fiscal.estado = "AM") OR                                                              */
/*                  (nota-fiscal.cidade = "Guajara-Mirim"   AND nota-fiscal.estado = "RO") OR                                                              */
/*                  (nota-fiscal.cidade = "Epitaciolandia"  AND nota-fiscal.estado = "AC") OR                                                              */
/*                  (nota-fiscal.cidade = "Boa Vista"       AND nota-fiscal.estado = "RR") OR                                                              */
/*                  (nota-fiscal.cidade = "Bonfim"          AND nota-fiscal.estado = "RR") OR                                                              */
/*                  (nota-fiscal.cidade = "Macapa"          AND nota-fiscal.estado = "AP") OR                                                              */
/*                  (nota-fiscal.cidade = "Santana"         AND nota-fiscal.estado = "AP") OR                                                              */
/*                  (nota-fiscal.cidade = "Brasileia"       AND nota-fiscal.estado = "AC") OR                                                              */
/*                  (nota-fiscal.cidade = "Cruzeiro do Sul" AND nota-fiscal.estado = "AC")) and                                                            */
/*                 nota-fiscal.emite-duplic = Yes then do:  /* Testa se a cidade da NF ≤ Manaus e se a NF emite duplicata */                               */
/*                                                                                                                                                         */
/*                 IF nota-fiscal.observ-nota = ? THEN                                                                                                     */
/*                     ASSIGN nota-fiscal.observ-nota =  "PIS: " + string((de-acum-vl-merc-ori * 0.0165), ">>>>>>9.99")                                    */
/*                                                     + "  -  COFINS: " + string((de-acum-vl-merc-ori * 0.076), ">>>>>>9.99").                            */
/*                 ELSE                                                                                                                                    */
/*                     ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "PIS: " + string((de-acum-vl-merc-ori * 0.0165), ">>>>>>9.99")     */
/*                                                                                + "  -  COFINS: " + string((de-acum-vl-merc-ori * 0.076), ">>>>>>9.99"). */
/*                                                                                                                                                         */
/*             end.                                                                                                                                        */


            /*------------- IMPRESSAO DAS LINHAS DA OBS --------------*/

            /*for each b-class-fis by b-indice:
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + String(b-class-fis.b-indice,"99") + "-" 
                                                                               + b-class-fis.b-cod-class + " ".
            end.*/


            /*------  IMPRIME CÖDIGO DA REPARTI∞ÄO FISCAL  ------*/

            IF TRIM(SUBSTRING(estabelec.char-2,62,20)) <> "" THEN
                  ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Cod.Repart.Fiscal: " + SUBSTRING(estabelec.char-2,62,20).

            /*------  Valor de retenªío de INSS  ------*/
            if  de-ger-inssretido > 0 then 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Valor Retencao INSS........: " 
                                                                             + string(de-ger-inssretido,">>>>>>9.99").

            /* Valores de retencao das contribuicoes sociais */
            if de-ger-pisretido > 0 or de-ger-cofinsretido > 0 or de-ger-csllretido > 0 THEN 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Vl Retencao CSLL/PIS/COFINS: " 
                                                                               + trim(STRING(de-ger-csllretido,">>>>>>9.99")) + " / " 
                                                                               + Trim(STRING(de-ger-pisretido,">>>>>>9.99")) + " / " 
                                                                               + trim(STRING(de-ger-cofinsretido,">>>>>>9.99")).

            /***** TRATATIVA DE SUBSTITUI∞ÄO TRIBUTÊRIA MG IMPLEMENTADO EM 
                   19/09 EM FUN∞ÄO DO REGIME CONSEGUIDO PELA INTELBRAS ****/
            IF emitente.insc-subs-trib <> "" THEN DO:
                 ASSIGN 
                     nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Nao retencao do ICMS ST conforme Regime Especial/Processo n. " + emitente.insc-subs-trib.

            END.
            

            IF AVAIL ped-venda AND
            ped-venda.observacoes <> "" THEN
                IF index(ped-venda.observacoes,"Extrato:") <> 0 THEN
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + trim(substring(ped-venda.observacoes,index(ped-venda.observacoes,"Extrato:"),20)).
                ELSE
                    IF  index(ped-venda.observacoes,"garantia. Pedido:") <> 0 THEN
                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' Pedido Telecontrol : ' + trim(substring(ped-venda.observacoes,index(ped-venda.observacoes,"garantia. Pedido:") + 18,13)).

            FOR FIRST int-loc-entr no-lock 
                where int-loc-entr.nome-abrev  = nota-fiscal.nome-ab-cli
                  and int-loc-entr.cod-entrega = nota-fiscal.cod-entrega:
            END.

            /*Foi retirado pois s¢ era v†lido antes da NF-e*/
/*             if nota-fiscal.cod-entrega <> "" AND nota-fiscal.cod-entrega <> 'Padr∆o' or                                                                                                                                                                                      */
/*                (AVAIL INT-loc-entr AND                                                                                                                                                                                                                                       */
/*                 int-loc-entr.endereco-completo <> "") then do:                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                                              */
/*                 FOR FIRST loc-entr no-lock                                                                                                                                                                                                                                   */
/*                     where loc-entr.nome-abrev  = nota-fiscal.nome-ab-cli                                                                                                                                                                                                     */
/*                       and loc-entr.cod-entrega = nota-fiscal.cod-entrega.                                                                                                                                                                                                    */
/*                     IF AVAIL INT-loc-entr AND                                                                                                                                                                                                                                */
/*                        int-loc-entr.endereco-completo <> "" THEN                                                                                                                                                                                                             */
/*                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Entrega: " + int-loc-entr.endereco-completo + " " + loc-entr.bairro + " " + loc-entr.cidade + " " + loc-entr.estado + " " + "CEP." + string(loc-entr.cep,param-global.formato-cep). */
/*                     ELSE                                                                                                                                                                                                                                                     */
/*                        ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + "Entrega: " + loc-entr.endereco + " " + loc-entr.bairro + " " + loc-entr.cidade + " " + loc-entr.estado + " " + "CEP." + string(loc-entr.cep,param-global.formato-cep).              */
/*                 end.                                                                                                                                                                                                                                                         */
/*             end.                                                                                                                                                                                                                                                             */

            ASSIGN nota-fiscal.observ-nota = trim(REPLACE(nota-fiscal.observ-nota,CHR(13),' ')).
               /*** PARA SANTA CATARINA, NOTA FISCAIS QUE SO TEM ITENS BENEFICIADOS
               PELA LEI DE INFORMµTICA, N«O PODE SAIR A MENSAGEM QUE ESTA NA NATUREZA
               DE OPERAÄ«O, QUE ê GRAVADA NA OBSERVACAO DA NOTA FISCAL  ***/

            assign l-so-portaria = YES.

            for each it-nota-fisc of nota-fiscal NO-LOCK 
                where not it-nota-fisc.it-codigo begins "servico",
                first item NO-LOCK where item.it-codigo = it-nota-fisc.it-codigo
                break by it-nota-fisc.it-codigo:

                FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

                IF (substring(ITEM.fm-codigo,6,2) <> "10" AND
                    substring(ITEM.fm-codigo,6,2) <> "13" AND
                    substring(ITEM.fm-codigo,6,2) <> "14") THEN
                    ASSIGN l-so-portaria = NO.

                FIND FIRST int-icms-it-uf 
                    WHERE int-icms-it-uf.estado    = nota-fiscal.estado
                      AND int-icms-it-uf.it-codigo = it-nota-fisc.it-codigo
                      NO-LOCK NO-ERROR.

                FIND FIRST icms-it-uf
                     WHERE icms-it-uf.it-codigo    = it-nota-fisc.it-codigo
                     AND   icms-it-uf.estado       = nota-fiscal.estado NO-LOCK NO-ERROR.
                
                IF  AVAIL INT-icms-it-uf 
                AND int-icms-it-uf.cod-mensagem <> 0 THEN DO:

                    IF  emitente.contrib-icms = NO 
                    AND AVAIL icms-it-uf
                    AND icms-it-uf.log-descons-para-nao-contribt = YES THEN NEXT.

                    FIND mensagem
                        WHERE mensagem.cod-mensagem = int-icms-it-uf.cod-mensagem
                        NO-LOCK NO-ERROR.
                    IF AVAIL mensagem THEN DO:
                       IF INDEX(nota-fiscal.observ-nota, mensagem.texto-mensag) = 0 THEN DO:
                           assign nota-fiscal.observ-nota = nota-fiscal.observ-nota + mensagem.texto-mensag.
                       END.
                    END.
                END.

                FIND FIRST int-item-uni-estab 
                    WHERE int-item-uni-estab.cod-estabel = nota-fiscal.cod-estabel
                      AND int-item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
                      NO-LOCK NO-ERROR.
                IF AVAIL int-item-uni-estab AND
                   int-item-uni-estab.cod-mensagem <> 0 THEN DO:
                    FIND mensagem
                        WHERE mensagem.cod-mensagem = int-item-uni-estab.cod-mensagem
                        NO-LOCK NO-ERROR.
                    IF AVAIL mensagem THEN DO:
                       IF INDEX(nota-fiscal.observ-nota, mensagem.texto-mensag) = 0 THEN
                          assign nota-fiscal.observ-nota = nota-fiscal.observ-nota + mensagem.texto-mensag.
                    END.
                END.
                IF nota-fiscal.cod-estabel = "105" and
                    item.cod-dcr-item <> "" THEN DO:
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ",DCR-E " + item.cod-dcr-item.
                END.


            END.
            FIND FIRST natur-oper NO-LOCK
                  WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

            if avail natur-oper and
               not natur-oper.log-oper-triang then do:
               find first it-nota-fisc
                    where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                      and it-nota-fisc.serie       = nota-fiscal.serie
                      and it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                      no-lock no-error.
               if avail it-nota-fisc and
                  it-nota-fisc.nr-docum <> "" and
                  it-nota-fisc.serie-docum <> "" then do:
                  find first b-nota-fiscal
                       where b-nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                         and b-nota-fiscal.serie       = it-nota-fisc.serie-docum
                         and b-nota-fiscal.nr-nota-fis = it-nota-fisc.nr-docum
                         no-lock no-error.
                  find natur-oper
                       where natur-oper.nat-operacao = b-nota-fiscal.nat-operacao
                       no-lock no-error.
                  if avail natur-oper and
                     natur-oper.log-oper-triang then do:
                     find ped-venda
                          where ped-venda.nr-pedcli = b-nota-fiscal.nr-pedcli
                            and ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli no-lock no-error.
                     if avail ped-venda AND c-observ-concat-pedidos = "" then do:
                        assign nota-fiscal.observ-nota = nota-fiscal.observ-nota + ped-venda.cond-espec.
                     end.
                  end.
               end.
            end.
            
            RUN pi-gerar-dados-extrato (" 01 - nota-fiscal.observ-nota: " + nota-fiscal.observ-nota).

            if  nota-fiscal.nr-pedcli <> '' 
            AND c-observ-concat-pedidos = ""
            AND INDEX(nota-fiscal.observ-nota, nota-fiscal.nr-pedcli) = 0 then 
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' ' + 'Pedido: ' + nota-fiscal.nr-pedcli .            

            RUN pi-gerar-dados-extrato ("INDEX(nota-fiscal.observ-nota, nota-fiscal.nr-pedcli): " + string(INDEX(nota-fiscal.observ-nota, nota-fiscal.nr-pedcli))).
            RUN pi-gerar-dados-extrato (" 02 - nota-fiscal.observ-nota: " + nota-fiscal.observ-nota).

            ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + ' Cod.Cliente: ' + string(nota-fiscal.cod-emitente) .
            IF AVAIL int-emitente AND
               int-emitente.dispositivo-legal <> ""  THEN DO:
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " " +  trim(int-emitente.dispositivo-legal).
            END.
            IF nota-fiscal.cod-portador = 999 AND
               nota-fiscal.modalidade   = 6 THEN DO:
                IF emitente.cod-emitente = 6926 THEN
                   ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " ** BOLETO **".
                ELSE
                    IF emitente.cod-gr-cli = 6 OR
                       emitente.cod-gr-cli = 8 THEN DO:
                        FIND int-cond-pagto
                            WHERE int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag
                            NO-LOCK NO-ERROR.
                        IF AVAIL int-cond-pagto THEN DO:
                            if SUBSTRING(int-cond-pagto.char-1,1,1) = "S" THEN DO:
                                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " ** BOLETO **".
                            END.
                        END.
                    END.
            END.

            /*dados do endereáo da transportado de redespacho*/
            IF nota-fiscal.nome-tr-red <> ""  and NOT (nota-fiscal.nome-tr-red  begins "RETIRA") THEN DO:
                FIND FIRST transporte NO-LOCK
                     WHERE transporte.nome-abrev = nota-fiscal.nome-tr-red NO-ERROR.

                IF AVAIL transporte THEN DO:
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " TRANS. REDESP. Raz∆o Social: " + transporte.nome + 
                                                                               " CNPJ " + transporte.cgc +
                                                                               " Ins. Estad.: " + transporte.ins-estadual.

                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " Endereáo:" + transporte.endereco + "," +
                                                                                              transporte.bairro   + "," +
                                                                                              transporte.cep      + "," +
                                                                                              transporte.cidade   + "," +
                                                                                              transporte.estado.
                END.
            END.
        END.

        /*********************************************************************************
        **  Prop¢sito:  Validar os pedidos/notas fiscais com os limites do SupplierCard
        **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
        **  Criaá∆o:    Outubro de 2011
        **********************************************************************************/
        /****************************************
        **  Validaá∆o do SupplierCard - In°cio
        *****************************************/
        FIND FIRST int-cond-pagto
            WHERE int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.

        IF AVAILABLE int-cond-pagto                       AND
           SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
            FIND FIRST cond-pagto
                WHERE cond-pagto.cod-cond-pag = int-cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
            IF INDEX(nota-fiscal.observ-nota, "Intelbras Clube em") = 0 THEN DO: /* Significa que ja gravou a mensagem, ou seja ja passou por aqui */
                IF AVAILABLE cond-pagto THEN
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + CHR(10) + "*Compra efetuada atravÇs do cart∆o Intelbras Clube em ":U + TRIM(STRING(cond-pagto.num-parcelas)) + " parcela(s).":U + CHR(10) + "*Para segunda via de boleto ou informaá‰es de compras enviar e-mail para clube@intelbras.com.br ou contatar o 0300-601-4045.":U. /* Em aberto */
                ELSE
                    ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + CHR(10) + "*Compra efetuada atravÇs do cart∆o Intelbras Clube.":U + CHR(10) + "*Para segunda via de boleto ou informaá‰es de compras enviar e-mail para clube@intelbras.com.br ou contatar o 0300-601-4045.":U. /* Em aberto */
            END.
        END.
        /****************************************
        **  Validaá∆o do SupplierCard - Final
        *****************************************/

        /* Ped-fiscal */
        FIND ped-fiscal NO-LOCK
             WHERE ped-fiscal.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
        IF AVAILABLE ped-fiscal THEN
            ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + CHR(10) + "*PedFiscal Nr. ":U + string(ped-fiscal.nr-pedido) + ". *CC destino do bem ":U + ped-fiscal.sc-codigo-rec + ".":U.

        /*DÇcio - Adiciona o PO Cliente na observaá∆o da nota*/
        IF nota-fiscal.cod-estabel BEGINS "6" THEN DO:
        
            ASSIGN c-oc = "".

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                       AND ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli NO-ERROR.
            
                IF  AVAIL  ped-venda THEN DO:
                    FIND FIRST int-ped-venda NO-LOCK
                         WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
                           AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
            
                    IF  AVAIL int-ped-venda THEN DO:
                        /*ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " Ordem Compra:" + TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).*/
                        IF c-oc = "" THEN
                            ASSIGN c-oc = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                        ELSE
                            ASSIGN c-oc = c-oc + ";" + TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                    END.
                END.
            END.
             IF c-oc <> "" THEN
                ASSIGN nota-fiscal.observ-nota = nota-fiscal.observ-nota + " Ordem Compra: "  + c-oc.
        END.

        ASSIGN c-nf-referenciado = "".
        FOR EACH nota-fisc-adc NO-LOCK
           WHERE nota-fisc-adc.cod-estab     = nota-fiscal.cod-estabel
             AND nota-fisc-adc.cod-serie     = nota-fiscal.serie
             AND nota-fisc-adc.cod-nota-fis  = nota-fiscal.nr-nota-fis
             AND nota-fisc-adc.cdn-emitente  = nota-fiscal.cod-emitente
             AND nota-fisc-adc.idi-tip-dado  = 03: //notas referenciadas

            IF c-nf-referenciado = "" THEN
                ASSIGN c-nf-referenciado = nota-fisc-adc.cod-docto-referado.
            ELSE
                ASSIGN c-nf-referenciado = c-nf-referenciado + "," + cod-docto-referado.
        END.
        IF c-nf-referenciado <> "" THEN DO:
            ASSIGN nota-fiscal.observ =  nota-fiscal.observ  + " Nfs referenciadas: " + c-nf-referenciado.
        END.

        //tratar observacao da sicred
        /* Favor confirmar o pagamento desta Nota Fiscal, respondendo este e-mail com o comprovante de pagamento anexo. Abaixo os dados banc·rios:
           CONTAS INTELBRAS AgÍncia Conta
           Banco Brasil 3425-8 350032-2
           Banco Bradesco 0347-6 16647-2
           Banco Ita˙ 1570 05555-6
           CÛdigo Identificador     CNPJ do cliente */

        EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
        RUN esp/es0018p.p (INPUT  "bodi317ef":U,
                           INPUT  10,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FIND FIRST tt-prog-ponto
             WHERE tt-prog-ponto.conteudo = emitente.nome-matriz NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
            ASSIGN nota-fiscal.observ = nota-fiscal.observ +  CHR(10) + " Favor confirmar o pagamento desta Nota Fiscal, respondendo este e-mail com o comprovante de pagamento anexo. Abaixo os dados banc·rios:" + CHR(10) + 
                                                             " CONTAS INTELBRAS AgÍncia Conta" + CHR(10) + 
                                                             " Banco Brasil 3425-8 350032-2  " + CHR(10) + 
                                                             " Banco Bradesco 0347-6 16647-2 " + CHR(10) + 
                                                             " Banco Ita˙ 1570 05555-6       " + CHR(10) +
                                                             " CNPJ do cliente: " + emitente.cgc.
        END.
         //fim tratamento observacao da sicred

        ASSIGN nota-fiscal.observ = REPLACE(nota-fiscal.observ,'"','').
        /*IF nota-fiscal.serie BEGINS "R" THEN
            ASSIGN nota-fiscal.observ = SUBSTRING(nota-fiscal.observ,1,200).*/


        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            IF AVAIL int-ped-venda AND int-ped-venda.num-serie-solar <> "" THEN DO:
                ASSIGN nota-fiscal.observ = nota-fiscal.observ + "Nr serie gerador solar " + int-ped-venda.num-serie-solar.
            END.
            //Bruno Joaquim - 19/03/2024 - Melhoria: M2305-132 Local de entrega Alternativo
            IF int-ped-venda.endereco-entrega-alternativo[1] <> "" THEN DO:
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " Endereáo de entrega:" .
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[1] . //Local Entrega
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[2] . //Endereco Completo 
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[6] . //Cidade
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[3] . //Bairro
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[4] . //UF
               ASSIGN nota-fiscal.observ = nota-fiscal.observ + " " + int-ped-venda.endereco-entrega-alternativo[5] . //CEP
            END.
        END.


        IF l-ativa-log THEN
            PUT "FINAL " nota-fiscal.observ-nota SKIP.
        
    END.

END PROCEDURE.

PROCEDURE pi-atualiza-volume:

    FOR EACH volume-nf EXCLUSIVE-LOCK
             WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
             AND   volume-nf.serie = nota-fiscal.serie
             AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis:
        DELETE volume-nf.
    END.

    FOR EACH volume-wms-nf EXCLUSIVE-LOCK
         WHERE volume-wms-nf.cod-estabel = nota-fiscal.cod-estabel
         AND   volume-wms-nf.serie = nota-fiscal.serie
         AND   volume-wms-nf.nr-nota-fis = nota-fiscal.nr-nota-fis:
        DELETE volume-wms-nf.
    END.

    /* atualiza transportadora das notas de faturamento de operacao triangular - conta e ordem */
    FOR EACH tt-notas-geradas NO-LOCK,
        FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel   = wt-docto.cod-estabel
              AND nota-fiscal.serie         = wt-docto.serie
              AND nota-fiscal.nr-nota-fis   = tt-notas-geradas.nr-nota:
        
        IF l-ativa-log THEN
           PUT "bodi317ef - antes sedex ou pac " nota-fiscal.nome-transp 
            nota-fiscal.cod-estabel  " " 
            nota-fiscal.serie " "
            nota-fiscal.nr-nota-fis  SKIP. 

        IF   /* Por solicitacao de Cristiano Araujo e Harleson */
            (nota-fiscal.nome-transp = "SEDEX MG" OR
             nota-fiscal.nome-transp = "SEDEX"    OR
             nota-fiscal.nome-transp = "E-SEDEX"  OR
             nota-fiscal.nome-transp = "PAC" OR
             nota-fiscal.nome-transp = "SEDEX 10" OR
             nota-fiscal.nome-transp = "MERCADO ENVI" OR
             nota-fiscal.nome-transp = "EBAZAR01" OR
             nota-fiscal.nome-transp = "EBAZAR02" OR
             nota-fiscal.nome-transp = "MAGALU" OR
             nota-fiscal.nome-transp = "TOTAL EXP"
             )  THEN DO:
            FOR EACH volume-nf EXCLUSIVE-LOCK
                     WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                     AND   volume-nf.serie       = nota-fiscal.serie
                     AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis:
                DELETE volume-nf.
            END.
            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                FIND LAST volume-nf EXCLUSIVE-LOCK
                     WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                     AND   volume-nf.serie       = nota-fiscal.serie
                     AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                     AND   volume-nf.it-codigo   = it-nota-fisc.it-codigo
                     AND   volume-nf.nr-volume = 1

                    NO-ERROR.

                IF not avail volume-nf then do:
                   create volume-nf. 
                   assign volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                          volume-nf.serie        = nota-fiscal.serie
                          volume-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                          volume-nf.it-codigo    = it-nota-fisc.it-codigo
                          volume-nf.nr-volume    = 1
                          volume-nf.varios-itens = YES.
                END.
                ASSIGN nota-fiscal.nr-volumes = string(volume-nf.nr-volume)
                       volume-nf.qtde  = volume-nf.qtde + it-nota-fisc.qt-faturada[1].

                IF l-ativa-log THEN
                   PUT "bodi317ef - /* Por solicitacao de Cristiano Araujo e Harleson */ Volume " volume-nf.nr-volume SKIP.
            END.

        END.
        ELSE DO:
            IF nota-fiscal.nr-volumes = ""  OR 
               nota-fiscal.nr-volumes = '0' THEN DO:

               ASSIGN i-proximo-vol   = 1
                      de-peso-liquido = 0
                      de-peso-bruto   = 0. 

                IF l-ativa-log THEN
                   PUT "bodi317ef - vai atualizar volumes " 
                    nota-fiscal.cod-estabel  " " 
                    nota-fiscal.serie " "
                    nota-fiscal.nr-nota-fis  SKIP. 
               
               RUN pi-calcula-volumes IN THIS-PROCEDURE.

               IF RETURN-VALUE <> "OK" THEN
                   RETURN "NOK".

            
               FIND LAST volume-nf NO-LOCK
                    WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                    AND   volume-nf.serie = nota-fiscal.serie
                    AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

               IF not avail volume-nf then do:
                  create volume-nf. 
                  assign volume-nf.cod-estabel = nota-fiscal.cod-estabel
                         volume-nf.serie       = nota-fiscal.serie
                         volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                         volume-nf.it-codigo   = ""
                         volume-nf.nr-volume = 1.

                  ASSIGN nota-fiscal.nr-volumes = "1".
                  
               END.
               ELSE
                   ASSIGN nota-fiscal.nr-volumes = string(volume-nf.nr-volume).

               IF l-ativa-log THEN
                  PUT "bodi317ef - depois pi-calcula-volumes1 - Volume " volume-nf.nr-volume SKIP.
              
               IF nota-fiscal.peso-bru-tot <> nota-fiscal.peso-liq-tot OR
                  nota-fiscal.peso-bru-tot = 0 OR
                  nota-fiscal.peso-liq-tot = 0 THEN
                   ASSIGN nota-fiscal.peso-bru-tot = de-peso-bruto
                          nota-fiscal.peso-liq-tot = de-peso-liquido.

               IF nota-fiscal.nat-operacao BEGINS "7" THEN DO:
                   FOR EACH volume-nf NO-LOCK
                        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                        AND   volume-nf.serie       = nota-fiscal.serie
                        AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                       BREAK BY volume-nf.nr-volume:

                       IF l-ativa-log THEN DO:
                          PUT  "Nro Volume " volume-nf.nr-volume  nota-fiscal.peso-bru-tot SKIP.
                       END.

                       
                       IF LAST-OF(volume-nf.nr-volume) THEN DO:
                            find first embalag NO-LOCK
                                 WHERE embalag.sigla-emb = volume-nf.sigla-emb
                                 no-error.


                            IF AVAIL embalag THEN DO:
                                ASSIGN nota-fiscal.peso-bru-tot = nota-fiscal.peso-bru-tot + embalag.peso-embal.
                            END.
                            IF l-ativa-log THEN DO:                            
                               put AVAIL embalag nota-fiscal.peso-bru-tot SKIP.
                            END.

                       END.
                   END.
               END.
           end.      
           ELSE DO:

               IF nota-fiscal.peso-bru-tot <> nota-fiscal.peso-liq-tot 
               OR nota-fiscal.peso-bru-tot = 0 
               OR nota-fiscal.peso-liq-tot = 0 THEN DO:

                   ASSIGN de-peso-liquido = 0
                          de-peso-bruto   = 0.

                   FOR EACH it-nota-fisc OF nota-fiscal exclusive-LOCK,
                       FIRST ITEM NO-LOCK
                       WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
                         IF ITEM.tipo-contr <> 4 THEN
                            ASSIGN de-peso-liquido           = de-peso-liquido + if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido) < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido
                                   de-peso-bruto             = de-peso-bruto   + if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto)   < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto
                                   it-nota-fisc.peso-liq-fat =                   if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido) < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido
                                   it-nota-fisc.peso-bruto   =                   if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto)   < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto.
                         ELSE
                             ASSIGN de-peso-liquido           = de-peso-liquido + it-nota-fisc.peso-liq-fat
                                    de-peso-bruto             = de-peso-bruto   + it-nota-fisc.peso-bruto.
.
                   END.

                   IF NOT nota-fiscal.nat-operacao BEGINS "7" THEN
                       ASSIGN nota-fiscal.peso-bru-tot = de-peso-bruto
                              nota-fiscal.peso-liq-tot = de-peso-liquido.
               END.

           END.

        END.
        
        FIND ped-venda
           WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
             AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
           NO-LOCK NO-ERROR.
        
        IF AVAIL ped-venda THEN
             FIND int-ped-venda
                  WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
        
        IF AVAIL ped-venda AND 
           AVAIL int-ped-venda AND
           dec(SUBSTRING(int-ped-venda.char-1,220,20)) > 0 THEN
           ASSIGN nota-fiscal.peso-bru-tot = dec(SUBSTRING(int-ped-venda.char-1,220,20)).
       
           
    END.

 
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-busca-contrato:
    
    RUN upc/ft4003-upca.w (INPUT ROWID(nota-fiscal)).

END PROCEDURE.


/** NSU **/
IF  p-ind-event = "EndEfetivaNota":U THEN DO:

    FIND FIRST tt-epc WHERE
               tt-epc.cod-event     = p-ind-event            AND
               tt-epc.cod-parameter = "ROWID(nota-fiscal)":U NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        FIND FIRST nota-fiscal WHERE
             ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF  AVAIL nota-fiscal THEN do:
            CREATE tt-notas-lidas.
            assign tt-notas-lidas.r-nfe-gati = rowid(nota-fiscal).
        end.

        /* ALTERAR STATUS DAS SOLICITAÄÂES - PROJETO CANAIS */
        IF  AVAIL nota-fiscal THEN
            RUN esp/esb/esesbapi012.p (INPUT rowid(nota-fiscal)).
        
    END.

    IF NOTA-FISCAL.COD-CHAVE-ACES-NF-ELETRO = "" THEN DO: 

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "esftp016", /* Nome do programa */
                           INPUT 2,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR. //Series FT e R2 nao tem chave de acesso
        
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = nota-fiscal.serie) THEN NEXT.

        RUN piAcertaChave (OUTPUT c-chave).
        IF c-chave = ? OR c-chave = "?" THEN NEXT.
        FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN OVERLAY(nota-fiscal.char-2,3,60) = c-chave.
        ASSIGN NOTA-FISCAL.COD-CHAVE-ACES-NF-ELETRO = c-chave.
        FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.

    END.
END.

if p-ind-event = 'EndEfetivaNota2' then do:
    FIND FIRST tt-epc NO-LOCK
         WHERE tt-epc.cod-event     = p-ind-event            
           AND tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.

    IF AVAILABLE tt-epc THEN DO:
        ASSIGN hbodi317ef = WIDGET-HANDLE(tt-epc.val-parameter).
    END.
    /* Regra para integraá∆o NFE - GATI */

    FOR EACH tt-notas-lidas NO-LOCK,
        FIRST nota-fiscal
            WHERE rowid(nota-fiscal) = tt-notas-lidas.r-nfe-gati:

        FIND estabelec
             WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
        /* TMS find first nota-fiscal-tr exclusive-lock
            where nota-fiscal-tr.cod-estabel = nota-fiscal.cod-estabel
            and   nota-fiscal-tr.cd-serie    = nota-fiscal.serie
            and   nota-fiscal-tr.nr-nf       = int(nota-fiscal.nr-nota-fis)
            and   nota-fiscal-tr.cgc-rem     = estabelec.cgc no-error.

        IF AVAIL nota-fiscal-tr THEN DO:
            ASSIGN nota-fiscal-tr.qt-volumes = int(nota-fiscal.nr-volumes).
        END.*/
        FOR EACH nota-embal exclusive-lock WHERE
              nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis and
              nota-embal.serie       = nota-fiscal.serie       and
              nota-embal.cod-estabel = nota-fiscal.cod-estabel AND
              NOTA-EMBAL.sigla-emb   = "cx":
            ASSIGN nota-embal.qt-vol = INT(nota-fiscal.nr-volumes).
        END.

        IF AVAIL nota-fiscal and
           nota-fiscal.nr-pedcli <> "" THEN DO:
            FOR EACH ped-venda 
                WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                  AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                  AND ped-venda.cod-sit-ped <= 2
                  AND   ped-venda.cod-priori = 10 
                BY nr-pedcli:
               
                IF CAN-FIND(FIRST ped-item OF ped-venda
                    WHERE ped-item.qt-log-aloc <> 0
                      AND ped-item.cod-sit-item <> 6) THEN 
                   NEXT.
            
                ASSIGN l-troca = NO.
                
                FOR EACH ped-item OF ped-venda NO-LOCK
                    WHERE ped-item.cod-sit-item <= 2:
            
                    IF ped-item.qt-alocada <> 0 THEN
                       IF ped-item.qt-alocada <> ped-item.qt-atendida THEN DO:
                           ASSIGN l-troca = NO.
                           LEAVE.
                       END.
                    
                    ASSIGN l-troca = YES.
                END.
                
                IF  l-troca THEN
                    ASSIGN ped-venda.cod-priori = 99.
            END.
        END.

        /*Chamado 74833*/
        FOR EACH ped-venda 
           WHERE ped-venda.nome-abrev  = nota-fiscal.nome-ab-cli
             AND ped-venda.nr-pedcli   = nota-fiscal.nr-pedcli
             AND ped-venda.cod-sit-ped = 2 /*Atendido Parcial*/:

            FIND FIRST bf-int-ped-venda EXCLUSIVE-LOCK
                 WHERE bf-int-ped-venda.nr-pedido = ped-venda.nr-pedido  NO-ERROR.

            IF AVAIL bf-int-ped-venda THEN DO:
                ASSIGN bf-int-ped-venda.vl-frete     = 0
                       bf-int-ped-venda.vl-embalagem = 0
                       bf-int-ped-venda.vl-seguro    = 0.

                RELEASE bf-int-ped-venda.
            END.
        END. 

        /* Faz o rec†lculo das parcelas da nota, conforme regra estabelecida para o SupplierCard */
        RUN pi-recalcula-parcelas.

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        IF  AVAIL int-emitente THEN DO:

            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                   AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
            IF  AVAIL ped-venda THEN DO:
                ASSIGN v_log_nat_deps = YES.
    
                IF   ped-venda.cod-cond-pag = 0
                AND (ped-venda.tp-pedido    = "94" 
                OR   ped-venda.tp-pedido    = "97") THEN /* pedidos do assist devem ser ignorados */
                    ASSIGN v_log_nat_deps = NO.
                ELSE DO:
                    EMPTY TEMP-TABLE tt-prog-ponto.
                    RUN esp/es0018p.p (INPUT "dps-nat-oper", /* Nome do programa */
                                       INPUT 1,             /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
            
                    IF  CAN-FIND (FIRST tt-prog-ponto
                                     WHERE tt-prog-ponto.conteudo = string(ped-venda.nat-operacao)) THEN
                        ASSIGN v_log_nat_deps = NO.
                END.

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "dps-canal-vd", /* Nome do programa */
                                   INPUT 1,         /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

                    IF  v_log_nat_deps = YES /* garantia */ THEN DO:
            
                        IF  ped-venda.cod-sit-ped = 2 /* atendido total ou parcial */
                        OR  ped-venda.cod-sit-ped = 3 THEN DO:
                            
                            /*Integraá∆o Atualiza saldo DEPS*/
                            EMPTY TEMP-TABLE tt-pedido-integra.
                            
                            CREATE tt-pedido-integra.
                            ASSIGN tt-pedido-integra.r-rowid = ROWID(ped-venda)
                                   tt-pedido-integra.i-origem-inegr = 3.
                            
                            RAW-TRANSFER tt-pedido-integra TO raw-param.
                            
                            RUN esp/trgw/wdi154a.p (INPUT raw-param,
                                                    INPUT 'msg0310',
                                                    OUTPUT TABLE resultado).
                
                            IF  RETURN-VALUE = "OK" THEN DO:
                                /* envia mensagem ao deps solicitando limite disponivel atualizado */
                                IF  AVAIL ped-venda THEN DO:
        
                                    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                                         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                                           AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        
                                    IF  AVAIL int-ped-venda2 THEN.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
end.

PROCEDURE pi-envia-e-mail-cartao:
    
    DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEFINE VARIABLE c-email     AS CHARACTER   NO-UNDO.

    ASSIGN cNom_from = 'ems@intelbras.com.br'.
    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND emitente
         WHERE emitente.cod-emitente = wt-docto.cod-emitente
         NO-LOCK NO-ERROR.
    
    FIND repres 
         WHERE repres.nome-abrev = wt-docto.no-ab-reppri
         NO-LOCK NO-ERROR.
    IF AVAIL repres AND 
       repres.e-mail <> "" THEN DO:
    
        ASSIGN c-email = repres.e-mail.

        FIND ped-venda
             WHERE ped-venda.nr-pedcli = wt-docto.nr-pedcli
               AND ped-venda.nome-abrev = wt-docto.nome-abrev
             NO-LOCK NO-ERROR.
        FIND atendente
             WHERE atendente.cd-oper =  int(ped-venda.tp-pedido)
             NO-LOCK NO-ERROR.
        IF AVAIL atendente AND
            atendente.email <> "" THEN
            ASSIGN c-email = c-email + "," + atendente.email.

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.


        FOR EACH tt-envio2:     DELETE tt-envio2.   END.
        FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.exchange    = param-global.log-1 
               tt-envio2.servidor    = param-global.serv-mail
               tt-envio2.porta       = param-global.porta-mail
               tt-envio2.remetente   = cNom_from
               tt-envio2.destino     = c-email
               tt-envio2.assunto     = "Pedido Intelbras - Redecard"
               tt-envio2.importancia = 2
               tt-envio2.log-enviada = YES
               tt-envio2.log-lida    = NO
               tt-envio2.acomp       = NO
               tt-envio2.arq-anexo   = ?
               tt-envio2.formato     = "text".


        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = "Senhores,"  + CHR(10).

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 2
               tt-mensagem.mensagem     = "N∆o ocorreu aprovaá∆o no sistema da RedeCard."  + CHR(10).


        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 3
               tt-mensagem.mensagem     = "Cliente ...: " + STRING(wt-docto.cod-emitente) + " - " + emitente.nome-emit + CHR(10).
        
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 4
               tt-mensagem.mensagem     = "Pedido.....: " + wt-docto.nr-pedcli + CHR(10).

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 5
               tt-mensagem.mensagem     = "Valor Total: " + string(wt-docto.vl-mercad) + CHR(10) + CHR(10).

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 5
               tt-mensagem.mensagem     = "Mensagem...: " + c-retorno + " - " + c-mensagem +  CHR(10) + CHR(10).

        
        RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'envemail-fatur2.txt') APPEND.
        IF RETURN-VALUE = "NOK" THEN DO:
            FOR EACH tt-erros:
                PUT "Erro no envio de email Cliente Diferenciado (bodi317ef)- NOta =  " FORMAT "x(80)"
                    nota-fiscal.nr-nota-fis " / " nota-fiscal.serie " / " nota-fiscal.cod-estabel SKIP.
                PUT tt-erros.desc-erro SKIP.

            END.
            ASSIGN lErro = YES.
        END.
        OUTPUT CLOSE.

        IF VALID-HANDLE(h-utapi019) THEN
            DELETE PROCEDURE h-utapi019.
            
        IF lErro AND NOT SESSION:BATCH-MODE AND i-num-ped-exec-rpw = 0 THEN DO:
                PUT "Erro no envio de email Cliente Diferenciado (bodi317ef)- NOta =  " FORMAT "x(80)"
                    nota-fiscal.nr-nota-fis " / " nota-fiscal.serie " / " nota-fiscal.cod-estabel SKIP.
                PUT tt-erros.desc-erro SKIP.
            END.


    END.


    
END PROCEDURE.

    

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conecta-rpc Include 
PROCEDURE conecta-rpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-rpc AS HANDLE NO-UNDO.
    DEF VAR l-ok AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-params AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "PARAM-RPC":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR FIRST tt-prog-ponto:
    
        ASSIGN c-params = tt-prog-ponto.conteudo.
    
    END.

    CREATE SERVER p-rpc.
    DO ON ERROR undo, LEAVE:
        ASSIGN l-ok = p-rpc:CONNECT("{&PARAM-RPC}" + c-params) NO-ERROR.
    END.
    IF NOT l-ok THEN DO:
        DELETE OBJECT p-rpc.
        p-rpc = ?.
        RETURN "NOK".
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desconecta-rpc Include 
PROCEDURE desconecta-rpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-rpc AS HANDLE NO-UNDO.

    IF VALID-HANDLE(p-rpc) THEN DO:
        p-rpc:DISCONNECT().
        DELETE OBJECT p-rpc.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-calcula-volumes:
    DEFINE VARIABLE c-erros     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esftp083  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-ult-vol    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-wms        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-ens-fat    AS LOGICAL INIT NO NO-UNDO.   

    FOR EACH volume-nf EXCLUSIVE-LOCK
        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
        AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
        AND   volume-nf.serie       = nota-fiscal.serie:
        DELETE volume-nf.
    END.
    
    FOR EACH volume-wms-nf EXCLUSIVE-LOCK
        WHERE volume-wms-nf.cod-estabel = nota-fiscal.cod-estabel
        AND   volume-wms-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
        AND   volume-wms-nf.serie       = nota-fiscal.serie:
        DELETE volume-wms-nf.
    END.

    EMPTY TEMP-TABLE tt-itens-calculo.
    EMPTY TEMP-TABLE tt-itens-flow-rack.

    ASSIGN de-peso-liquido = 0
           de-peso-bruto   = 0.

    FOR EACH it-nota-fisc OF nota-fiscal EXCLUSIVE-LOCK
        WHERE NOT it-nota-fisc.it-codigo BEGINS "servico",
        FIRST item NO-LOCK 
        WHERE item.it-codigo = it-nota-fisc.it-codigo
        BREAK BY it-nota-fisc.it-codigo:

        FOR FIRST fat-ser-lote NO-LOCK
            WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
              AND fat-ser-lote.serie       = it-nota-fisc.serie
              AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
              AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
              AND CAN-FIND(FIRST deposito NO-LOCK
                           WHERE deposito.cod-depos = fat-ser-lote.cod-depos
                             AND deposito.log-gera-wms):
        END.

        IF AVAIL fat-ser-lote THEN
            ASSIGN l-wms = YES.
        ELSE /* tratativa para itens avulsos segmento ENS */
            ASSIGN l-ens-fat = YES.

        IF ITEM.tipo-contr <> 4 THEN
            ASSIGN de-peso-liquido           = de-peso-liquido + if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido) < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido
                   de-peso-bruto             = de-peso-bruto   + if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto)   < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto
                   it-nota-fisc.peso-liq-fat =                   if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido) < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-liquido
                   it-nota-fisc.peso-bruto   =                   if  (it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto)   < 0.0001 then 0.0001 else it-nota-fisc.qt-faturada[1] * ITEM.peso-bruto.
         ELSE
             ASSIGN de-peso-liquido           = de-peso-liquido + it-nota-fisc.peso-liq-fat
                    de-peso-bruto             = de-peso-bruto   + it-nota-fisc.peso-bruto.

        IF CAN-FIND (FIRST tt-prog-ponto-tmp
                     WHERE tt-prog-ponto-tmp.nome-programa = 'bodi317ef'
                       AND tt-prog-ponto-tmp.ponto         = 1
                       AND tt-prog-ponto-tmp.conteudo      = it-nota-fisc.it-codigo) THEN
            NEXT.

        FIND FIRST tt-itens-calculo
             WHERE tt-itens-calculo.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
        IF NOT AVAIL tt-itens-calculo THEN DO:
            CREATE tt-itens-calculo.
            ASSIGN tt-itens-calculo.it-codigo  = it-nota-fisc.it-codigo.
        END.

        ASSIGN tt-itens-calculo.quantidade = tt-itens-calculo.quantidade + it-nota-fisc.qt-faturada[1].
        IF l-ativa-log THEN
            PUT "Itens da nota: " tt-itens-calculo.it-codigo tt-itens-calculo.quantidade.

        /** para Geradores Solar, explode a estrutura **/    
        IF it-nota-fisc.cod-unid-neg = 'ENS' AND l-ens-fat THEN DO:
           FIND FIRST estrutura NO-LOCK
                WHERE estrutura.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

           IF AVAIL estrutura THEN 
              DELETE tt-itens-calculo.
              
           FOR EACH estrutura NO-LOCK
              WHERE estrutura.it-codigo = it-nota-fisc.it-codigo
                AND estrutura.data-inicio  <= TODAY
                AND estrutura.data-termino >  TODAY :
             CREATE tt-itens-calculo.
             ASSIGN tt-itens-calculo.it-codigo  = estrutura.es-codigo
                    tt-itens-calculo.quantidade = estrutura.quant-usada * it-nota-fisc.qt-faturada[1].
           END.
        END.
    END.

    EMPTY TEMP-TABLE tt-volumes.
    EMPTY TEMP-TABLE tt-volumes-flow-rack.

/*     IF nota-fiscal.tp-pedido = "18" THEN DO:                                         */
/*        FIND FIRST nota-embal OF nota-fiscal NO-LOCK NO-ERROR.                        */
/*                                                                                      */
/*        ASSIGN i-aux = 0.                                                             */
/*                                                                                      */
/*        FOR EACH nota-embal of nota-fiscal NO-LOCK:                                   */
/*            DO i-cont = 1 TO nota-embal.qt-volumes:                                   */
/*                ASSIGN i-aux = i-aux + 1.                                             */
/*                CREATE tt-volumes.                                                    */
/*                ASSIGN tt-volumes.it-codigo    = it-nota-fisc.it-codigo               */
/*                       tt-volumes.qtde         = 1                                    */
/*                       tt-volumes.nr-volume    = i-aux                                */
/*                       tt-volumes.sigla-emb    = nota-embal.sigla-emb                 */
/*                       tt-volumes.varios-itens = NO.                                  */
/*                                                                                      */
/*                IF it-nota-fisc.cod-unid-neg = 'ENS' THEN DO:                         */
/*                    FIND FIRST estrutura NO-LOCK                                      */
/*                         WHERE estrutura.it-codigo = it-nota-fisc.it-codigo NO-ERROR. */
/*                                                                                      */
/*                    IF AVAIL estrutura THEN                                           */
/*                        ASSIGN tt-volumes.it-codigo = it-nota-fisc.it-codigo.         */
/*                END.                                                                  */
/*            END.                                                                      */
/*        END.                                                                          */
/*     END.                                                                             */

    /*Tratamento volumes decio*/
    IF nota-fiscal.cod-estabel BEGINS "6" THEN DO:

       FIND FIRST nota-embal OF nota-fiscal NO-LOCK NO-ERROR.

       IF AVAIL nota-embal THEN DO:

          FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK NO-ERROR.

          DO i-cont = 1 TO nota-embal.qt-volumes:
             CREATE tt-volumes.
             ASSIGN tt-volumes.qtde         = 1
                    tt-volumes.nr-volume    = i-cont
                    tt-volumes.sigla-emb    = nota-embal.sigla-emb
                    tt-volumes.varios-itens = NO
                    tt-volumes.it-codigo    = it-nota-fisc.it-codigo
                    .
          END.
       END.
    END.

    FIND FIRST tt-volumes NO-ERROR.

    IF NOT AVAIL tt-volumes THEN DO:

        RUN esp/ftp/esftp083.p PERSISTENT SET h-esftp083.

        RUN pi-calcula-volumes IN h-esftp083 (INPUT nota-fiscal.cod-emitente,
                                              INPUT nota-fiscal.nat-operacao,
                                              INPUT nota-fiscal.cod-estabel,
                                              INPUT nota-fiscal.nome-transp,
                                              INPUT  TABLE tt-itens-calculo,
                                              OUTPUT TABLE tt-volumes,
                                              OUTPUT c-erros).
    
        DELETE PROCEDURE h-esftp083.
        ASSIGN h-esftp083 = ?.
    END.
    
    IF l-wms THEN
        RUN piTrataFlowRack.

    if it-nota-fisc.cod-unid-neg = 'ENS' AND l-ens-fat then do:

        /*gerar 1 volume para cada peáa do gerador que nao fechar uma caixa inteira*/

        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "bodi317ef":U,
                           INPUT 9,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR LAST tt-volumes:
            ASSIGN i-ultimo-volume = tt-volumes.nr-volume.
        END.

        LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes i-ultimo-volume" + STRING(i-ultimo-volume)) NO-ERROR.
        
        FOR EACH tt-prog-ponto:
            ASSIGN d-tot-emb       = 0
                   i               = 0
                   i-qt-vol-item   = 0
                   i-nro-vol-gerar = 0.
            
            FOR EACH tt-volumes
               WHERE tt-volumes.it-codigo = tt-prog-ponto.conteudo,
               FIRST tt-itens-calculo
               WHERE tt-itens-calculo.it-codigo = tt-volumes.it-codigo
            BREAK BY tt-volumes.it-codigo:

                LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes tt-volumes.it-codigo" + STRING(tt-volumes.it-codigo)) NO-ERROR.
                
                find first item-caixa
                     where item-caixa.it-codigo = tt-volumes.it-codigo  
                       and item-caixa.qt-item   > 1 no-lock no-error.
            
                ASSIGN d-tot-emb = d-tot-emb + tt-volumes.qtd
                       i-qt-vol-item = i-qt-vol-item + 1.
                IF LAST-OF (tt-volumes.it-codigo) THEN DO:
                    IF tt-itens-calculo.quantidade < d-tot-emb or 
                       tt-itens-calculo.quantidade < item-caixa.qt-item THEN DO:
                        
                        IF i-qt-vol-item > 1 THEN
                            ASSIGN i-nro-vol-gerar = tt-itens-calculo.quantidade - (tt-volumes.qtde * (i-qt-vol-item - 1)).
                        ELSE 
                            ASSIGN i-nro-vol-gerar = tt-itens-calculo.quantidade - tt-volumes.qtde.
                            
                        if tt-itens-calculo.quantidade < item-caixa.qt-item then
                           i-nro-vol-gerar = tt-itens-calculo.quantidade.
            
                        LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes VAI ENTRAR NO DO i = 1 TO i-nro-vol-gerar") NO-ERROR.
                        DO i = 1 TO i-nro-vol-gerar:
                            LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes i" + STRING(i)) NO-ERROR.
                            LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes i-nro-vol-gerar" + STRING(i-nro-vol-gerar)) NO-ERROR.

                            find first item-caixa no-lock 
                                 where item-caixa.it-codigo = tt-volumes.it-codigo 
                                   and item-caixa.qt-item   = 1 no-error.

                            ASSIGN i-nro-vol-gerado = i-nro-vol-gerado + 1.
                            CREATE b-tt-volumes.
                            BUFFER-COPY tt-volumes TO b-tt-volumes.
                            ASSIGN b-tt-volumes.qtde = 1
                                   b-tt-volumes.sigla-emb = item-caixa.sigla-emb
                                   b-tt-volumes.nr-volume = i-ultimo-volume + i-nro-vol-gerado.
                        END.

                        LOG-MANAGER:WRITE-MESSAGE("C†lculo volumes SAIU DO DO:") NO-ERROR.
            
                        DELETE tt-volumes.
                    END.
                END.
            END.
        END.
        /***/
        
        find first estrutura where 
             estrutura.it-codigo = it-nota-fisc.it-codigo no-lock no-error.
        if avail estrutura then DO:

           FOR EACH b-estrutura-filho 
               WHERE b-estrutura-filho.it-codigo = estrutura.it-codigo:

               FOR EACH tt-volumes
                  WHERE tt-volumes.it-codigo = b-estrutura-filho.es-codigo:
                    assign tt-volumes.it-codigo = it-nota-fisc.it-codigo.
               end.
           END.
           
           /* reordena a sequencia dos volumes */ 
           assign i-ordena-vol    = 0
                  i-ult-vol       = 0.

           FOR EACH tt-volumes
              BREAK BY tt-volumes.nr-volume:
               
               IF i-ult-vol = tt-volumes.nr-volume THEN DO:
                   ASSIGN tt-volumes.nr-volume = i-ordena-vol.
               END.
               ELSE DO:
                   ASSIGN i-ult-vol = tt-volumes.nr-volume.
                   
                   assign i-ordena-vol = i-ordena-vol + 1.
                          tt-volumes.nr-volume = i-ordena-vol.
               END.
           END.
        END.
    end.

IF c-erros <> "" THEN DO:
        RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
        RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                               INPUT "EMS",
                                               INPUT "ERROR", 
                                               INPUT c-erros,
                                               INPUT c-erros,
                                               INPUT c-erros). 
        RETURN "NOK".
    END.
    
    ASSIGN i-ult-vol = 0.
    IF CAN-FIND(FIRST tt-volumes) THEN DO:

        FOR EACH tt-volumes
            BREAK BY tt-volumes.nr-volume:

            IF l-ativa-log THEN
                PUT "Volumes gerado: " tt-volumes.it-codigo tt-volumes.qtde.

            FIND FIRST volume-nf EXCLUSIVE-LOCK
                 WHERE volume-nf.cod-estabel = volume-nf.cod-estabel
                  AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND  volume-nf.serie       = nota-fiscal.serie
                  AND  volume-nf.it-codigo   = tt-volumes.it-codigo
                  AND  volume-nf.nr-volume   = tt-volumes.nr-volume NO-ERROR.

            IF NOT AVAIL volume-nf THEN DO:
                CREATE volume-nf.
                ASSIGN volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                       volume-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       volume-nf.serie        = nota-fiscal.serie
                       volume-nf.it-codigo    = tt-volumes.it-codigo
                       volume-nf.nr-volume    = tt-volumes.nr-volume
                       volume-nf.qtde         = tt-volumes.qtde           
                       volume-nf.sigla-emb    = tt-volumes.sigla-emb    
                       volume-nf.varios-itens = tt-volumes.varios-itens.
            END.
            ELSE DO:
                ASSIGN volume-nf.qtde = volume-nf.qtde  + tt-volumes.qtde.
            END.
            ASSIGN i-ult-vol = tt-volumes.nr-volume.
        END.
    END.

    IF CAN-FIND(FIRST tt-volumes-flow-rack) THEN DO:
        FOR EACH tt-volumes-flow-rack
            BREAK BY tt-volumes-flow-rack.nr-volume:

            IF FIRST-OF(tt-volumes-flow-rack.nr-volume) THEN
                ASSIGN i-ult-vol = i-ult-vol + 1.

            IF l-ativa-log THEN
                PUT "Volumes gerado: " tt-volumes-flow-rack.it-codigo tt-volumes-flow-rack.qtde.

            FIND FIRST volume-nf EXCLUSIVE-LOCK
                 WHERE volume-nf.cod-estabel = volume-nf.cod-estabel
                  AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                  AND  volume-nf.serie       = nota-fiscal.serie
                  AND  volume-nf.it-codigo   = tt-volumes-flow-rack.it-codigo
                  AND  volume-nf.nr-volume   = i-ult-vol NO-ERROR.

            IF NOT AVAIL volume-nf THEN DO:
                CREATE volume-nf.
                ASSIGN volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                       volume-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       volume-nf.serie        = nota-fiscal.serie
                       volume-nf.it-codigo    = tt-volumes-flow-rack.it-codigo
                       volume-nf.nr-volume    = i-ult-vol
                       volume-nf.qtde         = tt-volumes-flow-rack.qtde           
                       volume-nf.sigla-emb    = tt-volumes-flow-rack.sigla-emb    
                       volume-nf.varios-itens = tt-volumes-flow-rack.varios-itens.
            END.
            ELSE DO:
                ASSIGN volume-nf.qtde = volume-nf.qtde  + tt-volumes-flow-rack.qtde.
            END.

            FOR FIRST volume-wms-nf NO-LOCK
                WHERE volume-wms-nf.cod-estabel = volume-nf.cod-estabel
                  AND volume-wms-nf.serie       = volume-nf.serie
                  AND volume-wms-nf.nr-nota-fis = volume-nf.nr-nota-fis
                  AND volume-wms-nf.nr-volume   = volume-nf.nr-volume:
            END.

            IF NOT AVAIL volume-wms-nf THEN DO:
                CREATE volume-wms-nf.
                ASSIGN volume-wms-nf.cod-estabel  = nota-fiscal.cod-estabel
                       volume-wms-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       volume-wms-nf.serie        = nota-fiscal.serie
                       volume-wms-nf.nr-volume    = volume-nf.nr-volume
                       volume-wms-nf.cdd-embarq   = nota-fiscal.cdd-embarq
                       volume-wms-nf.nr-resumo    = nota-fiscal.nr-resumo
                       volume-wms-nf.tipo-separa  = 3. /* flow rack*/
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE. /* PROCEDURE pi-calcula-volumes. */

PROCEDURE Pi-grava-embalagem.
    /**** O FOR EACH ABAIXO ATUALIZA A EMBALAGEM NOS VOLUMES QUE N«O
          TINHA SIDO IDENTIFICADO O TAMANHO DA MESMA ***********/
    FOR EACH volume-nf
        where volume-nf.cod-estabel = nota-fiscal.cod-estabel
        AND   volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
        and   volume-nf.serie       = nota-fiscal.serie
        AND   volume-nf.sigla-emb   = "":
        ASSIGN volume-nf.sigla-emb = c-emb-escolhida.
    END.
END PROCEDURE.

PROCEDURE pi-cria-pagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-esapi015 AS HANDLE NO-UNDO.

    FOR EACH tt_log_erros_tit_ap_alteracao:
        DELETE tt_log_erros_tit_ap_alteracao.
    END.

    FOR EACH tt-pagto-vpc-aux:
        DELETE tt-pagto-vpc-aux.
    END.


    CREATE tt-pagto-vpc-aux.
    ASSIGN tt-pagto-vpc-aux.nr-vpc       = vpc.nr-vpc
           tt-pagto-vpc-aux.sequencia    = i-nr-sequencia-vpc + 1
           tt-pagto-vpc-aux.nr-pedcli    = nota-fiscal.nr-pedcli
           tt-pagto-vpc-aux.cod-estab-nf = nota-fiscal.cod-estabel
           tt-pagto-vpc-aux.serie        = nota-fiscal.serie
           tt-pagto-vpc-aux.nr-nota-fis  = nota-fiscal.nr-nota-fis
           tt-pagto-vpc-aux.valor        = nota-fiscal.vl-tot-nota
           tt-pagto-vpc-aux.data-pagto   = nota-fiscal.dt-emis-nota
           tt-pagto-vpc-aux.data-trans   = nota-fiscal.dt-emis-nota
           tt-pagto-vpc-aux.usuario      = v_cod_usuar_corren
           tt-pagto-vpc-aux.observacoes  = "Pagamento em Produto = " + nota-fiscal.nr-nota-fis + " Estabelecimento = " + nota-fiscal.cod-estabel  + " Serie = " + nota-fiscal.serie.
                                  

    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-pagamento-vpc IN h-esapi015 (INPUT TABLE tt-pagto-vpc-aux,
                                        OUTPUT TABLE tt_log_erros_tit_ap_alteracao).

    DELETE PROCEDURE h-esapi015.

    IF CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao) THEN DO:
        FOR EACH tt_log_erros_tit_ap_alteracao:
            ASSIGN vpc.observacoes = vpc.observacoes + " / Erro atualizacao VPC " + STRING(tt_log_erros_tit_ap_alteracao.ttv_num_mensagem) + " " +  tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro 
            +    "/"  +    nota-fiscal.nr-pedcli  +    "/"  +     nota-fiscal.cod-estabel    +    "/"  +
                           nota-fiscal.serie      +    "/"  +     nota-fiscal.nr-nota-fis    +    "/"  +
                           string(nota-fiscal.vl-tot-nota) +    "/"  + string(nota-fiscal.dt-emis-nota) +    "/"  +  v_cod_usuar_corren .
        END.

    END.

END PROCEDURE.

PROCEDURE pi-envia-email-supcard:
    DEFINE INPUT  PARAMETER p-usuario  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-assunto  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem AS CHARACTER   NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT AVAILABLE param-global THEN
        RETURN "NOK":U.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = p-usuario NO-LOCK NO-ERROR.

    IF NOT AVAILABLE usuar_mestre THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "intelbras@intelbras.com.br"
           tt-envio2.destino           = usuar_mestre.cod_e_mail_local
           tt-envio2.assunto           = p-assunto
           tt-envio2.formato           = "TEXTO":U.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = p-mensagem + CHR(13) + CHR(13) + "<E-mail autom†tico. N∆o responda>":U.

    IF VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    IF CAN-FIND(FIRST tt-erros) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.
/*                                                                                    */
/* PROCEDURE CreateUnidNeg:                                                           */
/*     DEFINE VARIABLE l-criou-unid-negocio AS LOGICAL     NO-UNDO.                   */
/*                                                                                    */
/*                                                                                    */
/*     /* Caso tenha pedido, busca a unidade de negocio do pedido de venda */         */
/*     if  it-nota-fisc.nr-pedcli <> "" THEN DO: /* origem no calculo da nota */      */
/*                                                                                    */
/*         for first ped-item                                                         */
/*             field (ped-item.nome-abrev                                             */
/*                    ped-item.nr-pedcli                                              */
/*                    ped-item.nr-sequencia                                           */
/*                    ped-item.it-codigo                                              */
/*                    ped-item.cod-refer)                                             */
/*             where ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli                 */
/*             and   ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli                   */
/*             and   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped                  */
/*             and   ped-item.it-codigo    = it-nota-fisc.it-codigo                   */
/*             and   ped-item.cod-refer    = it-nota-fisc.cod-refer no-lock:          */
/*                                                                                    */
/*             for each unid-neg-ped                                                  */
/*                 field (unid-neg-ped.perc-unid-neg                                  */
/*                        unid-neg-ped.cod_unid_neg)                                  */
/*                 where unid-neg-ped.nome-abrev   = ped-item.nome-abrev              */
/*                 and   unid-neg-ped.nr-pedcli    = ped-item.nr-pedcli               */
/*                 and   unid-neg-ped.nr-sequencia = ped-item.nr-sequencia            */
/*                 and   unid-neg-ped.it-codigo    = ped-item.it-codigo               */
/*                 and   unid-neg-ped.cod-refer    = ped-item.cod-refer no-lock:      */
/*                                                                                    */
/*                 FIND FIRST unid-neg-fat                                            */
/*                     WHERE unid-neg-fat.cod-estabel   = it-nota-fisc.cod-estabel    */
/*                       AND unid-neg-fat.serie         = it-nota-fisc.serie          */
/*                       AND unid-neg-fat.nr-nota-fis   = it-nota-fisc.nr-nota-fis    */
/*                       AND unid-neg-fat.nr-seq-fat    = it-nota-fisc.nr-seq-fat     */
/*                       AND unid-neg-fat.it-codigo     = it-nota-fisc.it-codigo      */
/*                     NO-LOCK NO-ERROR.                                              */
/*                 IF NOT AVAIL unid-neg-fat THEN DO:                                 */
/*                     create unid-neg-fat.                                           */
/*                     assign unid-neg-fat.cod-estabel   = it-nota-fisc.cod-estabel   */
/*                            unid-neg-fat.serie         = it-nota-fisc.serie         */
/*                            unid-neg-fat.nr-nota-fis   = it-nota-fisc.nr-nota-fis   */
/*                            unid-neg-fat.nr-seq-fat    = it-nota-fisc.nr-seq-fat    */
/*                            unid-neg-fat.it-codigo     = it-nota-fisc.it-codigo     */
/*                            unid-neg-fat.perc-unid-neg = unid-neg-ped.perc-unid-neg */
/*                            unid-neg-fat.cod_unid_neg  = unid-neg-ped.cod_unid_neg  */
/*                            l-criou-unid-negocio       = yes.                       */
/*                 END.                                                               */
/*             end.                                                                   */
/*         END.                                                                       */
/*     end.                                                                           */
/*                                                                                    */
/*     IF l-criou-unid-negocio = NO THEN DO:                                          */
/*         FIND FIRST item-uni-estab                                                  */
/*             WHERE item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel            */
/*               AND item-uni-estab.it-codigo   = it-nota-fisc.it-codigo              */
/*             NO-LOCK NO-ERROR.                                                      */
/*         IF AVAIL item-uni-estab THEN DO:                                           */
/*             create unid-neg-fat.                                                   */
/*             assign unid-neg-fat.cod-estabel   = it-nota-fisc.cod-estabel           */
/*                    unid-neg-fat.serie         = it-nota-fisc.serie                 */
/*                    unid-neg-fat.nr-nota-fis   = it-nota-fisc.nr-nota-fis           */
/*                    unid-neg-fat.nr-seq-fat    = it-nota-fisc.nr-seq-fat            */
/*                    unid-neg-fat.it-codigo     = it-nota-fisc.it-codigo             */
/*                    unid-neg-fat.perc-unid-neg = 100                                */
/*                    unid-neg-fat.cod_unid_neg  = item-uni-estab.cod-unid-neg.       */
/*         END.                                                                       */
/*     END.                                                                           */
/* END PROCEDURE.                                                                     */




PROCEDURE pi-recalcula-parcelas:

    DEF VAR da-prorrogada AS DATE NO-UNDO.

    IF  AVAIL nota-fiscal THEN DO:
        /*********************************************************************************
        **  Prop¢sito:  Rec†lcular as parcelas da nota fiscal para fazer o rateio corretamente
        **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
        **  Criaá∆o:    Setembro de 2011
        **********************************************************************************/
        FIND FIRST int-cond-pagto
            WHERE  int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.
        FIND FIRST cond-pagto
            WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-LOCK NO-ERROR.

        FIND FIRST ped-venda
             WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
               AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

        IF  (AVAILABLE int-cond-pagto                       
        AND AVAILABLE cond-pagto   
        AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U) 
        OR (AVAIL int-ped-venda
        AND int-ped-venda.log-gpon) THEN DO:
            FIND FIRST fat-duplic NO-LOCK
                WHERE  fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND  fat-duplic.serie       = nota-fiscal.serie
                  AND  fat-duplic.nr-fatura   = nota-fiscal.nr-fatura NO-ERROR.
            
            IF  AVAILABLE fat-duplic THEN
                ASSIGN dt-venc-prim-parc = fat-duplic.dt-venciment
                       i-num-parc-fat    = 0.

            FOR EACH  fat-duplic EXCLUSIVE-LOCK
                WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-duplic.serie       = nota-fiscal.serie
                  AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

                IF  AVAIL int-cond-pagto
                AND SUBSTRING(int-cond-pagto.char-1,8,1) <> "S" /*Flex*/  THEN 
                    ASSIGN fat-duplic.dt-venciment = ADD-INTERVAL(dt-venc-prim-parc, i-num-parc-fat, "MONTH":U).

                ASSIGN i-num-parc-fat = i-num-parc-fat + 1.

            END. /* FOR EACH fat-duplic EXCLUSIVE-LOCK */

            ASSIGN de-parcelas-aux = 0
                   de-comis-aux    = 0.

            FOR EACH  fat-duplic EXCLUSIVE-LOCK
                WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-duplic.serie       = nota-fiscal.serie
                  AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                ASSIGN fat-duplic.vl-parcela    = ROUND(nota-fiscal.vl-tot-nota / i-num-parc-fat, 2)
                       fat-duplic.vl-comis      = ROUND(nota-fiscal.vl-mercad   / i-num-parc-fat, 2)
                       fat-duplic.vl-parcela-me = fat-duplic.vl-parcela
                       fat-duplic.vl-comis-me   = fat-duplic.vl-comis
                       de-parcelas-aux          = de-parcelas-aux + fat-duplic.vl-parcela
                       de-comis-aux             = de-comis-aux    + fat-duplic.vl-comis.
            END. /* FOR EACH fat-duplic EXCLUSIVE-LOCK */

            FOR LAST  fat-duplic EXCLUSIVE-LOCK
                WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                  AND fat-duplic.serie       = nota-fiscal.serie
                  AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                ASSIGN de-parcelas-aux          = de-parcelas-aux - fat-duplic.vl-parcela
                       de-comis-aux             = de-comis-aux    - fat-duplic.vl-comis
                       fat-duplic.vl-parcela    = ROUND((nota-fiscal.vl-tot-nota - de-parcelas-aux), 2)
                       fat-duplic.vl-comis      = ROUND((nota-fiscal.vl-mercad   - de-comis-aux   ), 2)
                       fat-duplic.vl-parcela-me = fat-duplic.vl-parcela
                       fat-duplic.vl-comis-me   = fat-duplic.vl-comis.
            END. /* FOR LAST fat-duplic EXCLUSIVE-LOCK */


            FOR EACH  fat-duplic NO-LOCK
                WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                AND   fat-duplic.serie       = nota-fiscal.serie
                AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
                ASSIGN de-parcelas-aux = 0.
            
                FOR EACH  rateio-it-duplic EXCLUSIVE-LOCK USE-INDEX ch-codigo
                    WHERE rateio-it-duplic.cod-estabel = nota-fiscal.cod-estabel
                    AND   rateio-it-duplic.serie       = nota-fiscal.serie
                    AND   rateio-it-duplic.nr-fatura   = nota-fiscal.nr-fatura
                    AND   rateio-it-duplic.parcela     = fat-duplic.parcela:
                    FIND FIRST it-nota-fisc NO-LOCK
                        WHERE  it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                        AND    it-nota-fisc.serie       = nota-fiscal.serie
                        AND    it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                        AND    it-nota-fisc.it-codigo   = rateio-it-duplic.it-codigo NO-ERROR.
                    ASSIGN de-vl-tot-item = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-tot-item ELSE 0.
            
                    ASSIGN rateio-it-duplic.valor-rateio = ROUND(de-vl-tot-item / i-num-parc-fat, 2)
                           de-parcelas-aux               = de-parcelas-aux + rateio-it-duplic.valor-rateio.
                END.

                ASSIGN de-diferenca = de-parcelas-aux - fat-duplic.vl-parcela.

                FOR LAST  rateio-it-duplic EXCLUSIVE-LOCK USE-INDEX ch-codigo
                    WHERE rateio-it-duplic.cod-estabel = nota-fiscal.cod-estabel
                    AND   rateio-it-duplic.serie       = nota-fiscal.serie
                    AND   rateio-it-duplic.nr-fatura   = nota-fiscal.nr-fatura
                    AND   rateio-it-duplic.parcela     = fat-duplic.parcela:
                    ASSIGN rateio-it-duplic.valor-rateio = rateio-it-duplic.valor-rateio - de-diferenca.
                END.
            END. /* FOR EACH  fat-duplic NO-LOCK */
        END. /* IF AVAILABLE int-cond-pagto                       AND
                   SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO: */

        /* Aplicar regras de vencimento cadastradas no program esacr070 */
        IF  (AVAIL int-cond-pagto AND NOT (SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S")) THEN DO:
            RUN esp/acr/esacrapi003.p (INPUT ROWID(nota-fiscal)).

            FOR EACH fat-duplic EXCLUSIVE-LOCK
               WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                 AND fat-duplic.serie       = nota-fiscal.serie
                 AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
    
                ASSIGN da-prorrogada = fat-duplic.dt-venciment.
    
                /* caso vencimento caia em dia nao util, prorroga para proximo dia util */
                FIND FIRST estabelecimento
                     WHERE estabelecimento.cod_estab = fat-duplic.cod-estabel NO-LOCK NO-ERROR.
                IF  AVAIL estabelecimento THEN DO:
                    FIND FIRST calend_glob
                         WHERE calend_glob.cod_calend = estabelecimento.cod_calend_financ NO-LOCK NO-ERROR.
    
                    IF  AVAIL calend_glob THEN DO:
                        block_prorroga:
                        REPEAT:
    
                            FIND FIRST dia_calend_glob
                                WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
                                AND   dia_calend_glob.dat_calend = da-prorrogada NO-LOCK NO-ERROR.
                            
                            IF  AVAIL dia_calend_glob THEN DO:
                                IF dia_calend_glob.log_dia_util = YES THEN
                                    LEAVE block_prorroga.
                                ELSE
                                    ASSIGN da-prorrogada = da-prorrogada + 1.
                            END.
                            ELSE DO:
                                LEAVE block_prorroga.
                            END.
                        END.
                    END.
                END.
    
                ASSIGN fat-duplic.dt-venciment = da-prorrogada.
    
            END.
        END.
    END. /* IF  AVAIL nota-fiscal THEN DO: */
END PROCEDURE.

/* PROCEDURE pi-mudar-status-solicitacao:                                                                                                                                                          */
/*                                                                                                                                                                                                 */
/*     /*---------------------------------------------------------------------------*/                                                                                                             */
/*     /*  Altera o status da solicitaá∆o de benef°cio para "PAGO", quando todos os */                                                                                                             */
/*     /*  pedidos relaciondos a solicitaá∆o encontrada para o pedido da nota que   */                                                                                                             */
/*     /*  est† sendo processada neste momento, estiverem atendidos totalemente     */                                                                                                             */
/*     /*---------------------------------------------------------------------------*/                                                                                                             */
/*     DEF BUFFER b-solicitacao-item  FOR int-solicitacao-item.                                                                                                                                    */
/*     DEF BUFFER b-pedido-solic      FOR ped-venda.                                                                                                                                               */
/*     DEF BUFFER b-pedido-solic-item FOR ped-item.                                                                                                                                                */
/*     DEF VAR l-atendido AS LOG NO-UNDO.                                                                                                                                                          */
/*                                                                                                                                                                                                 */
/*     FIND b-pedido-solic NO-LOCK                                                                                                                                                                 */
/*         WHERE b-pedido-solic.nome-abrev = nota-fiscal.nome-ab-cli                                                                                                                               */
/*           AND b-pedido-solic.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.                                                                                                                       */
/*                                                                                                                                                                                                 */
/*             IF l-ativa-log THEN                                                                                                                                                                 */
/*                PUT SKIP(1) "nota-fiscal.nome-ab-cli: " nota-fiscal.nome-ab-cli SKIP                                                                                                             */
/*                    "nota-fiscal.nr-pedcli: " nota-fiscal.nr-pedcli SKIP.                                                                                                                        */
/*                                                                                                                                                                                                 */
/*                                                                                                                                                                                                 */
/*     IF  AVAIL b-pedido-solic THEN DO:                                                                                                                                                           */
/*         FOR FIRST int-solicitacao-item FIELDS (CodigoSolicitacaoBeneficio )                                                                                                                     */
/*             WHERE int-solicitacao-item.nome-abrev = b-pedido-solic.nome-abrev                                                                                                                   */
/*               AND int-solicitacao-item.nr-pedcli  = b-pedido-solic.nr-pedcli NO-LOCK.                                                                                                           */
/*         END.                                                                                                                                                                                    */
/*                                                                                                                                                                                                 */
/*         IF  AVAIL int-solicitacao-item THEN DO:                                                                                                                                                 */
/*                                                                                                                                                                                                 */
/*             FIND FIRST int-solicitacao NO-LOCK                                                                                                                                                  */
/*                 WHERE int-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio                                                                              */
/*                   AND int-solicitacao.desc-forma-pagto = "Produto"                                                                                                                              */
/*                   AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006 /* que n∆o esteja Cancelada*/ NO-ERROR.                                                                         */
/*                                                                                                                                                                                                 */
/*             IF  AVAIL int-solicitacao THEN DO:                                                                                                                                                  */
/*                 ASSIGN l-atendido = NO.                                                                                                                                                         */
/*                 FOR EACH b-solicitacao-item NO-LOCK                                                                                                                                             */
/*                       WHERE b-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio:                                                                         */
/*                                                                                                                                                                                                 */
/*                     IF  CAN-FIND (FIRST b-pedido-solic NO-LOCK                                                                                                                                  */
/*                                         WHERE b-pedido-solic.nome-abrev  = b-solicitacao-item.nome-abrev                                                                                        */
/*                                           AND b-pedido-solic.nr-pedcli   = b-solicitacao-item.nr-pedcli                                                                                         */
/*                                           AND b-pedido-solic.cod-sit-ped = 3) THEN DO: /* Atendido total */                                                                                     */
/*                                                                                                                                                                                                 */
/*                         IF l-ativa-log THEN                                                                                                                                                     */
/*                                PUT "Atendido Cliente: " b-solicitacao-item.nome-abrev  SKIP                                                                                                     */
/*                                    "Pedido: "  b-solicitacao-item.nr-pedcli SKIP.                                                                                                               */
/*                                                                                                                                                                                                 */
/*                         ASSIGN l-atendido = YES.                                                                                                                                                */
/*                     END.                                                                                                                                                                        */
/*                     ELSE DO:                                                                                                                                                                    */
/*                         ASSIGN l-atendido = NO.                                                                                                                                                 */
/*                         IF l-ativa-log THEN                                                                                                                                                     */
/*                             PUT "Ainda n∆o Cliente: " b-solicitacao-item.nome-abrev  SKIP                                                                                                       */
/*                                 "Pedido: "  b-solicitacao-item.nr-pedcl SKIP.                                                                                                                   */
/*                                                                                                                                                                                                 */
/*                         LEAVE.                                                                                                                                                                  */
/*                     END.                                                                                                                                                                        */
/*                 END.                                                                                                                                                                            */
/*                                                                                                                                                                                                 */
/*                 DO TRANS:                                                                                                                                                                       */
/*                                                                                                                                                                                                 */
/*                     FIND CURRENT int-solicitacao EXCLUSIVE-LOCK NO-ERROR.                                                                                                                       */
/*                                                                                                                                                                                                 */
/*                     /*-----------------------------------------------------------------------------------------------------*/                                                                   */
/*                     /*                                   ALTERAR OS ITENS DA SOLICITACAO                                   */                                                                   */
/*                     /*-----------------------------------------------------------------------------------------------------*/                                                                   */
/*                     IF  AVAIL int-solicitacao THEN DO:                                                                                                                                          */
/*                         DEF VAR de-pago      AS DEC NO-UNDO.                                                                                                                                    */
/*                         DEF VAR de-cancelado AS DEC NO-UNDO.                                                                                                                                    */
/*                         DEF VAR de-total-solicitacao-benef AS DEC NO-UNDO.                                                                                                                      */
/*                                                                                                                                                                                                 */
/*                         FOR EACH b-solicitacao-item EXCLUSIVE-LOCK                                                                                                                              */
/*                             WHERE b-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio                                                                    */
/*                               AND b-solicitacao-item.nome-abrev                 = nota-fiscal.nome-ab-cli                                                                                       */
/*                               AND b-solicitacao-item.nr-pedcli                  = nota-fiscal.nr-pedcli:                                                                                        */
/*                                                                                                                                                                                                 */
/*                               FIND FIRST b-pedido-solic-item NO-LOCK                                                                                                                            */
/*                                    WHERE b-pedido-solic-item.nome-abrev  = b-solicitacao-item.nome-abrev                                                                                        */
/*                                      AND b-pedido-solic-item.nr-pedcli   = b-solicitacao-item.nr-pedcli                                                                                         */
/*                                      AND b-pedido-solic-item.it-codigo   = b-solicitacao-item.CodigoProduto NO-ERROR.                                                                           */
/*                                                                                                                                                                                                 */
/*                               IF  NOT AVAIL b-pedido-solic-item THEN                                                                                                                            */
/*                                   NEXT.                                                                                                                                                         */
/*                                                                                                                                                                                                 */
/*                               /* Caso a sequencia tenha sido Cancelada */                                                                                                                       */
/*                               IF  b-pedido-solic-item.dt-canseq <> ? THEN /* Item Cancelado */                                                                                                  */
/*                                   ASSIGN b-solicitacao-item.ValorCancelado      = (b-pedido-solic-item.qt-pedida - b-pedido-solic-item.qt-atendida) * b-solicitacao-item.ValorUnitarioAprovado  */
/*                                          b-solicitacao-item.QuantidadeCancelada =  b-pedido-solic-item.qt-pedida - b-pedido-solic-item.qt-atendida                                              */
/*                                          de-cancelado                           =  de-cancelado + b-solicitacao-item.ValorCancelado.                                                            */
/*                                                                                                                                                                                                 */
/*                               /* Atualiza o valor pago*/                                                                                                                                        */
/*                               ASSIGN b-solicitacao-item.ValorPago = b-pedido-solic-item.qt-atendida * b-solicitacao-item.ValorUnitarioAprovado.                                                 */
/*                                                                                                                                                                                                 */
/*                         END.                                                                                                                                                                    */
/*                                                                                                                                                                                                 */
/*                         /*-----------------------------------------------------------------------------------------------------*/                                                               */
/*                         /*                                  Alterar status da Solicitacao                                      */                                                               */
/*                         /*-----------------------------------------------------------------------------------------------------*/                                                               */
/*                         IF  l-atendido THEN                                                                                                                                                     */
/*                             ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004  /* Pagamento Efetuado */                                                                        */
/*                                    int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004  /* Pagamento Reembolsado */                                                                     */
/*                                    int-solicitacao.StatusPagamento                 = 993520002. /* Pago Total Padr∆o */                                                                         */
/*                         ELSE                                                                                                                                                                    */
/*                             ASSIGN int-solicitacao.StatusPagamento = 993520001. /* Pago Parcial */                                                                                              */
/*                                                                                                                                                                                                 */
/*                         /* ATUALIZA O VALOR Jµ PAGO DA SOLICITAÄ«O */                                                                                                                           */
/*                         FOR EACH int-solicitacao-item no-lock                                                                                                                                   */
/*                             WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio:                                                                 */
/*                              ASSIGN de-pago = de-pago + int-solicitacao-item.ValorPago.                                                                                                         */
/*                              IF l-ativa-log THEN                                                                                                                                                */
/*                                 PUT "de-pago: " de-pago SKIP.                                                                                                                                   */
/*                         END.                                                                                                                                                                    */
/*                                                                                                                                                                                                 */
/*                         ASSIGN int-solicitacao.ValorPago = de-pago.                                                                                                                             */
/*                                                                                                                                                                                                 */
/*                     END.                                                                                                                                                                        */
/*                 END.                                                                                                                                                                            */
/*                                                                                                                                                                                                 */
/*                 FIND CURRENT int-solicitacao NO-LOCK NO-ERROR.                                                                                                                                  */
/*                                                                                                                                                                                                 */
/*                 IF l-ativa-log THEN                                                                                                                                                             */
/*                     PUT "AVAIL int-solicitacao: " AVAIL int-solicitacao SKIP.                                                                                                                   */
/*                                                                                                                                                                                                 */
/*                 IF  AVAIL int-solicitacao THEN DO:                                                                                                                                              */
/*                     DEF VAR l-ok AS LOG INIT NO NO-UNDO.                                                                                                                                        */
/*                     RUN esp/esb/esesbapi009-abater-parcial.p (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,                                                                                 */
/*                                                               OUTPUT TABLE tt-erro,                                                                                                             */
/*                                                               OUTPUT l-ok).                                                                                                                     */
/*                     FOR EACH tt-erro:                                                                                                                                                           */
/*                         IF  l-ativa-log THEN                                                                                                                                                    */
/*                             PUT "AVAIL tt-erro.mensagem: " tt-erro.mensagem SKIP.                                                                                                               */
/*                     END.                                                                                                                                                                        */
/*                                                                                                                                                                                                 */
/*                     IF l-ativa-log THEN                                                                                                                                                         */
/*                           PUT "antes esesbapi011-rpw.p " AVAIL int-solicitacao SKIP.                                                                                                            */
/*                                                                                                                                                                                                 */
/*                     /* CRIA UM PEDIDO DE EXECUÄ«O NO RPW, PARA ENVIAR O STATUS ATUALIZADO DA SOLICITAÄ«O */                                                                                     */
/*                     RUN esp/esb/esesbapi011-rpw.p (INPUT int-solicitacao.CodigoSolicitacaoBeneficio).                                                                                           */
/*                     IF l-ativa-log THEN                                                                                                                                                         */
/*                           PUT "depois esesbapi011-rpw.p " AVAIL int-solicitacao SKIP.                                                                                                           */
/*                                                                                                                                                                                                 */
/*                 END.                                                                                                                                                                            */
/*                 RELEASE int-solicitacao NO-ERROR.                                                                                                                                               */
/*                                                                                                                                                                                                 */
/*                 /*END.*/                                                                                                                                                                        */
/*             END.                                                                                                                                                                                */
/*         END.                                                                                                                                                                                    */
/*     END.                                                                                                                                                                                        */
/*                                                                                                                                                                                                 */
/*     RETURN "OK".                                                                                                                                                                                */
/* END.                                                                                                                                                                                            */

PROCEDURE piAcertaChave.

    DEFINE OUTPUT PARAM p-chave-nota AS CHAR FORMAT "x(60)" NO-UNDO.

    DEF BUFFER b-nota-fiscal FOR nota-fiscal.
    DEF BUFFER b-natur-oper FOR natur-oper.

    &if "{&bf_dis_versao_ems}" < "2.07" &then
      &global-define IDI-MODALID-BASE-ICMS-3    "3"
      &global-define IDI-MODALID-BASE-ICMS-ST-6 "6"
      &global-define IDI-MODALID-BASE-ICMS-ST-5 "5"
      &global-define IDI-MODALID-BASE-IPI-1     "1"
      &global-define IDI-MODALID-BASE-IPI-2     "2"
      &global-define IDI-FORMA-EMIS-NF-ELETRO   string(param-nf-estab.idi-tip-emis-nf-eletro)
      &global-define COD-UF-IBGE                substring(unid-feder.char-1,1,2)
      &global-define IDI-FORMA-EMIS             SUBSTR(b-nota-fiscal.char-2,65,2)
    
    &else
      &global-define IDI-MODALID-BASE-ICMS-3    3
      &global-define IDI-MODALID-BASE-ICMS-ST-6 6
      &global-define IDI-MODALID-BASE-ICMS-ST-5 5
      &global-define IDI-MODALID-BASE-IPI-1     1
      &global-define IDI-MODALID-BASE-IPI-2     2
      &global-define IDI-FORMA-EMIS-NF-ELETRO   param-nf-estab.idi-tip-emis-nf-eletro
      &global-define COD-UF-IBGE                unid-feder.cod-uf-ibge
      &global-define IDI-FORMA-EMIS             STRING(b-nota-fiscal.idi-forma-emis-nf-eletro)
    &endif
    
    &if "{&bf_dis_versao_ems}" >= "2.06" &then
      &global-define IDI-FORMA-CALC-PIS    item-dist.idi-forma-calc-pis = 2
      &global-define IDI-FORMA-CALC-COFINS item-dist.idi-forma-calc-cofins = 2
    &else
      &global-define IDI-FORMA-CALC-PIS    substring(item.char-1,193,1) = "2"
      &global-define IDI-FORMA-CALC-COFINS substring(item.char-1,194,1) = "2"
    &endif
   
    def var c-chave-nfe      as char    no-undo.
    def var c-nota-nfe       as char    no-undo.
    def var c-serie-nfe      as char    no-undo.
    def var i-count-nfe      as int     no-undo.
    def var i-mult-nfe       as int     no-undo.
    def var i-soma-mod-nfe   as int     no-undo.
    def var i-dig-ver-nfe    as int     no-undo.

    def buffer b-estab-nfe   for estabelec.

    find b-natur-oper no-lock where
         b-natur-oper.nat-operacao = nota-fiscal.nat-operacao no-error.

    if nota-fiscal.serie = "" then
       assign c-serie-nfe = "000".
    else do:
        if  length(nota-fiscal.serie) < 3 then do:
            assign c-serie-nfe = if length(nota-fiscal.serie) = 1 then
                                     "00" + nota-fiscal.serie
                                 else "0" + nota-fiscal.serie.
        end.
        else
            if  length(nota-fiscal.serie) = 3 then
                assign c-serie-nfe = nota-fiscal.serie.
            else
                assign c-serie-nfe = substring(nota-fiscal.serie,1,3).
    end.

    if length(nota-fiscal.nr-nota-fis) < 9 then do:
        assign c-nota-nfe = string(int(nota-fiscal.nr-nota-fis),"999999999").
    end.
    else
        if length(nota-fiscal.nr-nota-fis) = 9 then
            assign c-nota-nfe = nota-fiscal.nr-nota-fis.
        else
            assign c-nota-nfe = substring(nota-fiscal.nr-nota-fis,1,9).

    find b-estab-nfe no-lock where
         b-estab-nfe.cod-estabel = nota-fiscal.cod-estabel no-error.
    if not available b-estab-nfe then
        return "NOK":U.

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = nota-fiscal.cod-estabel:
    END.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel =  nota-fiscal.cod-estabel no-error.

    find unid-feder no-lock where
         unid-feder.pais   = estabelec.pais   and
         unid-feder.estado = estabelec.estado no-error.


    assign c-chave-nfe = (if avail unid-feder then unid-feder.cod-uf-ibge else "00") +
                         substring(string(year(nota-fiscal.dt-emis-nota),"9999"),3,2)     +
                         string(month(nota-fiscal.dt-emis-nota),"99")                     +
                         (if length(b-estab-nfe.cgc) = 9 then "000" + b-estab-nfe.cgc else b-estab-nfe.cgc) +
                         string(b-natur-oper.cod-model-nf-eletro,"99") +
                         c-serie-nfe +
                         c-nota-nfe  +
                         (IF AVAIL param-nf-estab THEN STRING(param-nf-estab.idi-tip-emis-nf-eletro) ELSE "1") + /*nota-fiscal.idi-forma-emis-nf-eletro*/
                         /*STRING(RANDOM(1,99999999),"99999999")*/
                         string(int(nota-fiscal.nr-nota-fis),"99999999").

    assign i-mult-nfe = 2.
    do i-count-nfe = length(c-chave-nfe) to 1 by -1:
        assign i-soma-mod-nfe = i-soma-mod-nfe + (int(substring(c-chave-nfe,i-count-nfe,1)) * i-mult-nfe).

        assign i-mult-nfe = i-mult-nfe + 1.
        if i-mult-nfe = 10 then
            assign i-mult-nfe = 2.
    end.

    if i-soma-mod-nfe MODULO 11 = 0 or
       i-soma-mod-nfe MODULO 11 = 1 then
        assign i-dig-ver-nfe = 0.
    else
        assign i-dig-ver-nfe = 11 - (i-soma-mod-nfe MODULO 11).

    assign p-chave-nota = c-chave-nfe + string(i-dig-ver-nfe).

    RETURN "OK":U.
END.

PROCEDURE pi_criaCaixaResto:

    IF l-ativa-log THEN
       PUT "bodi317ef - pi-calcula-volumes7 - Volume embalag.volume " embalag.volume " embalag.sigla-emb " embalag.sigla-emb " tt-resto.qtde " tt-resto.qtde " de-volume-resto " de-volume-resto SKIP.
    IF embalag.volume < de-volume-resto THEN DO:
        FIND FIRST volume-nf EXCLUSIVE-LOCK
             WHERE  volume-nf.cod-estabel  = nota-fiscal.cod-estabel
             AND    volume-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
             AND    volume-nf.serie        = nota-fiscal.serie
             AND    volume-nf.it-codigo    = item.it-codigo
             AND    volume-nf.nr-volume    = i-proximo-vol NO-ERROR.
         IF  NOT AVAIL volume-nf THEN DO:
             CREATE volume-nf.
             ASSIGN volume-nf.cod-estabel  = nota-fiscal.cod-estabel
                    volume-nf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                    volume-nf.serie        = nota-fiscal.serie
                    volume-nf.it-codigo    = item.it-codigo
                    volume-nf.nr-volume    = i-proximo-vol
                    volume-nf.varios-itens = YES
                    volume-nf.qtde         = embalag.volume.
         END.

         ASSIGN volume-nf.qtde             = volume-nf.qtde + embalag.volume
                de-volume-resto                   = de-volume-resto - embalag.volume
                volume-nf.sigla-emb        = "CX"
                de-SomaQtdePorCaixa               = de-SomaQtdePorCaixa  + embalag.volume.

         IF l-ativa-log THEN
            PUT "bodi317ef - pi-calcula-volumes7 - Volume " volume-nf.nr-volume SKIP.

         RUN pi_criaCaixaResto.
         IF l-ativa-log THEN
             PUT "MAIOR Embalagem Encontrada QUE COMPORTA PARTE DO FRACIONADO " de-volume-resto  "  embalag.volume  " embalag.volume " " c-emb-escolhida SKIP.

    END.
    ELSE DO:

        FOR EACH  b-embalagResto NO-LOCK
            WHERE b-embalagResto.sigla-emb BEGINS "F"
            BY    b-embalagResto.volume:

            IF  b-embalagResto.volume >= de-volume-resto THEN DO:
                ASSIGN c-emb-escolhida = b-embalagResto.sigla-emb
                       de-vol-embalag  = (b-embalagResto.altura * b-embalagResto.comprim * b-embalagResto.largura) / 1000000000.

                IF l-ativa-log THEN
                    PUT "MAIOR Embalagem Encontrada QUE COMPORTA RESTANTE DA PARTE DO FRACIONADO " de-volume-resto  "  b-embalagResto.volume  " b-embalagResto.volume " " c-emb-escolhida SKIP.
                LEAVE.
            END.

        END. /* FOR EACH  b-embalagResto NO-LOCK */
        LEAVE.

    END.

END PROCEDURE.

PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    
        output to value(c-arquivo-log) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string format "x(100)" skip.
        output close. 
    
    end.
END.
PROCEDURE pi-move-xml-diretorio-neogrid:
    /* -------------------------------------------------------------------------------------------------- */
    /* MOVER DO DIRETORIO TEMPORARIO ONDE O XML ESTA PARA O DIRETORIO DE CONSUMO DO NEOGRID.              */

    /* ESTE PROCEDIMENTO ‘ NECESSARIO PORQUE APENAS DEPOIS DA TRANSACAO DE CRIACAO DA NOTA SER FINALIZADA */

    /* QUE VAI GERAR ENVIAR O XML PARA SEFAZ.                                                             */       
    /* -------------------------------------------------------------------------------------------------- */
    DEF VAR c-dir-DE           AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-dir-PARA         AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-nome-xml         AS CHAR FORMAT "x(200)" NO-UNDO.
    DEF VAR i-err-status       AS INTEGER              NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "WIN32" THEN DO:
       RUN esp/es0018p.p (INPUT "cdapi590", /* Nome do programa */
                          INPUT 2,          /* Ponto do programa */
                          INPUT 0,
                          INPUT "",
                          OUTPUT TABLE tt-prog-ponto). 
    END.
    ELSE
       RUN esp/es0018p.p (INPUT "cdapi590",  /* Nome do programa */
                          INPUT 1,           /* Ponto do programa */
                          INPUT 0,
                          INPUT "",
                          OUTPUT TABLE tt-prog-ponto). 

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF  AVAIL tt-prog-ponto THEN DO:
        /*************************** DIRETÖRIO TEMPORÊRIO *************************/
        ASSIGN c-dir-DE   = tt-prog-ponto.conteudo + "/TMP/OUT".
        /************************* DIRETÖRIO NEOGRID OFICIAL **********************/

        ASSIGN c-dir-PARA = tt-prog-ponto.conteudo.  
    END.

    /*
    MESSAGE 'Diretorio DE:   '  c-dir-DE SKIP 
            'Diretorio PARA: '  c-dir-PARA
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/


    IF  TRIM(c-dir-PARA) = "" OR TRIM(c-dir-PARA) = "" THEN 
        LEAVE.

    IF AVAIL nota-fiscal THEN DO:
       FOR FIRST integr-totvs-colab NO-LOCK
           WHERE integr-totvs-colab.cod-edi = "170"    /* Tipo de Fluxo*/
             AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro /* Chave de acesso da nota */
             AND integr-totvs-colab.cod-msg  MATCHES "*.xml*" :
           
             RUN pi-devolve-xml (INPUT integr-totvs-colab.cod-msg,
                                 OUTPUT c-nome-xml).
       END.

       IF TRIM(c-nome-xml) <> "" THEN DO:
          ASSIGN c-dir-DE   = c-dir-DE   + "/"     + c-nome-xml.
                 c-dir-PARA = c-dir-PARA + "/OUT/" + c-nome-xml.

          IF SEARCH(c-dir-DE) <> ? THEN DO:
             OS-COPY VALUE(c-dir-DE) VALUE(c-dir-PARA).
              
             OS-DELETE VALUE(c-dir-DE).
          END.
       END.
    END.
    
END.


PROCEDURE pi-devolve-xml:

    DEF INPUT  PARAM p-msg      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-nome-xml AS CHAR NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.

    DO  i = 1 TO NUM-ENTRIES (p-msg, " "):
        IF  ENTRY(i, p-msg, " ") MATCHES "*.xml*" THEN DO:
            ASSIGN p-nome-xml = ENTRY(i, p-msg, " ").
            LEAVE.
        END.
    END.

END PROCEDURE.

PROCEDURE piTrataFlowRack:
    DEFINE VARIABLE h-esftp083  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-erros     AS CHARACTER   NO-UNDO.

    /* quando integrar WMS, verifica se h† necessidade de separar o que Ç retirado em flow rack */
    
    FOR FIRST wm-local NO-LOCK
        WHERE wm-local.cod-estabel = nota-fiscal.cod-estabel
          AND wm-local.log-local-padrao:
    END.

    IF NOT AVAIL wm-local THEN
        RETURN "OK".

    FOR EACH tt-volumes
        WHERE tt-volumes.varios-itens:  /* s¢ o que j† fracionou */

        FOR FIRST wm-item-picking NO-LOCK
            WHERE wm-item-picking.cod-estabel = wm-local.cod-estabel
              AND wm-item-picking.cod-local   = wm-local.cod-local
              AND wm-item-picking.cod-item    = tt-volumes.it-codigo
              AND CAN-FIND(FIRST ext-wm-picking NO-LOCK
                           WHERE ext-wm-picking.cod-estabel   = wm-item-picking.cod-estabel
                             AND ext-wm-picking.cod-local     = wm-item-picking.cod-local
                             AND ext-wm-picking.cod-picking   = wm-item-picking.cod-picking
                             AND ext-wm-picking.log-flow-rack = YES):
        END.

        IF AVAIL wm-item-picking THEN DO: /* separa flow rack */
            FIND FIRST tt-itens-flow-rack
                 WHERE tt-itens-flow-rack.it-codigo = tt-volumes.it-codigo NO-ERROR.
            IF NOT AVAIL tt-itens-flow-rack THEN DO:
                CREATE tt-itens-flow-rack.
                ASSIGN tt-itens-flow-rack.it-codigo  = tt-volumes.it-codigo
                       tt-itens-flow-rack.saida-flow-rack = YES.
            END.
            ASSIGN tt-itens-flow-rack.quantidade = tt-itens-flow-rack.quantidade + tt-volumes.qtde.

            FIND FIRST tt-itens-calculo
                 WHERE tt-itens-calculo.it-codigo = tt-volumes.it-codigo NO-ERROR.
            IF AVAIL tt-itens-calculo THEN DO:
                ASSIGN tt-itens-calculo.quantidade = tt-itens-calculo.quantidade - tt-volumes.qtde.
                IF tt-itens-calculo.quantidade <= 0 THEN
                    DELETE tt-itens-calculo.
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-itens-flow-rack) THEN DO:  /* refaz os volumes normais e gera os volumes flow rack em separado dos outros */

        EMPTY TEMP-TABLE tt-volumes.
        EMPTY TEMP-TABLE tt-volumes-flow-rack.
        
        RUN esp/ftp/esftp083.p PERSISTENT SET h-esftp083.

        /* volumes normais */
        RUN pi-calcula-volumes IN h-esftp083 (INPUT nota-fiscal.cod-emitente,
                                              INPUT nota-fiscal.nat-operacao,
                                              INPUT nota-fiscal.cod-estabel,
                                              INPUT nota-fiscal.nome-transp,
                                              INPUT  TABLE tt-itens-calculo,
                                              OUTPUT TABLE tt-volumes,
                                              OUTPUT c-erros).
        
        DELETE PROCEDURE h-esftp083.
        ASSIGN h-esftp083 = ?.

        IF c-erros <> "" THEN DO:
            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
            RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                   INPUT "EMS",
                                                   INPUT "ERROR", 
                                                   INPUT c-erros,
                                                   INPUT c-erros,
                                                   INPUT c-erros). 
            RETURN "NOK".
        END.
          
        RUN esp/ftp/esftp083.p PERSISTENT SET h-esftp083.

        /* volumes flow rack */
        RUN pi-calcula-volumes IN h-esftp083 (INPUT nota-fiscal.cod-emitente,
                                              INPUT nota-fiscal.nat-operacao,
                                              INPUT nota-fiscal.cod-estabel,
                                              INPUT nota-fiscal.nome-transp,
                                              INPUT  TABLE tt-itens-flow-rack,
                                              OUTPUT TABLE tt-volumes-flow-rack,
                                              OUTPUT c-erros).
        DELETE PROCEDURE h-esftp083.
        ASSIGN h-esftp083 = ?.

        IF c-erros <> "" THEN DO:
            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
            RUN _insertErrorManual IN hBODI317ef  (INPUT 0,
                                                   INPUT "EMS",
                                                   INPUT "ERROR", 
                                                   INPUT c-erros,
                                                   INPUT c-erros,
                                                   INPUT c-erros). 
            RETURN "NOK".
        END.
    END.

    RETURN "OK".
END PROCEDURE.
